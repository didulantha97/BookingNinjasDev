@isTest
public class ContactRecordBatchTast {
    
    @isTest static void testProcess(){
    
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i <= 10; i++) {
            Account acc = new Account(Name = 'Business Account ' + i, BillingCountry = 'Philippines', Continent__c = 'Asia');
            accounts.add(acc);
        }
        insert accounts;
        
        List<Contact> contacts = new List<Contact>();
        for(Account account : accounts) {
            for(Integer i = 0; i <= 5; i++) {
                Contact con = new Contact(LastName = 'Johnny', Email = 'test@test.te', AccountId = account.Id, MailingCountry = 'Philippines', Continent__c = 'Asia');
                contacts.Add(con);
            }
        }
        insert contacts;
        
        Test.startTest();   
          ContactRecordBatch batch = new ContactRecordBatch();
          batch.execute(null, accounts);
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