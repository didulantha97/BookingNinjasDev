/*****************************************************************************************
 * @Purpose      :  Unit Test for NewsForAccountController
 * @Created Date :  30 September 2018
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/
@isTest
private class NewsForAccountControllerTest {

    @testSetup
    static void createTestData() {
        Account acc = new Account(
            Name = 'News Account'
        );
        
        insert acc;
    }
    
    // perform valid search
    @isTest static void testValidNewsSearch() {
        Test.setMock(HttpCalloutMock.class, new MockHttpCalloutResponse());
        
        Test.startTest();
            Account acc = [SELECT Id FROM Account WHERE Name = 'News Account' LIMIT 1];
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(acc);
            NewsForAccountController ctrl = new NewsForAccountController(stdCtrl);
            
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
        Test.setMock(HttpCalloutMock.class, new MockHttpCalloutResponse());
        
        Test.startTest();
            Account acc = [SELECT Id FROM Account WHERE Name = 'News Account' LIMIT 1];
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(acc);
            NewsForAccountController ctrl = new NewsForAccountController(stdCtrl);

            System.assert(NULL != ctrl.getLanguages());
            System.assert(NULL != ctrl.getSortFactors());        
        
        Test.stopTest();
    }
}