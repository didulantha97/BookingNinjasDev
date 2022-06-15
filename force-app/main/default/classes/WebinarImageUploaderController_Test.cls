@isTest
public class WebinarImageUploaderController_Test {
	@isTest static void test01(){
        Webinar__c webinar = new Webinar__c(Name = 'Webinar 1', 
                           Category__c = 'Booking Ninjas', 
                           Webinar_Start__c = System.now().addDays(5).addHours(1), 
                           Webinar_End__c = System.now().addDays(5).addHours(2), 
                           Hosted_By__c = 'David Harroch, CEO of Booking Ninjas', Short_Description__c = 'Test message', Long_Description__c = 'Long message here', 
                           Recording_URL__c = 'https://www.youtube.com/watch?v=cff2_gEO8PE');
                               
        insert webinar;
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        ContentVersion contentVersion_1 = new ContentVersion(
            Title='Header_Picture1', 
            PathOnClient ='/Header_Picture1.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert contentVersion_1;
       
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = webinar.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        
        WebinarImageUploaderController.updatePicturePath(webinar.id);
        
        System.assertEquals(documents.size(), 1);
        System.assertEquals(documents[0].Id, contentVersion_2.ContentDocumentId);
        System.assertEquals(documents[0].LatestPublishedVersionId, contentVersion_2.Id);
        System.assertEquals(documents[0].Title, contentVersion_2.Title);
        System.assertEquals(contentlink.ContentDocumentId,contentVersion_2.ContentDocumentId );
        
        documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        delete documents;
    }
}