trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {
    
    List<Opportunity> opportunities_to_update = new List<Opportunity>();
    Set<Id> objectIds = new Set<Id>();
    for(Opportunity opp : Trigger.new) {
        objectIds.add(opp.Id);
    }
    List<Opportunity> opportunities = [SELECT Id, Name, StageName, Type, CloseDate, AccountId, Account.Name FROM Opportunity WHERE Id IN :objectIds];
    if(Trigger.isAfter && Trigger.isInsert) {
        for( Opportunity opp : opportunities) {
            try {
                Account a = [SELECT Name FROM Account WHERE Id = :opp.AccountId];
                opp.Name = a.Name + '_' + opp.StageName + '_' + String.valueOf(opp.CloseDate);
            } catch(QueryException e) {
                opp.Name = 'No Account' + '_' + opp.StageName + '_' + String.valueOf(opp.CloseDate);
            }
            
            opportunities_to_update.add(opp);
        } 
        
        if(opportunities_to_update.size() > 0) {
            update opportunities_to_update; 
        }
    }

    if(Trigger.isBefore && Trigger.isInsert){
        for(Opportunity opp : Trigger.new) {
            try {
                Contact a = [SELECT Id FROM Contact WHERE AccountId = :opp.AccountId];
                opp.Primary_Contact__c = a.Id;
            } catch(QueryException e) {
                System.debug(e);
            }
        }   
    }
    
    if(Trigger.isBefore && Trigger.isUpdate) {
        for(Opportunity opp : Trigger.new) {
            try {
                Account a = [SELECT Name FROM Account WHERE Id = :opp.AccountId];
                opp.Name = a.Name + '_' + opp.StageName + '_' + String.valueOf(opp.CloseDate);
            } catch(QueryException e) {
                opp.Name = 'No Account' + '_' + opp.StageName + '_' + String.valueOf(opp.CloseDate);
            }
        }   
    }
    
    // used by trial/pilot form, author: teguh@bookingninjas.com
    if( Trigger.isBefore && Trigger.isInsert ) {
        for( Opportunity opp : Trigger.New ) {
            if (opp.trialEmail__c != null) {
                Contact contact = [SELECT Id, AccountId FROM Contact WHERE Email = :opp.trialEmail__c LIMIT 1];
                Trigger.New[0].AccountId = contact.AccountId;
                Trigger.New[0].Primary_Contact__c = contact.Id;
                Trigger.New[0].trialEmail__c = null;
            }
        }
    }
    
    // used by trial/pilot form, author: teguh@bookingninjas.com
    // remove if current record is duplicate opportunity
    if (Trigger.isAfter && Trigger.isInsert) {
        for (Opportunity opp : Trigger.New) {
            List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE AccountId = :opp.AccountId AND Primary_Contact__c = :opp.Primary_Contact__c AND Id NOT IN :Trigger.New];
            if (opps.size() >= 1) {
                // update old opp
                Opportunity oldOpp = opps[0];
                oldOpp.StageName = 'Checkout';
                oldOpp.Type = 'Existing Business';
                oldOpp.Probability = 90;
                oldOpp.CloseDate = Date.Today().addDays(1);
                oldOpp.Effective_Date__c = Date.Today().addMonths(1);
                update oldOpp;
                // remove recently created opp, because old opp exist
                delete [SELECT Id FROM Opportunity WHERE Id IN :Trigger.New];
            }
        }
    }

}