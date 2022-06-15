@isTest
public class BN_Portal_ClientV2MOM_Controller_Test
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
        
        PageReference pageRef = Page.BN_Portal_ClientV2MOM;
        Test.setCurrentPage(pageRef);
        
        BN_Portal_ClientV2MOM_Controller ctrl = new BN_Portal_ClientV2MOM_Controller();
        
        ctrl.contact = BN_Portal_UserUtils.getContactByBNUserId(bnUserId);
        
        ctrl.vision = 'test vision';
        ctrl.values = 'test values';
        ctrl.methods = 'test methods';
        ctrl.obstacles = 'test obstacles';
        ctrl.measures = 'test measures';
        ctrl.saveV2MOM();
    }
}