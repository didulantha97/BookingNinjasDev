public with sharing class BN_WebinarsController {

    public List<Webinar> webinars {get; set;}
    public List<Webinar> recordings {get; set;}
    public Webinar_Registration__c registration {get;  set;}
    public PageReference toWebinarSinglePage {get; set;}
    public List<String> webinarOptionList = new List<String>();
    
    public Integer counter {get; set;}
    public Integer webinarsCounter {get; set;}
    public Integer recordingsCounter {get; set;}
    public String firstName {get; set;}
    public String email {get; set;}
    public String webinarId {get; set;}
    public String webinarName {get; set;}
    public String selectedWebinar {get; set;}
    
    public List<SelectOption> WebinarTopic = new List<SelectOption>();
    
    public BN_WebinarsController() {
        webinars = getWebinarList();
        webinarsCounter = webinars.size();
        recordings = getRecordingList();
        recordingsCounter = recordings.size();
        toWebinarSinglePage  = toWebinarSinglePage();

        firstName = '';
        email = '';
        webinarId = '';
        counter = 0;
    }
    
    public class Webinar{
        public String Id {get; set;}
        public String Name {get; set;}
        public String WebinarDate {get; set;}
        public String WebinarTime {get; set;}
        public String WebinarStart {get; set;} 
        public String WebinarEnd {get; set;}
        public String ActivityStartDate {get; set;}
        public String ActivityEndDate {get; set;}
        public String HostedBy {get; set;}
        public String ShortDescription {get; set;}
        public String LongDescription {get; set;}
        public String RecordingURL {get; set;}
        public String Caterogy {get; set;}
        public String WebinarMonth {get; set;}
        public String WebinarDay {get; set;}
        public String WebinarImagePath {get; set;}
        //Id, Name, Category__c, Date__c, Time__c, Webinar_Start__c, Webinar_End__c, Activity_Start_Date__c, Activity_End_Date__c, Hosted_By__c, Short_Description__c, Long_Description__c, Recording_URL__c
    }
    
    public List<Webinar> getWebinarList(){
        List<Webinar> webinar = new List<Webinar>();
        List<Webinar__c> webinarList = [SELECT Id, Name, Category__c, Date__c, Time__c, Webinar_Start__c, Webinar_End__c, Activity_Start_Date__c, Activity_End_Date__c, Hosted_By__c, Short_Description__c, Long_Description__c, Recording_URL__c, Image_Path__c FROM Webinar__c WHERE Webinar_Start__c >: Date.Today() AND Recording_URL__c = null ORDER BY Webinar_Start__c];
        for(Webinar__c web : webinarList){
            Webinar webObj = new Webinar();
            webObj.Id = web.Id;
            webObj.Name= web.Name;
            webObj.WebinarDate= String.valueOf(web.Date__c);
            webObj.WebinarTime = web.Time__c;
            webObj.WebinarStart = web.Webinar_Start__c.format('MM/dd/YYYY');
            webObj.WebinarEnd = web.Webinar_End__c.format('MM/dd/YYYY');
            webObj.WebinarMonth = web.Webinar_Start__c.format('MMM');
            webObj.WebinarDay = web.Webinar_Start__c.format('dd');
            webObj.ActivityStartDate = web.Activity_Start_Date__c;
            webObj.ActivityEndDate = web.Activity_End_Date__c;
            webObj.HostedBy = web.Hosted_By__c;
            webObj.ShortDescription = web.Short_Description__c;
            webObj.LongDescription = web.Long_Description__c;
            webObj.RecordingURL = web.Recording_URL__c ;
            webObj.Caterogy = web.Category__c;
            webObj.WebinarImagePath  = web.Image_Path__c;
            webinar.add(webObj);
        }
        if(webinar != null || webinar.size() > 0){
            return webinar;
        } else {
            return webinar = new List<Webinar>();
        }
    }
    
    public List<Webinar> getRecordingList(){
        List<Webinar> recording = new List<Webinar>();
        List<Webinar__c> recordingList = [SELECT Id, Name, Category__c, Date__c, Time__c, Webinar_Start__c, Webinar_End__c, Activity_Start_Date__c, Activity_End_Date__c, Hosted_By__c, Short_Description__c, Long_Description__c, Recording_URL__c, Image_Path__c FROM Webinar__c WHERE Recording_URL__c != null ORDER BY Webinar_Start__c];
        for(Webinar__c web : recordingList){
            Webinar webObj = new Webinar();
            webObj.Id = web.Id;
            webObj.Name= web.Name;
            webObj.WebinarDate= String.valueOf(web.Date__c);
            webObj.WebinarTime = web.Time__c;
            webObj.WebinarStart = web.Webinar_Start__c.format('MM/dd/YYYY');
            webObj.WebinarEnd = web.Webinar_End__c.format('MM/dd/YYYY');
            webObj.WebinarMonth = web.Webinar_Start__c.format('MMM');
            webObj.WebinarDay = web.Webinar_Start__c.format('dd');
            webObj.ActivityStartDate = web.Activity_Start_Date__c;
            webObj.ActivityEndDate = web.Activity_End_Date__c;
            webObj.HostedBy = web.Hosted_By__c;
            webObj.ShortDescription = web.Short_Description__c;
            webObj.LongDescription = web.Long_Description__c;
            webObj.RecordingURL = web.Recording_URL__c ;
            webObj.Caterogy = web.Category__c;
            webObj.WebinarImagePath  = web.Image_Path__c;
            recording.add(webObj);
        }
        
        if(recording != null || recording .size() > 0){
            return recording;
        } else {
            return recording = new List<Webinar>();
        }
    }
    
    public List<SelectOption> getWebinarTopic() {
        webinars = getWebinarList();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Choose Topics', 'Choose Topics'));
        for(Webinar web : webinars){
            options.add(new SelectOption(web.Name, web.Name));
        }
        webinarOptionList = new List<String>();
        for(SelectOption so : options){
            webinarOptionList.add(so.getValue());
        }
        return options;
    }
    
    public PageReference saveYourSeat() 
    {
        Webinar__c web;
        if(selectedWebinar != 'Choose Topics' && webinarOptionList.contains(selectedWebinar)){
            web = [select Id, Name, Date__c, Webinar_Start__c, Webinar_End__c From Webinar__c Where Name =: selectedWebinar Limit 1];
        } else {
            web = [select Id, Name, Date__c, Webinar_Start__c, Webinar_End__c From Webinar__c Where Name =: webinarName Limit 1];
        }
        
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
        PageReference pageRef = new PageReference('/apex/BN_WebinarThankYou?webinar-id='+ web.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference toWebinarSinglePage() 
    {
        // redirect to webinar schedule page
        PageReference pageRef = new PageReference('/apex/BN_WebinarSingle');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private void sendEmailNotif(String email, String title, String webinarDate, String webinarTimeStart, String webinarTimeEnd)
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