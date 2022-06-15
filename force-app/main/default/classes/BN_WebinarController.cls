public with sharing class BN_WebinarController {
    
    public Webinar__c webinar {get; set;}
    public String webinarId {get; set;}
    
    public Webinar_Registration__c registration {get;  set;}

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String phone {get; set;}
    public String business {get; set;}
    public String country {get; set;}
    
    public BN_WebinarController() {
    
        webinarId = ApexPages.currentPage().getParameters().get('id');
        webinar = getWebinar(webinarId);
    
        firstName = '';
        lastName = '';
        email = '';
        phone  =  '';
        business = '';
        country = '';
    }
    
    private Webinar__c getWebinar(String id)
    {
        return [SELECT Id, Name, Category__c, Date__c, Time__c, Hosted_By__c, Short_Description__c, Long_Description__c FROM Webinar__c WHERE Id = :id];
    }
    
    public PageReference saveYourSeat() 
    {
        // create new webinar registration record
        registration  = new Webinar_Registration__c();
        registration.First_Name__c = firstName;
        registration.Last_Name__c = lastName;
        registration.Email__c = email;
        registration.Phone__c = phone;
        registration.Business__c = business;
        registration.Country__c = country;
        registration.Webinar_Schedule__c = webinar.Date__c;
        registration.Webinar__c = webinar.Id;
        insert registration;
        
        // send email notification
        sendEmail(email, webinar.Name, String.valueOf(webinar.Date__c), webinar.Time__c);
        
        // redirect to thank you  page
        PageReference pageRef = new PageReference('/thank-you-for-your-interest');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private void sendEmail(String email, String title, String webinarDate, String webinarTime)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.setccAddresses(new String[] { 'david@bookingninjas.com' });
        message.optOutPolicy = 'FILTER';
        message.subject = 'Thank you for your interest in our Booking Ninjas Webinar - ' + title;
        message.setHtmlBody('This letter is confirmation that we have received your seat reservation for our webinar entitled: ' + title + '! <br/> This webinar is scheduled on ' + webinarDate + ' at ' + webinarTime + '. <br/> We appreciate your interest in joining our webinar. <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
    
}