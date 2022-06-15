public with sharing class BNConsultationController {
    
    public Lead lead { get; set; }
    public String name { get; set; }
    public String company { get; set; }
    public String phone { get; set; }
    public String email { get; set; }
    public String numberOfRooms { get; set; }
    public String currentPMS { get; set; }
    public String message { get; set; }
    public String selectedDate { get; set; }
    public Boolean isSuccess { get; set; }
    public Boolean isFailed { get; set; }
    public String responseMessage { get; set; }
    
    public BNConsultationController() {
        
        name = '';
        company = '';
        phone = '';
        email = '';
        numberofRooms = '';
        currentPMS = '';
        message = '';
        selectedDate = '';
        isSuccess = false;
        isFailed = false;
        responseMessage = '';
        
    }
    
    public PageReference SaveWithRedirect() {

        if(!checkExistingLeadByEmail(email)) {
            String[] names = name.split(' '); // trim name
            
            // insert new lead
            lead = new Lead();
            lead.FirstName = names[0];
            lead.LastName = names[1];
            lead.Phone = phone;
            lead.Company = company;
            lead.Email = email;
            //insert lead;
            
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true;
            Database.SaveResult sr = Database.insert(lead, dml);
            
            System.Debug('Insert lead here: ' + lead);
        }
        else {
            lead = [SELECT Id FROM Lead WHERE Email = :email LIMIT 1];
            
            System.Debug('Get existing lead here: ' + lead);
        }
        
        System.Debug('Initialize send email');
        
        // send email to admin
        sendEmail('david@bookingninjas.com', name, company, phone, email, currentPMS, numberOfRooms, selectedDate, message, lead.Id);
        
        System.Debug('Successfully sent email');
        
        // check page name
        String pageName = ApexPages.currentPage().getParameters().get('currentvfpage');
        String redirectpageName = pageName == 'BNConsultation' ? '/BNConsultation/BNSuccess' : '/BNConsult/BNThankYou';
        
        System.Debug('Redirect Page Name: ' + redirectpageName);
        
        // redirects to page
        PageReference retURL = new PageReference(redirectpageName);
        retURL.setRedirect(true);
        return retURL;
    }
    
    public void SaveWithoutRedirect() {

        if(!checkExistingLeadByEmail(email)) {
            String[] names = name.split(' '); // trim name
            
            // insert new lead
            lead = new Lead();
            lead.FirstName = names[0];
            lead.LastName = names[1];
            lead.Phone = phone;
            lead.Company = company;
            lead.Email = email;
            //insert lead;
            
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true;
            Database.SaveResult sr = Database.insert(lead, dml);
        }
        else {
            lead = [SELECT Id FROM Lead WHERE Email = :email LIMIT 1];
        }
        
        // send email to admin
        sendEmail('david@bookingninjas.com', name, company, phone, email, currentPMS, numberOfRooms, selectedDate, message, lead.Id);
        
        isSuccess = true;
        isFailed = false;
        responseMessage = 'Thank you for your interest!';
    }
    
    private boolean checkExistingLeadByEmail(String email) {
        List<Lead> leads = [SELECT Id, Email FROM Lead WHERE Email = :email];
        return leads.size() > 0 ? true : false;
    }
    
    private void sendEmail(String recipient, String name, String company, String phone, String email, String pms, String rooms, String selectedDate, String message, String leadId)
    {
        OrgWideEmailAddress orgAddress = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply@bookingninjas.com' LIMIT 1];
         
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{ recipient });
        mail.setSubject('Booking Ninjas Inquiry - ' + name);
        mail.setHTMLBody('Hi David. <br/><br/> I would like to inquire about Booking Ninjas. <br/><br/> See information below: <br/><br/> Name: ' + name + ' <br/> Phone: ' + phone + ' <br/> Email: ' + email + ' <br/> Company: ' + company + ' <br/> Number of rooms: ' + rooms + ' <br/> Current PMS: ' + pms + ' <br/> Preferred Date and Time (EST): ' + selectedDate + ' <br/> Message: ' + message + ' <br/><br/> Please see generated lead record <a href=\'https://bookingninjas.my.salesforce.com/' + leadId + '\'>here</a>.<br/><br/> ');
        mail.setOrgWideEmailAddressId(orgAddress.Id);
        Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    
    public void Subscribe()
    {
        string recipient = 'david@bookingninjas.com';
        
        OrgWideEmailAddress orgAddress = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply@bookingninjas.com' LIMIT 1];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //mail.setReplyTo(email);
        mail.setToAddresses(new String[]{ recipient });
        mail.setSubject('I would like to subscribe on Booking Ninjas Newsletter!');
        mail.setHTMLBody('Hi David. <br/><br/> I would like to subscribe on Booking Ninjas Newsletter! <br/><br/> Email: ' + email);
        mail.setOrgWideEmailAddressId(orgAddress.Id);
        Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        
        isSuccess = true;
        isFailed = false;
        responseMessage = 'Thank you for your interest!';
    }
}