@isTest
public class ScheduleCallBatchTest {

    @isTest static void testProcess(){
    
        Account acc = new Account(Name = 'Business Account');
     
        Contact con = new Contact(LastName = 'Harroch', FirstName = 'David', Email = 'david@bookingninjas.com', AccountId = acc.Id);
        insert con;

        Account_Executive__c ae = new Account_Executive__c(Name = 'David', Email__c = 'david@bookingninjas.com');
        insert ae;
        
        List<Cook_Book__c> cbs = new List<Cook_Book__c>();
        for(Integer i = 0; i <= 20; i++) {
            Cook_Book__c cb = new Cook_Book__c(Name = 'Call and Meeting', Scheduled_Date__c = Date.Today(), Scheduled_Time__c = Time.newInstance(i, 0, 0 ,0), Contact__c = con.Id, Account_Executive__c = ae.Id);
            cbs.add(cb);
        }
        insert cbs;
        
        Test.startTest();
            ScheduleCallBatch batch = new ScheduleCallBatch();
            batch.execute(null, cbs);
            batch.start(null);
            batch.finish(null);
        Test.stopTest();
    }

    @isTest static void testScheduledJob(){
        Test.startTest();
            ScheduledJob job = new ScheduledJob();
            job.execute(null);
        Test.stopTest();
    }    
}