@istest
class TestKirimEmail {

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

        Account_Executive__c aex = new Account_Executive__c(Name='David Harroch',Email__c='david@bookingninjas.com');
        insert aex;
    }
    
    static testmethod void testActivity() {
        // kirim api mock
        String successPayload = '{"count":2,"next":null,"previous":null,"results":[{"campaign_title":"Campaign 1", "campaign_date":"28 Mar 2022 - 01:34", "email":"teguh1@live.com", "open_total":10, "open_date": "17 Mar 2022 - 01:34", "click_total":0, "unsub":false, "unsub_date":"", "unsub_reason":""},{"campaign_title":"Campaign 2", "campaign_date":"17 Mar 2020 - 01:34", "email":"teguh2@live.com", "open_total":1, "open_date": "17 Mar 2022 - 01:34", "click_total":0, "unsub":false, "unsub_date":"", "unsub_reason":""}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimActivity kirim = new BatchKirimActivity();
        Id batchId = Database.executeBatch(kirim);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(2, [select count() from NewActivity__c]);
        System.assertEquals(1, [select count() from Contact WHERE Status__c = 'Hot']);
        System.assertEquals(1, [select count() from Contact WHERE Status__c = 'Warm']);
        System.assertEquals(2, [select count() from Contact WHERE Email_Status_Cleanup__c = 'Opened']);
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

    static testmethod void testUnopen() {
        // kirim api mock
        String successPayload = '{"count":2,"next":null,"previous":null,"results":[{"campaign_title": "Campaign 1", "campaign_date":"16 Mar 2020 - 01:34", "email": "teguh1@live.com"},{"campaign_title": "Campaign 2", "campaign_date":"18 Mar 2020 - 01:34", "email": "teguh2@live.com"}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimUnopen kirim = new BatchKirimUnopen();
        Id batchId = Database.executeBatch(kirim);
        Test.stopTest();
        System.assertEquals(2, [select count() from contact where Email_Status_Cleanup__c = 'Sent']);
    }

    static testmethod void testUnopenFailed() {
        // kirim api mock
        String successPayload = '{"detail":"Invalid page."}]}';
		KirimCalloutMock mock = new KirimCalloutMock(200, 'Success', successPayload);
		Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BatchKirimUnopen kirim = new BatchKirimUnopen();
        Id batchId = Database.executeBatch(kirim);
        Test.stopTest();
        System.assertEquals(0, [select count() from contact where Email_Status_Cleanup__c = 'Sent']);
    }

}