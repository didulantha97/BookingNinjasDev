@isTest
private class ScheduleCallControllerTest {
    
    @testSetup
    static void setupTestData() {
        
        Account accountTest = new Account();
        accountTest.Name = 'Test Name';
        insert accountTest;
        
        Contact conTest = new Contact();
        conTest.AccountId = accountTest.Id;
        conTest.FirstName = 'TestFname';
        conTest.LastName = 'TestLname';
        conTest.Email = 'david@bookingninjas.com';
        contest.Phone = '+19176002345';
        insert conTest;
        
        Account_Executive__c ae = new Account_Executive__c();
        ae.Name = 'David Harroch';
        ae.Email__c = 'david@bookigninjas.com';
        insert ae;
    }
    
    @isTest
    static void testConstructor() {        
        
        Contact con = [SELECT Id, Name, Account.Name, Email, MobilePhone, Phone FROM Contact LIMIT 1];
        
        PageReference pageRef = Page.ScheduleCall;
        Test.setCurrentPage(pageRef);  
        
        Test.StartTest(); 
            //ScheduleCallController ctrl = new ScheduleCallController(new ApexPages.StandardController(con));
            ScheduleCallController ctrl = new ScheduleCallController();
            ctrl.Id = pageRef.getParameters().put('id', String.valueOf(con.Id)); 
        Test.StopTest();
    }

}