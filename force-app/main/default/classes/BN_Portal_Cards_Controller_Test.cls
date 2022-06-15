@isTest
public class BN_Portal_Cards_Controller_Test
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
        
        PageReference pageRef = Page.BN_Portal_Cards;
        Test.setCurrentPage(pageRef);
        
        BN_Portal_Cards_Controller ctrl = new BN_Portal_Cards_Controller();
        
        ctrl.contact = BN_Portal_UserUtils.getContactByBNUserId(bnUserId);
        
        // cards
        List<Card__c> cards = [SELECT Id FROM Card__c];
        if(cards.size() > 0) ctrl.cardId = cards[0].Id;
        
        ctrl.cards = cards;
        ctrl.deleteCard();
        
        ctrl.cardName = 'Dave Harroch';
        ctrl.cardNumber = '4242424242424242';
        ctrl.cardCvv = '123';
        ctrl.cardExpDate = '06 / 2022';
        
        ctrl.addCard();
        
        
        // checks
        List<Check__c> checks = [SELECT Id FROM Check__c];
        if(checks.size() > 0) ctrl.checkId = checks[0].Id;
        
        ctrl.checks = checks;
        ctrl.deleteCheck();
        
        ctrl.nameOnAccount = 'David Harroch';
        ctrl.bankRoutingNumber = '123456789';
        ctrl.checkingAccountNumber = '123456789';
        ctrl.issuingBank = 'Bank of America';
        
        ctrl.addCheck();
    }
}