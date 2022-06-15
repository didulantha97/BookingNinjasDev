public without sharing class BN_EmailSubscribeController {

    public Email_Subscription__c subscription {get; set;}
    public String email {get; set;}
    public Decimal price {get; set;}
 
    public BN_EmailSubscribeController()
    {
        email = '';

    }
    
    public void subscribe() 
    {
        if(!checkExistingEmail(email))
        {
            subscription = new Email_Subscription__c();
            subscription.Email__c =  email;
            insert subscription;
        }
        
        email = '';
    }
    
    private boolean checkExistingEmail(string email)
    {
        List<Email_Subscription__c> emails = [SELECT Id, Email__c FROM Email_Subscription__c WHERE Email__c = :email];
        return emails.size() > 0 ? true : false;
    }

    public Decimal getLowestSpanishPrice(){
       
        String code = 'EUR';
        String region = '(ES) Spain';

        CurrencyType__c ct = [SELECT ISOCode__c, ConversionRate__c  FROM CurrencyType__c WHERE ISOCode__c=:code];        

        List<Product2> amounts = [SELECT MonthlyFee__c FROM Product2 WHERE IsActive = TRUE AND Product_Region__c =: region AND Type__c = 'Web'];

        List<Decimal> lowestPriceList = new List<Decimal>();

        for(Product2 p: amounts){
            lowestPriceList.add(p.MonthlyFee__c);
        }

        lowestPriceList.sort();

        price = lowestPriceList.get(0) * ct.ConversionRate__c;

        return price.round(System.RoundingMode.HALF_EVEN);
    }
    
    public Decimal getLowestEnglishPrice(){

        List<Product2> amounts = [SELECT MonthlyFee__c FROM Product2 WHERE IsActive = TRUE AND Type__c = 'Web'];

        List<Decimal> lowestPriceList = new List<Decimal>();

        for(Product2 p: amounts){
            lowestPriceList.add(p.MonthlyFee__c);
        }

        lowestPriceList.sort();

        price = lowestPriceList.get(0).round(System.RoundingMode.HALF_EVEN);

        return price;
    }
}