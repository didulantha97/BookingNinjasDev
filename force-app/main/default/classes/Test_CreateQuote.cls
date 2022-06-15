@IsTest
public class Test_CreateQuote {


    @TestSetup
    static void createTestData() {
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and isPersontype= true limit 1 ];
        RecordType recordTypeBusiness = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and isPersontype= false limit 1 ];
        system.debug(recordType);
    	
        Id pricebookId = Test.getStandardPricebookId();
        system.debug(pricebookId);
        //Person account
        Account Acc = new Account(Salutation = 'Mr.', FirstName = 'Joe', LastName = 'Schmoe', RecordTypeId = recordType.Id, PersonEmail = 'test@gmail.com', BillingCountry = 'Philippines', Continent__c = 'Asia');
        Insert Acc;
        system.debug(Acc);
        
        //Business account
        Account a = new Account(Name = 'test', BillingCountry = 'Philippines', Continent__c = 'Asia', RecordTypeId = recordTypeBusiness.Id);
        insert a;
        system.debug(a);
        system.debug(a.Id);

		     
        //Contact
        Contact Con = new Contact(LastName = 'Test1', AccountId = a.Id);
        Con.Email =  'test1@bookingninjas.com';
        Con.MailingCountry = 'Philippines';
        Con.Continent__c = 'Asia';
        insert Con;
        
        Contact Con2 = new Contact(LastName = 'Test2', AccountId = a.Id);
        Con2.Email =  'test2@bookingninjas.com';
        Con2.MailingCountry = 'Philippines';
        Con2.Continent__c = 'Asia';
        insert Con2;
        
        Contact Con3 = new Contact(LastName = 'Test3', AccountId = a.Id);
        Con3.Email =  'test3@bookingninjas.com';
        Con3.MailingCountry = 'Philippines';
        Con3.Continent__c = 'Asia';
        insert Con3;
        
        //Product Item 1
        Product2 pObj1 = new Product2();
        pObj1.Name = 'Product 1';
        pObj1.Family = 'No. of Units';
        pObj1.IsActive = true;
        pObj1.Quantity__c = 1;
        pObj1.Product_Region__c = '(EN) English';
        insert pObj1;
        
        //Price Book Entry for Product Item 1
        PriceBookEntry pbeObj1 = new PriceBookEntry();
        pbeObj1.Pricebook2Id = priceBookId;
        pbeObj1.UnitPrice = 500;
        pbeObj1.Product2Id = pObj1.Id;
        pbeObj1.IsActive = true;
        insert pbeObj1;
        
        //Product Item 2
        Product2 pObj2 = new Product2();
        pObj2.Name = 'Product 2';
        pObj2.Family = 'No. of Users';
        pObj2.IsActive = true;
        pObj2.Quantity__c = 10;
        pObj2.Product_Region__c = '(EN) English';
        insert pObj2;
        
        //Price Book Entry for Product Item 2
        
        PriceBookEntry pbeObj2 = new PriceBookEntry();
        pbeObj2.Pricebook2Id = priceBookId;
        pbeObj2.UnitPrice = 65;
        pbeObj2.Product2Id = pObj2.Id;
        pbeObj2.IsActive = true;
        insert pbeObj2;
        
        //Product Item 3
        Product2 pObj3 = new Product2();
        pObj3.Name = 'Product 3';
        pObj3.Family = 'Integration';
        pObj3.IsActive = true;
        pObj3.Quantity__c = 1;
        pObj3.Product_Region__c = '(EN) English';
        insert pObj3;
        
        //Price Book Entry for Product Item 3
        PriceBookEntry pbeObj3 = new PriceBookEntry();
        pbeObj3.Pricebook2Id = priceBookId;
        pbeObj3.UnitPrice = 500;
        pbeObj3.Product2Id = pObj3.Id;
        pbeObj3.IsActive = true;
        insert pbeObj3;
    
        //Opportunity
        Opportunity opptest = new Opportunity();
        opptest.Name = 'TestOppName';
        opptest.AccountId = Acc.Id;
        opptest.Type = 'New Business';
        opptest.CloseDate = Date.today();
        opptest.StageName = 'Prospecting';
        opptest.Primary_contact__c = Con.id;
        opptest.Contact_2__c = Con2.id;
        opptest.Contact_3__c = Con3.id;
        opptest.Product_Item_1__c = pObj1.Id;
        opptest.Product_Item_2__c = pObj2.Id;
        opptest.Product_Item_3__c = pObj3.Id;
        insert opptest;
        
        //Opp Record Id
        Id oppId = opptest.Id;
        
        //Opportunity Contact Role
        OpportunityContactRole OppCrTest = new OpportunityContactRole();
        OppCrTest.ContactId = Con.id;
        OppCrTest.IsPrimary = true;
        OppCrTest.OpportunityId = OppTest.Id;
        insert OppCrTest;
        
        //Opportunity Line Item
        OpportunityLineitem oliObj = new OpportunityLineitem();
        oliObj.opportunityid = opptest.id;
        oliObj.pricebookentryid = pbeObj1.id;
        oliObj.quantity = 1;
        oliObj.unitprice = 500;
        insert oliObj;
        
        //Quote
        Quote qObj = new Quote();
        qObj.Name = 'Test Quote';
        qObj.OpportunityId = OppTest.Id;
        qObj.ContactId = Con.Id;
        qObj.Contact_2__c = Con2.Id;
        qObj.Contact_3__c = Con3.Id;
        qObj.Pricebook2Id = Test.getStandardPricebookId();
        
        insert qObj;

    }

    @IsTest
    static void testCreateQuote() {        
        Opportunity OppTest1 = [Select id from Opportunity limit 1];
        system.debug(OppTest1);
        
        
        Test.StartTest();
        PageReference pageRef = Page.CreateQuote;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid', OppTest1.id);
        CreateQuoteController cqObj = new CreateQuoteController(new ApexPages.StandardController(OppTest1));
    
        cqObj.getProducts();
        cqObj.getstandardPrices();
        cqObj.getOpp();
        cqObj.clearAll();
        
        //cqObj.
    
        cqObj.Discount = 5;
        cqObj.TotalPrice = 100;
        cqObj.IncludedPriceForDiscount = 70;
        cqObj.ExcludedPriceForDiscount = 30;
        cqObj.OneTimePaymentWithNoDiscount = 30;
        cqObj.TotalPriceAfterDiscount = 60;
        cqObj.GrandTotal = 90;
        cqObj.MonthlyDues = 30;   
        cqObj.getstandardPrices();
        //cqObj.BuildQuote();
    
        Test.StopTest();

    }
    
    @isTest
    static void testCreateQuote2() {
        Opportunity OppTest1 = [Select id from Opportunity limit 1];
        system.debug(OppTest1);
        
        Test.StartTest();
        PageReference pageRef = Page.CreateQuote;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('oid', OppTest1.id);
        CreateQuoteController cqObj2 = new CreateQuoteController(new ApexPages.StandardController(OppTest1));
    
        cqObj2.showBlockCreate();
        cqObj2.showBlockUpdate();
        cqObj2.getProducts();
        cqObj2.getstandardPrices();
        cqObj2.getOpp();
        cqObj2.clearAll();
    
        Test.StopTest();
    }
    
    
    @isTest
    static void test3() {
        PageReference pageRef = Page.CreateQuote;
        Test.setCurrentPage(pageRef);
        Opportunity OppTest1 = [Select id from Opportunity limit 1];
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('oid', OppTest1.id);
        CreateQuoteController cqObj2 = new CreateQuoteController(new ApexPages.StandardController(OppTest1));
        
        cqObj2.getProducts();
        cqObj2.getstandardPrices();
        cqObj2.Discount = 5;
        cqObj2.TotalPrice = 100;
        cqObj2.IncludedPriceForDiscount = 70;
        cqObj2.ExcludedPriceForDiscount = 30;
        cqObj2.OneTimePaymentWithNoDiscount = 30;
        cqObj2.TotalPriceAfterDiscount = 60;
        cqObj2.GrandTotal = 90;
        cqObj2.MonthlyDues = 30;    
        cqObj2.getstandardPrices();
        cqObj2.calcTotalPrice();
        //cqObj2.BuildQuote();
        Test.StopTest();
    
    }
    
    @isTest
    static void test4() {
        Test.StartTest();
        PageReference pageRef = Page.CreateQuote;
        Test.setCurrentPage(pageRef);
        Opportunity OppTest1 = [Select id from Opportunity limit 1];
        ApexPages.currentPage().getParameters().put('oid', OppTest1.id);
        CreateQuoteController cqObj2 = new CreateQuoteController(new ApexPages.StandardController(OppTest1));
    
        cqObj2.getProducts();
        cqObj2.getstandardPrices();
        cqObj2.Discount = 5;
        cqObj2.TotalPrice = 100;
        cqObj2.IncludedPriceForDiscount = 70;
        cqObj2.ExcludedPriceForDiscount = 30;
        cqObj2.OneTimePaymentWithNoDiscount = 30;
        cqObj2.TotalPriceAfterDiscount = 60;
        cqObj2.GrandTotal = 90;
        cqObj2.MonthlyDues = 30;   
        cqObj2.calcTotalPrice();
        //cqObj2.BuildQuote();
        Test.StopTest();
    }
    
    
    @isTest
    static void test5() {
        Test.StartTest();
        PageReference pageRef = Page.CreateQuote;
        Test.setCurrentPage(pageRef);
        Opportunity OppTest1 = [Select id from Opportunity limit 1];
        ApexPages.currentPage().getParameters().put('oid', OppTest1.id);
        CreateQuoteController cqObj2 = new CreateQuoteController(new ApexPages.StandardController(OppTest1));
    
        cqObj2.getProducts();
        cqObj2.getstandardPrices();
        cqObj2.Discount = 5;
        cqObj2.TotalPrice = 100;
        cqObj2.IncludedPriceForDiscount = 70;
        cqObj2.ExcludedPriceForDiscount = 30;
        cqObj2.OneTimePaymentWithNoDiscount = 30;
        cqObj2.TotalPriceAfterDiscount = 60;
        cqObj2.GrandTotal = 90;
        cqObj2.MonthlyDues = 30;   
        cqObj2.calcTotalPrice();
        //cqObj2.BuildQuote();
        Test.StopTest();
    }
    
    @isTest
    static void test6() {
        Test.StartTest();
        PageReference pageRef = Page.CreateQuote;
        Test.setCurrentPage(pageRef);
        Opportunity OppTest1 = [Select id from Opportunity limit 1];
        ApexPages.currentPage().getParameters().put('oid', OppTest1.id);
        CreateQuoteController cqObj2 = new CreateQuoteController(new ApexPages.StandardController(OppTest1));
    
        cqObj2.getProducts();
        cqObj2.getstandardPrices();
        cqObj2.Discount = 5;
        cqObj2.TotalPrice = 100;
        cqObj2.IncludedPriceForDiscount = 70;
        cqObj2.ExcludedPriceForDiscount = 30;
        cqObj2.OneTimePaymentWithNoDiscount = 30;
        cqObj2.TotalPriceAfterDiscount = 60;
        cqObj2.GrandTotal = 90;
        cqObj2.MonthlyDues = 30;   
        cqObj2.calcTotalPrice();
        //cqObj2.BuildQuote();
        Test.StopTest();
    }
    
    @isTest
    static void test63() {
        Test.StartTest();
        PageReference pageRef = Page.CreateQuote;
        Test.setCurrentPage(pageRef);
        Opportunity OppTest1 = [Select id from Opportunity limit 1];
        ApexPages.currentPage().getParameters().put('oid', OppTest1.id);
        CreateQuoteController cqObj2 = new CreateQuoteController(new ApexPages.StandardController(OppTest1));
        
        cqObj2.getstandardPrices();
        cqObj2.Discount = 5;
        cqObj2.TotalPrice = 100;
        cqObj2.IncludedPriceForDiscount = 70;
        cqObj2.ExcludedPriceForDiscount = 30;
        cqObj2.OneTimePaymentWithNoDiscount = 30;
        cqObj2.TotalPriceAfterDiscount = 60;
        cqObj2.GrandTotal = 90;
        cqObj2.MonthlyDues = 30;   
        cqObj2.calcTotalPrice();
        //cqObj2.BuildQuote();
        Test.StopTest();
    }
    
    
    @isTest
    static void GenerateQuotePDFPassthroughControllerTest() {
        //createTestData();
        PageReference pageRef = Page.CreateQuote;
        Test.setCurrentPage(pageRef);
        Opportunity OppTest1 = [Select id from Opportunity limit 1];
        ApexPages.currentPage().getParameters().put('oid', OppTest1.id);
        CreateQuoteController cqObj = new CreateQuoteController(new ApexPages.StandardController(OppTest1));
    
        cqObj.getProducts();
        cqObj.PrepareQuote();

        cqObj.getstandardPrices();
        cqObj.getOpp();
        cqObj.clearAll();

        cqObj.getstandardPrices();
        cqObj.Discount = 5;
        cqObj.TotalPrice = 100;
        cqObj.IncludedPriceForDiscount = 70;
        cqObj.ExcludedPriceForDiscount = 30;
        cqObj.OneTimePaymentWithNoDiscount = 30;
        cqObj.TotalPriceAfterDiscount = 60;
        cqObj.GrandTotal = 90;
        cqObj.MonthlyDues = 30;   
        cqObj.BuildQuote();
        
        List<Contact> contacts = [select id from contact limit 3];
        
        Quote Quote = [select id, ContactId, Contact.Email, Contact_2__c, COntact_3__c, OpportunityID from Quote limit 1];
        quote.ContactId = contacts[0].id;
        quote.Contact_2__c = contacts[1].id;
        quote.Contact_3__c = contacts[2].id;
        update quote;
        System.debug('Quote=='+Quote);
        Test.StartTest();

        GenerateQuotePDFPassthroughController gc= new GenerateQuotePDFPassthroughController();
        gc.GenerateQuotePDFAndRedirectToQuotePage(Quote.id);

        Test.StopTest();
    }
}