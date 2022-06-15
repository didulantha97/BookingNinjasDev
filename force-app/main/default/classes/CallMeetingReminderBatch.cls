global with sharing class CallMeetingReminderBatch implements Database.Batchable<sObject>{
    private CallMeetingReminderService reminderService = new CallMeetingReminderService();
    public static Integer HOUR_PARAM = System.Now().addHours(1).hour();
    public static Integer MINUTE_PARAM = System.Now().addHours(1).minute();
    public static String query = 'SELECT Id, ' + 
                                        'WhoId, ' +
                                        'StartDateTime ' +
                                 'FROM Event ' +
                                 'WHERE StartDateTime = Today ' +
                                 'AND WhoId != null';
      
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Event> records) {
        reminderService.process(records, HOUR_PARAM, MINUTE_PARAM);
    }  

    global void finish(Database.BatchableContext BC) {
        
    }    
}