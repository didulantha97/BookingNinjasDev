/**
 * This is the controller for the dynamic mass email
 **/

global with sharing class DynamicMassEmail {
    webservice static string CreateDynamicMassEmail(Id objectId, String campaignID, String EmailTemplateName) {
        //get the email template that is already created to send emails.
        EmailTemplate et = [Select Id, Name, Subject, Body from EmailTemplate where name = :EmailTemplateName];
        List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
                        
        //Fetch all the contact and lead IDs from the campaign. Campiagn ID is being passed to this method.
        for (CampaignMember cm : [Select Id, ContactId, Contact.Email, Contact.HasOptedOutOfEmail, Contact.EmailBouncedDate, LeadID, Lead.Email, Lead.HasOptedOutOfEmail, Lead.EmailBouncedDate from CampaignMember where campaignID = :campaignID]) {
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); // new mail object

            if (cm.ContactId == null && cm.LeadId != null) {
                if (cm.Lead.Email != null) {
                    if (cm.Lead.HasOptedOutOfEmail == false && cm.Lead.EmailBouncedDate == null) {
                        mail.setTargetObjectId(cm.LeadID);
                        mail.setTemplateId(et.id);
                        mail.setWhatId(objectId);
                        mail.setsaveAsActivity(false);
                        mail.setSenderDisplayName('David Harroch - Booking Ninjas');
                        mailsToSend.add(mail);
                    }
                }
            }
            else if (cm.LeadId == null && cm.ContactId != null) {
                if (cm.Contact.Email != null) {
                    if (cm.Contact.HasOptedOutOfEmail == false && cm.Contact.EmailBouncedDate == null) {
                        mail.setTargetObjectId(cm.ContactId);
                        mail.setTemplateId(et.id);
                        mail.setWhatId(objectId);
                        mail.setsaveAsActivity(true);
                        mail.setSenderDisplayName('David Harroch - Booking Ninjas');
                        mailsToSend.add(mail);
                    }
                }
            }
        }
        
        try {
            Messaging.sendEmail(mailsToSend);  //send email
            return 'Successfully sent email!';
        } catch (EmailException e) {
            return 'The following exception has occurred: ' + e.getMessage();
        }
    }
}