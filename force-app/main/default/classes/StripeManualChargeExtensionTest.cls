/*****************************************************************************************
 * @Purpose      : Unit test for StripeManualChargeExtension
 * @Created Date : 14 August 2019
 * @Author       : Madhura Priyadarshana 
 *****************************************************************************************/
@isTest
private class StripeManualChargeExtensionTest {
    
    @testSetup
    static void setupTestData() {
        Test.startTest();
        Contact contactWithStripeId = new Contact(
          FirstName = 'Test',
            LastName = 'User',
            Stripe_Id__c = 'tk_dsfj324'
        );
        insert contactWithStripeId;
        
        Card__c card = new Card__c(
          Card_Number__c = 'Test Card',
            Contact__c = contactWithStripeId.Id
        );
        insert card;
        
        Test.stopTest();        
    }
    
    @isTest
    static void makeSuccessCharge() {
        Test.startTest();
        Contact con = [SELECT Id, Stripe_Id__c FROM Contact LIMIT 1];
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(con);
        StripeManualChargeExtension ctrl = new StripeManualChargeExtension(stdCtrl);
        ctrl.stripeTransaction.Total_Amount__c = 52.50;
        ctrl.serviceChargeIncluded = true;
        
        Test.setMock(System.HttpCalloutMock.class, new MockHttpResponseGenerator());
        ctrl.chargeCustomer();
        Test.stopTest();
        
        System.assert(NULL != [SELECT Id FROM Stripe_Transaction__c]);
    }

}