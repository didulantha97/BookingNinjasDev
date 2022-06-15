public with sharing class BN_WebinarSendCalendarController {
    public static Webinar__c webinar {get; set;}
    public static Webinar_Registration__c registration {get;  set;}
    public static String webinarName {get; set;}
    public static String outlookURL {get; set; }
    public static String googleURL {get; set; }
    public static PageReference backToWebinarPage {get; set;}
    public static PageReference toWebinarSinglePage {get; set;}
    public static String firstName {get; set;}
    public static String email {get; set;}
    public static String webinarId {get; set;}
    public static String selectedWebinar {get; set;}
    
    public BN_WebinarSendCalendarController(){
        webinarId = ApexPages.currentPage().getParameters().get('webinarId');
        webinar = getWebinar(webinarName);
        googleURL =  getGoogleCalendarURL();
        outlookURL = getOutlookCalendarURL();
        backToWebinarPage = backtoWebinarPage();
        toWebinarSinglePage  = toWebinarSinglePage();
    }
    
    public static Webinar__c getWebinar(String webinarName){
        Webinar__c webObj = [SELECT Id, Name, Date__c, Time__c, Category__c, Webinar_Start__c, Webinar_End__c, Activity_Start_Date__c, Activity_End_Date__c, Hosted_By__c, Short_Description__c, Long_Description__c FROM Webinar__c WHERE Id = :webinarId];
        webObj.Date__c = Date.parse(webObj.Webinar_Start__c.format('MM/dd/YYYY'));
        webObj.Time__c = webObj.Webinar_Start__c.format('hh:mm a');
        return webObj;
    }
    
    public static List<SelectOption> getWebinarTopic() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Choose Topics', 'Choose Topics'));
        for(Webinar__c web : [Select Name From Webinar__c]){
            options.add(new SelectOption(web.Name, web.Name));
        }
        return options;
    }
    
    public static PageReference backtoWebinarPage() 
    {
        // redirect to webinar schedule page
        PageReference pageRef = new PageReference('/apex/BN_Webinars');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public static PageReference toWebinarSinglePage() 
    {
        // redirect to webinar schedule page
        PageReference pageRef = new PageReference('/apex/BN_WebinarSingle');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public static PageReference saveYourSeat() 
    {
        Webinar__c web = [select Id, Name, Date__c, Webinar_Start__c, Webinar_End__c From Webinar__c Where Id =: webinarId Limit 1];
        
        // create new webinar registration record
        registration  = new Webinar_Registration__c();
        registration.First_Name__c = firstName;
        registration.Email__c = email;
        registration.Webinar_Schedule__c = web.Date__c;
        registration.Webinar__c = web.Id;
        insert registration;
        
        // send email notification
        sendEmailNotif(email, web.Name, web.Webinar_Start__c.format('MM/dd/YYYY'), web.Webinar_Start__c.format('hh:mm a'), web.Webinar_End__c.format('hh:mm a'));
        
        // redirect to thank you  page
        PageReference pageRef = new PageReference('/apex/BN_WebinarThankYou?webinarId='+ webinarId );
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public static String getGoogleCalendarURL(){
        String schedule = webinar.Activity_Start_Date__c + '/' + webinar.Activity_End_Date__c;
        String title = EncodingUtil.urlEncode(webinar.Name, 'UTF-8');
        String description = String.isBlank(webinar.Short_Description__c) ? EncodingUtil.urlEncode(webinar.Name, 'UTF-8') : EncodingUtil.urlEncode(webinar.Short_Description__c, 'UTF-8');
        String googleInviteUrl = 'https://calendar.google.com/calendar/r/eventedit?text='+title+'&details='+description+'&dates='+schedule ;
        return googleInviteUrl;
    }
    
    public static String getOutlookCalendarURL(){
        String startDate = webinar.Webinar_Start__c.format('yyyy-MM-dd') + 'T' + webinar.Webinar_Start__c.format('hh:mm');
        String endDate = webinar.Webinar_End__c.format('yyyy-MM-dd') + 'T' + webinar.Webinar_End__c.format('hh:mm');
        String title = EncodingUtil.urlEncode(webinar.Name, 'UTF-8').replace('+', '%20');
        String description = String.isBlank(webinar.Short_Description__c) ? EncodingUtil.urlEncode(webinar.Name, 'UTF-8').replace('+', '%20') : EncodingUtil.urlEncode(webinar.Short_Description__c, 'UTF-8').replace('+', '%20');
        String outlookInviteUrl = 'https://outlook.live.com/calendar/0/deeplink/compose?subject='+title+'&body='+description+'&startdt='+startDate+'&enddt='+endDate;
        return outlookInviteUrl;
    }

    private static void sendEmailNotif(String email, String title, String webinarDate, String webinarTimeStart, String webinarTimeEnd)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.setccAddresses(new String[] { 'david@bookingninjas.com' });
        message.optOutPolicy = 'FILTER';
        message.subject = 'Thank you for your interest in our Booking Ninjas Webinar - ' + title;
        message.setHtmlBody('This letter is confirmation that we have received your seat reservation for our webinar entitled: ' + title + '! <br/> This webinar is scheduled on ' + webinarDate + ' at ' + webinarTimeStart + ' to ' + webinarTimeEnd + '. <br/> We appreciate your interest in joining our webinar. <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}