/**
* The BNEmailActivityBatch class for create or update email activity and contact record
* because the record may be so many, we do it via bath apex and schedulable
*
* @author  Prayoga Teguh <teguh@bookingninjas.com>
* @version 1.0
* @since   2020-09-23
*/
public with sharing class BNEmailActivityBatch implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {

    public Iterable<sObject> start(Database.BatchableContext bc) {
        // fetch all last month's email activities
        BNEmailFetch bnemail = new BNEmailFetch();
        List<Map<Integer, String>> emailActivities = bnemail.fetchActivity();

        List<String> contactIds = new List<String>();
        if (emailActivities != null) {
            for (Map<Integer, String> activity: emailActivities){
                String contactId = activity.get(3);
                if (!contactIds.contains(contactId)) {
                    contactIds.add(contactId);   
                }
            }
        }

        // all contact that interact with the emails
        List<Contact> contacts = [SELECT Id, Status__c FROM Contact WHERE Id IN :contactIds];
        return contacts;
    }

    public void execute(Database.BatchableContext bc, List<Contact> contacts){
        List<Campaign_Report__c> addActivities = new List<Campaign_Report__c>();
        List<Contact> updateContacts = new List<Contact>();

        // fetch all last month's email activities
        BNEmailFetch bnemail = new BNEmailFetch();
        List<Map<Integer, String>> emailActivities = bnemail.fetchActivity();

        // contact activity
        Map<Id, List<Map<Integer, String>>> contactActivities = new Map<Id, List<Map<Integer, String>>>();
        for (Map<Integer, String> activity : emailActivities) {
            if (!contactActivities.containsKey(activity.get(3))) {
                contactActivities.put(activity.get(3), new List<Map<Integer, String>>{ activity });
            } else {
                List<Map<Integer, String>> currActs = contactActivities.get(activity.get(3));
                currActs.add(activity);
                contactActivities.put(activity.get(3), currActs);
            }
        }

        if (emailActivities != null) {
            // process each batch of email activity
            for (Contact contact: contacts) {
                Integer mostOpen = 0;
                Integer mostClick = 0;
                String contactStatus = null;
                String emailStatusCleanup = null;
                Boolean hasOptedOutOfEmail = false;
                String emailCheckerStatus = 'Ok';

                if (contactActivities.get(contact.Id) == null) {
                    continue;
                }
                for (Map<Integer, String> emailActivity: contactActivities.get(contact.Id)) {
                    Integer totalOpen = Integer.valueOf(emailActivity.get(7));
                    Integer totalClick = Integer.valueOf(emailActivity.get(6));

                    // create campaign activity record
                    String campaignName = '';
                    if (emailActivity.get(1).length() > 60) {
                        campaignName = emailActivity.get(1).substring(0, 60);
                    } else {
                        campaignName = emailActivity.get(1);
                    }
                    String qualityDesc = '';
                    if (emailActivity.get(5).length() > 255) {
                        qualityDesc = emailActivity.get(5).substring(0, 255);
                    } else {
                        qualityDesc = emailActivity.get(5);
                    }
                    Campaign_Report__c campaignActivity = new Campaign_Report__c(
                        Name = campaignName,
                        Campaign_Date__c = date.valueOf(emailActivity.get(2)),
                        Contact__c = contact.Id,
                        Contact_Quality__c = emailActivity.get(4),
                        Quality_Description__c = qualityDesc,
                        Total_Click__c = totalClick,
                        Total_Open__c = totalOpen
                    );
                    addActivities.add(campaignActivity);

                    // variable for update contact
                    if (mostOpen == 0 || mostOpen < totalOpen) {
                        mostOpen = totalOpen; // save most open data
                    }
                    if (mostClick == 0 || mostClick < totalClick) {
                        mostClick = totalClick; // save most click data
                    }
                    if (emailActivity.get(4).equals('Complaint')) {
                        emailCheckerStatus = 'Bad';
                        contactStatus = 'Bad Email';
                        emailStatusCleanup = 'Complaint';
                    } else if (emailActivity.get(4).equals('Soft Bounce')) {
                        emailCheckerStatus = 'Catch-All';
                        emailStatusCleanup = 'Soft Bounce';
                    } else if (emailActivity.get(4).equals('Hard Bounce')) {
                        emailCheckerStatus = 'Bad';
                        contactStatus = 'Bad Fit';
                        emailStatusCleanup = 'Hard Bounce';
                    } else if (emailActivity.get(4).equals('Unsubscribe')) {
                        emailCheckerStatus = 'Bad';
                        contactStatus = 'Bad Email';
                        emailStatusCleanup = 'Unsubscribed';
                        hasOptedOutOfEmail = true;
                    } else if (emailActivity.get(4).equals('Click')) {
                        emailStatusCleanup = 'Clicked';
                    } else if (emailActivity.get(4).equals('Open')) {
                        emailStatusCleanup = 'Opened';
                    } else if (emailActivity.get(4).equals('Sent')) {
                        emailStatusCleanup = 'Sent';
                    }
                }

                // update contact status if current status is better
                Map<String, Integer> statusMap = new Map<String, Integer>{'Cold'=>1, 'Warm'=>2, 'Super Warm'=>4, 'Hot'=>7};
                String strStatus = contact.Status__c; // old status
                Integer intStatus = 0;
                if (strStatus != null) {
                    intStatus = statusMap.get(strStatus);
                }
                if (mostOpen >= 7) {
                    contact.Status__c = 'Hot';
                } else if (mostOpen >= 4 && mostOpen >= intStatus) {
                    contact.Status__c = 'Super Warms';
                } else if (mostOpen >= 2 && mostOpen >= intStatus) {
                    contact.Status__c = 'Warm';
                } else if (mostOpen == 1 && mostOpen >= intStatus) {
                    contact.Status__c = 'Cold';
                }

                contact.Email_Checker_Status__c = emailCheckerStatus;
                contact.HasOptedOutOfEmail = hasOptedOutOfEmail;
                if (contactStatus != null) {
                    contact.Status__c = contactStatus;
                }
                if (emailStatusCleanup != null) {
                    contact.Email_Status_Cleanup__c = emailStatusCleanup;
                }

                updateContacts.add(contact);
            }
            
            // insert list of email activity to the database
            if (addActivities.size() > 0) {
                insert addActivities;
            }

            // update contact record based on their email activity
            if (updateContacts.size() > 0) {
                update updateContacts;
            }
        }
    }

    public void finish(Database.BatchableContext bc){
    }

    public void execute(SchedulableContext sc) {
        BNEmailActivityBatch b = new BNEmailActivityBatch();
        Database.executeBatch(b, 100);
    }

}