@isTest
public class PublishArticleBatch_Test {
    
    @isTest static void testProcess(){
    
        List<Article__c> articles = new List<Article__c>();
        for(Integer i = 0; i <= 10; i++) {
            Article__c article = new Article__c(Name = 'Test Article ' + i, Category__c = 'Article', Publish__c = false, Scheduled_Publish_Date__c = Date.Today().addDays(i), Is_Main_Article__c = true, Meta_Title__c = 'Article Title', Meta_Description__c = 'Article Desc');
            articles.add(article);
        }
        insert articles;
        
        Test.startTest();   
          PublishArticleBatch batch = new PublishArticleBatch();
          batch.execute(null, articles);
          batch.start(null);
          batch.finish(null); 
        Test.stopTest();
    }

    @isTest static void testScheduledJob(){
        Test.startTest();
          ScheduledJob job = new ScheduledJob();
          job.execute(null);
        Test.stopTest();
    }    
}