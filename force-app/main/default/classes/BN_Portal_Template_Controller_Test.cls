@isTest
public class BN_Portal_Template_Controller_Test
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
        String username;
        String password;
        List<BN_User__c> bnUsers = [SELECT Id, Username__c, Password__c FROM BN_User__c WHERE Role__c = 'Client' AND Status__c = 'Active'];
        if (bnUsers.size() > 0) {
            username = bnUsers[0].Username__c;
            password = bnUsers[0].Password__c;
        }
    
        PageReference pageRef = Page.BN_Portal_Home;
        Test.setCurrentPage(pageRef);
        
        BN_Portal_Template_Controller ctr = new BN_Portal_Template_Controller();
        
        ctr.page = ApexPages.currentPage().getUrl().substringAfter('/').split('\\?')[0];
        ctr.title = 'Best Hotel Management Software - Cloud-Based PMS | Booking Ninjas';
        ctr.description = 'The proper way to handle your property management today. Join our users and enjoy predictable growth';
        
        ctr.ref = Apexpages.currentPage().getUrl();
        
        Boolean isLogout = ctr.getIsLogout();
        ctr.checkUserLogin();
        ctr.redirectToLandingPage();
        
        if(isLogout)
        {
            ctr.username = username;
            ctr.password = password;
            ctr.login();
            ctr.getUserRole();
        }
        
        ctr.logoutPage();
    }
    
    @isTest
    static void passwordIncorrect()
    {
        String username;
        String password;
        List<BN_User__c> bnUsers = [SELECT Id, Username__c, Password__c FROM BN_User__c WHERE Role__c = 'Client' AND Status__c = 'Active'];
        if (bnUsers.size() > 0) {
            username = bnUsers[0].Username__c;
            password = bnUsers[0].Password__c;
        }
    
        PageReference pageRef = Page.BN_Portal_Home;
        Test.setCurrentPage(pageRef);
        
        BN_Portal_Template_Controller ctr = new BN_Portal_Template_Controller();
        
        Boolean isLogout = ctr.getIsLogout();
        
        if(isLogout)
        {
            ctr.username = username;
            ctr.password = 'wrongPassword';
            ctr.login();
        }
    }
    
    @isTest
    static void inactiveClient()
    {
        String username;
        String password;
        List<BN_User__c> bnUsers = [SELECT Id, Username__c, Password__c FROM BN_User__c WHERE Role__c = 'Client' AND Status__c = 'Inactive'];
        if (bnUsers.size() > 0) {
            username = bnUsers[0].Username__c;
            password = bnUsers[0].Password__c;
        }
    
        PageReference pageRef = Page.BN_Portal_Home;
        Test.setCurrentPage(pageRef);
        
        BN_Portal_Template_Controller ctr = new BN_Portal_Template_Controller();
        
        Boolean isLogout = ctr.getIsLogout();
        
        if(isLogout)
        {
            ctr.username = username;
            ctr.password = password;
            ctr.login();
        }
    }
    
    @isTest
    static void testSubscribe() 
    {
        PageReference pageRef = Page.BN_Portal_Template;
        Test.setCurrentPage(pageRef);
        
        BN_Portal_Template_Controller ctrl = new BN_Portal_Template_Controller();
        
        ctrl.email = 'joee@johnson.com';
        ctrl.subscribe();
    }
}