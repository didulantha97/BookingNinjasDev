global with sharing class ContactRecordBatch implements Database.Batchable<sObject>{
    
    private ContactRecordService service = new ContactRecordService();
    public String query = 'SELECT Id, Name, Total_Contact_Records__c FROM Account WHERE isPersonAccount = false';
    

    //Start Method which retrieves the records of case
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }  
    
    global void execute(Database.BatchableContext BC, List<Account> records) {
        service.process(records);
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }   
}