@isTest
public class CookBookTriggerTest {

    static testmethod void testRescheduleCookBookCall() {

        Test.StartTest();
            
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
        
        Account_Executive__c ae1 = new Account_Executive__c();
        ae1.Name = 'David Harroch';
        ae1.Email__c = 'david@bookigninjas.com';
        insert ae1;
        
        Account_Executive__c ae2 = new Account_Executive__c();
        ae2.Name = 'Danrien Lagman';
        ae2.Email__c = 'danrienl@bookigninjas.com';
        insert ae2;
        
        DateTime dt = System.today();
        
        // insert first cook book record
        Cook_Book__c cb1 = new Cook_Book__c();
        cb1.Name = 'Test Appointment 1';
        cb1.Contact__c = conTest.Id;
        cb1.Mobile__c = conTest.MobilePhone;
        cb1.Phone__c = conTest.Phone;
        cb1.X2nd_Phone__c = conTest.X2nd_Phone_Number__c;
        cb1.Account_Executive__c = ae1.Id;
        cb1.Scheduled_Date__c = Date.Today().addDays(1);
        cb1.Scheduled_Time__c = Time.newInstance(dt.hour(), dt.minute(), 0, 0);
        cb1.Call_Result__c = 'Appointments';
        insert cb1;
        
        // update cook book record 1, then set next call and reassign to AE
        Cook_Book__c cb2 = [SELECT Id, Contact__c, Mobile__c, Phone__c, X2nd_Phone__c, Account_Executive__c, Scheduled_Date__c, Scheduled_Time__c, Next_Call__c, Reassign_to_new_AE__c FROM Cook_Book__c WHERE Id = :cb1.Id];
        cb2.Next_Call__c = DateTime.newInstance(dt.Year(), dt.Month(), dt.Day(), dt.Hour(), dt.Minute(), 0);
        cb2.Reassign_to_new_AE__c = ae2.id;
        update cb2;
        
        // insert call log
        Call_Log__c cl = new Call_Log__c();
        cl.Cook_Book__c = cb1.Id;
        cl.Call_Result__c = 'Contacted';
        insert cl;
        
        Test.StopTest();
        
        //System.assertEquals(cl.Call_Result__c, cb1.Call_Result__c);

    }
    
}