public with sharing class ScheduleCallLWCController {
    
    @AuraEnabled
    public static CookBookWrapper scheduleCallAndCreateCB(String cbRecordJSON) {
        CookBookWrapper cookBookWrapper = (CookBookWrapper) JSON.deserialize(cbRecordJSON, CookBookWrapper.class);
        List<Contact> contacts = new List<Contact>();
        Set<String> objectIds = new Set<String>();
        String responseMessage = '';
        Boolean isSuccess = false;
        
        if(cookBookWrapper.scheduledDate != null && cookBookWrapper.userId != null){
            // instantiate CB list for saving
            List<Cook_Book__c> cookBooks = new List<Cook_Book__c>();
            Id recordId = cookBookWrapper.recordId;
            String sobjectType = recordId.getSObjectType().getDescribe().getName();
            Cook_Book__c cb = new Cook_Book__c();

            Account account;
            Contact contact;
            if(sobjectType == 'Account'){
                account = [SELECT Id, Linkedin_Company_URL__c, Name, Phone, Phone_2__c, PersonEmail, Email_1__c, Website FROM Account WHERE Id = :recordId LIMIT 1];
                cb.Name = account.Name + ' - Appointments ' + String.valueOf(cookBookWrapper.scheduledDate);
                cb.Phone__c = account.Phone;
                cb.X2nd_Phone__c = account.Phone_2__c;
                cb.AccountLookup__c = account.Id;
            }
            else if(sobjectType == 'Contact'){
                contact = [SELECT Id, Name, AccountId, Account.Name, Account.Website, Email, LinkedIN__c, MobilePhone, Phone, X2nd_Phone_Number__c FROM Contact WHERE Id = :recordId LIMIT 1];
                cb.Name = contact.Name + ' - Appointments ' + String.valueOf(cookBookWrapper.scheduledDate);
                cb.Contact__c = contact.Id;
                cb.AccountLookup__c = contact.AccountId != null ? contact.AccountId : null;
                cb.Mobile__c = contact.MobilePhone;
                cb.Phone__c = contact.Phone;
                cb.X2nd_Phone__c = contact.X2nd_Phone_Number__c;
            }
            cb.Account_Executive__c = cookBookWrapper.userId;
            cb.Scheduled_Date__c = cookBookWrapper.scheduledDate;            
            cb.Type__c = 'Calls';
            cb.Call_Result__c = 'Appointments';
            cb.Notes__c = cookBookWrapper.notes;
            cb.Interest_Level__c = cookBookWrapper.interestLevel;
            cookBooks.add(cb);
            
            try{
                if(cookBooks.size() > 0){                    
                    insert cookBooks;
                    
                    Account_Executive__c ae = [
                        SELECT Id, Name, Email__c
                        FROM Account_Executive__c
                        WHERE Id = :cookBooks[0].Account_Executive__c
                    ];

                    String targetName = sobjectType.equals('Contact') ? contact.Name : account.Name;
                    String targetEmail = sobjectType.equals('Contact') ? contact.Email : account.PersonEmail != null ? account.PersonEmail : account.Email_1__c;
                    String targetLinkedIn = sobjectType.equals('Contact') ? contact.LinkedIN__c : account.Linkedin_Company_URL__c;
                    String accountId = sobjectType.equals('Contact') ? contact.AccountId : account.Id;
                    String accountName = sobjectType.equals('Contact') ? contact.Account.Name : account.Name;
                    String websiteUrl = sobjectType.equals('Contact') ? contact.Account.Website : account.Website;
                    Map<String, Object> emailData = new Map<String, Object>{
                        'scheduleDate' => cookBooks[0].Scheduled_Date__c,
                        'recepientEmail' => ae.Email__c,
                        'recepientId' => cookBooks[0].Account_Executive__c,
                        'targetName' => targetName,
                        'targetEmail' => targetEmail,
                        'targetAccountId' => accountId,
                        'targetContactId' => contact != null ? contact.Id : null,
                        'targetAccountName' => accountName,
                        'targetLinkedIn' => targetLinkedIn,
                        'targetUrl' => websiteUrl,
                        'cookBookId' => cookBooks[0].Id,
                        'cookBookSize' => cookBooks.size(),
                        'cookBookNotes' => cookBooks[0].Notes__c,
                        'cookBookInterestLevel' => cookBooks[0].Interest_Level__c,
                        'sobjectType' => sobjectType
                    };
                    sendEmail(emailData);
                    
                    isSuccess = true;
                    responseMessage = 'Successfully created ' + cookBooks.size()
                        + ' cook book(s) out of ' + contacts.size()
                        + ' ' + sobjectType + ' (s) and assigned schedule call to ' + ae.Name + '.';
                } else{
                    isSuccess = false;
                    responseMessage = 'Selected contact(s) or AE(s) might already have scheduled call on the ' +
                        'selected date, please select a new date or assign to another AE';
                }
            } catch(Exception e) {
                isSuccess = false;
                responseMessage = 'Failed to set schedule calls. See error: ' + e.getMessage();
            }
        } else{
            isSuccess = false;
            responseMessage = 'No date or account executive selected!';
        }
        
        cookBookWrapper.responseMessage = responseMessage;
        cookBookWrapper.isSuccess = isSuccess;
        return cookBookWrapper;
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<Account_Executive__c> getAccountExecutives() {
        return [
            SELECT Id, Name, Email__c
            FROM Account_Executive__c
            ORDER BY Name DESC
        ];
    }
    
    /*Hung Huynh created */
    @AuraEnabled (cacheable = true)
    public static List<Contact> getContactIdByAccountId(Id accountId) {
        return [
            SELECT Id FROM Contact WHERE AccountId = :accountId LIMIT 1
        ];
    }
    
    private static void sendEmail(Map<String, Object> emailData){
        OrgWideEmailAddress orgAddress = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply@bookingninjas.com' LIMIT 1];
        
        Date scheduledDate = (Date)emailData.get('scheduleDate');
        String formattedDate = scheduledDate.Month() + '/' + scheduledDate.Day() + '/' + scheduledDate.Year();

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{ (String)emailData.get('recepientEmail') });
        email.setSubject('You have new assigned task! ' + (String)emailData.get('targetName') + ' ' + formattedDate);
        String contactName = '';
        if ((String)emailData.get('sobjectType') == 'Contact') {
            contactName = '<tr><td>Contact Name</td><td><a href="https://bookingninjas.my.salesforce.com/' + (String)emailData.get('targetContactId') + '" target="_blank">' + (String)emailData.get('targetName') + '</a></td></tr>';
        }
        String emailContent = 'You have ' + (Integer)emailData.get('cookBookSize') + ' new scheduled call(s) on ' + formattedDate + '. <br/>'+
        '<table style="width:50%"><tbody>'+
            contactName +
            '<tr><td>Contact Email</td><td>' + (String)emailData.get('targetEmail') + '</td></tr>'+
            '<tr><td>Account Name</td><td><a href="https://bookingninjas.my.salesforce.com/' + (String)emailData.get('targetAccountId') + '" target="_blank">' + (String)emailData.get('targetAccountName') + '</a></td></tr>'+
            '<tr><td>LinkedIn URL</td><td><a href="' + (String)emailData.get('targetLinkedIn') + '" target="_blank">' + (String)emailData.get('targetLinkedIn') + '</a></td></tr>'+
            '<tr><td>URL Link</td><td>' + (String)emailData.get('targetUrl') + '</td></tr>'+
            '<tr><td>Notes</td><td>' + (String)emailData.get('cookBookNotes') + '</td></tr>'+
            '<tr><td>Interest Level</td><td>' + (String)emailData.get('cookBookInterestLevel') + '</td></tr>'+
        '</tbody></table>' +
        '<br/>You can see via <a href="https://bookingninjas.my.salesforce.com/' + (String)emailData.get('cookBookId') + '">CB record link</a>.<br/><br/>' +
        'If you find the record with no scheduled time, please set it.<br/><br/>' + 
        'If you already had a recent interaction with the contacts, please disregard. Thanks!';
        email.setHTMLBody(emailContent);
        email.setOrgWideEmailAddressId(orgAddress.Id);
        if(!Test.isRunningTest()){
            Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    
    @TestVisible
    private class CookBookWrapper{
        @AuraEnabled public Date scheduledDate;
        @AuraEnabled public String userId;
        @AuraEnabled public String recordId;
        @AuraEnabled public String notes;
        @AuraEnabled public String interestLevel;
        @AuraEnabled public String responseMessage;
        @AuraEnabled public Boolean isSuccess;
    }
}