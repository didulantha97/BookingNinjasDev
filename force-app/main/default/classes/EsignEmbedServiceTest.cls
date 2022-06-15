@isTest
private with sharing class EsignEmbedServiceTest {
    @testSetup 
    static void setup() {
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

        insert new Opportunity(
            Name='TestOpp',
            AccountId=testAcc.Id, 
            Primary_Contact__c=testCont.Id,
            StageName='Working',
            CloseDate=System.today().addDays(35)
        );

        insert new eSign_Embed_Config__c(
            API_key__c = 'TEST_KEY',
            API_Secret__c = 'TEST_SECRET'
        );

        Test.stopTest();       
    }

    @isTest
    static void setAccessTokenTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockEsignGenieHttpResponseGenerator());
        EsignEmbedService service = new EsignEmbedService();
        service.setAccessToken();
        Test.stopTest();

        System.assertEquals(
            'test_access_token',
            service.accessToken,
            'Unexpected access token from EsignEmbedService.setAccessToken'
            );
    }

    @isTest
    static void invokeCreateFolderRequestTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockEsignGenieHttpResponseGenerator());
        EsignEmbedService service = new EsignEmbedService();
        String embedURL = service.invokeCreateFolderRequest([SELECT Id, CloseDate FROM Opportunity WHERE CloseDate=:System.today().addDays(35) LIMIT 1].Id);        
        Test.stopTest();

        System.assertEquals(
            'UNIQUE_EMBEDDED_SESSION_URL',
            embedURL,
            'Unexpected embedded session URL from invokeCreateFolderRequest function'
        );
    }

    @isTest
    static void checkDocSignTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockEsignGenieHttpResponseGenerator());
        EsignEmbedService service = new EsignEmbedService();
        Id oppId = [SELECT Id, CloseDate FROM Opportunity WHERE CloseDate=:System.today().addDays(35) LIMIT 1].Id;
        Id contId = [SELECT Id FROM Contact WHERE LastName ='TestLast' LIMIT 1].Id;
        service.checkDocSign(oppId, contId, 100);        
        Test.stopTest();

        System.assertEquals(
            [SELECT Id FROM Attachment].size(),
            2,
            'There is no attachment inserted!'
        );
    }
}