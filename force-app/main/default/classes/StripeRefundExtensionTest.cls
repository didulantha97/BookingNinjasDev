@isTest
private class StripeRefundExtensionTest {
    
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
        
        Stripe_Transaction__c st = new Stripe_Transaction__c(
            Guest_Contact__c = contactWithStripeId.Id,
            Stripe_Transaction_Id__c = 'ch_1EpZcpLJXa2cEwUA312DoOLM',
            Total_Amount__c = 1
        );
        insert st;
        
        Test.stopTest();        
    }
    
    @isTest
    static void makeSuccessRefund() {
        Test.startTest();
        Stripe_Transaction__c trans = [SELECT Id, Guest_Contact__c, Stripe_Transaction_Id__c,Total_Amount__c FROM Stripe_Transaction__c LIMIT 1];
        
        PageReference pageRef = Page.StripeRefund;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', trans.Id);
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(trans);
        StripeRefundExtension ctrl = new StripeRefundExtension(stdCtrl);
        
        Test.setMock(System.HttpCalloutMock.class, new MockHttpResponseGenerator());
        ctrl.doRefund();
        Test.stopTest();
    }

}