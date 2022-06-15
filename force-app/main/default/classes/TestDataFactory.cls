/**
 * Data Factory to generate records for unit tests
 * @author Alex Tsytsiura
 * @date July 15, 2020
 */

@IsTest
public class TestDataFactory {
    //-------------------------------------------------------------------------
    // Constants
    private final static Id STANDARD_PRICEBOOK_ID = Test.getStandardPricebookId();

    //-------------------------------------------------------------------------
    // Create SObject Utils
    public static List<Account> createAccounts(Integer numberOfRecords) {
        List<Account> result = new List<Account>();

        final Long ind = Datetime.now().getTime();
        for (Integer i = 0; i < numberOfRecords; i++) {
            result.add(new Account(
                    Name = 'TestAcc_' + ind + '#' + i
            ));
        }

        return result;
    }

    public static List<Contact> createContacts(Integer numberOfRecords, final List<Account> accounts) {
        List<Contact> result = new List<Contact>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            final Long ind = Datetime.now().getTime();
            for (Account a : accounts) {
                result.add(new Contact(
                        AccountId = a.Id,
                        FirstName = 'Test',
                        LastName = 'TestCont_' + ind + '#' + i,
                        Email = 'test' + ind + '_' + i + '@example.com',
                        Profile_Picture__c = 'https://example.com/avatar.png'
                ));
            }
        }

        return result;
    }

    public static void createAdminContact() {
        Account account = new Account(
            Name = 'Booking Ninjas'
        );
        insert account;

        Contact contact = new Contact(
            AccountId = account.Id,
            FirstName = 'David',
            LastName = 'Harroch',
            Email = 'david@bookingninjas.com',
            Profile_Picture__c = 'https://example.com/avatar.png'
        );
        insert contact;
    }

    public static List<Opportunity> createOpportunities(Integer numberOfRecords, final List<Account> accounts) {
        List<Opportunity> result = new List<Opportunity>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            final Long ind = Datetime.now().getTime();
            for (Account a : accounts) {
                result.add(new Opportunity(
                        Name = 'TestOpp_' + ind + '#' + i,
                        AccountId = a.Id,
                        StageName = 'Qualification',
                        CloseDate = Date.today()
                ));
            }
        }

        return result;
    }

    public static List<Quote> createQuotes(Integer numberOfRecords, final List<Opportunity> opportunities) {
        List<Quote> result = new List<Quote>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            final Long ind = Datetime.now().getTime();
            for (Opportunity o : opportunities) {
                result.add(new Quote(
                        Name = 'TestQuote_' + ind + '#' + i,
                        OpportunityId = o.Id,
                        Pricebook2Id = STANDARD_PRICEBOOK_ID
                ));
            }
        }

        return result;
    }

    public static List<Product2> createProducts(Integer numberOfRecords) {
        List<Product2> result = new List<Product2>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            final Long ind = Datetime.now().getTime();
            result.add(new Product2(
                    Name = 'TestProd_' + ind + '#' + i,
                    IsActive = true,
                    Product_Region__c = '(EN) English'
            ));
        }

        return result;
    }

    public static void createArticles(Integer numberOfRecords, final List<Contact> contacts) {
        List<Article__c> result = new List<Article__c>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            for (Contact a : contacts) {
                result.add(new Article__c(
                    Name = 'TestArticle_' + i,
                    Author__c = a.Id,
                    Cover_Photo__c = 'https://example.com/thumbnail.png',
                    Article_Preview__c = 'Test preview text',
                    HTML_Content__c = '<p>Article content</p>',
                    Scheduled_Publish_Date__c = Date.today().addDays(-2),
                    Publish__c = true,
                    Category__c = 'Featured',
                    Meta_Title__c = 'Article Title',
                    Meta_Description__c = 'Article description'
                ));
            }
        }

        insert result;
    }

    public static void createArticlesNoAuthor(Integer numberOfRecords) {
        List<Article__c> result = new List<Article__c>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            result.add(new Article__c(
                Name = 'TestArticle_' + i,
                Cover_Photo__c = 'https://example.com/thumbnail.png',
                Article_Preview__c = 'Test preview text',
                HTML_Content__c = '<p>Article content</p>',
                Scheduled_Publish_Date__c = Date.today().addDays(-2),
                Publish__c = true,
                Category__c = 'Featured',
                Meta_Title__c = 'Article Title',
                Meta_Description__c = 'Article description'
            ));
        }

        insert result;
    }

    public static List<QuoteLineItem> createQuoteLineItems(List<Quote> quotes, List<PricebookEntry> entries) {
        List<QuoteLineItem> result = new List<QuoteLineItem>();

        for (Quote q : quotes) {
            for (PricebookEntry e : entries) {
                result.add(new QuoteLineItem(
                        QuoteId = q.Id,
                        PricebookEntryId = e.Id,
                        Quantity = 1,
                        UnitPrice = 100
                ));
            }
        }

        return result;
    }

    //-------------------------------------------------------------------------
    // Utils
    public static List<PricebookEntry> assignProductsToPricebook(List<Product2> products) {
        List<PricebookEntry> result = new List<PricebookEntry>();

        for (Product2 p : products) {
            result.add(new PricebookEntry(
                    Product2Id = p.Id,
                    Pricebook2Id = STANDARD_PRICEBOOK_ID,
                    UnitPrice = 100,
                    IsActive = true
            ));
        }

        insert result;
        return result;
    }
}