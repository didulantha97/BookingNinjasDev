@isTest
public class BN_Portal_Account_Controller_Test
{
    @testSetup static void posSetup() {
        BN_DataTest.createDataTest(true, true);
    }
    
    public static testMethod void testItShould() 
    {
        String bnUserId;
        String userRole;
        
        BN_Portal_UserUtils.isLogout();
        
        List<BN_User__c> bnUsers = [SELECT Id, Username__c, Password__c FROM BN_User__c LIMIT 1];
        if (bnUsers.size() > 0)
        {
            BN_Portal_UserUtils.login(bnUsers[0].Username__c, bnUsers[0].Password__c);
        
            bnUserId = BN_Portal_UserUtils.getCurrBNUserId();
            userRole = BN_Portal_UserUtils.getUserRole(bnUserId);

            BN_Portal_UserUtils.defaultLandingPage();
        }
        
        PageReference pageRef = Page.BN_Portal_Account;
        Test.setCurrentPage(pageRef);
        
        BN_Portal_Account_Controller ctrl = new BN_Portal_Account_Controller();
        
        ctrl.contact = BN_Portal_UserUtils.getContactByBNUserId(bnUserId);
        
        String conId = ctrl.contact.Id;
        List<Opportunity> opportunities = [SELECT Id, Name, Account.Name, StageName, CloseDate FROM Opportunity WHERE Primary_Contact__c = :conId];
        if(opportunities.size() > 0) ctrl.opportunities = opportunities;
        
        // logout
        BN_Portal_UserUtils.logout();
    }
}