@istest
class BatchDeadContactTest {

    @testSetup 
    static void setup() {
        
        Account akun = new Account(name='Teguh 1');
        insert akun;
        
        Contact kontak1 = new Contact(
            lastname='Teguh 1',
            email='teguh1@live.com',
            Status__c='Cold',
            accountId=akun.id
        );
        insert kontak1;
        Contact kontak2 = new Contact(
            lastname='Teguh 2',
            email='teguh2@live.com',
            Status__c='Dead',
            accountId=akun.id
        );
        insert kontak2;
    }
    
    static testmethod void testDeadScheduler() {
        // schedule time
        //String cronExpr = '0 0 0 15 3 ? 2022';

        String cronExpr = '0 0 * * * ?';
        
        // kirim api mock
        String successPayload = '{"count":2,"next":null,"previous":null,"results":[{"email": "teguh1@live.com", "total": 10},{"email": "teguh2@live.com", "total": 4}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchDeadContact deads = new BatchDeadContact();
        String jobId = System.schedule('BatchDeadContact', cronExpr, deads);
        Test.stopTest();

        Integer executedJobs = [
            SELECT count() FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND ApexClass.Name = 'BatchDeadContact'
        ];
        system.assertEquals(1, executedJobs, 'The job should be scheduled');
    }

    static testmethod void testDead() {
        // kirim api mock
        String successPayload = '{"count":1,"next":null,"previous":null,"results":[{"email": "teguh1@live.com", "total": 10}]}';
        KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchDeadContact deads = new BatchDeadContact();
        Id batchId = Database.executeBatch(deads);
        Test.stopTest();
        System.assertEquals(2, [SELECT count() FROM Contact WHERE Status__c = 'Dead']);
    }

    static testmethod void testNoDead() {
        // kirim api mock
        String successPayload = '{"detail":"Invalid page."}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchDeadContact deads = new BatchDeadContact();
        Id batchId = Database.executeBatch(deads);
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Status__c = 'Dead']);
    }

    static testmethod void testAlreadyDead() {
        // kirim api mock
        String successPayload = '{"count":1,"next":null,"previous":null,"results":[{"email": "teguh2@live.com", "total": 10}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchDeadContact deads = new BatchDeadContact();
        Id batchId = Database.executeBatch(deads);
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Status__c = 'Dead']);
    }

}