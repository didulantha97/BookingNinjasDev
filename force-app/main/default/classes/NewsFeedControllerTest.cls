/*****************************************************************************************
 * @Purpose      :  Controller for NewsFeed Visualforce page which bring up new form newsapi.org
 * @Created Date :  23 September 2018
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/
@isTest
private class NewsFeedControllerTest {

    //  without setting required search params, resulting warning messages
    @isTest static void testNewsWithoutParams() {
        Test.startTest();
        
            NewsFeedController ctrl = new NewsFeedController();
            
            //  no search params set for headline search
            ctrl.headLineSearch();
            System.assertEquals('error', ctrl.headLines.status);
            
            //  no search params set for article search
            ctrl.searchArticles();
            System.assertEquals('error', ctrl.articles.status);
        
        Test.stopTest();
    }
    
    // perform valid search
    @isTest static void testValidNewsSearch() {
        Test.setMock(HttpCalloutMock.class, new MockHttpCalloutResponse());
        
        Test.startTest();
            // headline valid search
            NewsFeedController ctrl = new NewsFeedController();
            ctrl.headLineSearchKey = 'Dreamforce';
            ctrl.selectedCountry = 'test country';
            ctrl.selectedCategory = 'test category';
            ctrl.headLineSearch();
            System.assertEquals(ctrl.headLines.status, 'ok');
            
            // article valid search
            ctrl.selectedLanguage = 'test Language';
            ctrl.articleSearchKey = 'Dreamforce';
            ctrl.selectedSortFactor = 'relevancy';
            ctrl.domains = 'bbc.co.uk, cnn.com';
            ctrl.searchArticles();
            System.assertEquals(ctrl.articles.status, 'ok');
        Test.stopTest();
    }
    
    //  unit test for utility methods such as runtime picklist populations
    @isTest static void testUtilities() {
        Test.startTest();
            NewsFeedController ctrl = new NewsFeedController();
            System.assert(NULL != ctrl.getCategories());
            System.assert(NULL != ctrl.getCountries());
            System.assert(NULL != ctrl.getLanguages());
            System.assert(NULL != ctrl.getSortFactors());        
        
        Test.stopTest();
    }
}