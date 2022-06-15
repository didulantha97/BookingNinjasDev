@isTest
private class StripeCheckoutControllerTest {

    @testSetup static void setupTestData() {
        
    }
    
    @isTest static void testMainFunctions() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('Stripe_Checkout_Session_Response');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        
        	StripeCheckoutController ctrl = new StripeCheckoutController();
        	ctrl.getSessionId();
        	ctrl.captureTransaction();
        
        Test.stopTest();
        System.assert(NULL != [SELECT Id FROM Stripe_Transaction__c]);
    }
    
    @isTest static void testAmountScenarios() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('Stripe_Checkout_Session_Response');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        
        	StripeCheckoutController ctrl = new StripeCheckoutController();
        	ctrl.amount = '12.52';
        	ctrl.getSessionId();
        	
        	ctrl.amount = '12.5';
        	ctrl.getSessionId();
        
        	ctrl.amount = '12.522';
        	ctrl.getSessionId();
        
        Test.stopTest();
        System.assert(NULL != [SELECT Id FROM Stripe_Transaction__c]);
    }
}