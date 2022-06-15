public class BN_Portal_Users_Controller extends BN_Portal_Template_Controller {
    
    public Contact contact {get; set;}
    
    public List<User__c> users {get; set;}
    
    public User__c user {get; set;}
    public String name {get; set;}
    public String email {get; set;}
    public String phone {get; set;}
    public Date dateOfActivation {get; set;}
    
    public BN_Portal_Users_Controller() {
    
        String bnUserId = BN_Portal_UserUtils.getCurrBNUserId();
        
        contact = BN_Portal_UserUtils.getContactByBNUserId(bnUserId);
        
        users = getUsersByContactId(contact.Id);
        
        name = '';
        email = '';
        phone = '';
        dateOfActivation = Date.Today();
    }
    
    private List<User__c> getUsersByContactId(String conId)
    {
        return [SELECT Id, Name, Name__c, Email__c, Phone__c, Date_of_Activation__c FROM User__c WHERE Contact__c = :conId ORDER BY CreatedDate DESC];
    }
    
    public PageReference addUserRequest()
    {
        try {
            user = new User__c();
            user.Name__c = name;
            user.Email__c = email;
            user.Phone__c = phone;
            user.Date_of_Activation__c = dateOfActivation;
            user.Contact__c = contact.Id;
            insert user;
            
            // send email
            sendEmailNotif(user.Id);
            
            PageReference pageRef = new PageReference('/portal/users');
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
            return null;
        }
    }
    
    private void sendEmailNotif(String id)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'david@bookingninjas.com' };
        message.optOutPolicy = 'FILTER';
        message.subject = 'You have new client\'s user request';
        message.setHtmlBody('See record <a href="https://bookingninjas.my.salesforce.com/' + id + '">here</a>. <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}