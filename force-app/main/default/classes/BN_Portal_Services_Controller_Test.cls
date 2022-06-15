@isTest
public class BN_Portal_Services_Controller_Test
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
        
        PageReference pageRef = Page.BN_Portal_Services;
        Test.setCurrentPage(pageRef);
        
        BN_Portal_Services_Controller ctrl = new BN_Portal_Services_Controller();
        
        ctrl.contact = BN_Portal_UserUtils.getContactByBNUserId(bnUserId);
        
        List<Service__c> services = [SELECT Id FROM Service__c];
        ctrl.services = services;
        ctrl.getProductsAndServices();
        
        List<Product2> products = [SELECT Id FROM Product2];
        if(products.size() > 0) ctrl.productId = products[0].Id;
        ctrl.getProduct();
        
        ctrl.serviceRequest = 'Service';
        ctrl.description = 'Service Description';
        ctrl.price = 100;
        ctrl.quantity = 1;
        ctrl.addServiceRequest();
    }
}