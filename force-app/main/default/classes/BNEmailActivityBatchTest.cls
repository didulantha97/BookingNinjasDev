@isTest
private class BNEmailActivityBatchTest {

    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        
        for (Integer i=1;i<=10;i++) {
            accounts.add(new Account(name='Account Name '+i));
        }
        insert accounts;

        Integer i = 1;
        for (Account account : [SELECT id FROM account]) {
            contacts.add(new Contact(lastname='Name '+i, email='john-'+i+'@example.com', accountId=account.id));
            i += 1;
        }
        insert contacts;
        Contact contact = new Contact(LastName='Name 11', Email='john-11@example.com', Status__c='Hot', AccountId=accounts[0].Id);
        insert contact;
    }
    
    static testmethod void testActivityScheduler() {
        // schedule time
        //String cronExpr = '0 0 0 15 3 ? 2022';
		String cronExpr = '0 0 * * * ?';

        // bnmail api mock
        List<Contact> contacts = [SELECT Id FROM Contact ORDER BY Name];
        String id1 = contacts[0].Id;
        String id2 = contacts[1].Id;
        String data1 = '{"name": "Camp 1", "campaign_date": "2020-09-06", "contact_id": "' + id1 +
                       '", "total_open": 1, "total_click": 0, "contact_quality": "Open", "quality_description": ""},';
        String data2 = '{"name": "Camp 2", "campaign_date": "2020-09-07", "contact_id": "' + id2 +
                       '", "total_open": 1, "total_click": 1, "contact_quality": "Click", "quality_description": ""}';
        String successPayload = '{"count": 2, "results": ['+data1+data2+']}';
		BNEmailCalloutMock mock = new BNEmailCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BNEmailActivityBatch bnemail = new BNEmailActivityBatch();
        String jobId = System.schedule('BNEmailActivityBatch', cronExpr, bnemail);
        Test.stopTest();

        Integer executedJobs = [
            SELECT count() FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND ApexClass.Name = 'BNEmailActivityBatch'
        ];
        system.assertEquals(1, executedJobs, 'The job should be scheduled');
    }

    static testmethod void testActivity() {
        Contact contact1 = [SELECT Id FROM Contact WHERE Email = 'john-1@example.com' LIMIT 1];
        insert new Campaign_Report__c(name='Camp 1', Contact__c=contact1.Id);
        Contact contact2 = [SELECT Id FROM Contact WHERE Email = 'john-2@example.com' LIMIT 1];
        insert new Campaign_Report__c(name='Camp 2', Contact__c=contact2.Id);
        Contact contact3 = [SELECT Id FROM Contact WHERE Email = 'john-3@example.com' LIMIT 1];
        Contact contact4 = [SELECT Id FROM Contact WHERE Email = 'john-4@example.com' LIMIT 1];
        Contact contact5 = [SELECT Id FROM Contact WHERE Email = 'john-5@example.com' LIMIT 1];
        Contact contact6 = [SELECT Id FROM Contact WHERE Email = 'john-6@example.com' LIMIT 1];
        Contact contact7 = [SELECT Id FROM Contact WHERE Email = 'john-7@example.com' LIMIT 1];
        Contact contact8 = [SELECT Id FROM Contact WHERE Email = 'john-8@example.com' LIMIT 1];
        Contact contact9 = [SELECT Id FROM Contact WHERE Email = 'john-9@example.com' LIMIT 1];
        Contact contact10 = [SELECT Id FROM Contact WHERE Email = 'john-10@example.com' LIMIT 1];
        Contact contact11 = [SELECT Id FROM Contact WHERE Email = 'john-11@example.com' LIMIT 1];

        // bnmail api mock
        String data1 = '{"name": "Camp 1", "campaign_date": "2020-09-06", "contact_id": "' + contact1.Id +
                       '", "total_open": 1, "total_click": 0, "contact_quality": "Open", "quality_description": ""},';
        String data2 = '{"name": "Camp 2", "campaign_date": "2020-09-07", "contact_id": "' + contact2.Id +
                       '", "total_open": 1, "total_click": 1, "contact_quality": "Click", "quality_description": ""},';
        String data3 = '{"name": "Camp 3", "campaign_date": "2020-09-07", "contact_id": "' + contact3.Id +
                       '", "total_open": 0, "total_click": 0, "contact_quality": "Sent", "quality_description": ""},';
        String data4 = '{"name": "Camp 4", "campaign_date": "2020-09-07", "contact_id": "' + contact4.Id +
                       '", "total_open": 1, "total_click": 1, "contact_quality": "Unsubscribe", "quality_description": ""},';
        String data5 = '{"name": "Camp 5", "campaign_date": "2020-09-07", "contact_id": "' + contact5.Id +
                       '", "total_open": 0, "total_click": 0, "contact_quality": "Soft Bounce", "quality_description": ""},';
        String data6 = '{"name": "Camp 6", "campaign_date": "2020-09-07", "contact_id": "' + contact6.Id +
                       '", "total_open": 0, "total_click": 0, "contact_quality": "Hard Bounce", "quality_description": ""},';
        String data7 = '{"name": "Camp 7", "campaign_date": "2020-09-07", "contact_id": "' + contact7.Id +
                       '", "total_open": 1, "total_click": 1, "contact_quality": "Complaint", "quality_description": ""},';
        String data8 = '{"name": "Camp 8", "campaign_date": "2020-09-07", "contact_id": "' + contact8.Id +
                       '", "total_open": 2, "total_click": 0, "contact_quality": "Open", "quality_description": ""},';
        String data9 = '{"name": "Camp 9", "campaign_date": "2020-09-07", "contact_id": "' + contact9.Id +
                       '", "total_open": 4, "total_click": 0, "contact_quality": "Open", "quality_description": ""},';
        String data10 = '{"name": "Camp 10", "campaign_date": "2020-09-07", "contact_id": "' + contact10.Id +
                       '", "total_open": 7, "total_click": 0, "contact_quality": "Open", "quality_description": ""},';
        String data11 = '{"name": "Camp 11", "campaign_date": "2020-09-07", "contact_id": "' + contact11.Id +
                       '", "total_open": 1, "total_click": 0, "contact_quality": "Open", "quality_description": ""}';
        String successPayload = '{"count": 11, "results": ['+data1+data2+data3+data4+data5+data6+data7+data8+data9+data10+data11+']}';
		BNEmailCalloutMock mock = new BNEmailCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BNEmailActivityBatch b = new BNEmailActivityBatch();
        Id apexId = Database.executeBatch(b, 100);
        Test.stopTest();

        // after the testing stops, assert campaign activity records data
        System.assertEquals(11, [SELECT count() FROM Campaign_Report__c]);
        System.assertEquals(2, [SELECT count() FROM Contact WHERE Status__c = 'Cold']);
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Status__c = 'Warm']);
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Status__c = 'Super Warms']);
        System.assertEquals(2, [SELECT count() FROM Contact WHERE Status__c = 'Hot']);
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Email_Status_Cleanup__c = 'Sent']);
        System.assertEquals(5, [SELECT count() FROM Contact WHERE Email_Status_Cleanup__c = 'Opened']);
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Email_Status_Cleanup__c = 'Clicked']);
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Email_Status_Cleanup__c = 'Unsubscribed']);
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Email_Status_Cleanup__c = 'Soft Bounce']);
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Email_Status_Cleanup__c = 'Hard Bounce']);
        System.assertEquals(1, [SELECT count() FROM Contact WHERE Email_Status_Cleanup__c = 'Complaint']);
    }

    static testmethod void testActivityFailed() {
        // kirim api mock
		BNEmailCalloutExceptionMock mock = new BNEmailCalloutExceptionMock();
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BNEmailActivityBatch bnemail = new BNEmailActivityBatch();
        Id batchId = Database.executeBatch(bnemail);
        Test.stopTest();

        // after the testing stops, assert campaign activity records data
        System.assertEquals(0, [SELECT count() FROM Campaign_Report__c]);
    }

}