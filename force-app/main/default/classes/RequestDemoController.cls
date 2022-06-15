public without sharing class RequestDemoController {
    String recId;
    public Lead lead {get; set;}
    public Opportunity opp {get; set;}
    public Contact con {get; set;}
    public Contact admin {get; set;}
    public String StdObject {get; set;}
    public String Name {get; set;}
    public String Email {get; set;}
    public String Phone {get; set;}
    public DateTime PreferredDateTime {get; set;}
    public String Message {get; set;}
    public EmailTemplate etClient {get; set;}
    public EmailTemplate etAdmin {get; set;}
        
    public RequestDemoController(){
    
        recId = ApexPages.currentPage().getParameters().get('id');
        String prefix = String.valueOf(recId).substring(0,3);
        if(prefix == '00Q') {
            lead = [Select Id, Name, FirstName, LastName, Email, Phone, LeadSource, Preferred_Date__c, Preferred_Time__c, Message__c, IP_Address__c from Lead where id =: recId];
            StdObject = 'Lead';
            Name = lead.Name;
            Email = lead.Email;
            Phone = lead.Phone;
            etAdmin = [Select Id, Name from EmailTemplate where name = 'Request Demo Response Admin - Lead' limit 1]; //email template for response admin
        }
        else if (prefix == '003') {
            con = [Select Id, Name, FirstName, LastName, Email, Phone, IsPersonAccount, Preferred_Date__c, Preferred_Time__c, Message__c, IP_Address__c from Contact where id =: recId];
            StdObject = 'Contact';
            Name = con.Name;
            Email = con.Email;
            Phone = con.Phone;
            etAdmin = [Select Id, Name from EmailTemplate where name = 'Request Demo Response Admin - Contact' limit 1]; //email template for response admin
        }
        else if (prefix == '006') {
            opp = [Select Id, Primary_Contact__c, Primary_Contact__r.Name, Primary_Contact__r.FirstName, Primary_Contact__r.LastName, Primary_Contact__r.Email, Primary_Contact__r.Phone, LeadSource, Preferred_Date__c, Preferred_Time__c, Message__c from Opportunity where id =: recId];
            StdObject = 'Opportunity';
            Name = opp.Primary_Contact__r.Name;
            Email = opp.Primary_Contact__r.Email;
            Phone = opp.Primary_Contact__r.Phone;
            etAdmin = [Select Id, Name from EmailTemplate where name = 'Request Demo Response Admin - Opportunity' limit 1]; //email template for response admin
        }
        
        etClient = [Select Id, Name from EmailTemplate where name = 'Request Demo Response Client' limit 1]; //email template for response client
        
        PreferredDateTime = null;
        Message = '';
    }
    
    public PageReference SaveForm() 
    {
        if(StdObject == 'Lead')
        {
            lead.Preferred_Date_Time__c = PreferredDateTime;
            lead.Message__c = Message;
            lead.IP_Address__c = GetUserIPAddress();
            update lead;

            System.Debug('Lead==='+lead);
        }
        else if(StdObject == 'Contact')
        {
            con.Preferred_Date_Time__c = PreferredDateTime;
            con.Message__c = Message;
            con.IP_Address__c = GetUserIPAddress();
            update con;
            
            System.Debug('Contact==='+con);
        }
        else if(StdObject == 'Opportunity')
        {
            opp.Preferred_Date_Time__c = PreferredDateTime;
            opp.Message__c = Message;
            update opp;
            
            System.Debug('Opportunity==='+opp);
        }
        
        SendEmailToAdmin();
        SendEmailToClient();
        
        PageReference p = new Pagereference('/apex/Response?id=' + recId);
        p.setRedirect(true);
        return p;
    }
    
    public void SendEmailToAdmin()
    {
        //sends an email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new string[]{ 'david@bookingninjas.com' });
        if(StdObject == 'Lead') {
            mail.setTargetObjectId(lead.Id);
        }
        else if (StdObject == 'Contact') {
            mail.setTargetObjectId(con.Id);
        }
        else if (StdObject == 'Opportunity') {
            mail.setTargetObjectId(opp.Primary_Contact__c);
            mail.setWhatId(opp.Id);
        }
        mail.setTemplateId(etAdmin.Id);
        mail.setTreatTargetObjectAsRecipient(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public void SendEmailToClient()
    {
        //sends an email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        if(StdObject == 'Lead') {
            mail.setTargetObjectId(lead.Id);
            mail.setSaveAsActivity(true);
            //mail.setWhatId(lead.Id);
        }
        else if (StdObject == 'Contact') {
            mail.setTargetObjectId(con.Id);
            mail.setSaveAsActivity(true);
            //mail.setWhatId(con.Id);
        }
        else if (StdObject == 'Opportunity') {
            mail.setTargetObjectId(opp.Primary_Contact__c);
            mail.setSaveAsActivity(true);
            mail.setWhatId(opp.Id);
        }
        mail.setTemplateId(etClient.Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public String GetUserIPAddress() {
        string ReturnValue = '';
        
        ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        if (ReturnValue == '' || ReturnValue == null) {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        }
        System.Debug('IP: ' + ReturnValue);
        return ReturnValue;
    }
}