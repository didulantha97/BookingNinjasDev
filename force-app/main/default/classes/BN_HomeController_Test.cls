@isTest(seealldata = true)
public class BN_HomeController_Test {

    public static Lead lead;

    static {
        createTestData();
    }
    
    public static void createTestData() 
    {
        lead = new Lead();
        lead.LastName = 'Harroch';
        lead.Email = 'david@bookingninjas.com';
        lead.Phone = '+19176002345';
        lead.MobilePhone = '+19176002345';
        lead.Company = 'Booking Ninjas';
        lead.Property_Name__c = 'Hotel BN';
        lead.LeadSource = 'Demo Lead';
        insert lead;
    }
    
    public static testMethod void testSubmitDemoLeadForm() 
    {
        PageReference pageRef = Page.BN_Index;
        Test.setCurrentPage(pageRef);
        
        BN_HomeController ctrl = new BN_HomeController();
        
        Test.startTest();
        
            ctrl.getIndustryList();
            ctrl.getCompanySizeList();
            ctrl.getHqContinentList();
            ctrl.isVideoShown = false;

            ctrl.industry = 'Hospitality';
            ctrl.name = 'David Harroch';
            ctrl.email = 'david@email.com';
            ctrl.phone = '1234567890';
            ctrl.companySize = '1-10';
            ctrl.hqContinent = 'North America';
            ctrl.sendDemoLead();
            
        Test.stopTest();
    }
    
    public static testMethod void testCalendlyFormForContinent() 
    {
        PageReference pageRef = Page.BNCalendly;
        Test.setCurrentPage(pageRef);
        
        BN_HomeController ctrl = new BN_HomeController();
        
        Test.startTest();
        
            ctrl.getCalendlyContinents();
            
            ctrl.changeContinent();
                        
            ctrl.continent = 'USA';
            ctrl.calendlyName = 'Booking Ninjas USA';
            ctrl.calendlyLink = 'https://calendly.com/bookingninjas_meetings/booking-ninjas-us-30-minute-meeting';
            
            System.assertEquals(ctrl.calendlyName, 'Booking Ninjas USA');
            System.assertEquals(ctrl.calendlyLink, 'https://calendly.com/bookingninjas_meetings/booking-ninjas-us-30-minute-meeting');
            
        Test.stopTest();
    }
    
    public static testMethod void testCalendlyFormForMeetingType() 
    {
        PageReference pageRef = Page.BNCalendly;
        Test.setCurrentPage(pageRef);
        
        BN_HomeController ctrl = new BN_HomeController();
        
        Test.startTest();
        
            ctrl.getCalendlyMeetingTypeList();
            
            ctrl.changeMeetingType();
                        
            ctrl.meetingType = 'Introduction';
            ctrl.calendlyName = 'Introduction (15 mins, One-on-One)';
            ctrl.calendlyLink = 'https://calendly.com/bookingninjas_meetings/introduction';
            
            System.assertEquals(ctrl.calendlyName, 'Introduction (15 mins, One-on-One)');
            System.assertEquals(ctrl.calendlyLink, 'https://calendly.com/bookingninjas_meetings/introduction');
            
        Test.stopTest();
    }
}