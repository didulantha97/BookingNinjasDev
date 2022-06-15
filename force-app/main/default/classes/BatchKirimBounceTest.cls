@istest
class BatchKirimBounceTest {

    @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        
        for (Integer i=1;i<=2;i++) {
            accounts.add(new Account(name='Teguh '+i));
        }
        insert accounts;
        
        Integer j = 1;
        for (Account account : [select id from account]) {
            contacts.add(new Contact(lastname='Prayoga '+j, email='teguh'+j+'@live.com', Status__c='Warm', accountId=account.id));
            j = j + 1;
        }
        insert contacts;
    }
    
    static testmethod void testBounceScheduler() {
        // schedule time
        // String cronExpr = '0 0 0 15 3 ? 2022';
        String cronExpr = '0 0 * * * ?';

        // kirim api mock
        String successPayload = '{"count":2,"next":null,"previous":null,"results":[{"campaign_title": "Campaign 1", "campaign_date":"16 Mar 2020 - 01:34", "email": "teguh1@live.com", "bounce_type": "hard"},{"campaign_title": "Campaign 2", "campaign_date":"17 Mar 2020 - 01:34", "email": "teguh2@live.com", "bounce_type": "hard"}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimBounce acts = new BatchKirimBounce();
        String jobId = System.schedule('BatchKirimBounce', cronExpr, acts);
        Test.stopTest();

        Integer executedJobs = [
            SELECT count() FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND ApexClass.Name = 'BatchKirimBounce'
        ];
        system.assertEquals(1, executedJobs, 'The job should be scheduled');
    }

    static testmethod void testBounce() {
        // kirim api mock
        String successPayload = '{"count":2,"next":null,"previous":null,"results":[{"campaign_title": "Campaign 1", "campaign_date":"16 Mar 2020 - 01:34", "email": "teguh1@live.com", "bounce_type": "hard"},{"campaign_title": "Campaign 2", "campaign_date":"17 Mar 2020 - 01:34", "email": "teguh2@live.com", "bounce_type": "hard"}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimBounce kirim = new BatchKirimBounce();
        Id batchId = Database.executeBatch(kirim);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(2, [select count() from contact where Email_Status_Cleanup__c = 'Hard Bounce']);
        System.assertEquals(2, [select count() from contact where Status__c = 'Bad Email']);
    }

    static testmethod void testBounceFailed() {
        // kirim api mock
        String successPayload = '{"detail":"Invalid page."}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimBounce kirim = new BatchKirimBounce();
        Id batchId = Database.executeBatch(kirim);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(0, [select count() from contact where Email_Status_Cleanup__c = 'Hard Bounce']);
    }

}