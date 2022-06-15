/*********************************
 * Date					Who 			Description
 * Mar 20, 2021		Hung Huynh			Create a trigger to send email to admin email
 * *******************************/
trigger EmailSubscriptionTrigger on Email_Subscription__c (after insert) {
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            OrgWideEmailAddress orgAddress = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply@bookingninjas.com' LIMIT 1];
            String[] toAddresses = new String[] {'drago@bookingninjas.com','joshua@bookingninjas.com','oliver@bookingninjas.com','david@bookingninjas.com','marketingteam@bookingninjas.com'};
            for(Email_Subscription__c email : Trigger.New){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddresses);
                mail.setSubject('New BN Email Sub');
                mail.setHtmlBody('<p>Congrats, a new sub just signed up on bookingninjas.com for future notifications.</p>' + 
                                 '<p>Email: ' + email.Email__c + '</p>' +
                                 '<p>Created date: ' + email.CreatedDate + '</p>' +
                                 '<p>Please check - <a href="https://bookingninjas.my.salesforce.com/lightning/r/Email_Subscription__c/' + email.Id + '/view">view email subscription</a></p>' +
                                 '<p>for more details</p>' +
                                 '<p>Thanks,</p>' +
                                 '<p>BN Team</p>');
                mail.setOrgWideEmailAddressId(orgAddress.Id);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
}