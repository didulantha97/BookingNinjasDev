@isTest
private class BNES_ArticleControllerTest {
    @testSetup
    static void setup() {
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
        List<Contact> contacts = TestDataFactory.createContacts(1, accounts);
        insert contacts;
        TestDataFactory.createArticles(5, contacts);

        // add es region
        List<Article__c> articles = new List<Article__c>();
        for (Article__c article : [SELECT Id FROM Article__c]) {
            article.Article_Region__c = '(ES) Spain';
            articles.add(article);
        }
        update articles;
    }

    @isTest
    static void testGetArticles() {
        Id articleId = [SELECT Id FROM Article__c LIMIT 1].Id;
        BNES_ArticleController controller = new BNES_ArticleController();

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
        PageReference articlePage = Page.BNES_Article;
        Test.setCurrentPage(articlePage);
        Test.setMock(HttpCalloutMock.class, new IPAPIHttpCalloutMock());
        ApexPages.currentPage().getHeaders().put('True-Client-IP', '192.168.1.1');

        BNES_ArticleController controller = new BNES_ArticleController();

        Test.startTest();
        controller.articleId = articleId;
        controller.saveArticleView();
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM Article_Views__c WHERE IP_Address__c = '192.168.1.1']);
        System.assertEquals(1, [SELECT COUNT() FROM Article_Views__c WHERE ArticleId__c = :articleId]);
    }
}