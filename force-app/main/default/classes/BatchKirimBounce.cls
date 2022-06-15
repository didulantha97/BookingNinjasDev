public class BatchKirimBounce implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {

    public Iterable<sObject> start(Database.BatchableContext bc) {
        List<Map<Integer, String>> kirim_data = FetchKirim.fetchBounce();

        List<String> emails = new List<String>();
        if (kirim_data.size() > 0) {
            for (Map<Integer, String> kirim: kirim_data){
                String email = kirim.get(1);
                if (!emails.contains(email)) {
                    emails.add(email);   
                }
            }
        }

        List<Contact> contacts = [SELECT ID, Email, Email_Status_Cleanup__c, HasOptedOutOfEmail FROM Contact WHERE Email IN :emails];
        return contacts;
    }

    public void execute(Database.BatchableContext bc, List<Contact> contacts){
        List<Map<Integer, String>> kirim_data = FetchKirim.fetchBounce();
        List<Contact> update_contacts = new List<Contact>();
        // process each batch of records
        for (Contact kontak: contacts) {
        	Map<Integer, String> activity = new Map<Integer, String>();
            for (Map<Integer, String> campaign: kirim_data) {
                if (campaign.get(1).equals(kontak.Email)) {
                    activity = campaign;
                    break;
                }
            }
            if (activity.get(2) != null) {
                if (activity.get(2).equals('hard')) {
                    kontak.Email_Status_Cleanup__c = 'Hard Bounce';
                    kontak.HasOptedOutOfEmail = true;
                } else {
                    kontak.Email_Status_Cleanup__c = 'Soft Bounce';
                }
            } else {
                kontak.Email_Status_Cleanup__c = 'Soft Bounce';
            }
            kontak.Status__c = 'Bad Email';            
            
            if (activity.size() > 0) {
            	update_contacts.add(kontak);    
            }
		}
        if (update_contacts.size() > 0) {
            update update_contacts;
        }
    }

    public void finish(Database.BatchableContext bc){
    }

    public void execute(SchedulableContext sc) {
        BatchKirimBounce b = new BatchKirimBounce();
        database.executebatch(b);
    }

}