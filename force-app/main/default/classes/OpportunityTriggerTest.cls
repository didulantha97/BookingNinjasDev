@isTest
public class OpportunityTriggerTest {

    static testmethod void TestOppAutoFillFields() {
    
        Contact contact = new Contact();
        contact.LastName = 'Teguh';
        contact.Email = 'teguh@bookingninjas.com';
        insert contact;

        Account acc = new Account();
        acc.Name = 'Business Account';
        insert acc;
        
        Test.StartTest();
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp Name';
        opp.AccountId = acc.Id;
        opp.CloseDate = Date.Today();
        opp.StageName = 'Qualification';
        opp.Primary_Contact__c = contact.id;
        insert opp;
        
        Test.StopTest();
        
        //System.assertEquals(opp.Name, 'Business Account_Qualification_' + String.valueOf(Date.today().addDays(30)));
        //System.assertEquals(opp.CloseDate, Date.today().addDays(30));
        //System.assertEquals(opp.StageName, 'Qualification');
        //System.assertEquals(opp.Type, 'New Business');
    }
    
    static testmethod void testOpportunityFromTrialForm() {
        
        Contact contact = new Contact();
        contact.LastName = 'Teguh';
        contact.Email = 'teguh@bookingninjas.com';
        insert contact;
           
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'New Opportunity: Teguh';
        opportunity.trialEmail__c = 'teguh@bookingninjas.com';
        opportunity.Type = 'New Business';
        opportunity.StageName = 'Trial';
        opportunity.LeadSource = 'Booking Ninjas';
        opportunity.CloseDate = Date.Today().addDays(15);
        insert opportunity;
        
        Opportunity oppRecord = [SELECT Id, AccountId, Primary_Contact__c, trialEmail__c FROM Opportunity WHERE Id = :opportunity.Id LIMIT 1];
        
        Test.StartTest();
        System.assertEquals(oppRecord.AccountId, contact.AccountId);
        System.assertEquals(oppRecord.Primary_Contact__c, contact.Id);
        System.assertEquals(oppRecord.trialEmail__c, null);
        Test.StopTest();
    }

}