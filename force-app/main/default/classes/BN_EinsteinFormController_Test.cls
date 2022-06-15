@isTest(seealldata = true)
public class BN_EinsteinFormController_Test {

    public static Lead lead;
    
    static  { createTestData(); }
    
    public static void createTestData() 
    {
        lead = new Lead();
        lead.FirstName = 'David';
        lead.LastName =  'Harroch';
        lead.Title = 'CEO';
        lead.Company = 'Booking Ninjas';
        lead.Email = 'david@bookingninjas.com';
        lead.Phone = '+19176002345';
        insert lead;
    }
    
    public static testMethod void testRegisterExistingLead() 
    {
        PageReference pageRef = Page.BN_EinsteinForm;
        Test.setCurrentPage(pageRef);
        
        Lead lead = [SELECT Id, FirstName, LastName, Title, Company, Email, Phone FROM Lead WHERE Email = 'david@bookingninjas.com' LIMIT 1];
        
        BN_EinsteinFormController ctrl = new BN_EinsteinFormController();
        
        Test.startTest();
        
            ctrl.name = 'David Harroch';
            ctrl.title = 'CEO';
            ctrl.company = 'Booking Ninjas';
            ctrl.email = 'david@bookingninjas.com';
            ctrl.phone = '+19176002345';
            ctrl.preferredDateTime = '';
            ctrl.save();
        
        Test.stopTest();
        
        System.AssertEquals(lead.Email, 'david@bookingninjas.com');
    }
    
    public static testMethod void testRegisterNewLead() 
    {
        PageReference pageRef = Page.BN_EinsteinForm;
        Test.setCurrentPage(pageRef);

        BN_EinsteinFormController ctrl = new BN_EinsteinFormController();
        
        Test.startTest();
        
            ctrl.name = 'David Harroch';
            ctrl.title = 'CEO';
            ctrl.company = 'Booking Ninjas';
            ctrl.email = 'davidtest@bookingninjas.com';
            ctrl.phone = '+19176002345';
            ctrl.preferredDateTime = '';
            ctrl.save();
            
            Lead lead = [SELECT Id, FirstName, LastName, Title, Company, Email, Phone FROM Lead WHERE Email = 'davidtest@bookingninjas.com' LIMIT 1];
        
        Test.stopTest();
        
        System.AssertEquals(lead.Email, 'davidtest@bookingninjas.com');
    }
}