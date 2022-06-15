@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        String endpoint = req.getEndpoint();
        HttpResponse res = new HttpResponse();
        
        if(endpoint.contains('Stripe/token')) {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id": "tk_iui343uiIU3iuoi34i"}');
            res.setStatusCode(200);
        } else if(endpoint.contains('Stripe/charges')) {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Id": "sid_iui343uiIU3iuoi34i", "receipt_url": "https://sample.receipt.stripe.com"}');
            res.setStatusCode(200);
        } else if(endpoint.contains('Stripe/customers')) {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id": "sid_iui343uiIU3iuoi34i", "receipt_url": "https://sample.receipt.stripe.com"}');
            res.setStatusCode(200);
        }
        
        if (endpoint.contains('api.customer-alliance.com')) {
            System.assertEquals('https://api.customer-alliance.com/reviews/v1/ca.json?page=1&start=2012-08-01&end=2012-08-08', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());

            // Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"totalCount": 1896,"reviews":[{"hotel_name": "Ku Damm 101 Design-Hotel Berlin","review_id": "expedia19_191594862","review_source": "expedia","average_rating_normalized": "80.0000","average_rating": "4.0000","reviewer_comment": "","reviewer_comment_positive": "","reviewer_comment_negative": "","review_date": "2017-08-08 09:51:47","author": "Fred"}]}');
            res.setStatusCode(200);
        }

        if (endpoint.contains('login.uber.com')) {
            System.assertEquals('https://login.uber.com/oauth/v2/token', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            res.setHeader('Content-Type', 'application/json');
            String testToken = '12345';
            for (Integer i = 0; i < 6; i++) {
                testToken += testToken;
            }
            res.setBody('{"access_token": "'+testToken+'","token_type": "Bearer","expires_in": 2592000,"refresh_token": "xxx","scope": "profile history"}');
            res.setStatusCode(200);
        }

        if (endpoint.contains('maps.googleapis.com/maps/api/place/autocomplete/json?input')) {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"OK","predictions":[{"types":["locality","political","geocode"],"terms":[{"value":"London","offset":0},{"value":"UK","offset":8}],"reference":"ChIJdd4hrwug2EcRmSrV3Vo6llI","place_id":"ChIJdd4hrwug2EcRmSrV3Vo6llI","matched_substrings":[{"offset":0,"length":6}],"id":"b1a8b96daab5065cf4a08f953e577c34cdf769c0","description":"London, UK"},{"types":["transit_station","point_of_interest","establishment","geocode"],"terms":[{"value":"London Eye","offset":0},{"value":"London","offset":12},{"value":"UK","offset":20}],"reference":"ChIJH2U9GscEdkgR7sArcZd_NnI","place_id":"ChIJH2U9GscEdkgR7sArcZd_NnI","matched_substrings":[{"offset":0,"length":6}],"id":"36e980c36e5404484445baaf668d45259d6398a9","description":"London Eye, London, UK"},{"types":["locality","political","geocode"],"terms":[{"value":"Londonderry","offset":0},{"value":"UK","offset":13}],"reference":"ChIJY5PQNOTdX0gRL_NVxyr6Ib0","place_id":"ChIJY5PQNOTdX0gRL_NVxyr6Ib0","matched_substrings":[{"offset":0,"length":6}],"id":"aede3ce2eed4c02e3eaaa4fb737ceccedc654fc6","description":"Londonderry, UK"},{"types":["transit_station","point_of_interest","establishment","geocode"],"terms":[{"value":"London City Airport","offset":0},{"value":"London","offset":21},{"value":"UK","offset":29}],"reference":"ChIJwflgaYio2EcRkocxkiDA2bw","place_id":"ChIJwflgaYio2EcRkocxkiDA2bw","matched_substrings":[{"offset":0,"length":6}],"id":"cf6592cfaf9f2fa9ad98edaf47412e7a575455d8","description":"London City Airport, London, UK"},{"types":["transit_station","point_of_interest","establishment","geocode"],"terms":[{"value":"London Luton Airport","offset":0},{"value":"Luton","offset":22},{"value":"UK","offset":29}],"reference":"ChIJ97cTbdk3dkgRmeEdIDO10Zo","place_id":"ChIJ97cTbdk3dkgRmeEdIDO10Zo","matched_substrings":[{"offset":0,"length":6}],"id":"3ce20a501fd0d7fde26fc2e36b262fcf3b869509","description":"London Luton Airport, Luton, UK"}]}');
            res.setStatusCode(200);
        }

        if (endpoint.contains('https://maps.googleapis.com/maps/api/place/details/json?placeid')) {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"OK","result":{"rating":2.4,"name":"Luton Airport London (Ltn)","geometry":{"viewport":{"southwest":{"lng":-0.3777018302915021,"lat":51.87780761970849},"northeast":{"lng":-0.375003869708498,"lat":51.88050558029149}},"location":{"lng":-0.376388,"lat":51.87924839999999}}},"html_attributions":[]}');
            res.setStatusCode(200);
        }

        if (endpoint.contains('https://api.uber.com/v1.2/products?')) {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"localized_display_name":"UberX","distance":52.46,"display_name":"UberX","product_id":"3cb90303-3869-4701-a8fd-92efba468a94","high_estimate":108}');
            res.setStatusCode(200);
        }

        if (endpoint == 'https://api.uber.com/v1.2/requests') {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"request_id":"cd259799-d47c-4b20-a9b3-f54de38a131e", "status":"processing"}');
            res.setStatusCode(200);
        }

        if (endpoint.contains('https://api.uber.com/v1.2/estimates/price?')) {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"prices":{}}');
            res.setStatusCode(200);
        }

        if (endpoint.contains('https://api.uber.com/v1.2/requests/current')) {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"accepted"}');
            res.setStatusCode(200);
        }

        if (endpoint.contains('https://api.uber.com/v1.2/requests/fakeRequestId')) {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success":"true"}');
            res.setStatusCode(200);
        }
        return res;
    }
}