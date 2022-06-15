trigger StripeTransactionTrigger on Stripe_Transaction__c (before insert, before update, after insert, after update) {

    // used by trial/pilot form, author: teguh@bookingninjas.com
    if( Trigger.isBefore && Trigger.isInsert ) {
        for( Stripe_Transaction__c st : Trigger.New ) {
            if (st.trialEmail__c != null) {
                Contact contact = [SELECT Id, AccountId FROM Contact WHERE Email = :st.trialEmail__c LIMIT 1];
                Trigger.New[0].Guest_Contact__c = contact.Id;
                Trigger.New[0].trialEmail__c = null;
            }
        }
    }
    
}