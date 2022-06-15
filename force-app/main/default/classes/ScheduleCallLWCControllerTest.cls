@IsTest
public with sharing class ScheduleCallLWCControllerTest {
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


        ScheduleCallLWCController.CookBookWrapper cbWrapper = new ScheduleCallLWCController.CookBookWrapper();
        cbWrapper.recordId = con[0].Id;
        cbWrapper.scheduledDate = Date.newInstance(2018, 12, 20);
        cbWrapper.notes = 'Notes here';
        cbWrapper.interestLevel = '10';
        cbWrapper.userId = ae.Id;

        String cdWrapperSerialized;

        Test.startTest();
            ScheduleCallLWCController.CookBookWrapper cdWrapperDeserialized = ScheduleCallLWCController.scheduleCallAndCreateCB(JSON.serialize(cbWrapper));
        Test.stopTest();

        System.assertEquals(true, cdWrapperDeserialized.isSuccess);
    }
    
    @isTest
    static void testGetAccountExecutives() {
        Test.startTest();
            List<Account_Executive__c> ae  = ScheduleCallLWCController.getAccountExecutives();
        Test.stopTest();

        System.assertNotEquals(0, ae.size());
    }
}