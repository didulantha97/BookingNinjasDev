@istest
class BatchKirimActivityTest {

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
            
            if (j == 1) {
                contacts.add(new Contact(lastname='Prayoga Teguh', email='teguhprayoga@live.com', Status__c='Cold', accountId=account.id, Total_Unopen__c=4));
            }
            j = j + 1;
        }
        insert contacts;

        Account_Executive__c aex = new Account_Executive__c(Name='David Harroch',Email__c='david@bookingninjas.com');
        insert aex;
    }
    
    static testmethod void testActivityScheduler() {
        // schedule time
        //String cronExpr = '0 0 0 15 3 ? 2022';
        
        String cronExpr = '0 0 * * * ?';

        // kirim api mock
        String successPayload = '{"count":2,"next":null,"previous":null,"results":[{"campaign_title":"Campaign 1", "campaign_date":"28 Mar 2022 - 01:34", "email":"teguh1@live.com", "open_total":10, "open_date": "17 Mar 2022 - 01:34", "click_total":0, "unsub":false, "unsub_date":"", "unsub_reason":""},{"campaign_title":"Campaign 2", "campaign_date":"17 Mar 2020 - 01:34", "email":"teguh2@live.com", "open_total":1, "open_date": "17 Mar 2022 - 01:34", "click_total":0, "unsub":false, "unsub_date":"", "unsub_reason":""}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimActivity acts = new BatchKirimActivity();
        String jobId = System.schedule('BatchKirimActivity', cronExpr, acts);
        Test.stopTest();

        Integer executedJobs = [
            SELECT count() FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND ApexClass.Name = 'BatchKirimActivity'
        ];
        system.assertEquals(1, executedJobs, 'The job should be scheduled');
    }

    static testmethod void testActivity() {
        // kirim api mock
        String successPayload = '{"count":2,"next":null,"previous":null,"results":[{"campaign_title":"Campaign 1", "campaign_date":"28 Mar 2022 - 01:34", "email":"teguh1@live.com", "open_total":10, "open_date": "17 Mar 2022 - 01:34", "click_total":0, "unsub":false, "unsub_date":"", "unsub_reason":""},{"campaign_title":"Campaign 2", "campaign_date":"17 Mar 2020 - 01:34", "email":"teguh2@live.com", "open_total":1, "open_date": "17 Mar 2022 - 01:34", "click_total":0, "unsub":false, "unsub_date":"", "unsub_reason":""},{"campaign_title":"Campaign 1", "campaign_date":"28 Mar 2022 - 01:34", "email":"teguhprayoga@live.com", "open_total":1, "open_date": "17 Mar 2022 - 01:34", "click_total":0, "unsub":false, "unsub_date":"", "unsub_reason":""}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimActivity kirim = new BatchKirimActivity();
        Id batchId = Database.executeBatch(kirim);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(3, [select count() from NewActivity__c]);
        System.assertEquals(1, [select count() from Contact WHERE Status__c = 'Hot']);
        System.assertEquals(1, [select count() from Contact WHERE Status__c = 'Warm']);
        System.assertEquals(3, [select count() from Contact WHERE Email_Status_Cleanup__c = 'Opened']);
        System.assertEquals(0, [select count() from Contact WHERE Total_Unopen__c >= 3]);
    }

    static testmethod void testActivityFailed() {
        // kirim api mock
        String successPayload = '{"detail":"Invalid page."}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimActivity kirim = new BatchKirimActivity();
        Id batchId = Database.executeBatch(kirim);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(0, [select count() from NewActivity__c]);
    }

}