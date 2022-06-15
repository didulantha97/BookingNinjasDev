/*****************************************************************************************
 * @Purpose      : Controller extension for StripeAuthorizeCard page
 * @Created Date : 13 June 2019
 * @Author       : Madhura Priyadarshana 
 *****************************************************************************************/ 
public class StripeAuthorizeCardExtension {

    public Card__c card { get; set; }
    public Contact con {get; set; }
    
    public StripeAuthorizeCardExtension(ApexPages.StandardController ctrl) {
        card = [SELECT Id, Contact__c, Name FROM Card__c WHERE Id =: ctrl.getId()];
        con = [SELECT Id, Name, Stripe_Id__c, Email, MobilePhone FROM Contact WHERE Id =: card.Contact__c];
    }
    
    public void createCustomer() {
        //  first create customer with the Stripe generated token(source) for the give card
        HttpResponse customerResponse = StripeService.createCustomer('New customer ' + con.Name, this.con.Email);
        
        if(customerResponse.getStatusCode() == 200) {
            String respBody = customerResponse.getBody();
            respBody = respBody.replace('type', 'type_Z').replace('object', 'object_Z').replace('currency', 'currency_Z');
            System.debug('res : ' + respBody);
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(respBody);
            String customerStripeId = (String)m.get('id');
            System.debug('id : ' + customerStripeId);
            
            this.updateContact(customerStripeId);
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Card Authorization successful and contact is updated. You may close this window'));
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Card Authorization failed and contact is not updated. Please try again'));
        }
    }
    
    private void updateContact(String customerStripeId) {
        update new Contact(Id = con.Id, Stripe_Id__c = customerStripeId);
    }
}