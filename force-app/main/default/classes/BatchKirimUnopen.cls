public class BatchKirimUnopen implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {

    public Iterable<sObject> start(Database.BatchableContext bc) {
        List<Map<Integer, String>> kirim_data = FetchKirim.fetchUnopen();

        List<String> emails = new List<String>();
        if (kirim_data.size() > 0) {
            for (Map<Integer, String> kirim: kirim_data){
                String email = kirim.get(1);
                if (!emails.contains(email)) {
                    emails.add(email);   
                }
            }
        }

        List<Contact> contacts = [SELECT ID, Total_Unopen__c, Email_Status_Cleanup__c FROM Contact WHERE Email IN :emails];
        return contacts;
    }

    public void execute(Database.BatchableContext bc, List<Contact> contacts){
        List<Map<Integer, String>> kirim_data = FetchKirim.fetchUnopen();
        List<Contact> update_contacts = new List<Contact>();
        // process each batch of records
        for (Contact kontak: contacts) {
            kontak.Email_Status_Cleanup__c = 'Sent';
            if (kontak.Total_Unopen__c != null) {
                kontak.Total_Unopen__c = kontak.Total_Unopen__c + 1;
                if (kontak.Total_Unopen__c >= 3) {
                    kontak.Status__c = 'Dead';
                }
            } else {
                kontak.Total_Unopen__c = 0;
            }
            
            update_contacts.add(kontak);
		}
        if (update_contacts.size() > 0) {
            update update_contacts;
        }
    }

    public void finish(Database.BatchableContext bc){
    }

    public void execute(SchedulableContext sc) {
        BatchKirimUnopen b = new BatchKirimUnopen();
        database.executebatch(b);
    }

}