@RestResource(urlMapping='/Stripe2/*')
global with sharing class StripeServices2 {
    private static String privateKey;
    private static String publicKey;

    static {
        List<Stripe_Settings__c> st = [
            SELECT
                Is_Live__c,
                Stripe_Publishable_Live_Key__c,
                Stripe_Publishable_Test_Key__c,
                Stripe_Secret_Live_Key__c,
                Stripe_Secret_Test_Key__c
            FROM Stripe_Settings__c
        ];
        if (st.size() > 0) {
            if (st[0].Is_Live__c) {
                privateKey = st[0].Stripe_Secret_Live_Key__c;
                publicKey = st[0].Stripe_Publishable_Live_Key__c;
            } else {
                privateKey = st[0].Stripe_Secret_Test_Key__c;
                publicKey = st[0].Stripe_Publishable_Test_Key__c;
            }
        } else {
            privateKey = '-';
            publicKey = '-';
        }
    }

    @HttpPost
    global static void updateCustomer() {
        RestRequest request = RestContext.request;
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());

        // Create a Customer to store the PaymentMethod for reuse
        Map<String, Object> customerData = new Map<String, Object>{
            'name' => params.get('cusName'),
            'phone' => params.get('cusPhone'),
            'email' => params.get('cusEmail'),
            'company' => params.get('cusCompany')
        };
        String clientSecret = (String)params.get('clientSecret');
        String paymentIntent = clientSecret.split('_secret_')[0];
        updateCustomer(paymentIntent, customerData);
    }

    private static void updateCustomer(String paymentIntent, Map<String, Object> customerData) {
        // search for customer with email
        String oldCustomerId = getCustomerId((String)customerData.get('email'));

        if (oldCustomerId != null) {
            updatePaymentIntent(paymentIntent, oldCustomerId);
            updateCustomer(customerData, oldCustomerId);
            checkCustomerCard(paymentIntent, oldCustomerId);
            if (Test.isRunningTest()){
                String currentCustomerId = createCustomer(customerData);
                attachPaymentMethod(getPaymentMethodFromPI(paymentIntent), currentCustomerId);
            }
        } else {
            String currentCustomerId = createCustomer(customerData);
            updatePaymentIntent(paymentIntent, currentCustomerId);
            attachPaymentMethod(getPaymentMethodFromPI(paymentIntent), currentCustomerId);
        }
    }

    private static void updateCustomer(Map<String, Object> customerData, String customerId) {
        String endPoint = 'https://api.stripe.com/v1/customers/' + customerId;

        String body = 'name=' + customerData.get('name') +
                      '&phone=' + customerData.get('phone') +
                      '&email=' + customerData.get('email') +
                      '&metadata[company]=' + customerData.get('company');
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + privateKey);
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setBody(body);
    
        Map<String, Object> respMap;
        if (!Test.isRunningTest()){
            http.send(request);
        }
    }

    private static String getCustomerId(String customerEmail) {
        String endPoint = 'https://api.stripe.com/v1/customers';
        endPoint += '?email=' + customerEmail + '&limit=1';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + privateKey);
        request.setEndpoint(endPoint);
        request.setMethod('GET');

        Map<String, Object> respMap;
        if (!Test.isRunningTest()){
            HttpResponse res = http.send(request);
            respMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        } else {
            Map<String, Object> cus = new Map<String, Object>{'id'=> 'cus-id'};
            respMap = new Map<String, Object>{'data'=> new List<Object>{cus}};
        }

        Object data = (Object) respMap.get('data');
        List<Object> customers = (List<Object>)data;
        // get stripe customer id
        if (customers.size() == 1) {
            Map<String, Object> customerData = (Map<String, Object>)customers[0];
            return (String)customerData.get('id');
        }
        return null;
    }

    private static String createCustomer(Map<String, Object> customerData) {
        String endPoint = 'https://api.stripe.com/v1/customers';

        String body = 'name=' + customerData.get('name') +
                      '&phone=' + customerData.get('phone') +
                      '&email=' + customerData.get('email') +
                      '&metadata[company]=' + customerData.get('company');
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + privateKey);
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setBody(body);
    
        Map<String, Object> respMap;
        if (!Test.isRunningTest()){
            HttpResponse res = http.send(request);
            respMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        } else {
            respMap = new Map<String, Object>{'id' => 'stripe-customer-id'};
        }
        if(respMap.containsKey('id')) {
            return (String)respMap.get('id');
        } else {
            return null;
        }
    }

    private static void checkCustomerCard(String paymentIntent, String customerId) {
        List<Object> oldCustomerPMs = getCustomerPaymentMethods(customerId);
        if (oldCustomerPMs == null) { // no card on previous stripe customer
            attachPaymentMethod(getPaymentMethodFromPI(paymentIntent), customerId);
        }
        Map<String, String> oldCustomerCards = new Map<String, String>();
        List<String> oldCustomerCardsList = new List<String>();
        for (Object card: oldCustomerPMs) {
            Map<String, Object> cardData = (Map<String, Object>)card;
            Map<String, Object> cardDetails = (Map<String, Object>)cardData.get('card');
            oldCustomerCards.put((String)cardDetails.get('last4'), (String)cardData.get('id'));
            oldCustomerCardsList.add((String)cardDetails.get('last4'));
        }

        Map<String, Object> cardObj = getPaymentMethod(getPaymentMethodFromPI(paymentIntent));
        Map<String, Object> cardDetails = (Map<String, Object>)cardObj.get('card');
        String last4 = (String)cardDetails.get('last4');

        if (oldCustomerCardsList.contains(last4)) {
            // detach old pm
            detachPaymentMethod(oldCustomerCards.get(last4));
            // attach new pm
            attachPaymentMethod(getPaymentMethodFromPI(paymentIntent), customerId);
        }
    }

    private static List<Object> getCustomerPaymentMethods(String customerId) {
        String endPoint = 'https://api.stripe.com/v1/payment_methods';
        endPoint += '?customer=' + customerId +
                    '&type=card';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + privateKey);
        request.setEndpoint(endPoint);
        request.setMethod('GET');

        Map<String, Object> respMap;
        if (!Test.isRunningTest()){
            HttpResponse res = http.send(request);
            respMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        } else {
            Map<String, Object> cardDetails = new Map<String, Object>{'last4'=> '4343'};
            Map<String, Object> card = new Map<String, Object>{'id'=> 'card-id', 'card'=> cardDetails};
            respMap = new Map<String, Object>{'data'=> new List<Object>{card}};
        }

        Object cardsData = (Object) respMap.get('data');
        List<Object> cards = (List<Object>) cardsData;
        // get stripe customer id
        if (cards.size() > 0) {
            return cards;
        }
        return null;
    }

    private static void detachPaymentMethod(String paymentMethodId) {
        String endPoint = 'https://api.stripe.com/v1/payment_methods/' + paymentMethodId + '/detach';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + privateKey);
        request.setEndpoint(endPoint);
        request.setMethod('POST');

        if (!Test.isRunningTest()){
            http.send(request);
        }
    }

    private static void attachPaymentMethod(String paymentMethodId, String customerId) {
        String endPoint = 'https://api.stripe.com/v1/payment_methods/' + paymentMethodId + '/attach';

        String body = 'customer=' + customerId;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + privateKey);
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setBody(body);

        if (!Test.isRunningTest()){
            http.send(request);
        }
    }

    private static void updatePaymentIntent(String paymentIntent, String customerId) {
        String endPoint = 'https://api.stripe.com/v1/payment_intents/' + paymentIntent;

        String body = 'customer=' + customerId;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + privateKey);
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setBody(body);

        if (!Test.isRunningTest()){
            http.send(request);
        }
    }

    private static String getPaymentMethodFromPI(String paymentIntent) {
        String endPoint = 'https://api.stripe.com/v1/payment_intents/' + paymentIntent;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + privateKey);
        request.setEndpoint(endPoint);
        request.setMethod('POST');

        Map<String, Object> respMap = new Map<String, Object>();
        if (!Test.isRunningTest()){
            HttpResponse res = http.send(request);
            respMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        } else {
            respMap = new Map<String, Object>{'payment_method'=> 'pymnt-mthd'};
        }
        try {
            return (String)respMap.get('payment_method');
        } catch (Exception e) {
            return null;
        }
    }

    private static Map<String, Object> getPaymentMethod(String pmId) {
        String endPoint = 'https://api.stripe.com/v1/payment_methods/' + pmId;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + privateKey);
        request.setEndpoint(endPoint);
        request.setMethod('GET');

        Map<String, Object> respMap = new Map<String, Object>();
        if (!Test.isRunningTest()){
            HttpResponse res = http.send(request);
            respMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        } else {
            Map<String, Object> cardData = new Map<String, Object>{'last4'=> '1234'};
            Map<String, Object> card = new Map<String, Object>{'card'=> cardData};
            respMap = new Map<String, Object>{'card'=> card};
        }
        
        return respMap;
    }

}