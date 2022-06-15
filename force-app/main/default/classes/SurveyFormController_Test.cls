@isTest
public class SurveyFormController_Test {

    public static Opportunity OppTest = new Opportunity();
    public static Lead LeadTest = new Lead();
    public static Product2 pObj1 = new Product2();
    public static Contact Con;
    
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
        Account a = new Account(Name = 'test', BillingCountry = 'Philippines', Continent__c = 'Asia');
        insert a;
        
        //Admin Contact
        Contact admin = new Contact(LastName = 'BookingNinjas', Accountid = a.Id, Email = 'info@bookingninjas.com', Phone = '123456789', MailingCountry = 'Philippines', Continent__c = 'Asia');
        insert admin;
        
        //Contact
        Con = new Contact(LastName = 'James', FirstName = 'LeBron', Accountid = a.Id, Email = 'lebronjames@gmail.com', Phone = '123456789', MailingCountry = 'Philippines', Continent__c = 'Asia');
        insert Con;
        
        //Product Item 1
        pObj1 = new Product2();
        pObj1.Name = 'Product 1';
        pObj1.Family = 'No. of Units';
        pObj1.IsActive = true;
        pObj1.Quantity__c = 1;
        pObj1.Product_Region__c = '(EN) English';
        insert pObj1;
    
        //Opportunity
        Opptest.Name = 'TestOppName';
        OppTest.AccountId = Acc.Id;
        OppTest.Type = 'New Business';
        OppTest.CloseDate = Date.today();
        OppTest.StageName = 'Prospecting';
        OppTest.Primary_contact__c = Con.id;
        OppTest.Product_Item_1__c = pObj1.Id;
        OppTest.LeadSource = 'Web';
        insert OppTest;
        
        //Lead
        LeadTest.LastName = 'Dela Cruz';
        LeadTest.FirstName = 'Juan';
        LeadTest.Email = 'jdc@gmail.com';
        LeadTest.Phone = '123456789';
        LeadTest.LeadSource = 'Web';
        LeadTest.Country = 'Philippines';
        LeadTest.Continent__c = 'Asia';
        insert LeadTest;
    }
        
    public static testMethod void TestSurveyLeadForm() {
        Test.StartTest();
        
        PageReference pageRef = Page.SurveyForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', LeadTest.id);
        SurveyFormController sf = new SurveyFormController();
        
        sf.Name = LeadTest.Name;
        sf.Email = LeadTest.Email;
        sf.Phone = LeadTest.Phone;
        
        sf.GetUserIPAddress();
        sf.getItems();
        
        sf.BN_Q1 = 'No';
        sf.BN_Q2 = 'N/A';
        sf.BN_Q3 = 0;
        sf.BN_Q4 = 'N/A';
        sf.BN_Q5 = 'N/A';
    
        sf.SaveForm();
    
        Test.StopTest(); 
    }
    
    public static testMethod void TestSurveyContactForm() {
        Test.StartTest();
        
        PageReference pageRef = Page.SurveyForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', Con.id);
        SurveyFormController sf = new SurveyFormController();
        
        sf.Name = Con.Name;
        sf.Email = Con.Email;
        sf.Phone = Con.Phone;

        sf.GetUserIPAddress();
        sf.getItems();
        
        sf.BN_Q1 = 'No';
        sf.BN_Q2 = 'N/A';
        sf.BN_Q3 = 0;
        sf.BN_Q4 = 'N/A';
        sf.BN_Q5 = 'N/A';
    
        sf.SaveForm();
    
        Test.StopTest(); 
    }
    
    public static testMethod void TestSurveyOppForm() {
        Test.StartTest();
        
        PageReference pageRef = Page.SurveyForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', OppTest.id);
        SurveyFormController sf = new SurveyFormController();
        
        sf.Name = OppTest.Primary_contact__r.Name;
        sf.Email = OppTest.Primary_contact__r.Email;
        sf.Phone = OppTest.Primary_contact__r.Phone;
        
        sf.GetUserIPAddress();
        sf.getItems();
        
        sf.BN_Q1 = 'No';
        sf.BN_Q2 = 'N/A';
        sf.BN_Q3 = 0;
        sf.BN_Q4 = 'N/A';
        sf.BN_Q5 = 'N/A';
    
        sf.SaveForm();
    
        Test.StopTest(); 
    } 
}