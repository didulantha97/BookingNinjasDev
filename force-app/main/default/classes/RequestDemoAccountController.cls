public without sharing class RequestDemoAccountController {
    //String recId;
    public Lead lead {get; set;}
    public String FirstName {get; set;}
    public String LastName {get; set;}
    public String Email {get; set;}
    public String Phone {get; set;}
    public String Message {get; set;}
    public EmailTemplate etClient {get; set;}
    public EmailTemplate etAdmin {get; set;}
        
    public RequestDemoAccountController(ApexPages.StandardController stdController){    
        //recId = ApexPages.currentPage().getParameters().get('id');
        
        etClient = [Select Id, Name from EmailTemplate where name = 'Request Demo Account Response Client' limit 1]; //email template for response client
        etAdmin = [Select Id, Name from EmailTemplate where name = 'Request Demo Account Response Admin' limit 1]; //email template for response admin
        
        FirstName = '';
        LastName = '';
        Email = '';
        Phone = '';
        Message = '';
    }
    
    public Lead getLead()
    {
        return lead;
    }

    public PageReference SaveForm() 
    {
        Integer reCount = [Select Count() from Lead where Email =: Email limit 1];
        if(reCount > 0) {
            lead = [Select Id, Name, FirstName, LastName, Email, Phone, LeadSource, IP_Address__c from Lead where Email =: Email limit 1];
            System.Debug('Lead=='+lead);
        }
        else {
            lead = new Lead();
            lead.FirstName = FirstName;
            lead.LastName = LastName;
            lead.Email = Email;
            lead.Phone = Phone;
            lead.LeadSource = 'Booking Ninjas';
            lead.IP_Address__c = GetUserIPAddress();
            
            insert lead;
            
            System.Debug('Lead=='+lead);
        }
        
        SendEmailToAdmin();
        SendEmailToClient();
        
        PageReference p = new Pagereference('/apex/Response');
        p.setRedirect(true);
        return p;
    }
    
    public void SendEmailToAdmin()
    {
        //sends an email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new string[]{ 'david@bookingninjas.com' });
        mail.setTargetObjectId(lead.Id);
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setTemplateId(etAdmin.Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public void SendEmailToClient()
    {
        //sends an email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setTargetObjectId(lead.Id);
        //mail.setWhatId(lead.Id);
        mail.setSaveAsActivity(true);
        mail.setTemplateId(etClient.Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public String GetUserIPAddress() {
        string ReturnValue = '';
        
        ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        if (ReturnValue == '' || ReturnValue == null) {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        }
        return ReturnValue;
    }
}