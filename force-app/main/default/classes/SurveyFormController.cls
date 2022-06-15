public without sharing class SurveyFormController {
    String recId;
    public Lead lead {get; set;}
    public Opportunity opp {get; set;}
    public Contact con {get; set;}
    public String StdObject {get; set;}
    public String Name {get; set;}
    public String Email {get; set;}
    public String Phone {get; set;}
    public Boolean IsAnswered {get; set;}
    public String BN_Q1 {get; set;}
    public String BN_Q2 {get; set;}
    public Decimal BN_Q3 {get; set;}
    public String BN_Q4 {get; set;}
    public String BN_Q5 {get; set;}
    public EmailTemplate etClient {get; set;}
    public EmailTemplate etAdmin {get; set;}
        
    public SurveyFormController(){
    
        recId = ApexPages.currentPage().getParameters().get('id');
        String prefix = String.valueOf(recId).substring(0,3);
        if(prefix == '00Q') {
            lead = [Select Id, Name, FirstName, LastName, Email, Phone, LeadSource, IP_Address__c, BN_Survey_Q1__c, BN_Survey_Q2__c, BN_Survey_Q3__c, BN_Survey_Q4__c, BN_Survey_Q5__c, Is_Survey_Answered__c  from Lead where id =: recId limit 1];
            StdObject = 'Lead';
            Name = lead.Name;
            Email = lead.Email;
            Phone = lead.Phone;
            IsAnswered = lead.Is_Survey_Answered__c;
            etAdmin = [Select Id, Name from EmailTemplate where name = 'Survey Response Admin - Lead' limit 1]; //email template for response admin
        }
        else if (prefix == '003') {
            con = [Select Id, Name, FirstName, LastName, Email, Phone, IsPersonAccount, IP_Address__c, BN_Survey_Q1__c, BN_Survey_Q2__c, BN_Survey_Q3__c, BN_Survey_Q4__c, BN_Survey_Q5__c, Is_Survey_Answered__c  from Contact where id =: recId limit 1];
            StdObject = 'Contact';
            Name = con.Name;
            Email = con.Email;
            Phone = con.Phone;
            IsAnswered = con.Is_Survey_Answered__c;
            etAdmin = [Select Id, Name from EmailTemplate where name = 'Survey Response Admin - Contact' limit 1]; //email template for response admin
        }
        else if (prefix == '006') {
            opp = [Select Id, Primary_Contact__c, Primary_Contact__r.Name, Primary_Contact__r.FirstName, Primary_Contact__r.LastName, Primary_Contact__r.Email, Primary_Contact__r.Phone, LeadSource, BN_Survey_Q1__c, BN_Survey_Q2__c, BN_Survey_Q3__c, BN_Survey_Q4__c, BN_Survey_Q5__c, Is_Survey_Answered__c  from Opportunity where id =: recId limit 1];
            StdObject = 'Opportunity';
            Name = opp.Primary_Contact__r.Name;
            Email = opp.Primary_Contact__r.Email;
            Phone = opp.Primary_Contact__r.Phone;
            IsAnswered = opp.Is_Survey_Answered__c;
            etAdmin = [Select Id, Name from EmailTemplate where name = 'Survey Response Admin - Opportunity' limit 1]; //email template for response admin
        }
        
        etClient = [Select Id, Name from EmailTemplate where name = 'Survey Response Client' limit 1]; //email template for response client
        
        BN_Q1 = '';
        BN_Q2 = '';
        BN_Q3 = 0;
        BN_Q4 = '';
        BN_Q5 = '';
    }
    
    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('Yes', 'Yes'));
        options.add(new selectOption('No', 'No'));
        return options;
    }

    public PageReference SaveForm() 
    {
        if(StdObject == 'Lead')
        {
            lead.BN_Survey_Q1__c = BN_Q1;
            lead.BN_Survey_Q2__c = BN_Q2;
            lead.BN_Survey_Q3__c = BN_Q3;
            lead.BN_Survey_Q4__c = BN_Q4;
            lead.BN_Survey_Q5__c = BN_Q5;
            lead.Is_Survey_Answered__c = true;
            lead.IP_Address__c = GetUserIPAddress();
            update lead;
            
            System.Debug('Lead==='+lead);
        }
        else if(StdObject == 'Contact')
        {
            con.BN_Survey_Q1__c = BN_Q1;
            con.BN_Survey_Q2__c = BN_Q2;
            con.BN_Survey_Q3__c = BN_Q3;
            con.BN_Survey_Q4__c = BN_Q4;
            con.BN_Survey_Q5__c = BN_Q5;
            con.Is_Survey_Answered__c = true;
            con.IP_Address__c = GetUserIPAddress();
            update con;
            
            System.Debug('Contact==='+con);
        }
        else if(StdObject == 'Opportunity')
        {
            opp.BN_Survey_Q1__c = BN_Q1;
            opp.BN_Survey_Q2__c = BN_Q2;
            opp.BN_Survey_Q3__c = BN_Q3;
            opp.BN_Survey_Q4__c = BN_Q4;
            opp.BN_Survey_Q5__c = BN_Q5;
            opp.Is_Survey_Answered__c = true;
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
            //mail.setWhatId(lead.Id);
            mail.setSaveAsActivity(true);
        }
        else if (StdObject == 'Contact') {
            mail.setTargetObjectId(con.Id);
            //mail.setWhatId(con.Id);
            mail.setSaveAsActivity(true);
        }
        else if (StdObject == 'Opportunity') {
            mail.setTargetObjectId(opp.Primary_Contact__c);
            mail.setWhatId(opp.Id);
            mail.setSaveAsActivity(true);
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
        return ReturnValue;
    }
}