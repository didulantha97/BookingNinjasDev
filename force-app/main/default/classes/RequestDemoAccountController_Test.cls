@isTest
public class RequestDemoAccountController_Test {

    public static Lead LeadTest = new Lead();
    
    Static 
    {
        createTestData();
    }

    public static void createTestData() {
        //Business account
        Account a = new Account(Name = 'test', BillingCountry = 'Philippines', Continent__c = 'Asia');
        insert a;
        
        //Admin Contact
        Contact admin = new Contact(LastName = 'BookingNinjas', Accountid = a.Id, Email =  'info@bookingninjas.com', MailingCountry = 'Philippines', Continent__c = 'Asia');
        insert admin;
        
        //Lead
        LeadTest.LastName = 'Dela Cruz';
        LeadTest.FirstName = 'Juan';
        LeadTest.Email = 'jdc@gmail.com';
        LeadTest.Phone = '0000000000';
        LeadTest.LeadSource = 'Web';
        LeadTest.Country = 'Philippines';
        LeadTest.Continent__c = 'Asia';
        insert LeadTest;
    }
        
    public static testMethod void TestRequestDemoAccountForm() {
        Test.StartTest();
        
        PageReference pageRef = Page.RequestDemoAccountForm;
        Test.setCurrentPage(pageRef);
        RequestDemoAccountController sf = new RequestDemoAccountController(new ApexPages.StandardController(LeadTest));
    
        sf.getLead();
        sf.GetUserIPAddress();
        
        sf.FirstName = 'Juan';
        sf.LastName = 'Dela Cruz';
        sf.Email = 'jdc@gmail.com';
        sf.Phone = '0000000000';
        sf.Message = 'Test Message';
    
        sf.SaveForm();
        sf.SendEmailToAdmin();
        sf.SendEmailToClient();
    
        Test.StopTest(); 
    }
}