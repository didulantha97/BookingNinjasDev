/*****************************************************************************************
 * @Purpose      :  Scheduler batch to extract Contact records which are flagged to be updated from
 * 					FullContact, fetch and update them, and send a status report to given email ids
 * 					in the custom metadata
 * @Created Date :  30 April 2018
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/
global class FullContactScheduler implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts, Database.Stateful {

    String csvBody = '';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Name, FirstName, LastName, Email, MobilePhone FROM Contact WHERE Sync_with_FullContact__c = true');
    }
    
    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        List<Contact> cList = (List<Contact>) scope;
        List<PersonResponse> updateList = new List<PersonResponse>();
        
        for(Contact c : cList) {
            String strStatus = FullContactService.updateContact(c.Id);
            csvBody += c.Id + ',' + c.Name + ',' + strStatus + '\n';
        }
                
    }
    
    global void finish(Database.BatchableContext BC) {
        List<String> recipients = new List<String>();
        recipients.add('david@bookingninjas.com');	//	add default recipients
        
        //	retrieve any recipient email ids configured.
        List<FullContact_Login__mdt> mdtRecipients = [SELECT Recipients__c FROM FullContact_Login__mdt WHERE MasterLabel = 'Primary'];
        if(!mdtRecipients.isEmpty()) {
            String strRecipients = mdtRecipients.get(0).Recipients__c;
            if(String.isNotBlank(strRecipients)) {
                recipients = strRecipients.split(',');
            }
        }
        String finalCSV = 'Contact Id, Contact Name, Update Status \n';
        finalCSV += csvBody;
        
        //	Creating attachment
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalCSV);
        string csvname= 'FullContact Schedule' + Date.today().format() + '.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        
        //	Creating email
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        //String[] toAddresses = new list<string> {'madhurapriyadarshana@gmail.com', 'david@bookingninjas.com'};
        String subject ='FullContact Schedule status | ' + Date.today().format();
        email.setSubject(subject);
        email.setToAddresses( recipients );
        email.setPlainTextBody('Status of Contact update via FullContact web service for the date : ' + Date.today().format());
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
    }
    
    //	Scheduler execute
    global void execute(SchedulableContext SC) {
        String batchId = Database.executeBatch(this, 50);	// MAX SIZE CANNOT GO BEYOND 100 DUE TO QUERY INSIDE LOOP
        System.debug('batch Id : ' + batchId);
    }
    
}