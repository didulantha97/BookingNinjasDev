public    class EmbedESignPopupController {
    @AuraEnabled
    public static String getEmbedSessionURL(Id recordId) {
        try {
            ESignEmbedService service = new ESignEmbedService();
            return service.invokeCreateFolderRequest(recordId);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static void attachDocument(Id recordId, Id contId, Integer folderId){
        try {
            ESignEmbedService service = new ESignEmbedService();
            service.checkDocSign(recordId, contId, folderId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Opportunity getOpp(Id recordId){
        try {
            return [SELECT Id, Primary_Contact__c, ESignGenie_FolderId__c FROM Opportunity WHERE Id =:recordId ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


}