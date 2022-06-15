@isTest
private class BN_AuthorControllerTest {
    @testSetup
    static void setup() {
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
        List<Contact> contacts = TestDataFactory.createContacts(1, accounts);
        insert contacts;
        TestDataFactory.createArticles(5, contacts);
        TestDataFactory.createArticlesNoAuthor(4);
        TestDataFactory.createAdminContact();
    }

    @isTest
    static void testGetAuthor() {
        Id contactId = [SELECT Id FROM Contact LIMIT 1].Id;
        PageReference authorPage = Page.BN_Author;
        Test.setCurrentPage(authorPage);
        ApexPages.currentPage().getParameters().put('id', contactId);
        BN_AuthorController controller = new BN_AuthorController();

        Test.startTest();
        Contact author = controller.getAuthor();
        Test.stopTest();

        System.assertEquals(author.Id, contactId);
    }

    @isTest
    static void testGetAdminArticles() {
        PageReference authorPage = Page.BN_Author;
        Test.setCurrentPage(authorPage);
        ApexPages.currentPage().getParameters().put('id', 'admin');
        BN_AuthorController controller = new BN_AuthorController();

        Test.startTest();
        List<Article__c> authorArticles = controller.getAuthorArticles();
        Test.stopTest();

        System.assertEquals(4, authorArticles.size());
    }

    @isTest
    static void testGetAuthorArticles() {
        Id contactId = [SELECT Id FROM Contact LIMIT 1].Id;
        PageReference authorPage = Page.BN_Author;
        Test.setCurrentPage(authorPage);
        ApexPages.currentPage().getParameters().put('id', contactId);
        BN_AuthorController controller = new BN_AuthorController();

        Test.startTest();
        List<Article__c> authorArticles = controller.getAuthorArticles();
        Test.stopTest();

        System.assertEquals(5, authorArticles.size());
    }

    @isTest
    static void testGetTrendingArticles() {
        BN_AuthorController controller = new BN_AuthorController();

        Test.startTest();
        List<Article__c> articles = controller.getTrendingArticles();
        Test.stopTest();

        System.assertEquals(3, articles.size());
    }
}