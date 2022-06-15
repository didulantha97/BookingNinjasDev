global with sharing class ScheduleCallBatch implements Database.Batchable<sObject>{
    private ScheduleCallBatchService service = new ScheduleCallBatchService();
    public static Integer HOUR_PARAM = System.Now().addMinutes(30).hour();
    public static Integer MINUTE_PARAM = System.Now().addMinutes(30).minute();
    Time mapTime = Time.newInstance(HOUR_PARAM, MINUTE_PARAM, 0, 0);
    public static String query = 'SELECT Id, ' + 
                                        'Contact__c, ' +
                                        'Account_Executive__c, ' +
                                        'Scheduled_Date__c, ' +
                                        'Scheduled_Time__c ' +
                                 'FROM Cook_Book__c ' +
                                 'WHERE Scheduled_Date__c = TODAY ' +
                                 'AND Scheduled_Time__c = :mapTime ' +
                                 'AND Account_Executive__c != NULL';
                                 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Cook_Book__c> records) {
        service.process(records);
    }  

    global void finish(Database.BatchableContext BC) {
        
    }    
}