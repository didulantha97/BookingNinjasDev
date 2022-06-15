@isTest
private with sharing class CardServiceTest {
    @isTest
    static void createCardRecordTest() {
        Test.startTest();
        Account testAcc = new Account(Name='TestAcc');
        insert testAcc;

        Contact testCont = new Contact(
            FirstName='TestFirst',
            LastName='TestLast',
            Email='test@email.com',
            AccountId=testAcc.Id
        );
        insert testCont;

        List<EsignEmbedService.FieldValue> fieldVals = new List<EsignEmbedService.FieldValue>{
            new EsignEmbedService.FieldValue('text','Signer Name','Test User'),
            new EsignEmbedService.FieldValue('text','Card Number','0001123400011234'),
            new EsignEmbedService.FieldValue('text','Expiration Year','25'),
            new EsignEmbedService.FieldValue('text','Expiration Month','10')
        };

        CardService.createCardRecord(fieldVals, testCont.Id);
        Test.stopTest();

        System.assert([SELECT Card_Holder__c FROM Card__c WHERE Card_Holder__c='Test User'].size()>0, 'Card record has not been inserted!');
    }
}