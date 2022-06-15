public class BatchKirimCookBook implements Database.Batchable<sObject>, Schedulable {

    public Iterable<sObject> start(Database.BatchableContext bc) {
        List<Cook_Book__c> removeCbs = [SELECT Id FROM Cook_Book__c WHERE Name LIKE '% -Appointments- %' AND CreatedDate = LAST_N_DAYS:7];
        if (removeCbs != null) {
            delete removeCbs;
        }

        List<NewActivity__c> acts = [SELECT ID, Name, Campaign_Date__c, Total_Open__c, Contact__c, Contact__r.Name, Contact__r.AccountId, Contact__r.Email, Contact__r.HasOptedOutOfEmail FROM NewActivity__c WHERE Campaign_Date__c = LAST_N_DAYS:7 AND Total_Open__c >= 2];

        return acts;
    }

    public void execute(Database.BatchableContext bc, List<NewActivity__c> acts){
        List<Cook_Book__c> addCbs = new List<Cook_Book__c>();
        Account_Executive__c aex = [SELECT Id FROM Account_Executive__c WHERE Email__c = 'david@bookingninjas.com' LIMIT 1];

        for (NewActivity__c act: acts) {
            Integer actStatus = Integer.valueOf(act.Total_Open__c);
            String cbStatus = '';
            String cbStrStatus = '';
            if (actStatus >= 7) {
                cbStrStatus = 'Hot';
                cbStatus = '6';
            } else if (actStatus >= 4) {
                cbStrStatus = 'Super Warms';
                cbStatus = '5';
            } else if (actStatus >= 2) {
                cbStrStatus = 'Warm';
                cbStatus = '4';
            }
            Date skrg = date.today();
            Date tanggalBuka = act.Campaign_Date__c;
            Date tanggalTelp = tanggalBuka.addDays(2);
            Integer numberDaysDue = skrg.monthsBetween(tanggalTelp);

            if (numberDaysDue >= 0 && act.Contact__r.HasOptedOutOfEmail != true) {
                Cook_Book__c cb = new Cook_Book__c(
                    Name = act.Contact__r.Name + ' -Appointments- ' + String.valueOf(tanggalTelp),
                    Contact__c = act.Contact__c,
                    Account_Executive__c = aex.Id,
                    Interest_Level__c = cbStatus,
                    Record_Call__c = true,
                    Call_Result__c = 'Appointments',
                    Notes__c = cbStrStatus + ': ' + act.Name,
                    Scheduled_Date__c = tanggalTelp
                );
                if (!addCbs.contains(cb)) {
                    addCbs.add(cb);
                }
            }
        }

        if (addCbs != null) {
            insert addCbs;
        }
    }

    public void finish(Database.BatchableContext bc){
    }

    public void execute(SchedulableContext sc) {
        BatchKirimCookBook b = new BatchKirimCookBook();
        database.executebatch(b, 100); // execute only 100 records per batch
    }

}