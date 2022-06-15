@IsTest
private class StripeServicesTest {

    @isTest static void testSendPayment() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://bookingninjas.my.salesforce.com/services/apexrest/Stripe/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{' +
            '"currency": "usd",' +
            '"cus_name": "Teguh Prayoga",' +
            '"cus_phone": "+6281 2222 90905",' +
            '"cus_email": "teguh@bookingninjas.com",' +
            '"cus_company": "Booking Ninjas"' +
        '}');
        RestContext.request = request;
        // Update status of existing record to Working
        StripeServices.sendPayment();
    }

    @isTest static void testSendPaymentNoParams() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://bookingninjas.my.salesforce.com/services/apexrest/Stripe/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        // Update status of existing record to Working
        StripeServices.sendPayment();
    }
}