trigger ContentDocTrigger on ContentDocument (before delete) {
    
    if(trigger.isbefore &&trigger.isdelete){
        Set<id> cdocid = new Set<id>();
        Set<id> clinkparids = new Set<id>();
        for(ContentDocument cd : trigger.old){
           cdocid.add(cd.id); 
        }
        
        list<ContentDocumentLink> clinks = [select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where ContentDocumentId IN :cdocid];
        for(ContentDocumentLink cl : clinks){
            clinkparids.add(cl.LinkedEntityId);
        }
        
        List<Webinar__c> webinarList = [select id, Image_Path__c, (select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLinks) from Webinar__c where id IN :clinkparids];
        for(Webinar__c webObj : webinarList){
            webObj.Image_Path__c = '';
        }
        update webinarList;
    }
}