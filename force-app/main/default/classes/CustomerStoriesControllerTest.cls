@isTest
private class CustomerStoriesControllerTest {

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
        CustomerStoriesController obj = new CustomerStoriesController();
        List<CustomerStories__c> stories = obj.getCustomerStories();
        Test.stopTest();

        System.assert(stories.size() == 3);
    }
}