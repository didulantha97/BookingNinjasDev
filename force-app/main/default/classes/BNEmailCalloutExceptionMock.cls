public with sharing class BNEmailCalloutExceptionMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        CalloutException e = (CalloutException)CalloutException.class.newInstance();
        throw e;
    }
}