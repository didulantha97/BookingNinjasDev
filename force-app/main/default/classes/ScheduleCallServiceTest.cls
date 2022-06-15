@isTest
public class ScheduleCallServiceTest {
    
    @testSetup
    static void setupTestData(){
        
        Account accountTest = new Account();
        accountTest.Name = 'Test Name';
        insert accountTest;
        
        Contact conTest = new Contact();
        conTest.AccountId = accountTest.Id;
        conTest.FirstName = 'TestFname';
        conTest.LastName = 'TestLname';
        conTest.Email = 'david@bookingninjas.com';
        contest.MobilePhone = '+19176002345';
        contest.Phone = '+19176002345';
        contest.X2nd_Phone_Number__c = '+19176002345';
        insert conTest;
        
        Account_Executive__c ae = new Account_Executive__c();
        ae.Name = 'David Harroch';
        ae.Email__c = 'david@bookigninjas.com';
        insert ae;
    }
    
    @isTest
    static void testScheduleCall() {
    
        List<Contact> con = [SELECT Id, Name, Account.Name, Email, MobilePhone, Phone, X2nd_Phone_Number__c FROM Contact LIMIT 1];
        Account_Executive__c ae = [SELECT Id FROM Account_Executive__c LIMIT 1];
        DateTime dt = System.today();

        
        Test.StartTest();      
            ScheduleCallService service = new ScheduleCallService();
            service.contactId = con[0].Id;
            service.scheduledDate = Date.newInstance(2018, 12, 20);
            //service.scheduledTime = '11:00'; //Time.newInstance(dt.hour(), dt.minute(), 0, 0);
            service.notes = 'Notes here';
            service.interestLevel = '10';
            service.getListOfUsers();
            service.getListInterestLevel();
            service.userId = ae.Id;
            service.isContactHasSchedule();
            service.createTask();            
        Test.stopTest();
    }
    
}