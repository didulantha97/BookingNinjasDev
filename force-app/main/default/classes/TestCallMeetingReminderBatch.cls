@isTest
public class TestCallMeetingReminderBatch {

    @isTest static void testProcess(){
    
        Account acc = new Account(Name = 'Business Account', BillingCountry = 'Philippines', Continent__c = 'Asia');
     
        Contact con = new Contact(LastName = 'Johnny', Email = 'test@test.te', AccountId = acc.Id, MailingCountry = 'Philippines', Continent__c = 'Asia', Call_Request_Date__c = system.now().addHours(1));
        insert con;
        
        List<Event> events = new List<Event>();
        for(Integer i = 0; i <= 50; i++) {
            Event ev = new Event(Subject = 'Call' + i, StartDateTime = System.Now().addHours(i), WhoId = con.Id, DurationInMinutes = 60);
            events.add(ev);
        }
        insert events;
        
        
        Test.startTest();
        
        CallMeetingReminderBatch batch = new CallMeetingReminderBatch();
        batch.execute(null, events);
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