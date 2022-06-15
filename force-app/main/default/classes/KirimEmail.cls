public class KirimEmail {
    private String recordId;

    public KirimEmail(ApexPages.StandardController controller) {
        recordId = controller.getRecord().Id;
    }

    public void createRecord() {
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
        List<NewActivity__c> removeCampaigns = [SELECT Id FROM NewActivity__c WHERE Name IN :campaigns];
        delete removeCampaigns;
        List<Cook_Book__c> removeCbs = [SELECT Id FROM Cook_Book__c WHERE Name LIKE '% -Appointments- %'];
        delete removeCbs;

        BatchKirimActivity aktivitas = new BatchKirimActivity(); 
        Database.executeBatch(aktivitas);
        
        BatchKirimGeo geo = new BatchKirimGeo(); 
        Database.executeBatch(geo);
        
        BatchKirimBounce bounce = new BatchKirimBounce(); 
        Database.executeBatch(bounce);
        
        BatchKirimUnopen unopen = new BatchKirimUnopen(); 
        Database.executeBatch(unopen);
    }
}