public class BatchDeadContact implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {

    public Iterable<sObject> start(Database.BatchableContext bc) {
        List<Map<Integer, String>> kirim_data = FetchKirim.fetchDead();

        List<String> emails = new List<String>();
        if (kirim_data.size() > 0) {
            for (Map<Integer, String> kirim: kirim_data){
                String email = kirim.get(1);
                if (!emails.contains(email)) {
                    emails.add(email);   
                }
            }
        }

        List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Email IN :emails AND Status__c != 'Dead'];
        return contacts;
    }

    public void execute(Database.BatchableContext bc, List<Contact> contacts){
        List<Map<Integer, String>> kirim_data = FetchKirim.fetchDead();
        List<Contact> update_contacts = new List<Contact>();

        for (Contact kontak: contacts) {
            for (Map<Integer, String> data: kirim_data) {
                if (data.get(1).equals(kontak.Email)) {
                    Integer totalSkipped = Integer.valueOf(data.get(2));
                    if (totalSkipped > 5) {
                        kontak.Status__c = 'Dead';
                        update_contacts.add(kontak);
                        break;
                    }
                }
            }
		}
        if (update_contacts.size() > 0) {
            update update_contacts;
        }
    }

    public void finish(Database.BatchableContext bc){
    }

    public void execute(SchedulableContext sc) {
        BatchDeadContact b = new BatchDeadContact();
        database.executebatch(b, 100);
    }

}