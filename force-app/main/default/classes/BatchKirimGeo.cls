public class BatchKirimGeo implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {

    public Iterable<sObject> start(Database.BatchableContext bc) {
        List<Map<Integer, String>> kirim_data = FetchKirim.fetchGeo();

        List<String> emails = new List<String>();
        if (kirim_data.size() > 0) {
            for (Map<Integer, String> kirim: kirim_data){
                String email = kirim.get(1);
                if (!emails.contains(email)) {
                    emails.add(email);   
                }
            }
        }

        List<Contact> contacts = [SELECT ID, Email, IP_Address__c, MailingCity, MailingCountry FROM Contact WHERE Email IN :emails];
        return contacts;
    }

    public void execute(Database.BatchableContext bc, List<Contact> contacts){
        List<Map<Integer, String>> kirim_data = FetchKirim.fetchGeo();
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
            kontak.IP_Address__c = activity.get(2);   
            kontak.MailingCity = activity.get(4);  
            kontak.MailingCountry = activity.get(3);  
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
        BatchKirimGeo b = new BatchKirimGeo();
        database.executebatch(b);
    }

}