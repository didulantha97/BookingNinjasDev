public with sharing class BN_GuestPostController {
    
    public Lead lead {get; set;}
    
    public String name {get; set;}
    public String email {get; set;}
    public String pitchIdea {get; set;}
    public String message {get; set;}
    
    public Blob fileBody {get; set;}
    public string fileName {get; set;}
    public String contentType {get; set;}

    public BN_GuestPostController() {
        
        name = '';
        email = '';
        pitchIdea = '';
        message = '';
    }
    
    public PageReference submit()
    {
        // validates record
        if(getLeadByEmail(email).size() > 0)
        {
            // fetch lead
            lead = getLeadByEmail(email)[0];
        }
        else 
        {
            lead = new Lead();
            lead.LastName = name;
            lead.Email = email;
            lead.LeadSource = 'Guest Post';
            lead.Pitch_Idea__c = pitchIdea;
            lead.Guest_Post_Message__c = message;
            insert lead;
        }
        
        // insert attachment
        if(fileBody != null) {
            Attachment attach = new Attachment();
            attach.Body = fileBody;
            attach.Name = fileName;
            attach.ContentType = contentType;
            attach.ParentId = lead.Id;
            insert attach;
        }
        
        // send email notification
        sendEmail(email);
        
        // redirect to thank you  page
        PageReference pageRef = new PageReference('/thank-you-for-your-submission');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private List<Lead> getLeadByEmail(String email) {
        return [SELECT Id, FirstName, LastName, Email, Phone, LeadSource, Pitch_Idea__c, Guest_Post_Message__c FROM Lead WHERE Email = :email];
    }
    
    private void sendEmail(String email)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.setccAddresses(new String[] { 'david@bookingninjas.com' });
        message.optOutPolicy = 'FILTER';
        message.subject = 'Thank you for your interest in contributing to our Booking Ninjas blog!';
        message.setHtmlBody('Thank you for your interest in contributing to our Booking Ninjas blog! <br/> We look forward to hearing from you and taking care of all your PMS needs. <br/> To expedite the process, feel free to give us a call during business hours Monday-Friday at (917)-600-2345. <br/> We look forward to working with you! <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}