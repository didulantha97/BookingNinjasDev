@isTest()
public with sharing class BN_WebinarController_Test {

    public static List<Webinar__c> webinars;
    public static Webinar_Registration__c registration;
    
    static { createTestData(); }
    
    public static void createTestData() 
    {
        
        webinars = new List<Webinar__c>{
            new Webinar__c(
                Name = 'Webinar 1',
                Category__c = 'Booking Ninjas',
                Date__c = Date.Today().addDays(-1),
                Time__c = '10:00 AM EST',
                Webinar_Start__c = Date.Today().addDays(-1),
                Hosted_By__c = 'David Harroch, CEO of Booking Ninjas',
                Short_Description__c = 'Test message',
                Long_Description__c = 'Long message here',
                Recording_Url__c = 'https://www.youtube.com/watch?v=cff2_gEO8PE'
            ),
            new Webinar__c(
                Name = 'Webinar 2',
                Category__c = 'Booking Ninjas',
                Date__c = Date.Today().addDays(1),
                Time__c = '10:00 AM EST',
                Webinar_Start__c = Date.Today().addDays(1),
                Hosted_By__c = 'David Harroch, CEO of Booking Ninjas',
                Short_Description__c = 'Test message',
                Long_Description__c = 'Long message here'
            )
        };
        insert webinars;
        
        registration = new Webinar_Registration__c();
        registration.First_Name__c = 'David';
        registration.Last_Name__c = 'Harroch';
        registration.Email__c = 'david@bookingninjas.com';
        registration.Phone__c = '+19176002345';
        registration.Business__c = 'Company A';
        registration.Country__c = 'United States';
        registration.Webinar_Schedule__c = webinars[0].Date__c;
        registration.Webinar__c = webinars[0].Id;
        insert registration;
    }
    
    public static testMethod void testRegister() 
    {
        Test.startTest();
        
            PageReference pageRef = Page.BN_WebinarLeadForm;
            Test.setCurrentPage(pageRef);
            
            Webinar__c webinar = [SELECT Id, Name, Date__c, Time__c FROM Webinar__C LIMIT 1];
            ApexPages.currentPage().getParameters().put('id', webinar.Id);
            
            BN_WebinarController ctrl = new BN_WebinarController();
            
            ctrl.webinar = webinar;
            
            ctrl.firstName = 'Joe';
            ctrl.lastName = 'Johnson';
            ctrl.email = 'joe@email.com';
            ctrl.phone = '+123456789';
            ctrl.business = 'Company A';
            ctrl.country = 'United States';
            ctrl.saveYourSeat(); 
            
        Test.stopTest();
    }
}