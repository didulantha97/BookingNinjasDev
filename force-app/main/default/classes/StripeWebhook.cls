@RestResource(urlMapping='/stripe/webhook/*')
global class StripeWebhook {

    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.responseBody = Blob.valueOf('success');
        res.statusCode = 201;
        Blob body = req.requestBody;
        Map<String, String> webHookInfor = StripeWebhook.extractPaymentInformation(body.toString());
        StripeWebhook.capturePaymentInformation(webHookInfor);
    }
    
    private static Map<String, String> extractPaymentInformation(String response) {
        Map<String, String> webHookInfor = new Map<String, String>();        
        if(String.isNotBlank(response)) {
            String piId = '';
            String receiptUrl = '';
            String stripeTransactionId = '';
            Double totalAmount;
        	Map<String, Object> infor = (Map<String, Object>)JSON.deserializeUntyped(response);
            if(infor.containsKey('type') && 'payment_intent.succeeded'.equals((String)infor.get('type'))) {
                if(infor.containsKey('data')) {
                    Map<String, Object> dataMap = (Map<String, Object>)infor.get('data');
                    if(dataMap.containsKey('object')) {
                        Map<String, Object> objectMap = (Map<String, Object>)dataMap.get('object');
                        //	extract payment intent id, which is the key to cross check this transacion in Salesforce DB
                        piId = (String)objectMap.get('id');
                        webHookInfor.put('piId', piId);
                        
                        //	extract receipt url
                        if(objectMap.containsKey('charges')) {
                            Map<String, Object> chargesMap = (Map<String, Object>)objectMap.get('charges');
                            if(chargesMap.containsKey('data')) {
                                List<Object> dataObject = (List<Object>)chargesMap.get('data');
                                if(dataObject != null && dataObject.size() > 0) {
                                    Map<String, Object> paymentInfor = (Map<String, Object>)dataObject.get(0);
                                    if(paymentInfor.containsKey('receipt_url')) {
                                        receiptUrl = (String)paymentInfor.get('receipt_url');
                                        webHookInfor.put('receiptUrl', receiptUrl);
                                    }
                                    if(paymentInfor.containsKey('id')) {
                                        stripeTransactionId = (String)paymentInfor.get('id');
                                        webHookInfor.put('stripeTransactionId', stripeTransactionId);
                                    }
                                    if(paymentInfor.containsKey('amount')) {
                                        totalAmount = (Double)paymentInfor.get('amount');
                                        totalAmount = totalAmount/100;
                                        webHookInfor.put('totalAmount', String.valueOf(totalAmount));
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return webHookInfor;
    }
    
    private static void capturePaymentInformation(Map<String, String> infor) {
        Stripe_Transaction__c trans = new Stripe_Transaction__c();
        if(infor != null && !infor.isEmpty()) {
            try{
                trans = [SELECT Id, Stripe_Transaction_Id__c, Total_Amount__C, Status__c, Receipt_URL__c
                         FROM Stripe_Transaction__c
                         WHERE Payment_Intent_Id__c =: infor.get('piId') LIMIT 1];
                trans.Status__c = 'Succeeded';
                trans.Stripe_Transaction_Id__c = infor.get('stripeTransactionId');
                trans.Receipt_URL__c = infor.get('receiptUrl');
                if(String.isNotBlank(infor.get('totalAmount'))) {
                    trans.Total_Amount__c = Double.valueOf(infor.get('totalAmount'));
                }
                
                update trans;
            } catch(Exception ex) {
                System.debug('ERROR : StripeWebhook.capturePaymentInformation() \n' + ex.getMessage());
            }
        }
    }
}