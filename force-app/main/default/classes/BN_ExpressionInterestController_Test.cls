@isTest(seealldata = true)
public with sharing class BN_ExpressionInterestController_Test {

    public static Account account;
    public static Contact contact;
    public static Opportunity opportunity;
    
    static 
    {
        createTestData();
    }
    
    public static void createTestData() 
    {
        account = new Account();
        account.Name =  'Booking Ninjas';
        insert account;
        
        contact = new Contact();
        contact.LastName = 'Harroch';
        contact.FirstName = 'David';
        contact.Email = 'testdavid@bookingninjas.com';
        contact.AccountId = account.Id;
        insert contact;
        
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
        
            PageReference pageRef = Page.BN_Interest;
            Test.setCurrentPage(pageRef);

            BN_ExpressionInterestController ctrl = new BN_ExpressionInterestController();
            
            ctrl.name = 'Joe Johnson';
            ctrl.email = 'joe@email.com';
            ctrl.propertyName = 'Test Hotel';
            ctrl.numberOfRooms = '100';
            ctrl.pmsText = 'Test messgae';
            ctrl.targetDateOfActivation = Date.Today();
            ctrl.register(); 
            
        Test.stopTest();
    }
}