@isTest
public with sharing class BN_WebinarsController_Test {
    
    @testSetup static void setup()
    {
        //Webinar_Start__c, Webinar_End__c
        List<Webinar__c> webinar = new List<Webinar__c>{
            new Webinar__c(Name = 'Webinar 1', Category__c = 'Booking Ninjas', Webinar_Start__c = System.now().addDays(5).addHours(1), Webinar_End__c = System.now().addDays(5).addHours(2), Hosted_By__c = 'David Harroch, CEO of Booking Ninjas', Short_Description__c = 'Test message', Long_Description__c = 'Long message here', Recording_URL__c = 'https://www.youtube.com/watch?v=cff2_gEO8PE'),
            new Webinar__c(Name = 'Webinar 2', Category__c = 'Booking Ninjas', Webinar_Start__c = System.now().addDays(10).addHours(1), Webinar_End__c = System.now().addDays(5).addHours(10), Hosted_By__c = 'David Harroch, CEO of Booking Ninjas', Short_Description__c = 'Test message', Long_Description__c = 'Long message here'),
            new Webinar__c(Name = 'Webinar 3', Category__c = 'Booking Ninjas', Webinar_Start__c = System.now().addDays(15).addHours(1), Webinar_End__c = System.now().addDays(5).addHours(15), Hosted_By__c = 'David Harroch, CEO of Booking Ninjas', Short_Description__c = 'Test message', Long_Description__c = 'Long message here'),
            new Webinar__c(Name = 'Webinar 4', Category__c = 'Booking Ninjas', Webinar_Start__c = System.now().addDays(20).addHours(1), Webinar_End__c = System.now().addDays(5).addHours(20), Hosted_By__c = 'David Harroch, CEO of Booking Ninjas', Short_Description__c = 'Test message', Long_Description__c = 'Long message here'),
            new Webinar__c(Name = 'Webinar 5', Category__c = 'Booking Ninjas', Webinar_Start__c = System.now().addDays(25).addHours(1), Webinar_End__c = System.now().addDays(5).addHours(25), Hosted_By__c = 'David Harroch, CEO of Booking Ninjas', Short_Description__c = 'Test message', Long_Description__c = 'Long message here')
        };
        insert webinar;
        
        Webinar_Registration__c registration = new Webinar_Registration__c();
        registration.First_Name__c = 'David';
        registration.Last_Name__c = 'Harroch';
        registration.Email__c = 'david@bookingninjas.com';
        registration.Phone__c = '+19176002345';
        registration.Business__c = 'Company A';
        registration.Country__c = 'United States';
        registration.Webinar_Schedule__c = webinar[0].Date__c;
        registration.Webinar__c = webinar[0].Id;
        insert registration;
    }
    
    static testMethod void testListAllWebinars() 
    {
        Test.startTest();
            PageReference pageRef = Page.BN_Webinars;
            Test.setCurrentPage(pageRef);
            
            BN_WebinarsController ctrl = new BN_WebinarsController();
            List<BN_WebinarsController.Webinar> webinars = ctrl.getWebinarList();
            List<BN_WebinarsController.Webinar> webinarsOld = ctrl.getRecordingList();
        Test.stopTest();

        System.assertNotEquals(null, webinars);
        System.assertNotEquals(null, webinarsOld);
    }
    
    static testMethod void testRegister() 
    {
        List<Webinar__c> webinar = [SELECT Id, Name FROM Webinar__c];
        Test.startTest();
            PageReference pageRef = Page.BN_Webinars;
            Test.setCurrentPage(pageRef);
            BN_WebinarsController ctrl = new BN_WebinarsController();
            //Webinar__c webinar = [SELECT Id, Name, Date__c, Webinar_Start__c, Webinar_End__c FROM Webinar__C LIMIT 1];
            String webinarName = ApexPages.currentPage().getParameters().put('webinar', webinar[0].Name);
            ctrl.firstName = 'Joe';
            ctrl.email = 'joe@email.com';
            ctrl.webinarName = webinar[0].Name;
            ctrl.saveYourSeat();
            ctrl.getWebinarTopic();
        	ctrl.toWebinarSinglePage();
        Test.stopTest();
    }
}