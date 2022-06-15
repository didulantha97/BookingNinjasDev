global with sharing class ScheduledJob implements Schedulable {
    global void execute(SchedulableContext sc) {
        
        //CallMeetingReminderBatch callReminderBatch = new CallMeetingReminderBatch();
        //Database.executeBatch(callReminderBatch, 1);
        
        //ContactRecordBatch contactRecordBatch = new ContactRecordBatch();
        //Database.executeBatch(contactRecordBatch, 1);
        
        //ScheduleCallBatch scheduleCallBatch = new ScheduleCallBatch();
        //Database.executeBatch(scheduleCallBatch, 1);
        
        PublishArticleBatch publishArticleBatch = new PublishArticleBatch();
        Database.executeBatch(publishArticleBatch, 1);

        Datetime dt =  System.now().addDays(1);
        String day = String.valueOf(dt.day());
        String month = String.valueOf(dt.month());
        String hour = String.valueOf(dt.hour());
        String minute = String.valueOf(dt.minute());
        String second = String.valueOf(dt.second());
        String year = String.valueOf(dt.year());

        String strJobName = 'ArticlePublish ' + year + '-' + month + '-' + day + '-' + hour + '-' + minute;
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;

        if(!Test.isRunningTest()){
            System.schedule(strJobName, strSchedule, new ScheduledJob());
        }
    }
}