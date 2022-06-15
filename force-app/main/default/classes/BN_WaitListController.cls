public with sharing class BN_WaitListController {
    
    public Wait_list__c waitList {get;  set;}
    public Contact contact {get; set;}
    public Opportunity opportunity {get; set;}
    
    public Id waitListId {get; set;}

    public String name {get; set;}
    public String email {get; set;}
    public String phone {get; set;}
    public String preferredMethod {get; set;}
    public Date availabilityDate {get; set;}
    public boolean optforSMS {get; set;}
    
    public BN_WaitListController() {
    
        name = '';
        email = '';
        phone  =  '';
        preferredMethod = '';
        availabilityDate = Date.Today();
        optforSMS = false;
    }
    
    public BN_WaitListController(ApexPages.StandardController controller) 
    {
        waitListId = (Id)controller.getRecord().get('id');
        waitList = getWaitListRecord(waitListId);
    }
    
    public PageReference register() 
    {
        // create new waitlist record
        waitList = new Wait_List__c();
        waitList.Name__c = name;
        waitList.Email__c = email;
        waitList.Phone__c = phone;
        waitList.Preferred_Contact_Method__c = preferredMethod;
        waitList.Opt_in_to_SMS_System__c = optforSMS;
        waitList.Availability_Date__c = availabilityDate;
        insert waitList;
        
        // send email notification
        sendEmail(email);
        
        // redirect to thank you  page
        PageReference pageRef = new PageReference('/thank-you-for-expressing-your-interest');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private void sendEmail(String email)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.setccAddresses(new String[] { 'david@bookingninjas.com' });
        message.optOutPolicy = 'FILTER';
        message.subject = 'Thank you for expressing your interest to implement Booking Ninjas PMS!';
        message.setHtmlBody('Thank you for expressing your interest to implement Booking Ninjas Property Management System to your property! <br/> Currently, we are in the midst of helping other customers. In the meantime, join our waitlist to be on the way to receiving your digital transformation! We will notify you as soon as our next onboarding team becomes available. <br/> We look forward to hearing from you and taking care of all your PMS needs. <br/> To expedite the process, feel free to give us a call during business hours Monday-Friday at (917)-600-2345. <br/> We look forward to working with you! <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
    
    public List<SelectOption> getPreferredContactMethod()
    {
        List<SelectOption> methodList = new List<SelectOption>();
        methodList.add(new SelectOption('Phone and Email', 'Phone and Email'));
        methodList.add(new SelectOption('Phone Only', 'Phone Only'));
        methodList.add(new SelectOption('Email Only', 'Email Only'));
        return methodList;
    }
    
    public PageReference convertToOpp()
    {
         // validates record
        if(getContactByEmail(waitList.Email__c).size() > 0)
        {
            // fetch contact
            contact = getContactByEmail(waitList.Email__c)[0];
        }
        else 
        {
            Account account = new Account();
            account.Name = 'Wait List - ' + waitList.Name__c;
            insert account;
            
            contact = new Contact();
            contact.LastName = waitList.Name__c;
            contact.Email = waitList.Email__c;
            contact.Phone = waitList.Phone__c;
            contact.AccountId = account.Id;
            insert contact;
        }
        
        // insert new opp
        opportunity = new Opportunity();
        opportunity.Name = 'New Opportunity: ' +  contact.LastName;
        opportunity.AccountId = contact.AccountId;
        opportunity.Primary_Contact__c = contact.Id;
        opportunity.Type = 'New Business';
        opportunity.StageName = 'Top Opps';
        opportunity.LeadSource = 'Booking Ninjas';
        opportunity.CloseDate = Date.Today().addDays(14);
        insert opportunity;
        
        // redirect to new contact
        PageReference pageRef = new PageReference('/' + opportunity.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private Wait_List__c getWaitListRecord(Id id)
    {
        return  [SELECT Id, Name, Name__c, Email__c, Phone__c, Preferred_Contact_Method__c, Opt_in_to_SMS_System__c, Availability_Date__c FROM Wait_List__c WHERE Id = :id LIMIT 1];
    }
    
    private List<Contact> getContactByEmail(String email) {
        return [SELECT Id, FirstName, LastName, Email, Phone, AccountId, Account.Name FROM Contact WHERE Email = :email LIMIT 1];
    }
}