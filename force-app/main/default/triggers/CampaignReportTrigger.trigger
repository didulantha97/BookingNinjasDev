trigger CampaignReportTrigger on Campaign_Report__c (before insert) {
	if (Trigger.isBefore) {
        // get contact id & campaign name
        List<Id> contactIds = new List<Id>();
        List<String> campaignsName = new List<String>();
        for (Campaign_Report__c cr : Trigger.New){
            contactIds.add(cr.Contact__c);
            if (cr.Name.length() > 60) {
                campaignsName.add(cr.Name.substring(0, 60));
            } else {
                campaignsName.add(cr.Name);
            }
        }
        List<Campaign_Report__c> oldActivities = [SELECT Id FROM Campaign_Report__c WHERE Name IN :campaignsName AND Contact__c = :contactIds];
		// remove old activities
        if (oldActivities.size() > 0) {
            delete oldActivities;
        }
    }
}