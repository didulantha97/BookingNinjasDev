public without sharing class BN_VacancyPageController {
    private final Vacancy__c vacancy;    
    public Career__c career {get; set;}
        
    public BN_VacancyPageController(){      
        vacancy = [
            SELECT Id,DetailBannerArt__c,Name,VacancyID__c,Intro__c, Description__c,OtherInformation__c,Overview__c,Qualifications__c,Questions__c 
            FROM Vacancy__c 
            WHERE Id =: ApexPages.currentPage().getParameters().get('id')
        ];     
    }

    public String getRoleName(){
        if(vacancy.Name != null) {
            return vacancy.Name;
        }
        return '';
    }

    public String[] getOverview(){
        if(vacancy.Overview__c != null){
            return vacancy.Overview__c.split('[\n\r]+');
        }
        return new String[]{};
    }

    public String[] getDescription(){
        if(vacancy.Description__c != null){
            return vacancy.Description__c.split('[\n\r]+');
        }
        return new String[]{};
    }

    public String getIntro(){
        if(vacancy.Intro__c != null){
            return vacancy.Intro__c;
        }
        return '';
    }

    public String[] getQualifications(){
        if(vacancy.Qualifications__c != null){
            return vacancy.Qualifications__c.split('[\n\r]+');
        }
        return new String[]{};
    }

    public String[] getQuestions(){
        if(vacancy.Questions__c != null){
            return vacancy.Questions__c.split('[\n\r]+');
        }
        return new String[]{};
    }

    public String getOtherInformation(){
        if(vacancy.OtherInformation__c != null){
            return vacancy.OtherInformation__c;
        }
        return '';
    }

    public String getVacancyID(){
        return vacancy.VacancyID__c;
    }

    public String getDetailArt(){
        if(vacancy.DetailBannerArt__c == null){
            return 'https://d1b89zc79exfxt.cloudfront.net/img/career-bnr1.png';
        }
        
        return vacancy.DetailBannerArt__c;
    }

    public Vacancy__c getVacancy() {
        return vacancy;
    }
}