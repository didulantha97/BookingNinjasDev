global with sharing class PublishArticleBatch implements Database.Batchable<sObject>{

    DateTime dT = System.now();
    Date dateToday = date.newinstance(dT.year(), dT.month(), dT.day());
    
    private PublishArticleService service = new PublishArticleService(); 
    public String query = 'SELECT Id, Name, Is_Main_Article__c, Publish__c, Scheduled_Publish_Date__c FROM Article__c WHERE Publish__c = false AND Scheduled_Publish_Date__c != NULL AND Scheduled_Publish_Date__c = :dateToday';
    
    //Start Method which retrieves the records of case
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }  
    
    global void execute(Database.BatchableContext BC, List<Article__c> records) {
        service.process(records);
    }
    
    global void finish(Database.BatchableContext BC) {
        
    } 
}