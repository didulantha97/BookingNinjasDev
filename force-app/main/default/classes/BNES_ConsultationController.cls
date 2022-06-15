public with sharing class BNES_ConsultationController {

    public String name {get; set;}
    public String property {get; set;}
    public String company {get; set;}
    public String phone {get; set;}
    public String email {get; set;}
    public Time meetingTime {get; set;}
    public Date meetingDate {get; set;}
    
    public Lead lead {get; set;}
    
    public BNES_ConsultationController() {
        
        name = '';
        property = '';
        company = '';
        phone = '';
        email = '';
        meetingDate = Date.Today();
    }
    
    public PageReference save()
    {
        // add new lead
        lead = new Lead();
        lead.LastName = name;
        lead.Email = email;
        lead.Phone = phone;
        lead.MobilePhone = phone;
        lead.Company = company;
        lead.Property_Name__c = property;
        lead.Meeting_Date__c = meetingDate;
        lead.Meeting_Time__c  =  meetingTime;
        lead.LeadSource = 'Consulting';
        insert lead;
        
        // send email notification
        sendEmail(email, meetingDate, meetingTime);
        
        // redirect to thank you  page
        PageReference pageRef = new PageReference('/thank-you-for-your-interest');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private void sendEmail(String email, Date meetingDate, Time meetingTime)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.setccAddresses(new String[] { 'david@bookingninjas.com' });
        message.optOutPolicy = 'FILTER';
        message.subject = 'Consultation Confirmation | Booking Ninjas PM';
        message.setHtmlBody('Thank you for scheduling a consultation session with our team of Salesforce experts! This email serves as confirmation of your appointment scheduled for ' + meetingDate + ' at ' + meetingTime + '. Our experts are excited to answer any and all questions you may have about your Salesforce cloud as well as show you how to get the absolute most out of the Salesforce platform. <br/> If you’d like to make changes to your appointment, use this <a href="https://www.bookingninjas.com/calendly">link</a> to reschedule or cancel. <br/> If you have any further questions, call (917)-600-2345 Monday-Friday during business hours or reply to this email and a member of our team will be in touch as soon as possible. We look forward to working with you! <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    } 
}