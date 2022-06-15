/*
CHANGE LOG:
-  Edited by Bohdan Dosiak 27.12.2020

*/
@isTest(seealldata = true)
public with sharing class CareerToContactController_Test {
    
    public static Career__c career = new Career__c();
    public static Account account  = new Account();
    public static Contact contact = new Contact();
    
    public static Id id;
    
    static { createTestData(); }
    
    public static void createTestData()
    {
        // account
        account.Name = 'Booking Ninjas Devs_Test';
        insert account;
         //create custom setting
        Main_Accounts__c ma = new Main_Accounts__c();
        ma.Name = 'Booking Ninjas Devs_Test';
        ma.Account_Id__c = account.id;
        insert ma;
        
        // contact
        contact.FirstName = 'Joe';
        contact.LastName = 'Test';
        contact.AccountId = account.Id;
        contact.Email =  'test1@bookingninjas.com';
        insert contact; 
        
        // career
        career.Name__c = 'Test Applicant';
        career.Email__c = 'test@email.com';
        career.Phone__c = '+1987654321';
        insert career;
        
        id = career.Id;
    }
    
    public static testMethod void dotheConversion() 
    {
        Career__c c = [SELECT Id, Name__c, Email__c, Phone__c FROM Career__c WHERE Id = :id LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', c.Id);
        CareerToContactController ctr = new CareerToContactController(new ApexPages.StandardController(c));
        
        Test.StartTest();
        
        ctr.convertToContact();
        
        Test.StopTest();
    }
    
    public static testMethod void updateOpp() {
        Career__c c = [SELECT Id, Name__c, Email__c, Phone__c FROM Career__c WHERE Id = :id LIMIT 1];
  
        //Create contact
        Contact cont = new Contact();
        cont.FirstName = 'Test';
        cont.LastName = 'Applicant';
        cont.AccountId = account.Id;
        cont.Email =  'test@email.com';
        insert cont; 
        //create opportunity
        Opportunity newOpp = new Opportunity();
        newOpp.Name = 'Onboarded ' + Date.valueOf(System.now().addHours(40));
        newOpp.AccountId = account.Id;
        newOpp.StageName = 'Onboarded';
        newOpp.CloseDate = Date.valueOf(System.now().addHours(40)); //40 hours hardcoded
        newOpp.Primary_Contact__c = cont.Id;
        newOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Developer').getRecordTypeId();
        insert newOpp;
        
        
        
        ApexPages.currentPage().getParameters().put('id', c.Id);
        CareerToContactController ctr = new CareerToContactController(new ApexPages.StandardController(c));
        
        Test.StartTest();
        
        ctr.convertToContact();
        
        Test.StopTest();
    }
}