@isTest(seealldata = true)
public class BN_CareerController_Test {
    
    public static Career__c career;
    
    static 
    {
        createTestData();
    }
    
    public static void createTestData() 
    {
        career = new Career__c();
        career.Name__c = 'David Harroch';
        career.Phone__c = '+19176002345';
        career.Email__c  = 'david@bookingninjas.com';
        career.Linkedin__c = '';
        career.Position__c = 'Salesforce Admin';
        insert career;
    }
    
    public static testMethod void testApplyCareerViaModal() 
    {
        Test.startTest();
        
            PageReference pageRef = Page.BN_Career;
            Test.setCurrentPage(pageRef);

            BN_CareerController ctrl = new BN_CareerController();
            
            ctrl.getPositionList();
            ctrl.name = 'Joe Johnson';
            ctrl.phone = '0987654321';
            ctrl.email = 'joee@johnson.com';
            ctrl.linkedin = 'linkedin.com/joe';
            ctrl.position = 'Salesforce Developer';
            ctrl.register(); 
            
        Test.stopTest();
    }
    
    public static testMethod void testApplyCareerViaPage() 
    {
        Test.startTest();
        
            PageReference pageRef = Page.BN_CareerLeadForm;
            Test.setCurrentPage(pageRef);

            BN_CareerController ctrl = new BN_CareerController();
            
            ctrl.getPositionList();
            ctrl.name = 'Joe Johnson';
            ctrl.phone = '0987654321';
            ctrl.email = 'joee@johnson.com';
            ctrl.linkedin = 'linkedin.com/joe';
            ctrl.position = 'Salesforce Developer';
            ctrl.register(); 
            
        Test.stopTest();
    }
}