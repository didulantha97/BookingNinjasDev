@isTest
public with sharing class LoginHistoryTest {

    @isTest
    private static void testLogInOrg() {
        System.Test.setMock(WebServiceMock.class, new WebServiceSOAPLoginMockImpl());

        Map<String, String> loginResponce = LoginHistory.logInOrg('test', '12345', true);
        System.assert(loginResponce.get('sessionId') ==  'testSessionId');
    }

    @isTest
    private static void testFetchLoginHistoryFromOrg() {
        String datePeriod = LoginHistory.CURRENT_MONTH;
        User u = createUser();

        PageReference theUrl1 = new PageReference('url/services/data/v' + LoginHistory.versionServiceClass + '/query/');
        theUrl1.getParameters().put('q', LoginHistory.getUserQueryByDatePeriod(LoginHistory.CURRENT_MONTH));
        PageReference theUrl2 = new PageReference(  'url/services/data/v' + LoginHistory.versionServiceClass + '/query/');
        theUrl2.getParameters().put('q', LoginHistory.getLoginHistoryGroupedQueryByDatePeriod(LoginHistory.CURRENT_MONTH));
        SingleRequestMock fakeUserResponce = new SingleRequestMock(200,
            'Complete',
            '{"totalSize": 1, "done": true, "records": [{"Id" : "'+ u.Id + '"}]}',
            null);
        SingleRequestMock fakeLoginHistoryResponce = new SingleRequestMock(200,
            'Complete',
            '{"totalSize": 1, "done": true, "records": [{"numOfLogins" : "20", "UserId" : "'+ u.Id + '"}]}',
            null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(theUrl1.getUrl(), fakeUserResponce);
        endpoint2TestResp.put(theUrl2.getUrl(), fakeLoginHistoryResponce);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        Test.startTest();
        List<LoginHistory.UserLoginHistoryWrapper> logs = LoginHistory.fetchLoginHistory('url/services', '', datePeriod);
        Test.stopTest();
        System.assert(logs.size() ==  1);
    }

    @isTest
    private static void testCustomDatePeriodOptions() {
        List<LoginHistory.CustomOptions> options = LoginHistory.getDatePeriodOptions();
        System.assert(options.size() !=  0);
    }

    @isTest
    private static void testGetLoginDetails() {
        LoginHistory.LoginHistoryDetailsResponce responce = new LoginHistory.LoginHistoryDetailsResponce();
        responce.records = new List<LoginHistory.LoginHistoryWraper>{
            new LoginHistory.LoginHistoryWraper()
        };
        SingleRequestMock fakeResponce = new SingleRequestMock(200, 'Complete', JSON.serialize(responce), null);
        User u = createUser();
        Test.setMock(HttpCalloutMock.class, fakeResponce);
        Test.startTest();
        List<LoginHistory.LoginHistoryWraper> res = LoginHistory.getLoginHistoryDetails('serverUrl', '', LoginHistory.LAST_14_DAYS, u.Id );
        Test.stopTest();
        System.assert(res.size() ==  1);
    }

    public static User createUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduse@org.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserSELECT+Id%2C+UsernSELECT+Id%2C+Usern@testorg.com');
        insert u;
        return u;
    }

    public class MultiRequestMock implements HttpCalloutMock {
        Map<String, HttpCalloutMock> requests;

        public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
            this.requests = requests;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpCalloutMock mock = requests.get(req.getEndpoint());
            System.debug(req.getEndpoint());
            return mock.respond(req);
        }

        public void addRequestMock(String url, HttpCalloutMock mock) {
            requests.put(url, mock);
        }
    }

    private class WebServiceSOAPLoginMockImpl implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType) {
            if(request instanceof partnerSoapSforceAPI.login_element) {
                partnerSoapSforceAPI.loginResponse_element result = new partnerSoapSforceAPI.loginResponse_element();
                result.result = new partnerSoapSforceAPI.LoginResult();

                result.result.sessionId = 'testSessionId';
                result.result.serverUrl = 'testServerUrl';
                response.put('response_x', result);
            }
        }
    }

    public class SingleRequestMock implements HttpCalloutMock {
        protected Integer code;
        protected String status;
        protected String bodyAsString;
        protected Blob bodyAsBlob;
        protected Map<String, String> responseHeaders;

        public SingleRequestMock(Integer code, String status, String body,
            Map<String, String> responseHeaders) {
            this.code = code;
            this.status = status;
            this.bodyAsString = body;
            this.bodyAsBlob = null;
            this.responseHeaders = responseHeaders;
        }

        public SingleRequestMock(Integer code, String status, Blob body,
            Map<String, String> responseHeaders) {
            this.code = code;
            this.status = status;
            this.bodyAsBlob = body;
            this.bodyAsString = null;
            this.responseHeaders = responseHeaders;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse resp = new HttpResponse();
            resp.setStatusCode(code);
            resp.setStatus(status);
            if (bodyAsBlob != null) {
                resp.setBodyAsBlob(bodyAsBlob);
            } else {
                resp.setBody(bodyAsString);
            }

            if (responseHeaders != null) {
                for (String key : responseHeaders.keySet()) {
                    resp.setHeader(key, responseHeaders.get(key));
                }
            }
            return resp;
        }
    }

}