@isTest
private with sharing class CustomerStoriesDetailControllerTest {

    @isTest
    static void tester() {
        List<CustomerStories__c> listCs = new List<CustomerStories__c>();
        for(integer i=0; i<3; i++){
            CustomerStories__c cs = new CustomerStories__c();
            cs.Name = 'Company '+i;
            cs.About__c = 'About the campany '+i;
            cs.Industry__c = 'Hospital ';
            cs.Location__c = 'Country '+i;
            cs.LongDescription__c = 'lorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsum ';
            cs.Quote__c = 'lorem ipsumlorem  ';
            cs.IsActive__c = true;

            listCs.add(cs);
        }

        insert listCs;
        
        Test.startTest();

        CustomerStories__c cs1 = [SELECT Id, Name, About__c FROM CustomerStories__c WHERE Name = 'Company 0' LIMIT 1];

        PageReference pageRef = Page.BN_CustomerStories_Detail;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', cs1.Id);

        CustomerStoriesDetailController contr = new CustomerStoriesDetailController();
        Test.stopTest();

        System.assert(contr.story?.Location__c == 'Country 0');
    }
}