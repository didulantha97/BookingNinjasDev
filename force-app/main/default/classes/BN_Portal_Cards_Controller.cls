public class BN_Portal_Cards_Controller extends BN_Portal_Template_Controller {
    
    public Contact contact {get; set;}
    
    public List<Card__c> cards {get; set;}
    public Card__c card {get; set;}
    public String cardId {get; set;}
    public String cardName {get; set;}
    public String cardNumber {get; set;}
    public String cardCvv {get; set;}
    public String cardExpDate {get; set;}
    
    public List<Check__c> checks {get; set;}
    public Check__c check {get; set;}
    public String checkId {get; set;}
    public String nameOnAccount {get; set;}
    public String bankRoutingNumber {get; set;}
    public String checkingAccountNumber {get; set;}
    public String issuingBank {get; set;}
    
    public BN_Portal_Cards_Controller() {
        
        String bnUserId = BN_Portal_UserUtils.getCurrBNUserId();
        
        contact = BN_Portal_UserUtils.getContactByBNUserId(bnUserId);
        
        cards = getCardsByContactId(contact.Id);
        checks = getChecksByContactId(contact.Id);
        
        cardName = '';
        cardNumber = '';
        cardCvv = '';
        cardExpDate = '';
        
        nameOnAccount = '';
        bankRoutingNumber = '';
        checkingAccountNumber = '';
        issuingBank = '';
    }
    
    private List<Card__c> getCardsByContactId(String contactId)
    {
        return [SELECT Id, Name, Card_Holder__c, Card_Number__c, Card_Type__c, Expiration_Date__c, Security_Code__c, CreatedDate FROM Card__c WHERE Contact__c = :contactId ORDER BY CreatedDate DESC];
    }
    
    private List<Check__c> getChecksByContactId(String contactId)
    {
        return [SELECT Id, Name, Name__c, Bank_Routing_Number__c, Checking_Account_Number__c, Issuing_Bank__c, Contact__c, CreatedDate FROM Check__c WHERE Contact__c = :contactId ORDER BY CreatedDate DESC];
    }
        
    public PageReference addCard()
    {
        try {
            // convert card exp to date
            String month = cardExpDate.substring(0,2);
            String year = cardExpDate.substring(5);  
            Date cardExp = Date.newInstance(integer.valueOf(year), integer.valueOf(month), 1);
            System.Debug('cardExp: ' +  cardExp);
            
            card = new Card__c();
            card.Contact__c = contact.Id;
            card.Card_Holder__c = cardName;
            card.Card_Number__c = cardNumber;
            card.Security_Code__c = cardCvv;
            card.Expiration_Date__c = cardExp;
            insert card;
            
            // send email notif
            sendEmailNotif(card.Id);
            
            PageReference pageRef = new PageReference('/portal/cards');
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
            return null;
        }
    }
    
    public PageReference addCheck()
    {        
        try {
            check = new Check__c();
            check.Name__c = nameOnAccount;
            check.Bank_Routing_Number__c = bankRoutingNumber;
            check.Checking_Account_Number__c = checkingAccountNumber;
            check.Issuing_Bank__c = issuingBank;
            check.Contact__c = contact.Id;
            insert check;
            
            // send email notif
            sendEmailNotif(check.Id);
            
            PageReference pageRef = new PageReference('/portal/cards');
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
            return null;
        }
    }
    
    public void deleteCard()
    {
        Card__c cardDel = [SELECT Id, Name FROM Card__c WHERE Id = :cardId];
        delete cardDel;
        
        // reset
        cards = getCardsByContactId(contact.Id);
    }
    
    public void deleteCheck()
    {
        Check__c checkDel = [SELECT Id, Name FROM Check__c WHERE Id = :checkId];
        delete checkDel;
        
        // reset
        checks = getChecksByContactId(contact.Id);
    }
    
    private void sendEmailNotif(String id)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'david@bookingninjas.com' };
        message.optOutPolicy = 'FILTER';
        message.subject = 'You have new client\'s additional card/check';
        message.setHtmlBody('See record <a href="https://bookingninjas.my.salesforce.com/' + id + '">here</a>. <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}