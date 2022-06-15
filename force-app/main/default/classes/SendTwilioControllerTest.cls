/*****************************************************************************************
 * @Purpose      :  Unit test implementations for SendTwilioController
 * @Created Date :  30 August 2017
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/ 
@isTest
private class SendTwilioControllerTest {

    @testSetup
    static void setupTestData() {
        List<Contact> conList = new List<Contact>{
            new Contact(LastName = 'with Mobile', MobilePhone = '4444444444'),
            new Contact(LastName = 'without Mobile')
        };
            
        insert conList;
    }
    
    @isTest
    static void testConstructor() {        
        
        Contact con = [SELECT Id, MobilePhone FROM Contact WHERE LastName = 'with Mobile' LIMIT 1];
        
        PageReference pageRef = Page.SendTwilio;
        Test.setCurrentPage(pageRef);
        SendTwilioController ctrl = new SendTwilioController();
        ctrl.Ids = pageRef.getParameters().put('id', String.valueOf(con.Id));
    }
}