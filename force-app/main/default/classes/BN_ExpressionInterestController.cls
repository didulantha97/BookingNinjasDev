public with sharing class BN_ExpressionInterestController {
    
    public Account account {get; set;}
    public Contact contact {get; set;}
    public Opportunity opportunity {get; set;}
    
    public String name {get; set;}
    public String email {get; set;}
    public String propertyName {get; set;}
    public String numberOfRooms {get; set;}
    public String pmsText {get; set;}
    public Date targetDateOfActivation {get; set;}
    
    public BN_ExpressionInterestController() {
        name = '';
        email = '';
        propertyName = '';
        numberOfRooms = '';
        pmsText = '';
        targetDateOfActivation= Date.Today();
    }
    
    public PageReference register() 
    {
        // validates record
        if(getContactByEmail(email).size() > 0)
        {
            // fetch contact
            contact = getContactByEmail(email)[0];
        }
        else 
        {
            account = new Account();
            account.Name = propertyName;
            insert account;
            
            contact = new Contact();
            contact.AccountId = account.Id;
            contact.LastName = name;
            contact.Email = email;
            insert contact;
        }
        
        // insert new opp
        opportunity = new Opportunity();
        opportunity.Name = 'New Opportunity: ' +  name;
        opportunity.AccountId = contact.AccountId;
        opportunity.Primary_Contact__c = contact.Id;
        opportunity.Type = 'New Business';
        opportunity.StageName = 'Top Opps';
        opportunity.LeadSource = 'Booking Ninjas';
        opportunity.CloseDate = targetDateOfActivation;
        opportunity.PMS_Text__c = pmsText;
        insert opportunity;
        
        // send email notification
        sendEmail(email);
        
        // redirect to thank you  page
        PageReference pageRef = new PageReference('/thank-you-for-expressing-your-interest');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private List<Contact> getContactByEmail(String email) {
        return [SELECT Id, FirstName, LastName, Email, Phone, AccountId, Account.Name FROM Contact WHERE Email = :email];
    }
    
    private void sendEmail(String email)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.setccAddresses(new String[] { 'david@bookingninjas.com' });
        message.optOutPolicy = 'FILTER';
        message.subject = 'Thank you for expressing your interest to implement Booking Ninjas PMS!';
        message.setHtmlBody('Thank you for expressing your interest to implement Booking Ninjas Property Management System to your property! <br/> We look forward to hearing from you and taking care of all your PMS needs. <br/> To expedite the process, feel free to give us a call during business hours Monday-Friday at (917)-600-2345. <br/> We look forward to working with you! <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}