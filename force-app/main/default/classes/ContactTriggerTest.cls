@isTest
public class ContactTriggerTest {

    static testmethod void testCallFlowChange() {
           
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.BillingCountry = 'Philippines';
        acc.Continent__c = 'Asia';
        insert acc;
        
        Contact con1 = new Contact();
        con1.LastName = 'Harroch1';
        con1.AccountId = acc.Id;
        con1.MailingCountry = 'Philippines';
        con1.Continent__c = 'Asia';
        con1.Status__c = 'Cold';
        con1.Call_Flow__c = 'Priority Call List 3';
        con1.Call_Request_Date__c = DateTime.Now();
        con1.MobilePhone = '+19176002345';
        con1.Phone = '+19176002345';
        con1.X2nd_Phone_Number__c = '+19176002345';
        insert con1;
        
        Contact con6 = new Contact();
        con6.LastName = 'Harroch6';
        con6.AccountId = acc.Id;
        con6.Status__c = 'Mapping Call';
        insert con6;
        
        Contact con7 = new Contact();
        con7.LastName = 'Harroch1';
        con7.AccountId = acc.Id;
        con7.MailingCountry = 'Algeria';
        insert con7;
        
        Contact con8 = new Contact();
        con8.LastName = 'Harroch8';
        con8.AccountId = acc.Id;
        con8.MailingCountry = 'Australia';
        insert con8;
        
        Contact con2 = [Select Id, Status__c, Call_Flow__c, Linkedin_Activity__c, LinkedIn_Requested_Date__c from Contact Where Id = :con1.Id];
        con2.Status__c = 'Warm';
        con2.Call_Flow__c = 'Priority Call List 2';
        con2.Call_Request_Date__c = DateTime.Now();
        con2.Linkedin_Activity__c = 'Send Request';
        con2.LinkedIn_Requested_Date__c = Date.Today();
        update con2;
        
        Contact con3 = [Select Id, Name, AccountId, Status__c, Call_Flow__c, Linkedin_Activity__c, LinkedIn_Requested_Date__c from Contact Where Id = :con1.Id];
        con3.Status__c = 'Hot';
        con3.Call_Flow__c = 'Priority Call List 1';
        con3.Call_Request_Date__c = DateTime.Now();
        //con3.Linkedin_Activity__c = 'Send Request';
        //con3.LinkedIn_Requested_Date__c = Date.Today();
        update con3;
        
        Contact con4 = [Select Id, Name, AccountId, Status__c, Call_Flow__c, Linkedin_Activity__c, LinkedIn_Requested_Date__c from Contact Where Id = :con1.Id];
        con4.Status__c = 'Dead';
        con4.Call_Flow__c = '';
        con4.Call_Request_Date__c = null;
        update con4;
        
        Contact con5 = [Select Id, Name, AccountId, Status__c, Call_Flow__c, Linkedin_Activity__c, LinkedIn_Requested_Date__c from Contact Where Id = :con1.Id];
        con5.Status__c = '';
        con5.Call_Flow__c = '';
        con5.Call_Request_Date__c = null;
        con5.Linkedin_Activity__c = '';
        con5.LinkedIn_Requested_Date__c = null;
        update con5;
        
        Opportunity opp = new Opportunity();
        opp.Name = con3.Name + '_' + String.valueOf(Date.Today().addDays(7));
        opp.AccountId = con3.AccountId;
        opp.Primary_Contact__c = con3.Id;
        opp.CloseDate = Date.Today().addDays(7);
        opp.StageName = 'Qualification';
        opp.Probability = 10;
        insert opp;
        
        List<Cook_Book__c> cook_books = new List<Cook_Book__c>();
        for(Integer i = 1; i <=5; i++) {
            Cook_Book__c cb = new Cook_Book__c();
            cb.Name = 'Test Appointment ' + i;
            cb.Contact__c = con1.Id;
            cb.Mobile__c = '+19176002345';
            cb.Phone__c = '+19176002345';
            cb.X2nd_Phone__c = '+19176002345';
            cook_books.add(cb);
        }
        insert cook_books;
        
        
        Test.StartTest();
            System.assertEquals(con1.Call_Flow__c, 'Priority Call List 3');
            System.assertEquals(con2.Call_Flow__c, 'Priority Call List 2');
            System.assertEquals(con3.Call_Flow__c, 'Priority Call List 1');
            System.assertEquals(con4.Call_Flow__c, '');
            System.assertEquals(con5.Call_Flow__c, '');
            System.assertEquals(con3.Id, opp.Primary_Contact__c);
            System.assertEquals(cook_books[0].Mobile__c, con1.MobilePhone);
            System.assertEquals(cook_books[0].Phone__c, con1.Phone);
            System.assertEquals(cook_books[0].X2nd_Phone__c, con1.X2nd_Phone_Number__c);
        Test.StopTest();
    }
    
    static testmethod void testContactFromTrialForm() {
        
        Account acc = new Account();
        acc.Name = 'Booking Ninjas';
        insert acc;
           
        Contact contact = new Contact();
        contact.trialBusinessName__c = 'Booking Ninjas';
        contact.firstName = 'Teguh';
        contact.lastName = 'Prayoga';
        contact.Email = 'teguh@bookingninjas.com';
        contact.Phone = '+6281222290905';
        insert contact;
        
        Contact contactRecord = [SELECT Id, AccountId, trialBusinessName__c FROM Contact WHERE Id = :contact.Id LIMIT 1];
        
        Test.StartTest();
        System.assertEquals(contactRecord.AccountId, acc.Id);
        Test.StopTest();
    }
    
    static testmethod void testContact2FromTrialForm() {
        
        Contact contact = new Contact();
        contact.trialBusinessName__c = 'Booking Ninjas';
        contact.firstName = 'Teguh';
        contact.lastName = 'Prayoga';
        contact.Email = 'teguh@bookingninjas.com';
        contact.Phone = '+6281222290905';
        insert contact;
        
        Account accountRecord = [SELECT Id, Name FROM Account LIMIT 1];
        Contact contactRecord = [SELECT Id, AccountId, trialBusinessName__c FROM Contact WHERE Id = :contact.Id LIMIT 1];
        
        Test.StartTest();
        System.assertEquals(accountRecord.Name, 'Booking Ninjas');
        Test.StopTest();
    }
    
}