public with sharing class BN_WebinarSingle {

    public Webinar__c webinar {get; set;}
    public String name {get; set;}
    public String email {get; set;}
    public String phone {get; set;}
    public String linkedURL {get; set;}
    public String webinarDate {get; set;}
    public String webinarTime {get; set;}
    
    public BN_WebinarSingle(){
        this.name = '';
        this.email = '';
        this.phone = '';
        this.linkedURL = '';

        this.webinar = [SELECT Id, Short_Description__c, Long_Description__c, Name, Date__c, Time__c, Webinar_Start__c, Webinar_End__c
                        FROM Webinar__c
                        WHERE Id =: ApexPages.currentPage().getParameters().get('id')
                       ];

        this.webinarDate = webinar.Webinar_Start__c.format('MM/dd/YYYY');
        this.webinarTime = webinar.Webinar_Start__c.format('hh:mm a');
    }
    
    public PageReference saveYourSeat(){
        Integer index = name.indexOf(' ');
        insert new Webinar_Registration__c(First_Name__c = index > -1 ? name.substring(0, index) : null,
                                           Last_Name__c = index > -1 ? name.substring(index, name.length()) : name,
                                           Email__c = email,
                                           Phone__c = phone,
                                           LinkedIn_URL__c = linkedURL,
                                           Webinar_Schedule__c = webinar.Date__c,
                                           Webinar__c = webinar.Id
                                          );
        
        // send email notification
        sendEmailNotif();
        
        // redirect to thank you  page
        PageReference pageRef = new PageReference('/apex/BN_WebinarThankYou?webinarId=' + webinar.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }

    private void sendEmailNotif(){
        String title = webinar.Name;

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new List<String>{email};
        message.setccAddresses(new List<String>{'david@bookingninjas.com'});
        message.optOutPolicy = 'FILTER';
        message.subject = 'Thank you for your interest in our Booking Ninjas Webinar - ' + title;
        message.setHtmlBody('This letter is confirmation that we have received your seat reservation for our webinar entitled: ' + title + '! <br/> This webinar is scheduled on ' + webinarDate + ' at ' + webinar.Webinar_Start__c.format('hh:mm a') + ' to ' + webinar.Webinar_End__c.format('hh:mm a') + '. <br/> We appreciate your interest in joining our webinar. <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{message});
    }
}