public with sharing class BN_Portal_ForgotPassword_Controller {
    
    public String emailRequest {get;set;}
    public String newPassword {get;set;}
    public String bnUserId;
    
    public Email_Subscription__c subscription {get; set;} 
    public String email {get; set;}
    
    public BN_Portal_ForgotPassword_Controller() {
        
        bnUserId = ApexPages.currentPage().getParameters().get('id');
        System.Debug('bnUserId: '  + bnUserId);
        
        if (String.isNotEmpty(bnUserId)) {
            List<BN_User__c> bnUser = [  SELECT Id 
                        FROM BN_User__c 
                        WHERE Id = :bnUserId 
                          AND Status__c = 'Request Change Password'];
        }
        
        emailRequest = '';
        email = '';
    }
    
    public void requestChangePassword() {
        if (String.isNotEmpty(emailRequest)) {
          List<BN_User__c> bnUser = [  SELECT Id, Email__c 
                        FROM BN_User__c 
                        WHERE Email__c = :emailRequest 
                          AND Status__c <> 'Inactive'
                          AND Status__c <> 'Locked'];
        if (bnUser.size() > 0) {
            bnUser[0].Status__c = 'Request Change Password';
            update bnUser[0];
            
            // send email
            sendEmail(bnUser[0].Email__c, bnUser[0].Id);
        
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.BN_User_Pass_Email));
        }
        else 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.BN_Email_No_Exist));
        }
    }
    
    public void submitNewPassword() {
        if (String.isNotEmpty(newPassword) && String.isNotEmpty(bnUserId)) {
            Boolean hasError = false;
            BN_User__c bnUser = new BN_User__c(Id = bnUserId, Password__c = newPassword, Status__c = 'Active');
            try {
                update bnUser;
            } catch (Exception e) {
                hasError = true;
                System.debug('submitNewPassword Exception: '  + e);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, e.getMessage()));
            }
            
            if (!hasError) 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.BN_User_Login));      
        }
    }
    
    public void subscribe() 
    {
        if(!checkExistingEmail(email))
        {
            subscription = new Email_Subscription__c();
            subscription.Email__c =  email;
            insert subscription;
        }
        
        email = '';
    }
    
    private boolean checkExistingEmail(string email)
    {
        List<Email_Subscription__c> emails = [SELECT Id, Email__c FROM Email_Subscription__c WHERE Email__c = :email];
        return emails.size() > 0 ? true : false;
    }
    
    private void sendEmail(String email, String userId)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.optOutPolicy = 'FILTER';
        message.subject = 'Booking Ninjas Portal Request Password Change';
        message.setHtmlBody('This email is to confirm your request to change your password. Please click <a href="https://www.bookingninjas.com/reset-password?id=' + userId + '">here</a> to change your password. <br/> If your haven\'t requested this email, please disregard. <br/> We look forward to working with you! <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}