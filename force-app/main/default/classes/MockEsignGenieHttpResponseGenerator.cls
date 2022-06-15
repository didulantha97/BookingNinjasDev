@isTest
global with sharing class MockEsignGenieHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        EsignEmbedService service = new EsignEmbedService();

        System.assert(req.getEndpoint().contains(service.endpoint));

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);

        if(req.getEndpoint().contains(service.oauthEndpoint)) {
            res.setBody('{"access_token":"test_access_token"}');
        } else if(req.getEndpoint().contains(service.createFolderEndpoint)){
            res.setBody('{"result":"success","embeddedSigningSessions": [{"embeddedSessionURL": "UNIQUE_EMBEDDED_SESSION_URL"}],"folder":{"folderId": 100 }}');
        } else if(req.getEndpoint().contains(service.downloadFolderEndpoint)){
            res.setHeader('Content-Type', 'application/octet-stream');
            res.setBodyAsBlob(Blob.valueOf('TEST'));
        } else if(req.getEndpoint().contains(service.folderDetailEndPoint)){
            res.setBody(
                '{"folder":{"folderId": 100,"folderStatus": "EXECUTED" },'+
                ' "allFieldsNameValue":[{"fieldType":"text","name":"Signer Name","value":"Test User"},'+
                '{"fieldType":"text","name":"Card Number","value":"0001123400011234"},'+
                '{"fieldType":"text","name":"Expiration Year","value":"25"},'+
                '{"fieldType":"text","name":"Expiration Month","value":"10"}]}'
            );
        }

        return res;
    }
}