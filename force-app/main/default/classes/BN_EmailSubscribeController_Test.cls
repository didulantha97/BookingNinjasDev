@isTest(seealldata = true)
public class BN_EmailSubscribeController_Test {
    
    public static Email_Subscription__c subscription;
    
    static 
    {
        createTestData();
    }
    
    public static void createTestData() 
    {
        subscription= new Email_Subscription__c();
        subscription.Email__c  = 'david@bookingninjas.com';
        insert subscription;
    }
    
    public static testMethod void testSubscribe() 
    {
        Test.startTest();
        
            PageReference pageRef = Page.BN_LP_Club;
            Test.setCurrentPage(pageRef);

            BN_EmailSubscribeController ctrl = new BN_EmailSubscribeController();
            
            ctrl.email = 'joee@johnson.com';
            ctrl.subscribe(); 
                  
        Test.stopTest();
        
    }
    
    public static testMethod void testLowestPrices(){
        Test.startTest();
        	BN_EmailSubscribeController ctrl2 = new BN_EmailSubscribeController();
        	ctrl2.getLowestSpanishPrice();
        	ctrl2.getLowestEnglishPrice();
        Test.stopTest();
    }

}