public with sharing class InvoicePaymentController {
    
    public String quoteId {get; set;}
    public Quote quote {get; set;}
    public List<QuoteLineItem> quoteLineItems {get; set;}
    public Stripe_Transaction__c stripeTransaction { get; set; }
    public Opportunity opp {get; set;}
    
    public Decimal amount {get; set;}
    public String email {get; set;}
    public Boolean serviceChargeIncluded { get; set; }
    
    public String cardNumber {get; set;}
    public String cardExpiration {get; set;}
    public String cardCvv {get; set;}

    public InvoicePaymentController() 
    {
        quoteId = ApexPages.currentPage().getParameters().get('id');       
        System.Debug('Quote Id: ' + quoteId);
        if(quoteId != null) {
            system.debug('inside');
            quote = [SELECT Id, QuoteNumber, ExpirationDate, Opportunity.Id, Account.Name, Contact.Id, Contact.Name, Contact.Email, Contact.Email_2__c, Contact.Phone, Grand_Total__c, Total_Paid_Amount__c, Downpayment__c, Balance_Due_Amount__c, Stripe_Id__c, Monthly_Price__c, One_Time_Payment__c, Effective_Date__c FROM Quote WHERE Id = :quoteId LIMIT 1];
            system.debug('currentQuote' + quote);
            if(quote != null) {
                quoteLineItems = [SELECT Id, Product2.Name, Quantity, UnitPrice, TotalPrice, Notes__c FROM QuoteLineItem WHERE QuoteId = :quote.Id];
                opp = [SELECT Id, Total_Paid_Amount__c FROM Opportunity WHERE Id = :quote.Opportunity.Id];
                
               amount = (quote.One_Time_Payment__c * (quote.Downpayment__c/100)).setScale(2);
            }
            
            stripeTransaction = new Stripe_Transaction__c(Guest_Contact__c = quote.Contact.Id);
            
            serviceChargeIncluded = false;
            
            cardNumber = '';
            cardExpiration = '';
            cardCvv = '';
        }
    }
    
    public PageReference createToken()
    {    
        // trim card expiration
        String cardExpMonth = cardExpiration.substring(0, 2);
        String cardExpYear = cardExpiration.substring(5);

        //  first create card token
        String cardToken = StripeService.createCardToken(cardNumber, cardExpMonth, cardExpYear, cardCvv);
        System.Debug('Token: ' + cardToken);
        if(!String.isEmpty(cardToken))
        {
            chargeByCard(cardToken);
            
            // redirect to thank you  page
            PageReference pageRef = new PageReference('https://bookingninjas.gr8.com');
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }
    
    private void chargeByCard(String token) {
        List<Stripe_Transaction__c> transactionList = new List<Stripe_Transaction__c>();
        String strAmount = String.valueOf(amount * 100).substringBefore('.');
        String errorMessage;
        
        if(String.isNotBlank(strAmount)) {
            HttpResponse response = StripeService.chargeByCard(strAmount, String.valueOf(quote.QuoteNumber), token);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            
            if(response.getStatusCode() == 200) {                
                String parentTransactionId = (String)m.get('id');                
                
                if(this.serviceChargeIncluded) {            
                    Decimal serviceCharge = amount * 0.035;
                    String strServiceCharge = String.valueOf(serviceCharge * 100).substringBefore('.'); // represting the amount in cents to support Stripe formt
                    HttpResponse serviceChargeResponse = StripeService.chargeByCard(strServiceCharge,  'CC fee', token);
                    Map<String, Object> mCC = (Map<String, Object>)JSON.deserializeUntyped(serviceChargeResponse.getBody());
                    System.debug('cc response : ' + serviceChargeResponse);
                    System.debug('cc response map : ' + mCC);
                    Stripe_Transaction__c ccTransaction = new Stripe_Transaction__c(
                        Guest_Contact__c = quote.Contact.Id,
                        Stripe_Transaction_Id__c = (String)mCC.get('id'),
                        Receipt_URL__c = (String)mCC.get('receipt_url'),
                        Description__c = 'CC fee',
                        Total_Amount__c = serviceCharge
                    );
                    
                    transactionList.add(ccTransaction);
                }
                
                this.stripeTransaction.Stripe_Transaction_Id__c = parentTransactionId;
                this.stripeTransaction.Total_Amount__c = amount;
                this.stripeTransaction.Description__c = quote.QuoteNumber;
                stripeTransaction.Receipt_URL__c = (String)m.get('receipt_url');
                transactionList.add(stripeTransaction);
                
                insert transactionList;
                this.stripeTransaction = new Stripe_Transaction__c(Guest_Contact__c = quote.Contact.Id);
                this.serviceChargeIncluded = false;
                
                // update quote
                quote.Total_Paid_Amount__c += amount;
                update quote;
                
                // update opportunity
                opp.Total_Paid_Amount__c += amount;
                update opp;
            }
        }
    }
}