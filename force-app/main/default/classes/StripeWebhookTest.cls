@isTest
public class StripeWebhookTest {

    @testSetup static void setupTestData() {
        Contact con = new Contact(
        	FirstName = 'Test',
            LastName = 'User'
        );
        insert con;
        
    	Stripe_Transaction__c trans = new Stripe_Transaction__c(
        	Payment_Intent_Id__c = 'pi_1GeNGeLJXa2cEwUAJk8NtQ0Q',
            Guest_Contact__c = con.Id
        );
        insert trans;
    }
    
    @isTest static void testWebhook() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'stripe/services/apexrest/stripe/webhook';
        request.httpMethod = 'GET';
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'Stripe_Payment_Intent_Response' LIMIT 1];
		request.requestBody = Blob.valueOf(sr.Body.toString());
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        	StripeWebhook.doPost();
        Test.stopTest();
        
        Stripe_Transaction__c trans = [SELECT Id, Stripe_Transaction_Id__c, Total_Amount__C, Status__c, Receipt_URL__c
                         FROM Stripe_Transaction__c
                         WHERE Payment_Intent_Id__c = 'pi_1GeNGeLJXa2cEwUAJk8NtQ0Q'];
        System.assertEquals('Succeeded', trans.Status__c);
    }
}