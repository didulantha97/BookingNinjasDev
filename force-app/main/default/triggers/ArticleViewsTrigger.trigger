trigger ArticleViewsTrigger on Article_Views__c (before insert, after insert) {
	// assign the article view to the article object, author: teguh@bookingninjas.com
    if (Trigger.isBefore && Trigger.isInsert) {
        for (Article_Views__c av : Trigger.New) {
            if (av.ArticleId__c != null) {
                Article__c article = [SELECT Id FROM Article__c WHERE Id = :av.ArticleId__c LIMIT 1];
                Trigger.New[0].Article__c = article.Id;
            }
        }
    }
    
    // remove duplicate view from single visitor (ip address)
    // update total article view record, author: teguh@bookingninjas.com
    if (Trigger.isAfter && Trigger.isInsert) {
        for (Article_Views__c av : Trigger.New) {
            List<Article_Views__c> avs = [SELECT Id FROM Article_Views__c WHERE ArticleId__c = :av.ArticleId__c AND IP_Address__c = :av.IP_Address__c];
            if (avs.size() > 1) {
                delete [SELECT Id FROM Article_Views__c WHERE Id IN :Trigger.New];
            } else {
                Article__c article = [SELECT Id FROM Article__c WHERE Id = :av.Article__c LIMIT 1];
                List<Article_Views__c> articleAvs = [SELECT Id FROM Article_Views__c WHERE ArticleId__c = :article.Id];
                article.Total_Views__c = articleAvs.size();
                update article;
            }
        }
    }
}