@isTest(seealldata = true)
public class BN_ConsultationController_Test {
    
    public static Lead lead;
    
    static { createTestData(); }
    
    public static void createTestData() 
    {
        DateTime dt = System.today();
        
        lead = new Lead();
        lead.LastName = 'Harroch';
        lead.Email = 'david@bookingninjas.com';
        lead.Phone = '+19176002345';
        lead.MobilePhone = '+19176002345';
        lead.Company = 'Booking Ninjas';
        lead.Property_Name__c = 'Hotel BN';
        lead.Meeting_Date__c = Date.Today();
        lead.Meeting_Time__c  =  Time.newInstance(dt.hour(), dt.minute(), dt.second(), dt.millisecond());
        lead.LeadSource = 'Consulting';
        insert lead;
    }
    
    public static testMethod void testSubmitConsultation() 
    {
        PageReference pageRef = Page.BN_ConsultingForm;
        Test.setCurrentPage(pageRef);
        
        BN_ConsultationController ctrl = new BN_ConsultationController();
        
        Test.startTest();
        
            DateTime dt = System.today();
            
            ctrl.name = 'David Harroch';
            ctrl.company= 'Booking Ninjas';
            ctrl.property = 'Hotel BN';
            ctrl.email = 'david@bookingninjas.com';
            ctrl.phone = '+19176002345';
            ctrl.meetingTime = Time.newInstance(dt.hour(), dt.minute(), dt.second(), dt.millisecond());
            ctrl.meetingDate = Date.Today();
            ctrl.save();
            
        Test.stopTest();
    }
}