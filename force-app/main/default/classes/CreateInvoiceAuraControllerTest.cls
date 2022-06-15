@IsTest
class CreateInvoiceAuraControllerTest {
    private final static Integer NUMBER_OF_ACTIVE_PRODUCTS = 7;
    private final static Integer NUMBER_OF_INACTIVE_PRODUCTS = 3;
    private final static Integer NUMBER_OF_SELECTED_PRODUCTS = NUMBER_OF_ACTIVE_PRODUCTS + NUMBER_OF_INACTIVE_PRODUCTS;

    @TestSetup
    static void setup() {
        List<Account> testAccounts = TestDataFactory.createAccounts(1);
        insert testAccounts;

        List<Contact> testContacts = TestDataFactory.createContacts(1, testAccounts);
        insert testContacts;

        List<Opportunity> testOpportunities = TestDataFactory.createOpportunities(1, testAccounts);
        testOpportunities[0].Primary_Contact__c = testContacts[0].Id;
        insert testOpportunities;

        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            Name = CreateInvoiceAuraController.PRICEBOOK_STANDARD_NAME,
            IsActive = true
        );
        update standardPricebook;

        List<Product2> testProducts = TestDataFactory.createProducts(
            NUMBER_OF_ACTIVE_PRODUCTS + NUMBER_OF_INACTIVE_PRODUCTS
        );
        for (Integer i = 0; i < NUMBER_OF_INACTIVE_PRODUCTS; i++) {
            testProducts[i].IsActive = false;
        }
        insert testProducts;

