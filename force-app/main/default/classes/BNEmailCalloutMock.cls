/**
* The BNEmailCalloutMock class for fake fetching api https://bookingninjas.email
* this is for testing purpose.
*
* @author  Prayoga Teguh <teguh@bookingninjas.com>
* @version 1.0
* @since   2020-09-23
*/
public with sharing class BNEmailCalloutMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;

    public BNEmailCalloutMock(Integer code, String status, String body) {
        this.code = code;
        this.status = status;
        this.body = body;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);
        return res;
    }
}