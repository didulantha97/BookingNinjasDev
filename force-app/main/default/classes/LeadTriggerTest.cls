@isTest
public class LeadTriggerTest {

    static testmethod void testCallFlowChange() {

        Test.StartTest();
        
        Lead lead1 = new Lead();
        lead1.LastName = 'Client 1';
        lead1.Status = 'Unqualified';
        lead1.Country = 'Philippines';
        lead1.Continent__c = 'Asia';
        lead1.Email = 'client@gmail.com';
        lead1.Status__c = 'Cold';
        lead1.Call_Flow__c = 'Priority Call List 3';
        insert lead1;
        
        Lead lead2 = [Select Id, Status__c, Call_Flow__c, Linkedin_Activity__c, LinkedIn_Requested_Date__c from Lead Where Id = :lead1.Id];
        lead2.Status__c = 'Warm';
        lead2.Call_Flow__c = 'Priority Call List 2';
        lead2.Call_Request_Date__c = DateTime.Now();
        lead2.Linkedin_Activity__c = 'Send Request';
        lead2.LinkedIn_Requested_Date__c = Date.Today();
        update lead2;
        
        Lead lead3 = [Select Id, Name, Status__c, Call_Flow__c, Linkedin_Activity__c, LinkedIn_Requested_Date__c from Lead Where Id = :lead1.Id];
        lead3.Status__c = 'Hot';
        lead3.Call_Flow__c = 'Priority Call List 1';
        lead3.Call_Request_Date__c = DateTime.Now();
        //lead3.Linkedin_Activity__c = 'Send Request';
        //lead3.LinkedIn_Requested_Date__c = Date.Today();
        update lead3;
        
        Lead lead4 = [Select Id, Name, Status__c, Call_Flow__c, Linkedin_Activity__c, LinkedIn_Requested_Date__c from Lead Where Id = :lead1.Id];
        lead4.Status__c = 'Dead';
        lead4.Call_Flow__c = '';
        lead4.Call_Request_Date__c = null;
        update lead4;
        
        Lead lead5 = [Select Id, Name, Status__c, Call_Flow__c, Linkedin_Activity__c, LinkedIn_Requested_Date__c from Lead Where Id = :lead1.Id];
        lead5.Status__c = '';
        lead5.Call_Flow__c = '';
        lead5.Call_Request_Date__c = null;
        lead5.Linkedin_Activity__c = '';
        lead5.LinkedIn_Requested_Date__c = null;
        update lead5;
        
        Test.StopTest();

        System.assertEquals(lead1.Call_Flow__c, 'Priority Call List 3');
        System.assertEquals(lead2.Call_Flow__c, 'Priority Call List 2');
        System.assertEquals(lead3.Call_Flow__c, 'Priority Call List 1');
        System.assertEquals(lead4.Call_Flow__c, '');
        System.assertEquals(lead5.Call_Flow__c, '');
    }
}