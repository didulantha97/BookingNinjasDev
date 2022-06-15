@isTest private class BN_VacancyPageController_Test {
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

    @isTest static void testVacancyIsLoadedBasedOnIdParameter(){
        insertVacancyRecords(5);
        Vacancy__c v = [SELECT Id, Name, VacancyID__c FROM Vacancy__c LIMIT 1];
        Pagereference reference = Page.BN_Career_Detail;

        reference.getParameters().put('id', v.Id);
        Test.setCurrentPage(reference);

        BN_VacancyPageController controller = new BN_VacancyPageController();
        System.assertEquals(v.VacancyID__c, controller.getVacancyID());
    }
}