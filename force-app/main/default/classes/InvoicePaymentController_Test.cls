@IsTest
public class InvoicePaymentController_Test
{
    public static Opportunity opportunity = new Opportunity();
    public static Account account = new Account();
    public static Contact contact = new Contact();
    public static List<Product2> productItems = new List<Product2>();
    public static List<PriceBookEntry> productPrices = new List<PriceBookEntry>();
    public static OpportunityLineitem oliObj = new OpportunityLineItem();
    public static Quote quote = new Quote();
    public static List<QuoteLineItem> qliItems = new List<QuoteLineItem>();
    public static List<Selected_Product__c> selectedProducts = new List<Selected_Product__c>();
    
    public static Id id;
    public static Id quoteId;
    
    static
    {
        createTestData();
    }
    
    public static void createTestData()
    {
        
        Id priceBookId = Test.getStandardPricebookId();
        // price book id
        //Id priceBookId = [select Id, Pricebook2Id from PricebookEntry limit 1].Pricebook2Id;
        //Id priceBookEntryId = [select Id, Pricebook2Id from PricebookEntry limit 1].Id;
        
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
        Id priceBookEntryId = productPrices[0].Id;
        // opportunity
        opportunity.Name = 'Test Opportunity 1';
        opportunity.AccountId = account.Id;
        opportunity.Primary_Contact__c = contact.Id;
        opportunity.Type = 'New Business';
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'Prospecting';
        opportunity.Effective_Date__c = Date.Today().addMonths(1);
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
        quote.Downpayment__c = 50;
        quote.Effective_Date__c = Date.Today().addMonths(1);
        insert quote;
        
        quoteId = quote.Id;
        
        for(Integer i = 0; i <= 5; i++) {
            QuoteLineItem qli = new QuoteLineItem();
            qli.PricebookEntryId = priceBookEntryId;
            qli.QuoteId = quote.Id;
            qli.Discount = 0;
            qli.Quantity = 1;
            qli.UnitPrice = 100;
            qli.Notes__c = 'Test notes';
            qliItems.add(qli);
        }
        insert qliItems;
    }
    
    public static testMethod void doPayment() 
    {
        Test.StartTest();
        
            PageReference pageRef = Page.InvoicePayment;
            Test.setCurrentPage(pageRef);
            Quote quote = [SELECT Id, Stripe_Id__c FROM Quote WHERE Id = :quoteId LIMIT 1];
            ApexPages.currentPage().getParameters().put('Id', quote.Id);
            InvoicePaymentController ctr = new InvoicePaymentController();
            
            Test.setMock(System.HttpCalloutMock.class, new MockHttpResponseGenerator());
            
            // load select

            // populate variables
            ctr.amount = 100;
            ctr.email =  'david@bookingninjas.com';
            ctr.serviceChargeIncluded = false;
            ctr.cardNumber = '4242424242424242';
            ctr.cardCvv = '123';
            ctr.cardExpiration = '06 / 2022';
            
            // do payment
            ctr.createToken();

        Test.StopTest();
        
        System.assert(NULL != [SELECT Id FROM Stripe_Transaction__c]);
    }
}