public class CallMeetingReminderService {
    private CallMeetingReminderDataService dataService = new CallMeetingReminderDataService();
    public static final String CONFIRMATION_TEMPLATE_NAME = 'Follow up call meeting 1 hour';
    public static final String ORG_WIDE_ADDRESS = 'noreply@bookingninjas.com';
   
    public void process(List<Event> eventList, Integer HOUR_PARAM, Integer MINUTE_PARAM){
        Set<Id> eventIds = new Set<Id>();
        for(Event event : eventList){
            eventIds.add(event.Id);
        }

        EmailTemplate emailTemplate = dataService.getEmailTemplate(CONFIRMATION_TEMPLATE_NAME);
        System.debug(LoggingLevel.Info ,'emailTemplate = ' + emailTemplate);  
        OrgWideEmailAddress orgAddress = dataService.getOrgWideEmailAddress(ORG_WIDE_ADDRESS);
        System.debug(LoggingLevel.Info ,'OrgwideAddress = ' + orgAddress);

        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(Event event : eventList){
            if(event.StartDateTime.Hour() == HOUR_PARAM && event.StartDateTime.Minute() == MINUTE_PARAM) {
                Messaging.SingleEmailMessage email = getEmailMessage(event, emailTemplate, orgAddress);
                emailList.add(email);
            }
        }
        System.debug(LoggingLevel.Info ,'emailList = ' + emailList);
        
        if(emailList.size() > 0) {
            dataService.sendEmails(emailList);
        }     
    }
    
    private Messaging.SingleEmailMessage getEmailMessage(Event event, EmailTemplate emailTemplate, OrgWideEmailAddress orgAddress){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTargetObjectId(event.WhoId);
        email.setCcAddresses(new String[] { 'david@bookingninjas.com' }); 
        email.setTemplateId(emailTemplate.Id);
        email.setOrgWideEmailAddressId(orgAddress.Id);
        return email;      
    }
}