@isTest
public class TaskTriggerTest {

    static testmethod void testContactFieldChange() {
        Test.StartTest();
        
        // Business account
        Account acc = new Account();
        acc.Name = 'Business';
        acc.BillingCountry = 'Philippines';
        acc.Continent__c = 'Asia';
        insert acc;
        
        // Contact
        Contact con = new Contact();
        con.LastName = 'James';
        con.FirstName = 'LeBron';
        con.Accountid = acc.Id;
        con.Email = 'lebronjames@gmail.com';
        con.Phone = '123456789';
        con.MailingCountry = 'Philippines';
        con.Continent__c = 'Asia';
        insert con;
        
        // Task 1 - contact
        Task ts1 = new Task();
        ts1.WhoId = con.Id;
        ts1.ActivityDate = Date.Today();
        ts1.Subject = 'Do you face these common challenges?';
        ts1.Status = 'Completed';
        ts1.Priority = 'Normal';
        insert ts1;
        
        // Update Task 2 - contact
        Task ts2 = [Select Id, cirrusadv__Num_of_Replies__c, cirrusadv__Num_of_Opens__c from Task Where Id =: ts1.Id];
        ts2.cirrusadv__Num_of_Replies__c = 1;
        update ts2;
        
        // Update Contact 2
        Contact con2 = [Select Id, Status__c from Contact Where Id =: ts1.WhoId];
        con2.Status__c = 'Active Conversation';
        update con2;
        
        // Update Task 3 - contact
        Task ts3 = [Select Id, cirrusadv__Num_of_Replies__c, cirrusadv__Num_of_Opens__c from Task Where Id =: ts1.Id];
        ts3.cirrusadv__Num_of_Opens__c = 5;
        update ts3;
        
        // Update Contact 3
        Contact con3 = [Select Id, Status__c from Contact Where Id =: ts1.WhoId];
        con3.Status__c = 'Super Warms';
        update con3;
        
        Test.StopTest();
        
        System.assertEquals(con.Id, [Select WhoId from Task Where Id =: ts1.Id].WhoId);
        System.assertEquals(ts1.Subject, 'Do you face these common challenges?');
        System.assertEquals(con2.Status__c, 'Active Conversation');
        System.assertEquals(con3.Status__c, 'Super Warms');
    } 
    
    static testmethod void testLeadFieldChange() {
        Test.StartTest();
        
        // Lead
        lead lead = new Lead();
        lead.LastName = 'Irving';
        lead.FirstName = 'Kyrie';
        lead.Email = 'lebronjames@gmail.com';
        lead.Phone = '123456789';
        lead.Country = 'Philippines';
        lead.Continent__c = 'Asia';
        insert lead;
        
        // Task 1 - lead
        Task ts1 = new Task();
        ts1.WhoId = lead.Id;
        ts1.ActivityDate = Date.Today();
        ts1.Subject = 'Do you face these common challenges?';
        ts1.Status = 'Completed';
        ts1.Priority = 'Normal';
        insert ts1;
        
        // Update Task 2 - lead
        Task ts2 = [Select Id, cirrusadv__Num_of_Replies__c, cirrusadv__Num_of_Opens__c from Task Where Id =: ts1.Id];
        ts2.cirrusadv__Num_of_Replies__c = 1;
        update ts2;
        
        // Update lead 2
        Lead lead2 = [Select Id, Status__c from Lead Where Id =: ts1.WhoId];
        lead2.Status__c = 'Active Conversation';
        update lead2;
        
        // Update Task 3 - lead
        Task ts3 = [Select Id, cirrusadv__Num_of_Replies__c, cirrusadv__Num_of_Opens__c from Task Where Id =: ts1.Id];
        ts3.cirrusadv__Num_of_Opens__c = 5;
        update ts3;
        
        // Update lead 3
        Lead lead3 = [Select Id, Status__c from Lead Where Id =: ts1.WhoId];
        lead3.Status__c = 'Super Warms';
        update lead3;
        
        Test.StopTest();
        
        System.assertEquals(lead.Id, [Select WhoId from Task Where Id =: ts1.Id].WhoId);
        System.assertEquals(ts1.Subject, 'Do you face these common challenges?');
        System.assertEquals(lead2.Status__c, 'Active Conversation');
        System.assertEquals(lead3.Status__c, 'Super Warms');
    } 
}