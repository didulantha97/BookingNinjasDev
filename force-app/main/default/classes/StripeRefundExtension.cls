public class StripeRefundExtension {

    public String recordId {get;  set;}
    public Stripe_Transaction__c trans {get; set;}
    public Decimal amount {get; set;}
    
    public StripeRefundExtension(ApexPages.StandardController controller)
    {
        //recordId = (String)controller.getRecord().id;
        recordId = ApexPages.currentPage().getParameters().get('id');
        
        trans = getTransaction(recordId);
        if(trans != null) {
            amount = trans.Total_Amount__c;
        }
    }
    
    private Stripe_Transaction__c getTransaction(string id)
    {
        return [SELECT Id, Stripe_Transaction_Id__c, Total_Amount__c, Description__c, Receipt_URL__c, Status__c, Guest_Contact__r.Name  FROM Stripe_Transaction__c Where  Id = :id];
    }
    
    public void doRefund()
    {
        String errorMessage;
        
        if(String.isNotBlank(trans.Stripe_Transaction_Id__c))
        {
            Integer amountToRefund = Integer.valueOf(amount * 100);
            HttpResponse response = StripeService.getRefund(trans.Stripe_Transaction_Id__c, amountToRefund);
            //Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            
            if(response.getStatusCode() == 200) 
            {                
                //String parentTransactionId = (String)m.get('id');
                String parentTransactionId = trans.Stripe_Transaction_Id__c;
                
                // update status
                trans.Status__c = amount == trans.Total_Amount__c ? 'Refunded' : 'Partial Refund';
                update trans;
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Transaction successfully refunded! Stripe transaction id : ' + parentTransactionId));
            } 
            else
            {
                //errorMessage = (String)m.get('message');
                errorMessage = 'Please try again.';
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Error making Stripe refund: ' + errorMessage));
            }          
        }
        else 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Stripe Transaction Id is missing!'));
        }
    }
}