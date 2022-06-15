/*****************************************************
 * @Purpose      	: Unit test for TwilioWebhook
 * @Created Date : 30 October 2018
 * @Author       	  : Madhura Priyadarshana 
 ****************************************************/ 
@isTest
private class TwilioWebhookTest {

    //	common test data setup
    @testSetup
    static void setupTestData() {
        Test.startTest();
        
        Contact con = new Contact(
        	FirstName = 'Unit',
            LastName = 'Test',
            MobilePhone = '22222222',
            Email = 'abc@def.ghi'
        );
        
        Contact con2 = new Contact(
        	FirstName = 'Unit',
            LastName = 'Test 2',
            MobilePhone = '33333333',
            Email = 'abc2@def.ghi'
        );
        
        insert new List<Contact>{con, con2};
        
        //	call recording test data
        Task newTask = new Task(
        	Subject = 'test task',
            CallObject = '1234567890poiuy',
            WhoId = con.Id
        );
        insert newTask;
        
        Test.stopTest();
    }
    
    //	Unit test for call recording call back
    @isTest static void testCallRecordingCallBack() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/webhook/recording'; //Request URL
        req.httpMethod = 'GET';
        req.addParameter('RecordingUrl', 'https://recording.url.com');
        req.addParameter('DialCallDuration', '5');
        req.addParameter('CallSid', '1234567890poiuy');        
        
        RestContext.request = req;
    	RestContext.response= res;
        
        Test.startTest();
        	TwilioWebhook.doGet();
        Test.stopTest();
    }
    
    //	Unit test for an incoming SMS by a contact already there in the system
    @isTest static void testWebhookExistingContact() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/webhook'; //Request URL
        req.httpMethod = 'GET';
        req.addParameter('To', '1111111111');
        req.addParameter('From', '22222222');
        req.addParameter('Body', 'Hi from unit test');        
        
        RestContext.request = req;
    	RestContext.response= res;
        
        Test.startTest();
        	TwilioWebhook.doGet();
        Test.stopTest();
    }
    
    //	Unit test for an incoming SMS by a contact already there in the system
    @isTest static void testWebhookExistingContactNumberChange() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/webhook'; //Request URL
        req.httpMethod = 'GET';
        req.addParameter('To', '1111111111');
        req.addParameter('From', '+33333333');
        req.addParameter('Body', 'Hi from unit test number change');        
        
        RestContext.request = req;
    	RestContext.response= res;
        
        Test.startTest();
        	TwilioWebhook.doGet();
        Test.stopTest();
    }
    
    //	Unit test for an incoming SMS but sender not in contacts
    @isTest static void testWebhookAnonymousSender() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/webhook'; //Request URL
        req.httpMethod = 'GET';
        req.addParameter('To', '1111111111');
        req.addParameter('From', '22222233');
        req.addParameter('Body', 'Hi from unit test anonymous');
                
        RestContext.request = req;
    	RestContext.response= res;
        
        Test.startTest();
        	TwilioWebhook.doGet();
        Test.stopTest();
    }
}