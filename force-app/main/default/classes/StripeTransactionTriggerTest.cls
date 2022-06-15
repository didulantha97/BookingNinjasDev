@isTest
public class StripeTransactionTriggerTest {

    static testmethod void testCallFlowChange() {
        
        Contact contact = new Contact();
        contact.LastName = 'Teguh';
        contact.Email = 'teguh@bookingninjas.com';
        insert contact;
           
        Stripe_Transaction__c st = new Stripe_Transaction__c();
        st.trialEmail__c = 'teguh@bookingninjas.com';
        st.Stripe_Transaction_Id__c = '123';
        st.Total_Amount__c = 1;
        st.Description__c = 'Desc';
        st.Receipt_URL__c = 'https://bookingninjas.com';
        insert st;
        
        Stripe_Transaction__c stRecord = [SELECT Id, Guest_Contact__c, trialEmail__c FROM Stripe_Transaction__c WHERE Id = :st.Id LIMIT 1];
        
        Test.StartTest();
        System.assertEquals(stRecord.Guest_Contact__c, contact.Id);
        System.assertEquals(stRecord.trialEmail__c, null);
        Test.StopTest();
    }
    
}