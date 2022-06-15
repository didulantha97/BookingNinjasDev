public class ScheduleCallBatchService {

    public static final String ORG_WIDE_ADDRESS = 'noreply@bookingninjas.com';
   
    public void process(List<Cook_Book__c> cbList) {
        Set<Id> cbIds = new Set<Id>();
        for(Cook_Book__c cb : cbList){
            cbIds.add(cb.Id);
        }
        
        OrgWideEmailAddress orgAddress = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :ORG_WIDE_ADDRESS LIMIT 1];
            
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        for(Cook_Book__c cb : cbList){
        
            String ae_email = [SELECT Email__c FROM Account_Executive__c WHERE Id = :cb.Account_Executive__c].Email__c;
            String contact_name = [SELECT Name FROM Contact WHERE Id = :cb.Contact__c].Name;
            string formattedTime = cb.Scheduled_Time__c.Hour() + ':' + cb.Scheduled_Time__c.Minute();
            
            Messaging.SingleEmailMessage email = getEmailMessage(contact_name, ae_email, formattedTime, orgAddress);
            emailList.add(email);
        }
        
        if(emailList.size() > 0) {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList, false);
        } 
    }
    
    private Messaging.SingleEmailMessage getEmailMessage(String name, String recipient, String formattedTime, OrgWideEmailAddress orgAddress){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{ recipient });
        email.setSubject('Call Assigned | Follow up');
        email.setHTMLBody('Upcoming scheduled call with ' + name + ' today at ' + formattedTime + '!<br/><br/>Lets change the world one account at a time!!!');
        email.setOrgWideEmailAddressId(orgAddress.Id);
        
        return email;      
    }
}