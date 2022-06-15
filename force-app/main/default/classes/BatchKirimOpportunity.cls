public class BatchKirimOpportunity implements Database.Batchable<sObject>, Schedulable {

    public Iterable<sObject> start(Database.BatchableContext bc) {
        List<Opportunity> removeOldOpps = [SELECT Id FROM Opportunity WHERE Created_by_Email_Campaign__c = true AND Campaign_Date__c = LAST_N_DAYS:7];
        if (removeOldOpps != null) {
            delete removeOldOpps;
        }

        List<NewActivity__c> acts = [SELECT ID, Campaign_Date__c, Contact__c, Contact__r.AccountId, Contact__r.Email FROM NewActivity__c WHERE Campaign_Date__c = LAST_N_DAYS:7 AND Total_Open__c >= 4];

        return acts;
    }

    public void execute(Database.BatchableContext bc, List<NewActivity__c> acts){
        List<Opportunity> addOpps = new List<Opportunity>();
        List<Opportunity> updateOpps = new List<Opportunity>();

        List<String> emails = new List<String>();
        for (NewActivity__c act: acts){
            String email = act.Contact__r.Email;
            if (!emails.contains(email)) {
                emails.add(email);
            }
        }

        // process each batch of records
        Map<String, Opportunity> currentOpps = new Map<String, Opportunity>();
        for (Opportunity opp: [SELECT Primary_Contact__r.Email, Id FROM Opportunity WHERE Primary_Contact__r.Email IN :emails]) {
            currentOpps.put(opp.Primary_Contact__r.Email, opp);
        }

        for (NewActivity__c act: acts) {
            Opportunity currentOpp;
            if (currentOpps != null) { // check if there's existing opp, if yes, update it!
                Opportunity opp = currentOpps.get(act.Contact__r.Email);
                if (opp != null) {
                    currentOpp = opp;
                    currentOpp.CloseDate = act.Campaign_Date__c.addDays(5);
                    if (!updateOpps.contains(currentOpp)) {
                        updateOpps.add(currentOpp);
                    }
                }
            }
            if (currentOpp == null) { // if no opp, create new
                currentOpp = new Opportunity(
                    Name = 'fromtrigger',
                    Type = 'New Business',
                    AccountId = act.Contact__r.AccountId,
                    Primary_Contact__c = act.Contact__c,
                    CloseDate = act.Campaign_Date__c.addDays(5),
                    StageName = 'Working',
                    Created_by_Email_Campaign__c = true,
                    Campaign_Date__c = act.Campaign_Date__c
                );
                
                if (!addOpps.contains(currentOpp)) {
                    addOpps.add(currentOpp);
                }
            }
        }

        if (addOpps != null) {
            insert addOpps;
        }
        if (updateOpps != null) {
            update updateOpps;
        }
    }

    public void finish(Database.BatchableContext bc){
        List<Opportunity> removeUnwantedOpps = [SELECT Id FROM Opportunity WHERE Name LIKE '%_Qualification_%' AND CreatedDate = TODAY];
        if (removeUnwantedOpps != null) {
            delete removeUnwantedOpps;
        }
    }

    public void execute(SchedulableContext sc) {
        BatchKirimOpportunity b = new BatchKirimOpportunity();
        database.executebatch(b, 100); // execute only 100 records per batch
    }

}