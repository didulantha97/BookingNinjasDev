@isTest
public class AccountTriggerTest {

    static testmethod void testContinentChange() {

        Test.StartTest();
            
        Account acc = new Account();
        acc.Name = 'Test Account 1';
        acc.BillingCountry = 'Philippines';
        acc.Continent__c = 'Asia';
        acc.Total_Contact_Records__c = 7;
        insert acc;
        
        Contact con1 = new Contact();
        con1.LastName = 'Harroch1';
        con1.AccountId = acc.Id;
        con1.MailingCountry = 'Philippines';
        con1.Continent__c = 'Asia';
        insert con1;
        
        Contact con2 = new Contact();
        con2.LastName = 'Harroch2';
        con2.AccountId = acc.Id;
        con2.MailingCountry = 'Philippines';
        con2.Continent__c = 'Asia';
        insert con2;
        
        Contact con3 = new Contact();
        con3.LastName = 'Harroch3';
        con3.AccountId = acc.Id;
        con3.MailingCountry = 'Philippines';
        con3.Continent__c = 'Asia';
        insert con3;
        
        Contact con4 = new Contact();
        con4.LastName = 'Harroch4';
        con4.AccountId = acc.Id;
        con4.MailingCountry = 'Philippines';
        con4.Continent__c = 'Asia';
        insert con4;
        
        Contact con5 = new Contact();
        con5.LastName = 'Harroch5';
        con5.AccountId = acc.Id;
        con5.MailingCountry = 'Philippines';
        con5.Continent__c = 'Asia';
        insert con5;
        
        Contact con6 = new Contact();
        con6.LastName = 'Harroch6';
        con6.AccountId = acc.Id;
        con6.MailingCountry = 'Philippines';
        con6.Continent__c = 'Asia';
        insert con6;
        
        Contact con7 = new Contact();
        con7.LastName = 'Harroch7';
        con7.AccountId = acc.Id;
        con7.MailingCountry = 'Philippines';
        con7.Continent__c = 'Asia';
        insert con7;
       
        update acc;
        
        //List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        
        Test.StopTest();

        System.assertEquals(acc.Continent__c, con1.Continent__c);
        System.assertEquals(acc.Continent__c, con2.Continent__c);
        System.assertEquals(acc.Continent__c, con3.Continent__c);
        System.assertEquals(acc.Continent__c, con4.Continent__c);
        System.assertEquals(acc.Continent__c, con5.Continent__c);
        System.assertEquals(acc.Continent__c, con6.Continent__c);
        System.assertEquals(acc.Continent__c, con7.Continent__c);
        //System.assertEquals(acc.Total_Contact_Records__c, contacts.size());
    }
    
}