public with sharing class BN_EinsteinFormController {
    
    public Lead lead {get;  set;}
    
    public String name {get; set;}
    public String title {get; set;}
    public String company {get; set;}
    public String email {get;  set;}
    public String phone {get; set;}
    public String preferredDateTime {get; set;}
    
    public String QA1 {get; set;}
    public String QA2 {get; set;}
    public String QA2_1 {get; set;}
    public String QA3 {get; set;}
    public String QA3_1 {get; set;}
    public String QA4 {get; set;}
    public String QA5 {get; set;}
    
    public BN_EinsteinFormController() {
        name = '';
        title = '';
        company = '';
        email = '';
        phone = '';
        preferredDateTime = '';
        QA1 = '';
        QA2 = '';
        QA2_1 = '';
        QA3 = '';
        QA3_1 = '';
        QA4 = '';
        QA5 = '';
    }
    
    public PageReference save() 
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
            lead.Title = title;
            lead.Company = company;
            lead.Email = email;
            lead.Phone = phone;
            insert lead;
        }
        
        // send email notification
        sendEmail(lead, QA1, QA2, QA2_1, QA3, QA3_1, QA4, QA5);
    
        // redirect to thank you  page
        PageReference pageRef = new PageReference('/thank-you');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private List<Lead> getLeadByEmail(String email) {
        return [SELECT Id, FirstName, LastName, Email, Phone, Company, Title FROM Lead WHERE Email = :email];
    }
    
    private void sendEmail(Lead leadInfo, String A1, String A2, String A2_1, String A3, String A3_1, String A4, String A5)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'david@bookingninjas.com' };
        message.optOutPolicy = 'FILTER';
        message.subject = 'You have new Einstein AI Inquiry!';
        message.setHtmlBody('Greetings! <br/><br/>I would like to inquire about Booking Ninjas Einstein AI. <br/><br/> See information below: <br/><br/> Name: <b>' + name + '</b><br/><br/> Title: <b>' + title + '</b><br/><br/> Company: <b>' + company + '</b><br/><br/> Email: <b>' + email + '</b><br/><br/> Phone: <b>' + phone + '</b><br/><br/> Preferred meeting date/time: <b>' + preferredDateTime + '</b><br/><br/><br/>' + 
                                'Q1. How do you think AI will help you and your company to grow? <br/> A1: <b>' + A1 + '</b><br/><br/>' + 
                                'Q2. How and when did you first hear of Einstein AI? <br/> A2: <b>' + A2 + '</b><br/><br/>' + 
                                'Q3. Have you experienced AI in any other situations? <br/> A3: <b>' + A3 + '</b><br/><br/>' + 
                                'Q4. What is the current system you are using? <br/> A4: <b>' + A4 + '</b><br/><br/>' + 
                                'Q5. Last but not least, do you trust the fact that AI will be the next big revolution? <br/> A5: <b>' + A5 + '</b>');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}