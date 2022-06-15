@isTest
public class CookBookController_Test {
    
    public static Cook_Book__c cb;
    public static Account_Executive__c ae;
    
    Static {
        createTestData();
    }

    public static void createTestData() {
        //Business account
        Account a = new Account(Name = 'test', BillingCountry = 'Philippines');
        insert a;

        Contact con = new Contact(FirstName = 'David', LastName = 'Harroch', Accountid = a.Id, Email =  'david@bookingninjas.com', MailingCountry = 'Philippines');
        insert con;
        
        ae = new Account_Executive__c();
        ae.Name = 'David Harroch';
        ae.Email__c = 'david@bookigninjas.com';
        insert ae;
        
        //instantiate date time
        DateTime dt = Datetime.Now();
        
        List<Cook_Book__c> cbList = new List<Cook_Book__c>();
        for(Integer i=1; i<=10; i++) {
            cb = new Cook_Book__c();
            cb.Name = 'Test_Call_' + con.Name + '_' + Date.Today().addDays(i);
            cb.Contact__c = con.Id;
            cb.Scheduled_Date__c = Date.Today().addDays(i);
            cb.Scheduled_Time__c = Time.newInstance(dt.hour(), dt.minute(), 0, 0);
            cb.Account_Executive__c = ae.Id;
            cb.Type__c = 'Calls';
            cb.Call_Result__c = 'Appointments';
            cb.Interest_Level__c = String.valueOf(i);
            cbList.add(cb);
        }
        insert cbList;
    }
    
    public static testMethod void TestCookBookList() {
        Test.StartTest();
        
        PageReference pageRef = Page.CookBookReport;
        Test.setCurrentPage(pageRef);
        CookBookController controller = new CookBookController();
        controller.getListOfUsers();
        controller.getListOfInterestLevel();
        controller.getListOfContinents();
        controller.getListOfCallResult();
        controller.UserId = ae.Id;
        controller.StartDate = Date.Today();
        controller.EndDate = Date.Today().addDays(30);
        controller.InterestLevel = '1';
        controller.Continent = 'Asia';
        controller.search();
        
        Test.StopTest();
    }
}