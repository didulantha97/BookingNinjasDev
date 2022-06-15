@isTest
private class SitemapControllerTest {
    
    @isTest
    static void tester(){
        insert new Article__c(Name = 'TestArticle',
                              Article_Link__c = 'test-article',
                              Publish__c = true,
                              Meta_Title__c = 'TestTitle',
                              Meta_Description__c = 'TestDescription'
                             );

        Test.startTest();
        SitemapController ctr = new SitemapController();
        Test.stopTest();

        System.assert(ctr.blogPages.size() == 1);
        System.assert(ctr.blogPages[0].contains('test'));
    }
}