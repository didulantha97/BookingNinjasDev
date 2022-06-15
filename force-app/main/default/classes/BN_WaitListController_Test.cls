@isTest(seealldata = true)
public with sharing class BN_WaitListController_Test {

    public static Id waitListId;
    public static Wait_List__c waitList = new Wait_List__c();
    public static Account account  = new Account();
    public static Contact contact = new Contact();
    public static Opportunity opportunity = new Opportunity();
    
    static { createTestData(); }
    
    public static void createTestData() 
    {
        // wait list
        waitList.Name__c = 'David Harroch';
        waitList.Email__c = 'david@bookingninjas.com';
        waitList.Phone__c = '+19176002345';
        waitList.Preferred_Contact_Method__c = 'Email Only';
        waitList.Opt_in_to_SMS_System__c = false;
        waitList.Availability_Date__c = Date.Today().addDays(15);
        insert waitList;
        
        waitListId = waitList.Id;
        
        // account
        account.Name = 'Business';
        insert account;
        
        // contact
        contact.FirstName = 'Joe';
        contact.LastName = 'Test';
        contact.AccountId = account.Id;
        contact.Email =  'test1@bookingninjas.com';
        insert contact; 
        
        // opportunity
        opportunity = new Opportunity();
        opportunity.Name = 'New Opportunity';
        opportunity.AccountId = account.Id;
        opportunity.Primary_Contact__c = contact.Id;
        opportunity.Type = 'New Business';
        opportunity.StageName = 'Trial';
        opportunity.LeadSource = 'Booking Ninjas';
        opportunity.CloseDate = Date.Today().addDays(15);
        opportunity.PMS_Text__c =  'Test message';
        insert opportunity;
    }
    
    public static testMethod void testRegister() 
    {
        Test.startTest();
        
            PageReference pageRef = Page.BN_WaitList;
            Test.setCurrentPage(pageRef);

            BN_WaitListController ctrl = new BN_WaitListController();
            
            ctrl.getPreferredContactMethod();
            ctrl.name = 'Joe Johnson';
            ctrl.email = 'joe@email.com';
            ctrl.phone = '+123456789';
            ctrl.preferredMethod = 'Email Only';
            ctrl.optforSMS = false;
            ctrl.availabilityDate = Date.Today();
            ctrl.register(); 
            
        Test.stopTest();
    }
    
    public static testMethod void dotheConversion() 
    {
        Wait_List__c wL = [SELECT Id FROM Wait_List__c WHERE Id = :waitListId LIMIT 1];
        ApexPages.currentPage().getParameters().put('id', wL.Id);
        BN_WaitListController ctrl = new BN_WaitListController(new ApexPages.StandardController(wL));
        
        Test.StartTest();
        
            ctrl.convertToOpp();
        
        Test.StopTest();
    }
}