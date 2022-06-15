@isTest
private class BN_ThankYouControllerTest {
    @testSetup
    static void setupData() {
        prepareData();
    }

    @isTest
    static void testPage() {
        Id quoteId = [SELECT Id FROM Quote LIMIT 1].Id;
        PageReference activationPage = Page.BN_ThankYou;
        Test.setCurrentPage(activationPage);
        ApexPages.currentPage().getParameters().put('id', quoteId);

        Test.startTest();
        BN_ThankYouController controller = new BN_ThankYouController();
        Test.stopTest();

        System.assert(controller.message != null, 'Message should not null.');
        System.assert(controller.message == 'The activation is successful!', 'Message is not correct.');
    }

    private static void prepareData() {
        Account account = new Account(Name = 'Booking Ninjas');
        insert account;

        Contact contact = new Contact(
            AccountId = account.Id,
            FirstName = 'Teguh',
            LastName = 'Prayoga',
            Email = 'teguh@bookingninjas.com',
            Status__c = 'Warm'
        );
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

        Product2 product = new Product2(
            Name = 'Extra Small',
            Hierarchy_Order__c = 1,
            Description = 'X-Tra small package',
            Product_Region__c = '(EN) English',
            AnnualDiscount__c = 'All',
            Features__c = 'Guest Management',
            Size__c = '50-100',
            ImplementationDeposit__c = 30,
            ImplementationFee__c = 500,
            MonthlyFee__c = 75,
            IsActive = true
        );
        insert product;

        Pricebook2 pb = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            Name = 'Standard Price Book',
            IsActive = true
        );
        update pb;

        PriceBookEntry pbe = new PriceBookEntry(
            Pricebook2Id = pb.Id,
            Product2Id = product.Id,
            IsActive = true,
            UnitPrice = 75
        );
        insert pbe;

        Quote quote = new Quote(
            Name = 'Test Quote',
            OpportunityId = opp.Id,
            Due_Now__c = 120,
            Grand_Total__c = 120,
            One_Time_Payment__c = 120,
            Monthly_Price__c = 45,
            AnnualyPayment__c = 0,
            ExpirationDate = Date.today().addDays(7),
            Due_Date__c = Date.today().addDays(7),
            Pricebook2Id = pb.Id
        );
        insert quote;
    }
}