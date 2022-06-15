public class CallMeetingReminderDataService {

    public EmailTemplate getEmailTemplate(String templateName){
        List<EmailTemplate> templates = new List<EmailTemplate>();
        templates.addAll([Select Id From EmailTemplate Where Name = :templateName]);
        return templates.isEmpty() ? new EmailTemplate() : templates.get(0);
    }

    public OrgWideEmailAddress getOrgWideEmailAddress(String address){
        List<OrgWideEmailAddress> templates = new List<OrgWideEmailAddress>();
        if(OrgWideEmailAddress.SObjectType.getDescribe().isAccessible()){
           templates.addAll([Select Id from OrgWideEmailAddress where Address =: address]);
        }
        return templates.isEmpty() ? new OrgWideEmailAddress() : templates.get(0);
    }    
    
    public void sendEmails(List<Messaging.SingleEmailMessage> emailList){
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList, false);         
    }
}