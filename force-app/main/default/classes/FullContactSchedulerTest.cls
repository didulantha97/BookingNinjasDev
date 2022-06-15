/*****************************************************************************************
 * @Purpose      :  Hold all the unit tests for FullContactScheduler
 * @Created Date :  30 April 2018
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/ 
@isTest
private class FullContactSchedulerTest {

    //  create test data
    @testSetup
    static void setupTestData() {
        Contact con = new Contact(
            FirstName = 'Full',
            LastName = 'Contact',
            MobilePhone = '4444444444',
            Email = 'email@abc.com',
            Sync_with_FullContact__c = true
        );
        
        insert con;
    }
    
    //  test scheduler invoke
    @isTest
    static void testScheduler() {
        Test.startTest();
            FullContactScheduler scheduler = new FullContactScheduler();
            String sch = '0 0 23 * * ?'; 
            System.schedule('Test Territory Check', sch, scheduler); 
        Test.stopTest();
    }
    
    //  test batch invoke
    @isTest
    static void testBatch() {
        Test.startTest();
            FullContactScheduler batch = new FullContactScheduler();
            Database.executeBatch(batch);
        Test.stopTest();
    }
}