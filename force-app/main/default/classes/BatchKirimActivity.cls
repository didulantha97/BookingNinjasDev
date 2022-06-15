public class BatchKirimActivity implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {

    public Iterable<sObject> start(Database.BatchableContext bc) {
        // delete all activity with title is the current campaigns
        List<Map<Integer, String>> kirim_data = FetchKirim.fetchActivity();
        List<String> campaigns = new List<String>();
        if (kirim_data.size() > 0) {
            for (Map<Integer, String> kirim: kirim_data) {
                String campaign = kirim.get(1);
                if (!campaigns.contains(campaign)) {
                    campaigns.add(campaign);
                }
            }
        }

        List<NewActivity__c> removeCampaigns = [SELECT Id FROM NewActivity__c WHERE Name IN :campaigns AND Campaign_Date__c = LAST_N_DAYS:7];
        delete removeCampaigns;

        // getting all campaign corespond emails
        List<String> emails = new List<String>();
        if (kirim_data.size() > 0) {
            for (Map<Integer, String> kirim: kirim_data){
                String email = kirim.get(3);
                if (!emails.contains(email)) {
                    emails.add(email);
                }
            }
        }
        List<Contact> contacts = [SELECT ID, Name, Email, Status__c, HasOptedOutOfEmail FROM Contact WHERE Email IN :emails];
        return contacts;
    }

    public void execute(Database.BatchableContext bc, List<Contact> contacts){
        List<Map<Integer, String>> kirim_data = FetchKirim.fetchActivity();
        List<Contact> update_contacts = new List<Contact>();
        List<NewActivity__c> add_activities = new List<NewActivity__c>();
        
        // process each batch of records
        for (Contact kontak: contacts) {
        	Map<Integer, String> first_activity = new Map<Integer, String>();
            Map<Integer, String> activity = new Map<Integer, String>();
            for (Map<Integer, String> campaign: kirim_data) {
                if (campaign.get(3).equals(kontak.Email)) {
                    if (first_activity.size() == 0) {
                        first_activity = campaign;
                    }
                    activity = campaign;
                    NewActivity__c aktivitas = new NewActivity__c();
                    aktivitas.Name = activity.get(1);
                    aktivitas.Campaign_Date__c = date.valueOf(AlatAlat.ubah(activity.get(2)));
                    aktivitas.Contact__c = kontak.Id;
                    aktivitas.Total_Open__c = Integer.valueOf(activity.get(4));
                    aktivitas.Total_Click__c = Integer.valueOf(activity.get(5));
                    aktivitas.Unsubscribed__c = Boolean.valueOf(activity.get(6));
                    aktivitas.Unsubscribed_Reason__c = activity.get(8);
                    if (Boolean.valueOf(activity.get(6)) == true) {
                        aktivitas.Unsubscribed_Date__c = date.valueOf(AlatAlat.ubah(activity.get(7)));
                    }
                    Integer actStatus = Integer.valueOf(activity.get(4));
                    String cbStatus = '';
                    String cbStrStatus = '';
                    if (actStatus >= 7) {
                        aktivitas.Status__c = 'Hot';
                        cbStrStatus = 'Hot';
                        cbStatus = '6';
                    } else if (actStatus >= 4) {
                        aktivitas.Status__c = 'Super Warms';
                        cbStrStatus = 'Super Warms';
                        cbStatus = '5';
                    } else if (actStatus >= 2) {
                        aktivitas.Status__c = 'Warm';
                        cbStrStatus = 'Warm';
                        cbStatus = '4';
                    } else if (actStatus == 1) {
                        aktivitas.Status__c = 'Cold';
                    }

                    if (!add_activities.contains(aktivitas)) {
                        add_activities.add(aktivitas);
                    }

                }
            }

            kontak.Email_Checker_Status__c = 'Ok';
            kontak.Total_Unopen__c = 0;
            // getting current contact status
            String strStatus = kontak.Status__c;
            Integer intStatus = 0;
            if (strStatus != null) {
                if (strStatus.equals('Hot')) {
                    intStatus = 7;
                } else if (strStatus.equals('Super Warms')) {
                    intStatus = 4;
                } else if (strStatus.equals('Warm')) {
                    intStatus = 2;
                } else if (strStatus.equals('Cold')) {
                    intStatus = 1;
                }
            }
            // update contact status if current status is better
            Integer currentStatus = Integer.valueOf(first_activity.get(4));
            if (currentStatus >= 7) {
                kontak.Status__c = 'Hot';
            } else if (currentStatus >= 4 && currentStatus >= intStatus) {
                kontak.Status__c = 'Super Warms';
            } else if (currentStatus >= 2 && currentStatus >= intStatus) {
                kontak.Status__c = 'Warm';
            } else if (currentStatus == 1 && currentStatus >= intStatus) {
                kontak.Status__c = 'Cold';
            }
            // update contact email opt out & email status
            if (Boolean.valueOf(first_activity.get(6)) == true) {
                kontak.HasOptedOutOfEmail = true;
                kontak.Unsubscribed_Reason__c = first_activity.get(8);
                kontak.Email_Status_Cleanup__c = 'Unsubscribed';
            } else if (Integer.valueOf(first_activity.get(5)) >= 1) {
                kontak.Email_Status_Cleanup__c = 'Clicked';
            } else if (Integer.valueOf(first_activity.get(4)) >= 1) {
                kontak.Email_Status_Cleanup__c = 'Opened';
            }
            update_contacts.add(kontak);
        }
        
        if (update_contacts.size() > 0) {
            update update_contacts;
        }
        
        if (add_activities.size() > 0) {
            insert add_activities;
        }

    }

    public void finish(Database.BatchableContext bc){
    }

    public void execute(SchedulableContext sc) {
        BatchKirimActivity b = new BatchKirimActivity();
        database.executebatch(b);
    }

}