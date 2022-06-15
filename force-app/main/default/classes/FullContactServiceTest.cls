/*****************************************************************************************
 * @Purpose      :  Hold all the unit tests for FullContactService
 * @Created Date :  30 April 2018
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/ 
@isTest
private class FullContactServiceTest {

    //	create test data
    @testSetup
    static void setupTestData() {
        Contact con = new Contact(
            FirstName = 'Full',
            LastName = 'Contact',
            MobilePhone = '4444444444',
            Email = 'email@abc.com'
        );
        
        insert con;
    }
    
   	//	Exception flow : call without setting the Mock callout
    @isTest
    static void testFullContactException() {
        Test.startTest();
            Contact con = [SELECT Id FROM Contact WHERE Email = 'email@abc.com'];
            FullContactService.updateContact(con.Id);
        Test.stopTest();
    }
    
    //	Happy flow : call after setting required Mock response
    @isTest
    static void testFullContact() {
        Test.startTest();
            Test.setMock(System.HttpCalloutMock.class, new MockHttpCalloutResponse());
            Contact con = [SELECT Id FROM Contact WHERE Email = 'email@abc.com'];
            FullContactService.updateContact(con.Id);
        Test.stopTest();
    }
}