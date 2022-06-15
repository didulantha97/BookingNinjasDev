public with sharing class PublishArticleService {

    public void process(List<Article__c> articleList) {
    
        Set<Id> articleIds = new Set<Id>();
        for(Article__c a : articleList) {
            articleIds.add(a.Id);
        }
        
        Map<Id, Article__c> mappedArticles = new Map<Id, Article__c>([SELECT Id, Name, Publish__c, Is_Main_Article__c FROM Article__c WHERE Id IN :articleIds]);
        Map<Id, Article__c> articles_to_update = new Map<Id, Article__c>();
        
        for(Article__c a : articleList) 
        {
            Article__c article = mappedArticles.get(a.Id);
            if(article != null)
            {
                // instantiate date today
                DateTime dT = System.now();
                Date dateToday = date.newinstance(dT.year(), dT.month(), dT.day());
                
                // instantiate new article list to update
                List<Article__c> mainArticles_to_update = new List<Article__c>();
                
                // check if it is a main publish article
                if(article.Is_Main_Article__c == true)
                {
                    // perform loop on existing main articles to be deactivated
                    List<Article__c> articles = [SELECT Id, Is_Main_Article__c FROM Article__c WHERE Is_Main_Article__c = true AND Scheduled_Publish_Date__c < :dateToday];
                    for(Article__c ar : articles)
                    {
                        ar.Is_Main_Article__c = false;
                        mainArticles_to_update.add(ar);
                    }
                    
                    if(mainArticles_to_update.size() > 0)
                        update mainArticles_to_update;
                }
                
                // set title
                String title = article.Name.replace(' ', '-').toLowerCase();
                
                article.Publish__c = true;
                article.Article_Link__c = 'https://www.bookingninjas.com/blog/' + title;
                articles_to_update.put(article.Id, article);
            }
            continue;
        }

        try 
        {
            // update list
            update articles_to_update.values();
        }
        catch(DMLException e) {
            system.debug('Records were not all properly updated.  Error: '+ e);
        }
    }
}