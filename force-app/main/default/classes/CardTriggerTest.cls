@isTest
public class CardTriggerTest {

    static testmethod void testCallFlowChange() {
        
        Contact contact = new Contact();
        contact.LastName = 'Teguh';
        contact.Email = 'teguh@bookingninjas.com';
        insert contact;
           
        Card__c card = new Card__c();
        card.trialEmail__c = 'teguh@bookingninjas.com';
        card.Card_Holder__c = 'Teguh';
        card.Card_Number__c = '080989999';
        card.Security_Code__c = '123';
        card.Expiration_Date__c = Date.today();
        insert card;
        
        Card__c cardRecord = [SELECT Id, Contact__c, trialEmail__c FROM Card__c WHERE Id = :card.Id LIMIT 1];
        
        Test.StartTest();
        System.assertEquals(cardRecord.Contact__c, contact.Id);
        System.assertEquals(cardRecord.trialEmail__c, null);
        Test.StopTest();
    }
    
}