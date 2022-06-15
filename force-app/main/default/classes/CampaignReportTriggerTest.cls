@isTest
public class CampaignReportTriggerTest {
    
    @testSetup static void setup() {
        Contact ct = new Contact(LastName = 'Teguh', Email = 'teguh@bookingninjas.com');
        insert ct;
        insert new Campaign_Report__c(Name = 'New Campaign', Contact__c = ct.Id);
    }

    static testmethod void testOpportunityFromTrialForm() {
        Contact ct = [SELECT Id FROM Contact WHERE Email = 'teguh@bookingninjas.com'];

        Test.StartTest();
        insert new Campaign_Report__c(Name = 'New Campaign', Contact__c = ct.Id);
        Test.StopTest();

        System.assertEquals(1, [SELECT count() FROM Campaign_Report__c WHERE Contact__c = :ct.Id]);
    }

}