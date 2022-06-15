public    class FeedbackController {

    String recId;
    public Contact con {get; set;}
    
    public Decimal FeedBack1 {get; set;}
    public String FeedBack2 {get; set;}
    public String FeedBack3 {get; set;}
    public String FeedBack4 {get; set;}
    public String FeedBack5 {get; set;}
    public String FeedBack6 {get; set;}
    public Boolean IsAnswered {get; set;}
    
    public EmailTemplate etClient {get; set;}
    public EmailTemplate etAdmin {get; set;}
    
    public FeedbackController(ApexPages.StandardController stdController) {    
        
        recId = ApexPages.currentPage().getParameters().get('id');
        
        con = [Select Id, Name, Email, LeadSource, Phone, Is_Feedback_Answered__c, 
                Current_PMS_Suppliers_Grade__c,
                X1_or_2_things_that_can_be_better__c,
                Key_take_aways_from_the_call__c,
                Is_system_change_part_of_your_3_prio__c,
                Biggest_concerns_about_implementation__c,
                Anything_that_didn_t_meet_expectations__c 
              from Contact Where Id =: recId];
        
        FeedBack1 = 0;
        FeedBack2 = '';
        FeedBack3 = '';
        FeedBack4 = '';
        FeedBack5 = '';
        FeedBack6 = '';
        
        IsAnswered = con.Is_Feedback_Answered__c;
        
        etClient = [Select Id, Name from EmailTemplate where name = 'Feedback Response Client' limit 1];
        etAdmin = [Select Id, Name from EmailTemplate where name = 'Feedback Response Admin' limit 1];
    }
    
    public Contact getContact()
    {
        return con;
    }
    
    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('', '--None--'));
        options.add(new selectOption('Yes', 'Yes'));
        options.add(new selectOption('No', 'No'));
        return options;
    }
    
    public PageReference SaveForm() 
    {
        con.Current_PMS_Suppliers_Grade__c = Feedback1;
        con.X1_or_2_things_that_can_be_better__c = Feedback2;
        con.Key_take_aways_from_the_call__c = Feedback3;
        con.Is_system_change_part_of_your_3_prio__c = Feedback4;
        con.Biggest_concerns_about_implementation__c = Feedback5;
        con.Anything_that_didn_t_meet_expectations__c = Feedback6;
        con.Is_Feedback_Answered__c = true;
          
        update con;
        
        SendEmailToAdmin();
        SendEmailToClient();
        
        PageReference p = new Pagereference('/apex/Response');
        p.setRedirect(true);
        return p;
    }
    
    public void SendEmailToAdmin()
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new string[]{ 'david@bookingninjas.com' });
        mail.setTargetObjectId(con.Id);
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setTemplateId(etAdmin.Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public void SendEmailToClient()
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setTargetObjectId(con.Id);
        //mail.setWhatId(con.Id);
        mail.setSaveAsActivity(true);
        mail.setTemplateId(etClient.Id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}