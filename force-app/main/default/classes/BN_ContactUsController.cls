public with sharing class BN_ContactUsController {
    
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String phone {get; set;}
    public String company {get; set;}
    public String comment {get; set;}
    public String pms {get; set;}
    public Integer noOfUnits {get; set;}
    
    public Lead lead {get; set;}
    
    public BN_ContactUsController() {
    
        firstName = '';
        lastName = '';
        email = '';
        phone = '';
        company = '';
        comment = '';
        pms = '';
        noOfUnits = 0;
    }
    
    public PageReference save()
    {
        // add new lead
        lead = new Lead();
        lead.LastName = lastName;
        lead.FirstName = firstName;
        lead.Email = email;
        lead.Phone = phone;
        lead.Company = company;
        lead.LeadSource = 'Booking Ninjas';
        lead.Message__c = comment;
        lead.Number_of_Units_Under_Management__c = noOfUnits;
        lead.Current_Software_Used__c = pms;
        insert lead;
        
        // send email notification
        sendEmail(email);
        
        // redirect to thank you  page
        PageReference pageRef = new PageReference('/thank-you-for-your-interest');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private void sendEmail(String email)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.setccAddresses(new String[] { 'david@bookingninjas.com' });
        message.optOutPolicy = 'FILTER';
        message.subject = 'Thank you for expressing your interest to Booking Ninjas PMS!';
        message.setHtmlBody('Thank you for expressing your interest to Booking Ninjas Property Management System! <br/> We look forward to hearing from you and taking care of all your PMS needs. <br/> To expedite the process, feel free to give us a call during business hours Monday-Friday at (917)-600-2345. <br/> We look forward to working with you! <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}