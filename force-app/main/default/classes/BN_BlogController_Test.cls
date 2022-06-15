/**
 * @description       : 
 * @author            : teguh@bookingninjas.com
 * @group             : 
 * @last modified on  : 31-05-2022
 * @last modified by  : teguh@bookingninjas.com
 * Modifications Log 
 * Ver   Date         Author                    Modification
 * 1.0   11-22-2020   teguh@bookingninjas.com   Initial Version
**/
@isTest
private class BN_BlogController_Test {

    @testSetup
    static void setup() {
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
        List<Contact> contacts = TestDataFactory.createContacts(1, accounts);
        insert contacts;
        TestDataFactory.createArticles(20, contacts);
    }

    @isTest
    static void testGetSearchArticles() {
        PageReference blogPage = Page.BN_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('search', 'article');
        BN_BlogController controller = new BN_BlogController();

        Test.startTest();
        controller.searchQuery = 'Article';
        List<Article__c> articles = controller.getRecentArticles();
        Test.stopTest();

        System.assertEquals(12, articles.size());
    }

    @isTest
    static void testGetCategoryArticles() {
        PageReference blogPage = Page.BN_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('category', 'featured');
        ApexPages.currentPage().getParameters().put('page', '1');
        BN_BlogController controller = new BN_BlogController();

        Test.startTest();
        List<Article__c> articles = controller.getRecentArticles();
        Test.stopTest();

        System.assertEquals(12, articles.size());
    }

    @isTest
    static void testGetRecentArticles() {
        BN_BlogController controller = new BN_BlogController();

        Test.startTest();
        Integer currentPage = controller.currentPageNumber;
        List<Article__c> articles = controller.getRecentArticles();
        Test.stopTest();

        System.assertEquals(12, articles.size());
        System.assertEquals(1, currentPage);
    }

    @isTest
    static void testGetTrendingArticles() {
        BN_BlogController controller = new BN_BlogController();

        Test.startTest();
        List<Article__c> articles = controller.getTrendingArticles();
        Test.stopTest();

        System.assertEquals(3, articles.size());
    }

    @isTest
    static void testSearch() {
        BN_BlogController controller = new BN_BlogController();

        Test.startTest();
        controller.searchQuery = 'Article';
        PageReference pr = controller.search();
        Test.stopTest();

        String searchParams = pr.getParameters().get('search');

        System.assertEquals('article', searchParams);
    }

    @isTest
    static void testNext() {
        PageReference blogPage = Page.BN_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('page', '2');
        BN_BlogController controller = new BN_BlogController();

        Test.startTest();
        PageReference pr = controller.next();
        Test.stopTest();

        String pageParams = pr.getParameters().get('page');

        System.assertEquals('3', pageParams);
    }

    @isTest
    static void testPrev() {
        PageReference blogPage = Page.BN_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('page', '3');
        BN_BlogController controller = new BN_BlogController();

        Test.startTest();
        PageReference pr = controller.previous();
        Test.stopTest();

        String pageParams = pr.getParameters().get('page');

        System.assertEquals('2', pageParams);
    }

    @isTest
    static void testGetDisabledNext() {
        PageReference blogPage = Page.BN_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('page', '2');
        BN_BlogController controller = new BN_BlogController();

        Test.startTest();
        Boolean disabledNext = controller.getDisableNext();
        Boolean disabledPrev = controller.getDisablePrevious();
        Test.stopTest();

        System.assertEquals(true, disabledNext);
        System.assertEquals(false, disabledPrev);
    }

    @isTest
    static void testGetDisabledPrev() {
        PageReference blogPage = Page.BN_Blog;
        Test.setCurrentPage(blogPage);
        ApexPages.currentPage().getParameters().put('page', '1');
        BN_BlogController controller = new BN_BlogController();

        Test.startTest();
        Boolean disabledNext = controller.getDisableNext();
        Boolean disabledPrev = controller.getDisablePrevious();
        Test.stopTest();

        System.assertEquals(false, disabledNext);
        System.assertEquals(true, disabledPrev);
    }
    
    @isTest
    static void testGetCategories(){
        BN_BlogController controller = new BN_BlogController();
        Test.startTest();
        controller.getArticleCategories();
        Test.stopTest();
    
    }

}