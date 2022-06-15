trigger CookBookTrigger on Cook_Book__c ( before insert, before update, after update ) {
    Set<Id> objectIds = new Set<Id>();
    for(Cook_Book__c cb : Trigger.new) {
        objectIds.add(cb.Id);
    }    
    List<Cook_Book__c> cookbooks = [SELECT Id, Contact__c, Contact__r.Name, Contact__r.MobilePhone, Contact__r.Phone, Contact__r.X2nd_Phone_Number__c, Mobile__c, Phone__c, X2nd_Phone__c, Account_Executive__c, Scheduled_Date__c, Next_Call__c FROM Cook_Book__c WHERE Id IN :objectIds];
    if(Trigger.isBefore && Trigger.isInsert) {
        for( Cook_Book__c cb : Trigger.new ) {
            if(cb.AccountLookup__c != null && cb.Contact__c == null){
                Account account = [SELECT Id, Phone, Phone_2__c FROM Account WHERE Id = :cb.AccountLookup__c];
                cb.Phone__c = account.Phone;
                cb.X2nd_Phone__c = account.Phone_2__c;
            }
            else if(cb.Contact__c != null){
                Contact contact = [SELECT Id, MobilePhone, Phone, X2nd_Phone_Number__c FROM Contact WHERE Id = :cb.Contact__c];
                // update mobile phone based contact's value
                cb.Mobile__c = contact.MobilePhone;
                cb.Phone__c = contact.Phone;
                cb.X2nd_Phone__c = contact.X2nd_Phone_Number__c;
            }
        }
    }
        
    if (Trigger.isBefore && Trigger.isUpdate) {
        List<Cook_Book__c> cook_books_to_add = new List<Cook_Book__c>();

        for( Cook_Book__c cb : Trigger.New ) {
            // update mobile phone based contact's value, if exist
            cb.Mobile__c = cb.Contact__r.MobilePhone != null ? cb.Contact__r.MobilePhone : cb.Mobile__c;
            cb.Phone__c = cb.Contact__r.Phone != null ? cb.Contact__r.Phone : cb.Phone__c;
            cb.X2nd_Phone__c = cb.Contact__r.X2nd_Phone_Number__c != null ? cb.Contact__r.X2nd_Phone_Number__c : cb.X2nd_Phone__c;

            if(trigger.oldMap.get(cb.Id).Next_Call__c == null && cb.Next_Call__c != null) 
            {
                Cook_Book__c addCb = new Cook_Book__c();
                addCb.Name = cb.Contact__r.Name + ' - Appointments ' + String.valueOf(Date.newInstance(cb.Next_Call__c.Year(), cb.Next_Call__c.Month(), cb.Next_Call__c.Day()));
                addCb.Contact__c = cb.Contact__c;
                addCb.Mobile__c = cb.Mobile__c;
                addCb.Account_Executive__c = cb.Reassign_to_new_AE__c != null ? cb.Reassign_to_new_AE__c : cb.Account_Executive__c;
                addCb.Scheduled_Date__c = Date.newInstance(cb.Next_Call__c.Year(), cb.Next_Call__c.Month(), cb.Next_Call__c.Day());  // new date
                addCb.Type__c = 'Calls';
                addCb.Call_Result__c = 'Appointments';
                addCb.Interest_Level__c = cb.Interest_Level__c;
                addCb.Notes__c = cb.Notes__c;
                
                cook_books_to_add.add(addCb);
            }
        }
        
        try 
        {
            if( cook_books_to_add.size() > 0 )
            {
                insert cook_books_to_add;
            }
        }
        catch(DMLException e) {
            System.Debug('Scheduled calls for cook books were not added.  Error: '+ e);
            
        }
    }
}