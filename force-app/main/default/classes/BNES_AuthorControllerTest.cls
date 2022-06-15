@isTest
private class BNES_AuthorControllerTest {
    @testSetup
    static void setup() {
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
        List<Contact> contacts = TestDataFactory.createContacts(1, accounts);
        insert contacts;
        TestDataFactory.createArticles(5, contacts);
        TestDataFactory.createArticlesNoAuthor(4);
        TestDataFactory.createAdminContact();

        // add es region
        List<Article__c> articles = new List<Article__c>();
        for (Article__c article : [SELECT Id FROM Article__c]) {
            article.Article_Region__c = '(ES) Spain';
            articles.add(article);
        }
        update articles;
    }

    @isTest
    static void testGetAuthor() {
        Id contactId = [SELECT Id FROM Contact LIMIT 1].Id;
        PageReference authorPage = Page.BNES_Author;
        Test.setCurrentPage(authorPage);
        ApexPages.currentPage().getParameters().put('id', contactId);
        BNES_AuthorController controller = new BNES_AuthorController();

        Test.startTest();
        Contact author = controller.getAuthor();
        Test.stopTest();

        System.assertEquals(author.Id, contactId);
    }

    @isTest
    static void testGetAdminArticles() {
        PageReference authorPage = Page.BNES_Author;
        Test.setCurrentPage(authorPage);
        ApexPages.currentPage().getParameters().put('id', 'admin');
        BNES_AuthorController controller = new BNES_AuthorController();

        Test.startTest();
        List<Article__c> authorArticles = controller.getAuthorArticles();
        Test.stopTest();

        System.assertEquals(4, authorArticles.size());
    }

    @isTest
    static void testGetAuthorArticles() {
        Id contactId = [SELECT Id FROM Contact LIMIT 1].Id;
        PageReference authorPage = Page.BNES_Author;
        Test.setCurrentPage(authorPage);
        ApexPages.currentPage().getParameters().put('id', contactId);
        BNES_AuthorController controller = new BNES_AuthorController();

        Test.startTest();
        List<Article__c> authorArticles = controller.getAuthorArticles();
        Test.stopTest();

        System.assertEquals(5, authorArticles.size());
    }

    @isTest
    static void testGetTrendingArticles() {
        BNES_AuthorController controller = new BNES_AuthorController();

        Test.startTest();
        List<Article__c> articles = controller.getTrendingArticles();
        Test.stopTest();

        System.assertEquals(3, articles.size());
    }
}