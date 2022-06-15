trigger CardTrigger on Card__c (before insert, before update, after insert, after update) {

    // used by trial/pilot form, author: teguh@bookingninjas.com
    if( Trigger.isBefore && Trigger.isInsert ) {
        for( Card__c card : Trigger.New ) {
            if (card.trialEmail__c != null) {
                Contact contact = [SELECT Id, AccountId FROM Contact WHERE Email = :card.trialEmail__c LIMIT 1];
                Trigger.New[0].Contact__c = contact.Id;
                Trigger.New[0].trialEmail__c = null;
            }
        }
    }
    
    // used by trial/pilot form, author: teguh@bookingninjas.com
    // remove if current record is duplicate opportunity
    if (Trigger.isAfter && Trigger.isInsert) {
        for (Card__c card : Trigger.New) {
            List<Card__c> cards = [SELECT Id FROM Card__c WHERE Card_Number__c = :card.Card_Number__c];
            if (cards.size() > 1) {
                delete [SELECT Id FROM Card__c WHERE Card_Number__c = :card.Card_Number__c AND Id NOT IN :Trigger.New];
            }
        }
    }

}