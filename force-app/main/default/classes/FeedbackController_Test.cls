@isTest
public class FeedbackController_Test {

    public static Contact con;
    
    Static {
        createTestData();
    }

    public static void createTestData() {
        //Business account
        Account a = new Account(Name = 'test', BillingCountry = 'Philippines', Continent__c = 'Asia');
        insert a;
        
        con = new Contact(FirstName = 'David', LastName = 'Harroch', Accountid = a.Id, Email =  'david@bookingninjas.com', MailingCountry = 'Philippines', Continent__c = 'Asia');
        insert con;
    }
        
    public static testMethod void TestFeedbackForm() {
        Test.StartTest();
        
        PageReference pageRef = Page.FeedbackForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', con.id);
        FeedbackController sf = new FeedbackController(new ApexPages.StandardController(con));
    
        sf.getContact();
        
        sf.getItems();
        
        sf.Feedback1 = 50;
        sf.Feedback2 = 'Feedback answer 2';
        sf.Feedback3 = 'Feedback answer 3';
        sf.Feedback4 = 'Yes';
        sf.Feedback5 = 'Feedback answer 5';
        sf.Feedback6 = 'Feedback answer 6';
        sf.IsAnswered = true;
    
        sf.SaveForm();
    
        Test.StopTest(); 
    }
}