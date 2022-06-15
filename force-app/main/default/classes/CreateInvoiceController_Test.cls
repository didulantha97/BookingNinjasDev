@Istest
public class CreateInvoiceController_Test
{
    
    @TestSetup
    static void createTestData() {
        
        Opportunity opportunity = new Opportunity();
        Account account = new Account();
        Contact contact = new Contact();
        List<Product2> productItems = new List<Product2>();
        List<PriceBookEntry> productPrices = new List<PriceBookEntry>();
        OpportunityLineitem oliObj = new OpportunityLineItem();
        Quote quote = new Quote();
        List<QuoteLineItem> qliItems = new List<QuoteLineItem>();
        List<Selected_Product__c> selectedProducts = new List<Selected_Product__c>();
        
        Id id;
        Id quoteId;
        
        Id priceBookId = Test.getStandardPricebookId();
        
        // account
        account.Name = 'Business';
        insert account;
        
        // contact
        contact.FirstName = 'Joe';
        contact.LastName = 'Test';
        contact.AccountId = account.Id;
        contact.Email =  'test1@bookingninjas.com';
        insert contact; 
        
        // products
        for(Integer i = 0; i <= 5; i++) {
            Product2 p = new Product2();
            p.Name = 'Product ' + i;
            p.isActive = true;
            p.Product_Region__c = '(EN) English';
            productItems.add(p);
        }
        insert productItems;
        
        // product prices
        for(Integer i = 0; i <= 5; i++) {
            PriceBookEntry pbe = new PriceBookEntry();
            pbe.Pricebook2Id = priceBookId;
            pbe.Product2Id = productItems[i].Id;
            pbe.UnitPrice = 500;
            pbe.isActive = true;
            productPrices.add(pbe);
        }
        insert productPrices;
        
        // opportunity
        opportunity.Name = 'Test Opportunity 1';
        opportunity.AccountId = account.Id;
        opportunity.Primary_Contact__c = contact.Id;
        opportunity.Type = 'New Business';
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'Prospecting';
        opportunity.Effective_Date__c = Date.today().addMonths(1);
        insert opportunity;
        
        // selected products
        for(Integer i = 0; i <= 5; i++){
            Selected_Product__c sp = new Selected_Product__c();
            sp.Opportunity__c = opportunity.Id;
            sp.Product__c = productItems[i].Id;
            sp.Quantity__c = 1;
            sp.Price__c = 500;
            sp.Notes__c = 'Test notes';
            sp.Payment_Type__c = 'Monthly';
            selectedProducts.add(sp);
        }
        insert selectedProducts;

        id = opportunity.Id;
        
        quote.OpportunityId = opportunity.Id;   
        quote.Name = 'Quote: '+ opportunity.Name;   
        quote.ContactId = contact.Id;
        quote.ExpirationDate = date.today().addDays(2);
        quote.BillingName = contact.Name;
        quote.Pricebook2Id = priceBookId;
        quote.Grand_Total__c = 100;
        quote.One_Time_Payment__c = 100;
        quote.Monthly_Price__c = 100;
        quote.Phone = '0000000000';
        quote.Email = 'test@gmail.com';
        quote.Notes__c = 'Test notes';
        quote.Effective_Date__c = Date.today().addMonths(1);
        insert quote;
        
        quoteId = quote.Id;
        
        for(Integer i = 0; i <= 5; i++) {
            QuoteLineItem qli = new QuoteLineItem();
            qli.PricebookEntryId = productPrices[0].Id;
            qli.QuoteId = quote.Id;
            qli.Discount = 0;
            qli.Quantity = 1;
            qli.UnitPrice = 100;
            qli.Notes__c = 'Test notes';
            qliItems.add(qli);
        }
        insert qliItems;
    }
    
   	@IsTest
    static void testAddProduct() 
    {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        List<Product2> productItems = [select id, name from Product2];
        Test.StartTest();
        
        PageReference pageRef = Page.CreateInvoice;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        CreateInvoiceController ctr = new CreateInvoiceController(new ApexPages.StandardController(opp));
        
        // add product
        ctr.productSelected = productItems[0].Id;
        ctr.Quantity = 1;
        ctr.ProductNotes = 'Test note';
        ctr.addSelectedProduct();
        
        // call methods
        ctr.getProductsAvailable();

        Test.StopTest();
    }
    
    @IsTest
    static void testRemoveProduct() 
    {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        List<Selected_Product__c> selectedProducts = [select id from Selected_Product__c where Opportunity__c = :opp.Id];
        Test.StartTest();
        
        PageReference pageRef = Page.CreateInvoice;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        CreateInvoiceController ctr = new CreateInvoiceController(new ApexPages.StandardController(opp));
        
        // remove product
        ctr.removeProductId = selectedProducts[0].Id;
        ctr.removeSelectedProduct();
        
        // call methods
        ctr.getProductsAvailable();
        
        Test.StopTest();
    }
    
    @IsTest
    static void testCreateInvoice() 
    {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.StartTest();
        
        PageReference pageRef = Page.CreateInvoice;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', opp.Id);
        CreateInvoiceController ctr = new CreateInvoiceController(new ApexPages.StandardController(opp));
        
        // set default variables
        ctr.Quantity = 1;
        ctr.TotalPrice = 0;
        ctr.OneTimePayment = 0;
        ctr.GrandTotal = 0;
        ctr.MonthlyDues = 0;
        ctr.Downpayment = 0;
        ctr.Notes = 'Test note';
        
        // call methods
        ctr.initSelectedProducts();
        ctr.initAvailableProducts();
        ctr.CalcTotalPrice();
        ctr.ClearAll();
        ctr.getProductsAvailable();
        ctr.BuildQuote();
        
        Test.StopTest();
    }
    
    @IsTest
    static void GenerateInvoicePDFPassthroughControllerTest() 
    {
        Quote q = [SELECT Id FROM Quote LIMIT 1];
        Test.StartTest();
        
        PageReference pageRef = Page.QuotePdf;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', q.Id);
        ApexPages.StandardController testCtrl = new ApexPages.StandardController(q);  
        GenerateInvoicePDFPassthroughController ctr = new GenerateInvoicePDFPassthroughController(testCtrl);
        
        Test.StopTest();
    }
}