@isTest
public class BN_WebinarSendCalendarController_Test{
    public static List<Webinar__c> webinars;
    public static Webinar__c webinarRecord;
    public static Webinar_Registration__c registration;
    static { createTestData(); }
    
    public static void createTestData() 
    {
        //Webinar_Start__c, Webinar_End__c
        webinars = new List<Webinar__c>{
            new Webinar__c(Name = 'Webinar 1', Category__c = 'Booking Ninjas', Webinar_Start__c = System.now().addDays(5).addHours(1), Webinar_End__c = System.now().addDays(5).addHours(2), Hosted_By__c = 'David Harroch, CEO of Booking Ninjas', Short_Description__c = 'Test message', Long_Description__c = 'Long message here', Recording_Url__c = 'https://www.youtube.com/watch?v=cff2_gEO8PE'),
            new Webinar__c(Name = 'Webinar 2', Category__c = 'Booking Ninjas', Webinar_Start__c = System.now().addDays(10).addHours(1), Webinar_End__c = System.now().addDays(5).addHours(10), Hosted_By__c = 'David Harroch, CEO of Booking Ninjas', Short_Description__c = 'Test message', Long_Description__c = 'Long message here'),
            new Webinar__c(Name = 'Webinar 3', Category__c = 'Booking Ninjas', Webinar_Start__c = System.now().addDays(15).addHours(1), Webinar_End__c = System.now().addDays(5).addHours(15), Hosted_By__c = 'David Harroch, CEO of Booking Ninjas', Short_Description__c = 'Test message', Long_Description__c = 'Long message here'),
            new Webinar__c(Name = 'Webinar 4', Category__c = 'Booking Ninjas', Webinar_Start__c = System.now().addDays(20).addHours(1), Webinar_End__c = System.now().addDays(5).addHours(20), Hosted_By__c = 'David Harroch, CEO of Booking Ninjas', Short_Description__c = 'Test message', Long_Description__c = 'Long message here'),
            new Webinar__c(Name = 'Webinar 5', Category__c = 'Booking Ninjas', Webinar_Start__c = System.now().addDays(25).addHours(1), Webinar_End__c = System.now().addDays(5).addHours(25), Hosted_By__c = 'David Harroch, CEO of Booking Ninjas', Short_Description__c = 'Test message', Long_Description__c = 'Long message here')
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
    
    public static testMethod void testListAllWebinars() 
    {
        Test.startTest();
            PageReference pageRef = Page.BN_WebinarThankYou;
            String webinarName = ApexPages.currentPage().getParameters().put('webinarId', webinars[0].Id);
            BN_WebinarSendCalendarController ctrl = new BN_WebinarSendCalendarController();
            //webinarRecord = [SELECT Id, Name, Date__c, Time__c FROM Webinar__c Name =: webinarName];
            Test.setCurrentPage(pageRef);
            
        Test.stopTest();
    }
    
    public static testMethod void testRegister() 
    {
        Test.startTest();
        
            PageReference pageRef = Page.BN_WebinarThankYou;
            Test.setCurrentPage(pageRef);
            
            //Webinar__c webinar = [SELECT Id, Name, Date__c, Time__c FROM Webinar__c LIMIT 1];
            ApexPages.currentPage().getParameters().put('webinarId', webinars[0].Id);
            BN_WebinarSendCalendarController ctrl = new BN_WebinarSendCalendarController();
            
            BN_WebinarSendCalendarController.firstName = 'Joe';
            BN_WebinarSendCalendarController.email = 'joe@email.com';
            BN_WebinarSendCalendarController.webinarName = webinars[0].Name;
            BN_WebinarSendCalendarController.saveYourSeat();
            BN_WebinarSendCalendarController.getWebinarTopic();
            BN_WebinarSendCalendarController.getGoogleCalendarURL();
            BN_WebinarSendCalendarController.getOutlookCalendarURL();
            
        Test.stopTest();
    }
}