@isTest
public with sharing class BN_CheckoutSucceedControllerTest {

    private static Account account;
    private static Contact contact;
    private static String invoiceId;
    private final static Id STANDARD_PRICEBOOK_ID = Test.getStandardPricebookId();
    
    static {
        account = new Account();
        account.Name =  'Booking Ninjas';
        insert account;
        
        contact = new Contact();
        contact.LastName = 'Harroch';
        contact.FirstName = 'David';
        contact.Email = 'testdavid@bookingninjas.com';
        contact.AccountId = account.Id;
        insert contact;

        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            Type = 'New Business',
            AccountId = account.Id,
            Primary_Contact__c = contact.Id,
            CloseDate = Date.today().addDays(5),
            StageName = 'Working'
        );
        insert opp;

        Quote quot = new Quote(
            Name = 'Test Quote',
            OpportunityId = opp.Id,
            Due_Now__c = 120,
            Grand_Total__c = 120,
            One_Time_Payment__c = 120,
            Monthly_Price__c = 45,
            AnnualyPayment__c = 0,
            ExpirationDate = Date.today().addDays(7),
            Due_Date__c = Date.today().addDays(7)
        );
        insert quot;
        invoiceId = quot.Id;

        Product2 product = new Product2(
            Name = 'Extra Small',
            Hierarchy_Order__c = 1,
            Description = 'X-Tra small package',
            Product_Region__c = '(EN) English',
            AnnualDiscount__c = 'All',
            ImplementationDeposit__c = 30,
            ImplementationFee__c = 500,
            MonthlyFee__c = 75,
            IsActive = true
        );
        insert product;

        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            Name = CreateInvoiceAuraController.PRICEBOOK_STANDARD_NAME,
            IsActive = true
        );
        update standardPricebook;

        PriceBookEntry pbe = new PriceBookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = product.Id,
            IsActive = true,
            UnitPrice = 75
        );
        insert pbe;
    }

    public static testMethod void testNewVisitWithQuoteId() 
    {
        PageReference successPage = Page.BN_CheckoutSucceed;
        Test.setCurrentPage(successPage);
        ApexPages.currentPage().getParameters().put('id', 'stripe-id');
        ApexPages.currentPage().getParameters().put('invoice', invoiceId);
        ApexPages.currentPage().getParameters().put('order', '1');
        ApexPages.currentPage().getParameters().put('length', 'monthly');

        Test.startTest();
        BN_CheckoutSucceedController controller = new BN_CheckoutSucceedController();
        Cookie visited = ApexPages.currentPage().getCookies().get('visited-stripe-id');
        controller.addSuccessActions();
        Test.stopTest();

        System.AssertEquals(visited.getValue(), '1');
    }

    public static testMethod void testNewVisitWithoutQuoteId() 
    {
        PageReference successPage = Page.BN_CheckoutSucceed;
        Test.setCurrentPage(successPage);
        ApexPages.currentPage().getParameters().put('id', 'stripe-id');
        ApexPages.currentPage().getParameters().put('invoice', '');
        ApexPages.currentPage().getParameters().put('order', '1');
        ApexPages.currentPage().getParameters().put('length', 'monthly');

        Test.startTest();
        BN_CheckoutSucceedController controller = new BN_CheckoutSucceedController();
        Cookie visited = ApexPages.currentPage().getCookies().get('visited-stripe-id');
        controller.addSuccessActions();
        Test.stopTest();

        System.AssertEquals(visited.getValue(), '1');
    }

}