@isTest
global class StripeHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        response.setBody('{"amount_remaining":0, "amount_paid": 38000, "id": "stripe-id", "data": [{"id": "test1-price-id", "latest_invoice": "in-id-stripe"}], "name": "Teguh Prayoga", "email": "teguh@bookingninjas.com", "phone": "+6281222290905", "metadata": {"company": "Booking Ninjas"}, "status": "paid", "amount_remaining": 0, "amount_paid": 44800, "hosted_invoice_url": "https://stripe.com/loc/", "lines": {"data": [{"amount": 38000, "quantity": 2, "price": {"lookup_key": "bn-lookup", "unit_amount": 9500}}]}}');
        response.setStatusCode(200);
        return response; 
    }
}