@isTest(seealldata = true)
public class BN_ContactUsController_Test {
    
    public static Lead lead;
    
    static { createTestData(); }
    
    public static void createTestData() 
    {
        lead = new Lead();
        lead.LastName = 'Harroch';
        lead.FirstName = 'David';
        lead.Email = 'david@bookingninjas.com';
        lead.Phone = '+19176002345';
        lead.MobilePhone = '+19176002345';
        lead.Company = 'Booking Ninjas';
        insert lead;
    }
    
    public static testMethod void testSubmitContactUsForm() 
    {
        PageReference pageRef = Page.BN_Contact;
        Test.setCurrentPage(pageRef);
        
        BN_ContactUsController ctrl = new BN_ContactUsController();
        
        Test.startTest();

            ctrl.firstName = 'David';
            ctrl.lastName = 'Harroch';
            ctrl.company= 'Booking Ninjas';
            ctrl.email = 'david@bookingninjas.com';
            ctrl.phone = '+19176002345';
            ctrl.comment = 'Test comment';
            ctrl.pms = 'Opera';
            ctrl.noOfUnits = 50;
            ctrl.save();
            
        Test.stopTest();
    }
}