@IsTest
private class StripeServices2Test {

    @testSetup static void setupTestData() {
        Stripe_Settings__c st = new Stripe_Settings__c(
            Is_Live__c = false,
            Stripe_Publishable_Live_Key__c = 'LiveKey',
            Stripe_Publishable_Test_Key__c = 'TestKey'
        );
        insert st;
    }

    @isTest static void testSendPayment() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://bookingninjas.my.salesforce.com/services/apexrest/Stripe2/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{' +
            '"cusName": "Teguh Prayoga",' +
            '"cusPhone": "+6281 2222 90905",' +
            '"cusEmail": "teguh@bookingninjas.com",' +
            '"cusCompany": "Booking Ninjas",' +
            '"clientSecret": "stripe_secret_code"' +
        '}');
        RestContext.request = request;
        // Update status of existing record to Working
        StripeServices2.updateCustomer();
    }
}