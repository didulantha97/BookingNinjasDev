@isTest
global class IPAPIHttpCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"status": "success", "city": "Jakarta", "country": "Indonesia"}');
        response.setStatusCode(200);
        return response; 
    }
}