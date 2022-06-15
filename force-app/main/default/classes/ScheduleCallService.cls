public with sharing class ScheduleCallService {
    
    public String contactId {get; set;}
    Set<String> objectIds = new Set<String>();
    List<Contact> contacts = new List<Contact>();
    
    public Date scheduledDate {get; set;}
    public String notes {get; set;}
    public String interestLevel {get; set;}
    public Id userId {get; set;}
    
    public boolean contactHasSchedule {get; set;}
    public Boolean showError {get; set;}
    public Boolean showSuccess {get; set;}
    public String responseMessage {get; set;}
    
    public ScheduleCallService() {
        
        contactHasSchedule = false;
        showError = false;
        showSuccess = false;
        responseMessage = '';
    }
    
    public void createTask() 
    {
        showError = false;
        showSuccess = false;
        responseMessage = '';
        
        if(scheduledDate != null && userId != null) 
        {   
            // instantiate CB list for saving                        
            List<Cook_Book__c> cook_books = new List<Cook_Book__c>();
                        
            // split ids to list
            List<String> contactIds = contactId.split(',');
            for(String cId : contactIds) 
            {
                objectIds.add(cId);
            }
            
            // iterate contacts and schedule call one at a time        
            for(Contact contact : [SELECT Id, Name, Account.Name, Email, MobilePhone, Phone, x2nd_Phone_Number__c FROM Contact WHERE Id IN :objectIds]) 
            {
                Cook_Book__c cb = new Cook_Book__c();
                cb.Name = contact.Name + ' - Appointments ' + String.valueOf(scheduledDate);
                cb.Contact__c = contact.Id;
                cb.Mobile__c = contact.MobilePhone;
                cb.Phone__c = contact.Phone;
                cb.X2nd_Phone__c = contact.X2nd_Phone_Number__c;
                cb.Account_Executive__c = userId;
                cb.Scheduled_Date__c = scheduledDate;
                cb.Type__c = 'Calls';
                cb.Call_Result__c = 'Appointments';
                cb.Notes__c = notes;
                cb.Interest_Level__c = interestLevel;
                cook_books.add(cb);
            }
            
            try 
            {
                if(cook_books.size() > 0)
                {
                    insert cook_books;
                    
                    Account_Executive__c ae = [SELECT Id, Name, Email__c FROM Account_Executive__c WHERE Id = :userId];
                    sendEmail(scheduledDate, ae.Email__c, cook_books.size());    
                        
                    showError = false;
                    showSuccess = true;
                    responseMessage = 'Successfully created ' + cook_books.size() + ' cook book(s) out of ' + contacts.size() + ' contact(s) and assigned schedule call to ' + ae.Name + '.';
                }
                else {
                    showError = true;
                    showSuccess = false;
                    responseMessage = 'Selected contact(s) or AE(s) might already have scheduled call on the selected date, please select a new date or assign to another AE';
                }
            }
            catch(Exception e) 
            {
                showError = true;
                showSuccess = false;
                responseMessage = 'Failed to set schedule calls. See error: ' + e.getMessage();
            }
        }
        else 
        {
            showError = true;
            showSuccess = false;
            responseMessage = 'No date or account executive selected!';
        }
        
    }
    
    public List<SelectOption> getListOfUsers() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        for(Account_Executive__c u : [Select Id, Name, Email__c from Account_Executive__c]) 
        {
            options.add(new SelectOption(u.Id, u.Email__c));
        }
        return options;
    }
    
    public List<SelectOption> getListInterestLevel() 
    {
        List<SelectOption> options = new List<SelectOption>();
        for(Integer i = 0; i <= 10; i++) 
        {
            options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        return options;
    }
    
    public void isContactHasSchedule() 
    {
        showError = false;
        showSuccess = false;
        responseMessage = '';
        
        List<String> contactIds = contactId.split(',');
        for(String cId : contactIds) 
        {
            objectIds.add(cId);
        }
        
        List<Cook_Book__c> checkCBs = [SELECT Id FROM Cook_Book__c WHERE Contact__c IN :objectIds AND Scheduled_Date__c >= :scheduledDate];
        if(checkCBs.size() > 0) 
        {         
            showError = true;
            showSuccess = false;
            responseMessage = 'Selected contact(s) has already scheduled call in the future. Would you still like to proceed?';
        }
    }
    
    private boolean isExistingSchedule(String contactId, String userId, Date scheduledDate)
    {    
        // check first if contact has existing schedule
        List<Cook_Book__c> checkContacts = [SELECT Id FROM Cook_Book__c WHERE Contact__c = :contactId AND Scheduled_Date__c = :scheduledDate];
        if(checkContacts.size() > 0)
        {
            return true;
        }
        else 
        {
            // then check if account executive is available for the available schedule
            List<Cook_Book__c> checkAEs = [SELECT Id FROM Cook_Book__c WHERE Account_Executive__c = :userId AND Scheduled_Date__c = :scheduledDate];
            if(checkAEs.size() > 0) {
                return true;
            }
            return false;
        } 
    }
    
    private void sendEmail(Date scheduledDate, string recipient, integer size)
    {
        OrgWideEmailAddress orgAddress = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply@bookingninjas.com' LIMIT 1];
        
        String formattedDate = scheduledDate.Month() + '/' + scheduledDate.Day() + '/' + scheduledDate.Year();
                    
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{ recipient });
        email.setSubject('You have new assigned task!');
        email.setHTMLBody('You have ' + size + ' new scheduled call(s) on ' + formattedDate + '. <br/><br/> Please see via <a href=\'https://bookingninjas.my.salesforce.com/apex/CookBookReport?id=' + userId + '&date=' + scheduledDate + '\'>cook book report</a>.<br/><br/> If you find the record with no scheduled time, please set it. <br/><br/>If you already had a recent interaction with the contacts, please disregard.');
        email.setOrgWideEmailAddressId(orgAddress.Id);
        Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}