/*****************************************************************************************
 * @Purpose      : Controller extension for StripeManualCharge page
 * @Created Date : 10 June 2019
 * @Author       : Madhura Priyadarshana 
 *****************************************************************************************/ 
public class StripeManualChargeExtension {

    public Contact con {get; set; }
    public Map<Id, Card__c> cards {get; set; }
    public String selectedCardId {get; set; }
    public Boolean serviceChargeIncluded { get; set; }
    public Stripe_Transaction__c stripeTransaction { get; set; }
    
    public StripeManualChargeExtension(ApexPages.StandardController ctrl) {
      con = [SELECT Id, Stripe_Id__c, Name FROM Contact WHERE Id =: ctrl.getId()];
        cards = new Map<Id, Card__c>([SELECT Id, Name, Card_Number__c, Stripe_Id__c FROM Card__c WHERE Contact__c =: con.Id]);
        serviceChargeIncluded = false;
        stripeTransaction = new Stripe_Transaction__c(Guest_Contact__c = con.Id);
    }
    
    /*  This is obsolete as picking a card and proceed to payment is not possible
     * public List<SelectOption> getCardPicklist() {
        List<SelectOption> cardList = new List<SelectOption>();
        cardList.add(new SelectOption('--None--', '--None--'));
        for(Card__c card : cards.values()) {
            cardList.add(new SelectOption(card.Id, (card.Name + card.Card_Number__c.substring(0,3))));
        }
        
        return cardList;
    }*/
    
    public void chargeCustomer() {
        List<Stripe_Transaction__c> transactionList = new List<Stripe_Transaction__c>();
        String strAmount = String.valueOf(this.stripeTransaction.Total_Amount__c * 100).substringBefore('.');
        String errorMessage;
        
        if(String.isNotBlank(strAmount)) {
            HttpResponse response = StripeService.chargeByCustomer(strAmount, this.stripeTransaction.Description__c, con.Stripe_Id__c);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            
            if(response.getStatusCode() == 200) {                
                String parentTransactionId = (String)m.get('id');                
                
                if(this.serviceChargeIncluded) {            
                    Decimal serviceCharge = this.stripeTransaction.Total_Amount__c * 0.035;
                    String strServiceCharge = String.valueOf(serviceCharge * 100).substringBefore('.'); // represting the amount in cents to support Stripe formt
                    HttpResponse serviceChargeResponse = StripeService.chargeByCustomer(strServiceCharge,  'CC fee', con.Stripe_Id__c);
                    Map<String, Object> mCC = (Map<String, Object>)JSON.deserializeUntyped(serviceChargeResponse.getBody());
                    System.debug('cc response : ' + serviceChargeResponse);
                    System.debug('cc response map : ' + mCC);
                    Stripe_Transaction__c ccTransaction = new Stripe_Transaction__c(
                        Guest_Contact__c = con.Id,
                        Stripe_Transaction_Id__c = (String)mCC.get('id'),
                        Receipt_URL__c = (String)mCC.get('receipt_url'),
                        Description__c = 'CC fee',
                        Total_Amount__c = serviceCharge
                    );
                    
                    transactionList.add(ccTransaction);
                }
                
                this.stripeTransaction.Stripe_Transaction_Id__c = parentTransactionId;
                stripeTransaction.Receipt_URL__c = (String)m.get('receipt_url');
                transactionList.add(stripeTransaction);
                
                insert transactionList;
                this.stripeTransaction = new Stripe_Transaction__c(Guest_Contact__c = con.Id);
                this.serviceChargeIncluded = false;
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Transaction successful! Stripe transaction id : ' + parentTransactionId));
            } else {
                errorMessage = (String)m.get('message');
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error making Stripe charge : ' + errorMessage));
            }
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please enter a valid amount'));
        }
    }
}