public class StripeCheckoutController {

    public String stripeCheckoutSessionId { get; set; }
    public String itemName { get; set; }
    public String itemDescription { get; set; }
    public String amount { get; set; }
    public Integer quantity { get; set; }
    public Stripe_Transaction__c trans { get; set; }
    public String sessionId { get; set; }
    String piId;
    Map<String, String> sessionInfo;
    
    public StripeCheckoutController() {
        trans = new Stripe_Transaction__c(
        	Status__c = 'Pending'
        );
        stripeCheckoutSessionId = ApexPages.currentPage().getParameters().get('session_id');
        //	TODO : need to set the session id from the response and enable Checkout
    }
    
    public void getSessionId() {
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Stripe/checkout/sessions');
        req.setMethod('POST');
        
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');        
        
        String body = '';
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        String successUrl = baseUrl + '/apex/StripeCheckout?session_id={CHECKOUT_SESSION_ID}';
        String cancelUrl = baseUrl + '/apex/StripeCheckout';
        
        //	setting amount according to the required format
        if(String.isNotBlank(this.amount)) {
            if(this.amount.contains('.')) {
                String[] priceParts = this.amount.split('\\.');
                if(priceParts[1].length() > 2) {
                    this.amount = priceParts[0] + priceParts[1].substring(0, 2);
                } else if(priceParts[1].length() == 1) {
                    this.amount = this.amount.replace('.', '') + '0';
                } else {
                    this.amount = this.amount.replace('.', '');
                }
            }
        } else {
            this.amount = '00';
        }
        
        body = 'success_url=' + successUrl + 
            	'&cancel_url=' + cancelUrl + 
            	'&payment_method_types[0]=card' +            
            	'&line_items[0][name]=' + this.itemName +
            	'&line_items[0][description]=' + this.itemDescription + 
            	'&line_items[0][amount]=' + this.amount + 
            	'&line_items[0][currency]=usd' +
            	'&line_items[0][quantity]=' + this.quantity;
        req.setBody(body);
        
        HttpResponse resp = ht.send(req);

        extractSessionInfor(resp);
        
    }
    
    private void extractSessionInfor(HttpResponse resp) {
        sessionInfo = new Map<String, String>();
        Map<String, Object> respMap = (Map<String, Object>)JSON.deserializeUntyped(resp.getBody());
        
        if(respMap.containsKey('payment_intent')) {
            piId = (String)respMap.get('payment_intent');
            sessionInfo.put('piId', piId);
        }
        if(respMap.containsKey('id')) {
            sessionId = (String)respMap.get('id');
            sessionInfo.put('sessionId', sessionId);
        }
    }
    
    public void captureTransaction() {
        if(sessionInfo != null && !sessionInfo.isEmpty()) {
            trans.Description__c = this.itemDescription;
            try {
                if(sessionInfo.containsKey('piId'))
                    trans.Payment_Intent_Id__c = sessionInfo.get('piId');
                if(sessionInfo.containsKey('sessionId'))
                    trans.Stripe_Checkout_Session_Id__c = sessionInfo.get('sessionId');
                
                insert trans;
            } catch(Exception ex) {
                System.debug('ERROR : StripeCheckoutController.captureTransaction() \n' + ex.getMessage());
            }
        }
    }
}