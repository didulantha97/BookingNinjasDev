/*****************************************************
 * @Purpose         : Unit test for TwilioClientController
 * @Created Date    : 13 November 2018
 * @Author          : Madhura Priyadarshana 
 ****************************************************/ 
@isTest
private class TwilioClientControllerTest {
    
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
        
        Contact con = new Contact(
        	FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@con.com',
            MobilePhone = '1111111111'
        );
        insert con;
        
        Cook_Book__c cb = new Cook_Book__c(
        	Name = 'Test Cook Book',
            Contact__c = con.Id
        );
        insert cb;
        
        Test.stopTest();
    }
    //  unit test for basic functionalities of the controller
    //  
    //  getToken() can not be properly tested in the way wanted as the Twilio helper library package has been
    //  developed by specifying some attributes for Test execution (Test.isRunningTest())
    @isTest static void testFundamentals() {
        Test.startTest();
            Cook_Book__c cb = [SELECT Id FROM Cook_Book__c WHERE Name = 'Test Cook Book'];
            TwilioClientController ctrl = new TwilioClientController();
            ctrl.uname = 'test uname';
            Test.setCurrentPageReference(Page.Dial);
            System.currentPageReference().getParameters().put('PhoneNumber', '11111111111');
            System.currentPageReference().getParameters().put('parentCBId', cb.Id);
            System.assert( null != ctrl.getDial());
        Test.stopTest();
    }
    
    @isTest static void testExtension() {
        Test.startTest();
            Contact con = [SELECT Id FROM Contact WHERE Email = 'test@con.com'];
            Cook_Book__c cb = [SELECT Id FROM Cook_Book__c WHERE Name = 'Test Cook Book'];
            TwilioClientController ctrl = new TwilioClientController();
            ctrl.uname = 'test uname';
            Test.setCurrentPageReference(Page.Dial);
            System.currentPageReference().getParameters().put('PhoneNumber', '1111111x1111');
            System.currentPageReference().getParameters().put('parentCBId', con.Id);
            System.assert( null != ctrl.getDial());
        Test.stopTest();
    }
    
    //##	SMS related unit test		//
    //  unit test for success twilio call
    @isTest
    static void testSendSMS() {
        Test.setMock(HttpCalloutMock.class, new MockHttpCalloutResponse());
        
        Contact con = [SELECT Id FROM Contact WHERE LastName = 'with Mobile' LIMIT 1];
        
        Test.startTest();
            TwilioClientController ctrl = new TwilioClientController();
            ctrl.isSMS = false;
            ctrl.parentRecordId = String.valueOf(con.Id);
            ctrl.message = '{{name}} Sample message from test class';
            ctrl.recipientMobile = '44444444444';
            ctrl.triggerMessage();
            
            ctrl.isSMS = true;
            ctrl.triggerMessage();
        
        Test.stopTest();
    }
    
    //  Unit test for catch block
    @isTest
    static void testException() {
        Contact con = [SELECT Id FROM Contact WHERE LastName = 'without Mobile' LIMIT 1];
        
        Test.startTest();
        
            TwilioClientController ctrl = new TwilioClientController();
            ctrl.isSMS = false;
            ctrl.parentRecordId = String.valueOf(con.Id);
        	ctrl.recipientMobile = '44444444444';
            ctrl.message = '{{name}} Sample message from test class';
            ctrl.triggerMessage();   // this will throw callout in test class exception
            
        Test.stopTest();
        
        System.assert(ctrl.showError);
        System.assert(!ctrl.showSuccess);
    }
    
    //  unit test for utility methods in the controller
    @isTest static void testUtility() {
        Test.startTest();
            TwilioClientController ctrl = new TwilioClientController();
            List<SelectOption> options = ctrl.getTemplates();
            ctrl.selectedTemplate = options.get(0).getValue();
            ctrl.onChangeTemplate();
            System.assert('--None--' == options.get(0).getLabel());
            
            ctrl.selectedTemplate = options.get(1).getvalue();
            ctrl.onChangeTemplate();
            System.assert(String.isNotBlank(ctrl.message));
        
        Test.stopTest();
    }
    
    //  unit test for SMS tracking
    @isTest static void testTrackSMS() {
        Test.startTest();
            Contact con = [SELECT Id FROM Contact WHERE LastName = 'without Mobile' LIMIT 1];
            TwilioClientController ctrl = new TwilioClientController();
            ctrl.parentRecordId = String.valueOf(contact.Id);
            ctrl.trackMessage('1111111111', '22222222222', 'test message', 'Incoming', con.Id);
        Test.stopTest();
    }
    
    //####		/SMS Related Unit test			//
}