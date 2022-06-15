@isTest
public with sharing class BN_TrialSucceedControllerTest {

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
        insert opportunity;
    }

    public static testMethod void testAddContact() 
    {
        PageReference successPage = Page.BN_TrialSucceed;
        Test.setCurrentPage(successPage);
        Test.setMock(HttpCalloutMock.class, new StripeHttpCalloutMock());
        ApexPages.currentPage().getParameters().put('id', 'stripe-id');

        Test.startTest();
        BN_TrialSucceedController controller = new BN_TrialSucceedController();
        Cookie visited = ApexPages.currentPage().getCookies().get('visited-stripe-id');
        controller.addSuccessActions();
        Test.stopTest();

        System.AssertEquals(visited.getValue(), '1');
    }

}