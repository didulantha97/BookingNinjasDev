@isTest
private class BN_WebinarSingle_Test {
    
    @isTest
    static void tester(){
        Webinar__c webinar = new Webinar__c(Name = 'Webinar 1',
                                            Category__c = 'Booking Ninjas',
                                            Webinar_Start__c = Datetime.now().addDays(10).addHours(1),
                                            Webinar_End__c = Datetime.now().addDays(10).addHours(2),
                                            Hosted_By__c = 'David Harroch, CEO of Booking Ninjas',
                                            Short_Description__c = 'Test message',
                                            Long_Description__c = 'Long message here'
                                           );
        insert webinar;

        Test.startTest();
        
        PageReference pageRef = Page.BN_WebinarSingle;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', webinar.Id);
        
        BN_WebinarSingle obj = new BN_WebinarSingle();
        obj.name = 'Joe';
        obj.email = 'joe@email.com';
        obj.phone = '05554443322';
        obj.linkedURL = 'www.linkedIn.com/testuser123.com';
        obj.saveYourSeat();
        
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM Webinar_Registration__c]);
    }
}