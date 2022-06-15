@isTest
private class BNES_BlogControllerTest {

    @testSetup
    static void setup() {
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
        List<Contact> contacts = TestDataFactory.createContacts(1, accounts);
        insert contacts;
        TestDataFactory.createArticles(20, contacts);

        // add es region
        List<Article__c> articles = new List<Article__c>();
        for (Article__c article : [SELECT Id FROM Article__c]) {
            article.Article_Region__c = '(ES) Spain';
            articles.add(article);
        }
        update articles;
    }

    @isTest
    static void testGetSearchArticles() {
        PageReference blogPage = Page.BNES_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('search', 'article');
        BNES_BlogController controller = new BNES_BlogController();

        Test.startTest();
        controller.searchQuery = 'Article';
        List<Article__c> articles = controller.getRecentArticles();
        Test.stopTest();

        System.assertEquals(12, articles.size());
    }

    @isTest
    static void testGetCategoryArticles() {
        PageReference blogPage = Page.BNES_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('category', 'featured');
        ApexPages.currentPage().getParameters().put('page', '1');
        BNES_BlogController controller = new BNES_BlogController();

        Test.startTest();
        List<Article__c> articles = controller.getRecentArticles();
        Test.stopTest();

        System.assertEquals(12, articles.size());
    }

    @isTest
    static void testGetRecentArticles() {
        BNES_BlogController controller = new BNES_BlogController();

        Test.startTest();
        Integer currentPage = controller.currentPageNumber;
        List<Article__c> articles = controller.getRecentArticles();
        Test.stopTest();

        System.assertEquals(12, articles.size());
        System.assertEquals(1, currentPage);
    }

    @isTest
    static void testGetTrendingArticles() {
        BNES_BlogController controller = new BNES_BlogController();

        Test.startTest();
        List<Article__c> articles = controller.getTrendingArticles();
        Test.stopTest();

        System.assertEquals(3, articles.size());
    }

    @isTest
    static void testSearch() {
        BNES_BlogController controller = new BNES_BlogController();

        Test.startTest();
        controller.searchQuery = 'Article';
        PageReference pr = controller.search();
        Test.stopTest();

        String searchParams = pr.getParameters().get('search');

        System.assertEquals('article', searchParams);
    }

    @isTest
    static void testNext() {
        PageReference blogPage = Page.BNES_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('page', '2');
        BNES_BlogController controller = new BNES_BlogController();

        Test.startTest();
        PageReference pr = controller.next();
        Test.stopTest();

        String pageParams = pr.getParameters().get('page');

        System.assertEquals('3', pageParams);
    }

    @isTest
    static void testPrev() {
        PageReference blogPage = Page.BNES_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('page', '3');
        BNES_BlogController controller = new BNES_BlogController();

        Test.startTest();
        PageReference pr = controller.previous();
        Test.stopTest();

        String pageParams = pr.getParameters().get('page');

        System.assertEquals('2', pageParams);
    }

    @isTest
    static void testGetDisabledNext() {
        PageReference blogPage = Page.BNES_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('page', '2');
        BNES_BlogController controller = new BNES_BlogController();

        Test.startTest();
        Boolean disabledNext = controller.getDisableNext();
        Boolean disabledPrev = controller.getDisablePrevious();
        Test.stopTest();

        System.assertEquals(true, disabledNext);
        System.assertEquals(false, disabledPrev);
    }

    @isTest
    static void testGetDisabledPrev() {
        PageReference blogPage = Page.BNES_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('page', '1');
        BNES_BlogController controller = new BNES_BlogController();

        Test.startTest();
        Boolean disabledNext = controller.getDisableNext();
        Boolean disabledPrev = controller.getDisablePrevious();
        Test.stopTest();

        System.assertEquals(false, disabledNext);
        System.assertEquals(true, disabledPrev);
    }

    @isTest
    static void testGetCategories(){
        BNES_BlogController controller = new BNES_BlogController();
        Test.startTest();
        controller.getArticleCategories();
        Test.stopTest();
    
    }
}