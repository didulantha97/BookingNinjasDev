@isTest
private with sharing class EmbedESignPopupControllerTest {
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
    static void getEmbedSessionURLTest_Positive() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockEsignGenieHttpResponseGenerator());
        String embedURL = EmbedESignPopupController.getEmbedSessionURL([SELECT Id, CloseDate FROM Opportunity WHERE CloseDate=:System.today().addDays(35) LIMIT 1].Id);
        Test.stopTest();

        System.assertEquals(
            'UNIQUE_EMBEDDED_SESSION_URL',
            embedURL,
            'Unexpected embedded session URL from invokeCreateFolderRequest function'
        );
    }

    @isTest
    static void getEmbedSessionURLTest_Negative() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockEsignGenieHttpResponseGenerator());
        String embedURL;
        try{
            embedURL = EmbedESignPopupController.getEmbedSessionURL(null);
        } catch(Exception e){}
       
        Test.stopTest();

        System.assertEquals(
            null,
            embedURL,
            'Unexpected embedded session URL from invokeCreateFolderRequest function'
        );
    }

    @isTest
    static void attachDocumentTest_Positive() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockEsignGenieHttpResponseGenerator());
        Id oppId = [SELECT Id, CloseDate FROM Opportunity WHERE CloseDate=:System.today().addDays(35) LIMIT 1].Id;
        Id contId = [SELECT Id FROM Contact WHERE LastName ='TestLast' LIMIT 1].Id;
        
        EmbedESignPopupController.attachDocument(oppId, contId, 100);
        Test.stopTest();

        System.assertEquals(
            [SELECT Id FROM Attachment].size(),
            2,
            'There is no attachment inserted!'
        );
    }

    @isTest
    static void attachDocumentTest_Negative() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockEsignGenieHttpResponseGenerator());
        Id contId = [SELECT Id FROM Contact WHERE LastName ='TestLast' LIMIT 1].Id;
        try {
            EmbedESignPopupController.attachDocument(null, contId, 100);
        } catch(Exception e) {}
        
        Test.stopTest();

        System.assert(
            [SELECT Id FROM Attachment].isEmpty(),
            'Attachments found in negative test!'
        );
    }

    @isTest
    static void getOppTest(){
        Test.startTest();
        Id oppId = [SELECT Id, CloseDate FROM Opportunity WHERE CloseDate=:System.today().addDays(35) LIMIT 1].Id;
        Opportunity opp = EmbedESignPopupController.getOpp(oppId);
        Test.stopTest();
        System.assertEquals(oppId, opp.Id, 'Unexpected result for the opportunity!');
    }

}