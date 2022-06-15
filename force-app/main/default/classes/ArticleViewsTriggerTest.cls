@isTest
public class ArticleViewsTriggerTest {
    
    static testmethod void testArticleView() {
        
        Article__c art = new Article__c();
        art.Name = 'Article Title';
        art.Meta_Title__c = 'Article Title';
        art.Meta_Description__c = 'Article description';
        insert art;
           
        Article_Views__c av = new Article_Views__c();
        av.ArticleId__c = art.Id;
        av.IP_Address__c = '192.168.1.1';
        insert av;
        
        Article__c artRecord = [SELECT Id FROM Article__c LIMIT 1];
        Article_Views__c avRecord = [SELECT ArticleId__c FROM Article_Views__c LIMIT 1];
        
        Test.StartTest();
        System.assertEquals(avRecord.ArticleId__c, artRecord.Id);
        Test.StopTest();
    }
    
    static testmethod void testArticleViewExist() {
        
        Article__c art = new Article__c();
        art.Name = 'Article Title';
        art.Meta_Title__c = 'Article Title';
        art.Meta_Description__c = 'Article description';
        insert art;
        
        Article_Views__c av1 = new Article_Views__c();
        av1.ArticleId__c = art.Id;
        av1.IP_Address__c = '192.168.1.1';
        insert av1;
           
        Article_Views__c av2 = new Article_Views__c();
        av2.ArticleId__c = art.Id;
        av2.IP_Address__c = '192.168.1.1';
        insert av2;
        
        Article__c artRecord = [SELECT Id, Total_Views__c FROM Article__c LIMIT 1];
        Article_Views__c avRecord = [SELECT ArticleId__c FROM Article_Views__c LIMIT 1];
        
        Test.StartTest();
        System.assertEquals(avRecord.ArticleId__c, artRecord.Id);
        System.assertEquals(artRecord.Total_Views__c, 1);
        Test.StopTest();
    }
    
}