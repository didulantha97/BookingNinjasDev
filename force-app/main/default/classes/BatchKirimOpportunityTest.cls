@istest
class BatchKirimOpportunityTest {

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

        Opportunity opportunity = new Opportunity(
            Name = 'fromtrigger',
            Type = 'New Business',
            AccountId = Account.Id,
            Primary_Contact__c = contact.Id,
            CloseDate = Date.newInstance(2018, 2, 17),
            StageName = 'Top Opps'
        );
        insert opportunity;
    }
    
    static testmethod void testActivityScheduler() {
        // schedule time
        //String cronExpr = '0 0 0 15 3 ? 2022';
		String cronExpr = '0 0 * * * ?';

        Test.startTest();
        BatchKirimOpportunity opps = new BatchKirimOpportunity();
        String jobId = System.schedule('BatchKirimOpportunity', cronExpr, opps);
        Test.stopTest();

        Integer executedJobs = [
            SELECT count() FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND ApexClass.Name = 'BatchKirimOpportunity'
        ];
        system.assertEquals(1, executedJobs, 'The job should be scheduled');
    }

    static testmethod void testUpdateOpportunity() {
        Test.startTest();
        BatchKirimOpportunity opps = new BatchKirimOpportunity();
        Id batchId = Database.executeBatch(opps);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
        System.assertEquals(1, [select count() from Opportunity]);
        Date tanggal = Date.today().addDays(5);
        System.assertEquals(1, [select count() from Opportunity where StageName = 'Top Opps' AND CloseDate = :tanggal]);
    }

    static testmethod void testAddOpportunity() {
        Account account = new Account(name='Muhammad Teguh');
        insert account;
        
        Contact contact = new Contact(
            Lastname = 'Teguh',
            Email = 'teguh2@live.com',
            AccountId = account.Id
        );
        insert contact;

        NewActivity__c aktivitas = new NewActivity__c(
            Name = 'Test Campaign 2',
            Campaign_Date__c = Date.today(),
            Contact__c = contact.Id,
            Total_Open__c = 7,
            Total_Click__c = 1,
            Unsubscribed__c = false,
            Unsubscribed_Reason__c = null,
            Unsubscribed_Date__c = null,
            Status__c = 'Hot'
        );
        insert aktivitas;

        Test.startTest();
        BatchKirimOpportunity opps = new BatchKirimOpportunity();
        Id batchId = Database.executeBatch(opps);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
        System.assertEquals(2, [select count() from Opportunity]);
        Date tanggal = Date.today().addDays(5);
        System.assertEquals(1, [select count() from Opportunity where StageName = 'Working' AND CloseDate = :tanggal]);
        System.assertEquals(1, [select count() from Opportunity where StageName = 'Top Opps' AND CloseDate = :tanggal]);
    }

}