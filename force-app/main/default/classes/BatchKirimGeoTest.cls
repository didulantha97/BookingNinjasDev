@istest
class BatchKirimGeoTest {

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
    
    static testmethod void testGeoScheduler() {
        // schedule time
        //String cronExpr = '0 0 0 15 3 ? 2022';
		String cronExpr = '0 0 * * * ?';

        // kirim api mock
        String successPayload = '{"count":2,"next":null,"previous":null,"results":[{"email":"teguh1@live.com", "ip_address":"40.94.100.14", "country":"United States (US)", "timezone":"America/New_York (GMT-5)"},{"email":"teguh2@live.com", "ip_address":"40.94.100.15", "country":"United States (US)", "timezone":"America/Los_Angeles (GMT-8)"}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimGeo acts = new BatchKirimGeo();
        String jobId = System.schedule('BatchKirimGeo', cronExpr, acts);
        Test.stopTest();

        Integer executedJobs = [
            SELECT count() FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND ApexClass.Name = 'BatchKirimGeo'
        ];
        system.assertEquals(1, executedJobs, 'The job should be scheduled');
    }

    static testmethod void testGeo() {
        // kirim api mock
        String successPayload = '{"count":2,"next":null,"previous":null,"results":[{"email":"teguh1@live.com", "ip_address":"40.94.100.14", "country":"United States (US)", "timezone":"America/New_York (GMT-5)"},{"email":"teguh2@live.com", "ip_address":"40.94.100.15", "country":"United States (US)", "timezone":"America/Los_Angeles (GMT-8)"}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimGeo kirim = new BatchKirimGeo();
        Id batchId = Database.executeBatch(kirim);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(2, [select count() from contact where MailingCountry = 'United States (US)']);
    }

    static testmethod void testGeoFailed() {
        // kirim api mock
        String successPayload = '{"detail":"Invalid page."}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimGeo kirim = new BatchKirimGeo();
        Id batchId = Database.executeBatch(kirim);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(0, [select count() from contact where MailingCountry = 'United States (US)']);
    }

}