        TestDataFactory.assignProductsToPricebook(testProducts);
    }

    @IsTest
    static void testGetAllProducts() {
        Test.startTest();
        List<PricebookEntry> verifyProducts = CreateInvoiceAuraController.getAllProducts();
        Test.stopTest();

        System.assertEquals(
            NUMBER_OF_ACTIVE_PRODUCTS,
            verifyProducts.size(),
            'Incorrectly retrieved active products, expected ' +
            NUMBER_OF_ACTIVE_PRODUCTS +
            ' but retrieved ' +
            verifyProducts.size()
        );
    }

    @IsTest
    static void testGetDraftQuote_QuoteAlreadyExists() {
        List<Opportunity> testOpportunities = [SELECT Id FROM Opportunity LIMIT 1];
        List<PricebookEntry> entries = [SELECT Id FROM PricebookEntry];

        List<Quote> testDraftQuotes = TestDataFactory.createQuotes(1, testOpportunities);
        testDraftQuotes[0].IsDraft__c = true;
        insert testDraftQuotes;

        List<QuoteLineItem> testItems = TestDataFactory.createQuoteLineItems(testDraftQuotes, entries);
        insert testItems;

        Test.startTest();
        Quote verifyQuote = CreateInvoiceAuraController.getDraftQuote(testOpportunities[0].Id);
        Test.stopTest();
    }

    @IsTest
    static void testGetDraftQuote_ReturnDefaultQuote() {
        List<Opportunity> testOpportunities = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Quote verifyQuote = CreateInvoiceAuraController.getDraftQuote(testOpportunities[0].Id);
        Test.stopTest();

        System.assertNotEquals(null, verifyQuote);
        System.assertEquals(0, verifyQuote.QuoteLineItems.size());
        System.assertEquals(100, verifyQuote.Downpayment__c);
    }

    @IsTest
    static void testSaveDraftQuote() {
        List<Opportunity> testOpportunities = [SELECT Id FROM Opportunity LIMIT 1];
        List<PricebookEntry> entries = [SELECT Id, Product2Id FROM PricebookEntry WHERE Product2.IsActive = TRUE];

        List<Quote> testDraftQuotes = TestDataFactory.createQuotes(1, testOpportunities);
        testDraftQuotes[0].IsDraft__c = true;
        insert testDraftQuotes;

        List<QuoteLineItem> testItems = TestDataFactory.createQuoteLineItems(
            testDraftQuotes,
            new List<PricebookEntry>{ entries[0], entries[1] }
        );
        insert testItems;

        List<CreateInvoiceAuraController.ProductWrapper> testWrappers = new List<CreateInvoiceAuraController.ProductWrapper>();

        // existing item that user updated, it should be updated in database
        CreateInvoiceAuraController.ProductWrapper shouldBeUpdated = createWrapper(testItems[0]);
        shouldBeUpdated.removed = false;
        shouldBeUpdated.price = 200;
        shouldBeUpdated.implFee = 200;
        shouldBeUpdated.notes = 'Updated Notes';
        testWrappers.add(shouldBeUpdated);

        // existing item that user removed, it should be deleted from the database
        CreateInvoiceAuraController.ProductWrapper shouldBeRemoved = createWrapper(testItems[1]);
        shouldBeRemoved.removed = true;
        testWrappers.add(shouldBeRemoved);

        // new item, it should be inserted
        CreateInvoiceAuraController.ProductWrapper shouldBeInserted = new CreateInvoiceAuraController.ProductWrapper();
        shouldBeInserted.removed = false;
        shouldBeInserted.productId = entries[2].Product2Id;
        shouldBeInserted.price = 1000;
        shouldBeInserted.implFee = 1000;
        shouldBeInserted.quantity = 10;
        shouldBeInserted.discount = 0.5;
        shouldBeInserted.notes = 'New Items to be inserted';
        testWrappers.add(shouldBeInserted);

        // new item that user removed, it should be ignored, because it is not stored in the database
        CreateInvoiceAuraController.ProductWrapper shouldBeIgnored = new CreateInvoiceAuraController.ProductWrapper();
        shouldBeIgnored.removed = true;
        testWrappers.add(shouldBeIgnored);

        testDraftQuotes[0].Grand_Total__c = 1000;
        testDraftQuotes[0].One_Time_Payment__c = 100;
        testDraftQuotes[0].Monthly_Price__c = 250;

        Test.startTest();
        Quote verifyQuote = CreateInvoiceAuraController.saveDraftQuote(
            testOpportunities[0].Id,
            testDraftQuotes[0],
            testWrappers
        );
        Test.stopTest();
    }

    @IsTest
    static void testSendQuote() {
        List<Opportunity> testOpportunities = [SELECT Id, Name, Primary_Contact__c FROM Opportunity LIMIT 1];
        List<PricebookEntry> entries = [SELECT Id, Product2Id FROM PricebookEntry WHERE Product2.IsActive = TRUE];

        List<Quote> testDraftQuotes = TestDataFactory.createQuotes(1, testOpportunities);
        testDraftQuotes[0].IsDraft__c = true;
        insert testDraftQuotes;

        List<QuoteLineItem> testItems = TestDataFactory.createQuoteLineItems(
            testDraftQuotes,
            new List<PricebookEntry>{ entries[0], entries[1] }
        );
        insert testItems;

        List<CreateInvoiceAuraController.ProductWrapper> wrappers = new List<CreateInvoiceAuraController.ProductWrapper>();
        for (QuoteLineItem item : testItems) {
            wrappers.add(createWrapper(item));
        }

        testDraftQuotes[0].Notes__c = 'Test Quote Note';
        testDraftQuotes[0].Downpayment__c = 100;
        testDraftQuotes[0].Monthly_Price__c = 100;
        testDraftQuotes[0].One_Time_Payment__c = 500;
        testDraftQuotes[0].Grand_Total__c = 600;

        Test.startTest();
        final String verifyQuoteId = CreateInvoiceAuraController.sendQuote(
            testOpportunities[0].Id,
            testDraftQuotes[0],
            wrappers
        );
        Test.stopTest();

        System.assertNotEquals(null, verifyQuoteId, 'Should return quote id');

        // verify that Quote record was created
        List<Quote> verifyQuotes = [
            SELECT
                Id,
                Name,
                ContactId,
                Grand_Total__c,
                One_Time_Payment__c,
                Monthly_Price__c,
                Notes__c,
                DownPayment__c,
                IsDraft__c
            FROM Quote
        ];
        System.assertEquals(verifyQuoteId, verifyQuotes[0].Id);
        System.assertEquals(testOpportunities[0].Primary_Contact__c, verifyQuotes[0].ContactId);
        System.assertEquals(testDraftQuotes[0].Grand_Total__c, verifyQuotes[0].Grand_Total__c);
        System.assertEquals(testDraftQuotes[0].One_Time_Payment__c, verifyQuotes[0].One_Time_Payment__c);
        System.assertEquals(testDraftQuotes[0].Monthly_Price__c, verifyQuotes[0].Monthly_Price__c);
        System.assertEquals(testDraftQuotes[0].Notes__c, verifyQuotes[0].Notes__c);
        System.assertEquals(testDraftQuotes[0].Downpayment__c, verifyQuotes[0].DownPayment__c);
        System.assertEquals(false, verifyQuotes[0].IsDraft__c);

        // verify that quote line items was created
        List<QuoteLineItem> verifyQuoteLineItems = [SELECT Id FROM QuoteLineItem WHERE QuoteId = :verifyQuoteId];
        System.assertEquals(testItems.size(), verifyQuoteLineItems.size());

        // verify that Opportunity Total Price successfully updated
        List<Opportunity> verifyOpportunities = [
            SELECT Id, Total_Amount__c
            FROM Opportunity
            WHERE Id IN :testOpportunities
        ];
        System.assertEquals(testDraftQuotes[0].Grand_Total__c, verifyOpportunities[0].Total_Amount__c);
    }

    @IsTest
    static void testGetQuoteById() {
        List<Opportunity> testOpportunities = [SELECT Id FROM Opportunity LIMIT 1];

        List<Quote> testDraftQuotes = TestDataFactory.createQuotes(1, testOpportunities);
        testDraftQuotes[0].IsDraft__c = true;
        insert testDraftQuotes;
        Test.startTest();
        List<Quote> quotes = CreateInvoiceAuraController.getQuoteById(testDraftQuotes[0].Id);
        Test.stopTest();

        System.assertNotEquals(0, quotes.size());
    }

    private static CreateInvoiceAuraController.ProductWrapper createWrapper(QuoteLineItem item) {
        CreateInvoiceAuraController.ProductWrapper result = new CreateInvoiceAuraController.ProductWrapper();
        result.itemId = item.Id;
        result.productId = item.Product2Id;
        result.price = item.UnitPrice;
        result.implFee = item.UnitPrice;
        result.quantity = item.Quantity;
        result.discount = item.Discount;
        result.notes = item.Notes__c;
        result.paymentMethod = item.Payment_Type__c;
        result.removed = false;
        return result;
    }
}