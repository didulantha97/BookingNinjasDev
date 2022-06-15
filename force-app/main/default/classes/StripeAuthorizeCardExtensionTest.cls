/*****************************************************************************************
 * @Purpose      : Unit test for StripeAuthorizeCardExtension
 * @Created Date : 27 August 2019
 * @Author       : Madhura Priyadarshana 
 *****************************************************************************************/
@isTest
private class StripeAuthorizeCardExtensionTest {

    @testSetup
    static void setupTestData() {
        Contact con = new Contact(
        	FirstName = 'Stripe',
            LastName = 'User',
            Email = 'stripe@user.com',
            Stripe_Id__c = ''
        );
        insert con;
        
        Card__c card = new Card__c(
        	Contact__c = con.Id
        );
        insert card;
    }
    
    @isTest static void testCreateCustomer() {
        Test.startTest();
        Card__c card = [SELECT Id, Contact__c FROM Card__c LIMIT 1];
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(card);
        StripeAuthorizeCardExtension ctrl = new StripeAuthorizeCardExtension(stdCtrl);
        
        Test.setMock(System.HttpCalloutMock.class, new MockHttpResponseGenerator());
        ctrl.createCustomer();
        
        Contact con = [SELECT Id, Stripe_Id__c FROM Contact WHERE Id =: card.Contact__c LIMIT 1];
        System.assert(con.Stripe_Id__c != NULL);
        Test.stopTest();
    }
}