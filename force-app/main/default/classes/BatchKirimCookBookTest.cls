@istest
class BatchKirimCookBookTest {

    @testSetup 
    static void setup() {
        Account account = new Account(name='Teguh Prayoga');
        insert account;
        
        Contact contact = new Contact(
            Lastname = 'Prayoga',
            Email = 'teguh1@live.com',
            AccountId = account.Id
        );
        insert contact;

        Account_Executive__c aex = new Account_Executive__c(Name='David Harroch',Email__c='david@bookingninjas.com');
        insert aex;
    }
    
    static testmethod void testActivityScheduler() {
        // schedule time
        //String cronExpr = '0 0 0 15 3 ? 2022';
		String cronExpr = '0 0 * * * ?';
        
        Test.startTest();
        BatchKirimCookBook opps = new BatchKirimCookBook();
        String jobId = System.schedule('BatchKirimCookBook', cronExpr, opps);
        Test.stopTest();

        Integer executedJobs = [
            SELECT count() FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND ApexClass.Name = 'BatchKirimCookBook'
        ];
        system.assertEquals(1, executedJobs, 'The job should be scheduled');
    }

    static testmethod void testCookBooks() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        NewActivity__c aktivitas = new NewActivity__c(
            Name = 'Test Campaign',
            Campaign_Date__c = Date.today(),
            Contact__c = contact.Id,
            Total_Open__c = 6,
            Total_Click__c = 1,
            Unsubscribed__c = false,
            Unsubscribed_Reason__c = null,
            Unsubscribed_Date__c = null,
            Status__c = 'Hot'
        );
        insert aktivitas;

        Test.startTest();
        BatchKirimCookBook opps = new BatchKirimCookBook();
        Id batchId = Database.executeBatch(opps);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
        System.assertEquals(1, [select count() from Cook_Book__c]);
        System.assertEquals(1, [select count() from Cook_Book__c where Call_Result__c = 'Appointments']);
    }

    static testmethod void testNoCookBook() {
        Test.startTest();
        BatchKirimCookBook opps = new BatchKirimCookBook();
        Id batchId = Database.executeBatch(opps);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
        System.assertEquals(0, [select count() from Cook_Book__c]);
        System.assertEquals(0, [select count() from Cook_Book__c where Call_Result__c = 'Appointments']);
    }

}