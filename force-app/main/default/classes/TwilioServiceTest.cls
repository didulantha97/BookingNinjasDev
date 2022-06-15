/*****************************************************************************************
 * @Purpose      : Unit test for TwilioService
 * @Created Date : 30 August 2018
 * @Author       : Madhura Priyadarshana 
 *****************************************************************************************/ 
@isTest
public class TwilioServiceTest {

    //  common test data setup
    @testSetup 
    static void setupTestData() {
        Test.startTest();
        
        SMS_Template__c template = new SMS_Template__c(
            Name = 'Test Template',
            Template_Body__c = 'Test Body'
        );
        insert template;  
                
        List<Contact> conList = new List<Contact>{
            new Contact(LastName = 'with Mobile', MobilePhone = '4444444444'),
            new Contact(LastName = 'without Mobile')
        };     
        insert conList;
        
        Test.stopTest();
    }
    
    //  unit test for success twilio call
    @isTest
    static void testSendSMS() {
        Test.setMock(HttpCalloutMock.class, new MockHttpCalloutResponse());
        
        Contact con = [SELECT Id FROM Contact WHERE LastName = 'with Mobile' LIMIT 1];
        
        Test.startTest();
            TwilioService service =  new TwilioService();
            service.isSMS = false;
            service.recordId = String.valueOf(con.Id);
            service.message = '{{name}} Sample message from test class';
            //service.recipient = '4444444444';
            service.triggerMessage();
            
            service.isSMS = true;
            service.triggerMessage();
        
        Test.stopTest();
    }
    
    //  Unit test for catch block
    @isTest
    static void testException() {
        Contact con = [SELECT Id FROM Contact WHERE LastName = 'without Mobile' LIMIT 1];
        
        Test.startTest();
        
            TwilioService service = new TwilioService();
            service.isSMS = false;
            service.recordId = String.valueOf(con.Id);
            service.message = '{{name}} Sample message from test class';
            service.triggerMessage();   // this will throw callout in test class exception
            
        Test.stopTest();
        
        System.assert(service.showError);
        System.assert(!service.showSuccess);
    }
    
    //  unit test for utility methods in the controller
    @isTest static void testUtility() {
        Test.startTest();
            TwilioService service = new TwilioService();
            List<SelectOption> options = service.getTemplates();
            service.selectedTemplate = options.get(0).getValue();
            service.onChangeTemplate();
            System.assert('--None--' == options.get(0).getLabel());
            
            service.selectedTemplate = options.get(1).getvalue();
            service.onChangeTemplate();
            System.assert(String.isNotBlank(service.message));
        
        Test.stopTest();
    }
    
    //  unit test for SMS tracking
    @isTest static void testTrackSMS() {
        TwilioService service = new TwilioService();
        service.recordId = String.valueOf(contact.Id);
        service.trackMessage('1111111111', '22222222222', 'test message', 'Incoming', null);
    }
}