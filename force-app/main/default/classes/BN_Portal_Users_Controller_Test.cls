@isTest
public class BN_Portal_Users_Controller_Test
{
    @testSetup static void posSetup() {
        BN_DataTest.createDataTest(true, true);
    }
    
    public static testMethod void testItShould() 
    {
        String bnUserId;

        List<BN_User__c> bnUsers = [SELECT Id, Username__c, Password__c FROM BN_User__c LIMIT 1];
        if (bnUsers.size() > 0)
        {
            BN_Portal_UserUtils.login(bnUsers[0].Username__c, bnUsers[0].Password__c);
        
            bnUserId = BN_Portal_UserUtils.getCurrBNUserId();
        }
        
        PageReference pageRef = Page.BN_Portal_Users;
        Test.setCurrentPage(pageRef);
        
        BN_Portal_Users_Controller ctrl = new BN_Portal_Users_Controller();
        
        ctrl.contact = BN_Portal_UserUtils.getContactByBNUserId(bnUserId);
        
        List<User__c> users = [SELECT Id FROM User__c];
        ctrl.users = users;
        
        ctrl.name = 'Dave Harroch';
        ctrl.email = 'david@bookingninjas.com';
        ctrl.phone = '+19176002345';
        ctrl.dateOfActivation = Date.Today().addDays(7);
        ctrl.addUserRequest();
    }
}