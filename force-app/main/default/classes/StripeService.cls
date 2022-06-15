/*****************************************************************************************
 * @Purpose      : Handle Stripe operations via Stripe API
 * @Created Date : 30 April 2019
 * @Author       : Madhura Priyadarshana 
 *****************************************************************************************/ 
public class StripeService {
    
    public StripeService() {
        
    }
    
    public static void createSource() {
        
    }
    
    //  create a customer with a card attached(source id)
    public static HttpResponse createCustomer(String description, String email) {
        String token = Apexpages.currentPage().getParameters().get('token');
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        String body = '';
        
        req.setEndpoint('callout:Stripe/customers');
        req.setMethod('POST');
        body = 'source=' + token +
            '&email=' + email + 
            '&description=' + description;
        
        req.setBody(body);
        res = ht.send(req);
        
        return res;        
    }
    
    public static void attachSourceToCustomer(String customerId, String sourceId) {
        
    }
    
    //  Check the card balance
    public static void checkBalance() {
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        
        req.setEndpoint('callout:Stripe/balance');  //req.setEndpoint(baseURL + 'balance');
        req.setMethod('GET');
        
        res = ht.send(req);
        System.debug('res : ' + res.getBody());                
    }
    
    //  create one time card token
    //  expMonth : two digit 12
    //  expYear  : four digit 2021
    //  cvc     : three digit 132
    public static String createCardToken(String cardNumber, String expMonth, String expYear, String cvc) {
        String token;
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        String body = '';
        
        req.setEndpoint('callout:Stripe/tokens');
        req.setMethod('POST');
        body = 'card[number]=' + cardNumber +
            '&card[exp_month]=' + expMonth + 
            '&card[exp_year]=' + expYear +
            '&card[cvc]=' + cvc;
        
        req.setBody(body);
        res = ht.send(req);
        System.debug('token resp : ' + res.getBody());
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        token = (String)m.get('id');
        System.debug('one time token : ' + token);
        
        return token;
    }
    
    //  make one time transaction
    public static HttpResponse chargeByCard(String amount, String description, String token) {
        //String token = Apexpages.currentPage().getParameters().get('token');
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        String body = '';
        
        req.setEndpoint('callout:Stripe/charges');
        req.setMethod('POST');
        
        body = 'amount=' + amount +
            '&currency=usd' + 
            '&source=' + token +
            '&description=' + description;
        System.debug('charge body : ' + body);
        
        req.setBody(body);
        res = ht.send(req);
        System.debug('charge Res : ' + res.getBody());
        return res;
        
        //  https://stripe.com/docs/api/charges/create
        //  https://stripe.com/docs/quickstart
        //  https://stripe.com/docs/checkout#integration-custom
    }
    
    //  charge for a saved customer
    public static HttpResponse chargeByCustomer(String amount, String description, String customerStripeId) {
        String transactionId;
        
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        String body = '';
        
        req.setEndpoint('callout:Stripe/charges');
        req.setMethod('POST');
        body = 'amount=' + amount +
            '&currency=usd' + 
            '&customer=' + customerStripeId +
            '&description=' + description;
        
        req.setBody(body);
        res = ht.send(req);
        
        return res;
    }
    
    //  get terminal connection token
    public static HttpResponse getConnectionToken() {
        HttpResponse res;
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndPoint('callout:Stripe/terminal/connection_tokens');
        req.setMethod('POST');
        
        res = ht.send(req);
        
        return res;
    }
    
    public static HttpResponse getRefund(String transactionId, Integer amount) {
        //String transactionId;
        
        Http ht = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        String body = '';
        
        req.setEndpoint('callout:Stripe/refunds');
        req.setMethod('POST');
        body = 'charge=' + transactionId + '&amount=' +  amount;
        
        req.setBody(body);
        res = ht.send(req);
        
        return res;
    }
}