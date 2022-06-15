@RestResource(urlMapping='/Stripe/*')
global with sharing class StripeServices {
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
    global static void sendPayment() {
        Map<String, Object> o = new Map<String, Object>();
        RestRequest request = RestContext.request;
        try {
            // Deserialize the JSON string into name-value pairs
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());

            // Create a PaymentIntent with the order amount and currency and the customer id
            Map<String, Object> paymentIntentData = new Map<String, Object>{
                'amount' => params.get('amount'),
                'currency' => params.get('currency'),
                'description' => params.get('description')
            };
            Map<String, Object> intent = createPaymentIntent(paymentIntentData);

            Map<String, Object> returnData = new Map<String, Object>{
                'publicKey' => publicKey,
                'clientSecret' => intent.get('client_secret'),
                'id' => intent.get('id')
            };
            // Send publishable key and PaymentIntent details to client
            RestResponse res = RestContext.response;
            if (res == null) {
                res = new RestResponse();
                RestContext.response = res;
            }
            res.responseBody = Blob.valueOf(JSON.serialize(returnData));
            res.statusCode = 200;
        } catch (Exception e) {
            RestResponse res = RestContext.response;
            if (res == null) {
                res = new RestResponse();
                RestContext.response = res;
            }
            res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, Object>{'status'=>'error'}));
            res.statusCode = 403;
        }
    }

    private static Map<String, Object> createPaymentIntent(Map<String, Object> paymentIntentData) {
        String endPoint = 'https://api.stripe.com/v1/payment_intents';
        Integer amount = Integer.valueOf(paymentIntentData.get('amount')) * 100;

        String body = 'amount=' + amount +
                      '&currency=' + paymentIntentData.get('currency') +
                      '&description=' + paymentIntentData.get('description');

        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + privateKey);
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setBody(body);

        if (!Test.isRunningTest()){
            Http http = new Http();
            HttpResponse res = http.send(request);
            return (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        } else {
            return new Map<String, Object>{
                'id' => 'stripe-payment-intent-id',
                'status'=> 'succeeded',
                'client_secret' => 'its-secret'
            };
        }
    }

}