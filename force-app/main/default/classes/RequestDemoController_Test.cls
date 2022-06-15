@isTest(seeAllData=false)
public class RequestDemoController_Test {

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
        Contact admin = new Contact(LastName = 'BookingNinjas', Accountid = a.Id,  Email = 'bookingninjas@gmail.com', Phone = '123456789', MailingCountry = 'Philippines', Continent__c = 'Asia');
        admin.Email =  'info@bookingninjas.com';
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
        
    public static testMethod void TestRequestDemoLeadForm() {
        Test.StartTest();
        
        PageReference pageRef = Page.RequestDemoForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', LeadTest.id);
        RequestDemoController sf = new RequestDemoController();
    
        sf.Name = LeadTest.Name;
        sf.Email = LeadTest.Email;
        sf.Phone = LeadTest.Phone;
        
        sf.GetUserIPAddress();

        sf.PreferredDateTime = system.now();
        sf.Message = 'test message';
    
        sf.SaveForm();
    
        Test.StopTest(); 
    }
    
    public static testMethod void TestRequestDemoContactForm() {
        Test.StartTest();
        
        PageReference pageRef = Page.RequestDemoForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', Con.id);
        RequestDemoController sf = new RequestDemoController();
    
        sf.Name = Con.Name;
        sf.Email = Con.Email;
        sf.Phone = Con.Phone;
        
        sf.GetUserIPAddress();

        sf.PreferredDateTime = system.now();
        sf.Message = 'test message';
    
        sf.SaveForm();
    
        Test.StopTest(); 
    }
    
    public static testMethod void TestRequestDemoOpportunityForm() {
        Test.StartTest();
        
        PageReference pageRef = Page.RequestDemoForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', OppTest.id);
        RequestDemoController sf = new RequestDemoController();
    
        sf.Name = OppTest.Primary_contact__r.Name;
        sf.Email = OppTest.Primary_contact__r.Email;
        sf.Phone = OppTest.Primary_contact__r.Phone;
        
        sf.GetUserIPAddress();

        sf.PreferredDateTime = system.now();
        sf.Message = 'test message';
    
        sf.SaveForm();
    
        Test.StopTest(); 
    }
}