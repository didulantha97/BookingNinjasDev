public class WebinarImageUploaderController {
    
	@AuraEnabled
    public static void updatePicturePath(String recId){  
        //In lighting, the attachments are stored in content documents
        ContentDocumentLink docLink = [ SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recId order by Id desc LIMIT 1]; 
        //ContentVersion Id uniquely identifies the attachment
        ContentVersion version = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :docLink.ContentDocumentId];
        
        Webinar__c topic = [Select Id From Webinar__c Where Id =: recId];
        topic.Image_Path__c = URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + version.Id;
        update topic;
    }
}