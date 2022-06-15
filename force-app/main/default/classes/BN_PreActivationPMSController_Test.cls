@isTest(seealldata = true)
public class BN_PreActivationPMSController_Test {

    public static PreActivation__c preActivation;
    
    static { createTestData(); }
    
    public static void createTestData() 
    {
        preActivation = new PreActivation__c();
        preActivation.Organization_Name__c = 'Test Org';
        preActivation.Contact1_Name__c = 'Test1Name';
        preActivation.Contact1_Email__c = 'test1@email.com';
        preActivation.Contact1_Phone__c = '123456789';
        preActivation.Contact2_Name__c = 'Test2Name';
        preActivation.Contact2_Email__c = 'test2@email.com';
        preActivation.Contact2_Phone__c = '123456789';
        preActivation.Contact3_Name__c = 'Test3Name';
        preActivation.Contact3_Email__c = 'test3@email.com';
        preActivation.Contact3_Phone__c = '123456789';
        preActivation.Number_of_units__c = 50;
        preActivation.Number_of_users__c = 10;
        preActivation.Property_Address__c = 'Miami Beach, Florida';
        preActivation.Property_Address_2__c = 'Miami Beach, Florida';
        preActivation.Property_Address_3__c = 'Miami Beach, Florida';
        preActivation.PMS_Requirements__c = 'Test Message';
        preActivation.Questions_about_product__c = 'Test Message';
        insert preActivation;
    }
    
    public static testMethod void testSubmit() 
    {
        PageReference pageRef = Page.BN_ActivationForm;
        Test.setCurrentPage(pageRef);
        
        BN_PreActivationPMSController ctrl = new BN_PreActivationPMSController();
        
        Test.startTest();
        
            ctrl.organizationName = 'Test Org';
            ctrl.contact1Name = 'Test1Name';
            ctrl.contact1Email = 'test1@email.com';
            ctrl.contact1Phone = '123456789';
            ctrl.contact2Name = 'Test2Name';
            ctrl.contact2Email = 'test2@email.com';
            ctrl.contact2Phone = '123456789';
            ctrl.contact3Name = 'Test3Name';
            ctrl.contact3Email = 'test3@email.com';
            ctrl.contact3Phone = '123456789';
            ctrl.numberOfUnits = 50;
            ctrl.numberOfusers = 10;
            ctrl.propertyAddress = 'Miami Beach florida';
            ctrl.propertyAddress2 = 'Miami Beach florida';
            ctrl.propertyAddress3 = 'Miami Beach florida';
            ctrl.pmsRequirements = 'Test message';
            ctrl.questionsAboutProduct = 'Test message';
            ctrl.register();
        
        Test.stopTest();
    }
}