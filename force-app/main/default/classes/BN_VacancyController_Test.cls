@isTest
private class BN_VacancyController_Test {

    private static void insertVacancyRecords(Integer y){
        for(Integer x = 0; x < y; x++){
            Vacancy__c v = new Vacancy__c(
                Name ='Vacancy '+ x, 
                Intro__c='Something',
                DetailBannerArt__c='https://d1b89zc79exfxt.cloudfront.net/img/Account_Executives.png',
                IconArt__c='https://d1b89zc79exfxt.cloudfront.net/img/career-monitor.png',
                Description__c='Something',
                Order__c = x,
                OtherInformation__c = 'Other information',
                Qualifications__c = 'Qualifications',
                Overview__c = 'Overview',
                IsOpen__c = (Math.mod(x, 2) > 0)
            );

            insert v;
        }
    }
    
    @isTest static void testGetVacanciesMethod() 
    {
        insertVacancyRecords(10);

        List<Vacancy__c> vacancies = BN_VacancyController.getVacancies();
        System.assertEquals(vacancies.size(), 5); // only open requests are returned.        
    }
    
    @isTest static void testGetSingleVacancyMethod() 
    {
        insertVacancyRecords(3);
        Vacancy__c v = [SELECT Id, Name FROM Vacancy__c LIMIT 1];

        Vacancy__c vacancy = BN_VacancyController.getSingleVacancy(v.Id);
        System.assert(vacancy != null);
        if(vacancy != null){
            System.assertEquals(vacancy.Name, v.Name);
        }
    }

    @isTest static void testSubmitApplication(){
        insertVacancyRecords(3);
        List<Vacancy__c> vacancies = BN_VacancyController.getVacancies();

        BN_VacancyController.submitApplication(new Career__c(
            Name__c = 'Kolade Ige', 
            RelatedVacancy__c = vacancies[0].Id, 
            Email__c = 'kolade.ige@gmail.com',
            Phone__c = '08088473115',
            LinkedIn__c = 'https://www.linkedin.com/in/koladeige/')
        );

        Career__c career = [SELECT Name, Id, RelatedVacancy__c FROM Career__c LIMIT 1];
        System.assert(career != null);
        if(career != null){
            System.assertEquals(vacancies[0].Id, career.RelatedVacancy__c);
        }
    }
    
}