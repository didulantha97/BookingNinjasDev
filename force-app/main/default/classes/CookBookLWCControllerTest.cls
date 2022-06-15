@isTest
public class CookBookLWCControllerTest {

    @TestSetup
    public static void makeData() {

        Account a = new Account(Name = 'test', BillingCountry = 'Philippines');
        insert a;

        Contact con = new Contact(FirstName = 'David', LastName = 'Harroch', Accountid = a.Id, Email = 'david@bookingninjas.com', MailingCountry = 'Philippines');
        insert con;
        
        Account_Executive__c ae = new Account_Executive__c();
        ae.Name = 'David Harroch';
        ae.Email__c = 'david@bookigninjas.com';
        insert ae;
        
        DateTime dt = Datetime.Now();
        
        List<Cook_Book__c> cbList = new List<Cook_Book__c>();
        for(Integer i=1; i<=10; i++) {
            Cook_Book__c cb = new Cook_Book__c();
            cb.Name = 'Test_Call_' + con.Name + '_' + Date.Today().addDays(i);
            cb.Contact__c = con.Id;
            cb.AccountLookup__c = a.Id;
            cb.Scheduled_Date__c = Date.Today().addDays(i);
            cb.Scheduled_Time__c = Time.newInstance(dt.hour(), dt.minute(), 0, 0);
            cb.Account_Executive__c = ae.Id;
            cb.Type__c = 'Calls';
            cb.Call_Result__c = 'Appointments';
            cb.Interest_Level__c = '1';//String.valueOf(i);
            cbList.add(cb);
        }
        insert cbList;


        List<Account_Executive__c> aeList = new List<Account_Executive__c>();
        for(Integer i = 1; i <= 10; i++) {
            Account_Executive__c aeTemp = new Account_Executive__c(
                Name = 'David Harroch' + i,
                Email__c = 'david@bookigninjas.com' + i
            );

            aeList.add(aeTemp);
        }
        insert aeList;
    }


    @isTest
    public static void getAccountExecutivesTest() {

        Test.startTest();
        List<Account_Executive__c> aeList = CookBookLWCController.getAccountExecutives();
        Test.stopTest();

        System.assertEquals(false, aeList.isEmpty(), 'getAccountExecutivesTest:');
        System.assertEquals(11, aeList.size(), 'getAccountExecutivesTest - aeList.size: ');
    }

    
    @isTest
    public static void searchTest() {

        Account_Executive__c ae = [SELECT Id FROM Account_Executive__c WHERE Email__c = 'david@bookigninjas.com' LIMIT 1];
        Contact con = [SELECT Id FROM Contact WHERE Email = 'david@bookingninjas.com' LIMIT 1];

        CookBookLWCController.SearchWrapper sw = new CookBookLWCController.SearchWrapper(
            ae.Id,
            Date.Today(),
            Date.Today().addDays(10),
            '1',
            '',
            'Appointments',
            false,
            true,
            false
        );
        String searchjson = JSON.serialize(sw);

        Test.StartTest();
        String results = CookBookLWCController.search(searchjson);
        Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(results);
        List<Object> objList = (List<Object>) jsonMap.get('searchResult');
        Test.StopTest();


        System.assertEquals(10, jsonMap.get('count'), 'searchTest: count: ');
        System.assertEquals(10, objList.size(), 'searchTest: records.size: ');
    }
}