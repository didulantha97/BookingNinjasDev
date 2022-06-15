@isTest(seealldata = true)
public with sharing class WRToContactController_Test {

    public static Webinar_Registration__c registration = new Webinar_Registration__c();
    public static Account account  = new Account();
    public static Contact contact = new Contact();
    
    public static Id id;
    
    static { createTestData(); }
    
    public static void createTestData()
    {
        // account
        account.Name = 'Business';
        insert account;
        
        // contact
        contact.FirstName = 'Joe';
        contact.LastName = 'Test';
        contact.AccountId = account.Id;
        contact.Email =  'test123@bookingninjas.com';
        insert contact; 
        
        // registration
        registration.First_Name__c = 'David';
        registration.Last_Name__c = 'Harroch';
        registration.Email__c = 'davidtest23@bookingninjas.com';
        registration.Phone__c = '+19176002345';
        insert registration;
        
        id = registration.Id;
    }
    
    public static testMethod void dotheConversion() 
    {
        Webinar_Registration__c wr = [SELECT Id, First_Name__c, Last_Name__c, Email__c, Phone__c FROM Webinar_Registration__c WHERE Id = :id LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', wr.Id);
        WRToContactController ctr = new WRToContactController(new ApexPages.StandardController(wr));
        
        Test.StartTest();
        
        ctr.convertToContact();
        
        Test.StopTest();
    }
}