@isTest
private class BN_ArticleControllerTest {
    @testSetup
    static void setup() {
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
        List<Contact> contacts = TestDataFactory.createContacts(1, accounts);
        insert contacts;
        TestDataFactory.createArticles(5, contacts);
    }

    @isTest
    static void testGetArticles() {
        Id articleId = [SELECT Id FROM Article__c LIMIT 1].Id;
        BN_ArticleController controller = new BN_ArticleController();

        Test.startTest();
        controller.articleId = articleId;
        Article__c articleShown = controller.getArticle();
        List<Article__c> trendingArticles = controller.getTrendingArticles();
        Test.stopTest();

        System.assertEquals(articleShown.Id, articleId);
        System.assertEquals(3, trendingArticles.size());
    }

    @isTest
    static void testArticleView() {
        Id articleId = [SELECT Id FROM Article__c LIMIT 1].Id;
        PageReference articlePage = Page.BN_Article;
        Test.setCurrentPage(articlePage);
        Test.setMock(HttpCalloutMock.class, new IPAPIHttpCalloutMock());
        ApexPages.currentPage().getHeaders().put('True-Client-IP', '192.168.1.1');

        BN_ArticleController controller = new BN_ArticleController();

        Test.startTest();
        controller.articleId = articleId;
        controller.saveArticleView();
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM Article_Views__c WHERE IP_Address__c = '192.168.1.1']);
        System.assertEquals(1, [SELECT COUNT() FROM Article_Views__c WHERE ArticleId__c = :articleId]);
    }
}