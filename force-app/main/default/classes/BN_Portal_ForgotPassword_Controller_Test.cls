@isTest
public class BN_Portal_ForgotPassword_Controller_Test
{
    @testSetup static void posSetup() {
        BN_DataTest.createDataTest(true, true);
        
        Email_Subscription__c subscription= new Email_Subscription__c();
        subscription.Email__c  = 'david@bookingninjas.com';
        insert subscription;
    }
    
    @isTest
    static void itShould()
    {
        PageReference pageRef = Page.BN_Portal_ForgotPassword;
        Test.setCurrentPage(pageRef);
        
        BN_Portal_ForgotPassword_Controller ctr = new BN_Portal_ForgotPassword_Controller();
        ctr.emailRequest = 'david@bookingninjas.com';
        ctr.requestChangePassword();
        
        List<BN_User__c> bnUsers = [SELECT Id FROM BN_User__c LIMIT 1];
        if (bnUsers.size() > 0) {
            //bnUsers[0].Status__c = 'Request Change Password';
            //update beUsers[0];
            
            Apexpages.currentPage().getParameters().put('id', bnUsers[0].Id);
            ctr = new BN_Portal_ForgotPassword_Controller();
            
            ctr.newPassword = 'newPassword';
            ctr.submitNewPassword();
        }
    }
    
    @isTest
    static void testSubscribe() 
    {
        PageReference pageRef = Page.BN_Portal_ForgotPassword;
        Test.setCurrentPage(pageRef);
        
        BN_Portal_ForgotPassword_Controller ctrl = new BN_Portal_ForgotPassword_Controller();
        
        ctrl.email = 'joee@johnson.com';
        ctrl.subscribe();
    }
}