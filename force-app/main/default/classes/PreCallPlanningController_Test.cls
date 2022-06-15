@isTest(seeAllData=false)
public class PreCallPlanningController_Test {

    public static Account account;
    public static Pre_Call_Planner__c precall;
    
    Static 
    {
        createTestData();
    }

    public static void createTestData() {
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and isPersontype= true limit 1 ];
        
        //Person account
        Account Acc = new Account(Salutation = 'Mr.', FirstName = 'Joe', LastName = 'Schmoe', RecordTypeId = recordType.Id, PersonEmail = 'test@gmail.com', BillingCountry = 'Philippines', Continent__c = 'Asia');
        Insert Acc;
        
        //Business account
        account = new Account(Name = 'test', BillingCountry = 'Philippines', Continent__c = 'Asia');
        insert account;
        
        //Contact
        Contact c = new Contact(FirstName = 'Joe', LastName = 'Johnson', Email = 'joe@gmail.com', AccountId = account.Id, MailingCountry = 'Philippines', Continent__c = 'Asia');
        insert c;
        
        //Pre-Call Planner
        precall = new Pre_Call_Planner__c(Account__c = Acc.Id);
        insert precall;
    }
        
    public static testMethod void TestPreCallPlanning() {
        Test.StartTest();
        
        PageReference pageRef = Page.PreCallPlanning;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', precall.Id);
        PreCallPlanningController sf = new PreCallPlanningController(new ApexPages.StandardController(precall));
    
        sf.getPreCall();
        sf.getAccount();
    
        sf.SavePreCallPlanningForm();
        sf.GeneratePreCallPdf();
    
        Test.StopTest(); 
    }
    
    public static testMethod void TestCallDebriefingTool() {
        Test.StartTest();
        
        PageReference pageRef = Page.CallDebriefing;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', precall.Id);
        PreCallPlanningController sf = new PreCallPlanningController(new ApexPages.StandardController(precall));
    
        sf.getPreCall();
        sf.getAccount();
    
        sf.SaveCallDebriefingForm();
        sf.GenerateCallDebriefingPdf();
    
        Test.StopTest(); 
    }
}