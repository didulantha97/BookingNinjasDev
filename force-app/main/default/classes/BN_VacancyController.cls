public without sharing class BN_VacancyController {    
    @AuraEnabled(cacheable=true)
    public static Vacancy__c getSingleVacancy(String vacancyId) {
        return [
            SELECT OwnerId,Id,Name,VacancyID__c,Intro__c, Description__c,OtherInformation__c,Overview__c,Qualifications__c,Questions__c 
            FROM Vacancy__c 
            WHERE Id =: vacancyId
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Vacancy__c> getVacancies() {
        return [
            SELECT Id,Name,VacancyID__c,Intro__c,IconArt__c
            FROM Vacancy__c
            WHERE IsOpen__c =: TRUE   
            ORDER BY Order__c       
        ];
    }

    @AuraEnabled
    public static String submitApplication(Career__c career) 
    {
        BN_VacancyController.APIResponse response = new BN_VacancyController.APIResponse();
        response.Status = 'success';

        Vacancy__c vacancy = [SELECT Id, OwnerId FROM Vacancy__c WHERE Id =: career.RelatedVacancy__c];

        try{
            insert career;
            sendAcknowledgement(career);
        } catch (Exception e){
            response.Status = 'failure';
            response.Message = e.getMessage();
        }

        return JSON.serialize(response);
    }

    private static void sendAcknowledgement(Career__c career){
        EmailTemplate lstEmailTemplates = [SELECT Id, Body, Markup, HtmlValue, Subject, EnhancedLetterheadId, TemplateStyle, TemplateType, RelatedEntityType, BrandTemplateId, Encoding FROM EmailTemplate WHERE DeveloperName = 'BN_CareerApplicationConfirmation' LIMIT 1];
        Vacancy__c vacancy = [SELECT Id, OwnerId FROM Vacancy__c WHERE Id =: career.RelatedVacancy__c LIMIT 1];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(lstEmailTemplates.Id);
        mail.setSaveAsActivity(false);
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setTargetObjectId(vacancy.OwnerId); // Any contact or User id of your record
        mail.setToAddresses(new list<string>{career.Email__c});

        mail.setWhatId(career.Id); // Enter your record Id whose merge field you want to add in template
        Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
    }

    class APIResponse {
        public String Status = 'failure';
        public String Message = '';
        public String MessageCode = '';
        public object OtherInfo = null;        
    }
}