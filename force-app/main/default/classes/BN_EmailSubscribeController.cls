public class BN_EmailSubscribeController {
    
    public Email_Subscription__c subscription {get; set;}
    public String email {get; set;}
    public Decimal price {get; set;}
    public String IsoCode {get; set;}
    
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
    
    public String getIsoCode(){
        String pageName = ApexPages.currentPage().getUrl().substringAfter('/');
        String apexPageName = ApexPages.currentPage().getUrl().substringAfter('apex/');
        
        if(pageName.contains('') || apexPageName.contains('BN_') || apexPageName == null){
            IsoCode = 'USD';
        }else if((pageName.contains('es') || pageName.contains('ep')) || (apexPageName.contains('BNES_') || apexPageName.contains('BNEP_'))){
            IsoCode = 'EUR';
        }
        return IsoCode;
    }
    
    
    public Decimal getLowestPrice(){
        
        getIsoCode();

        String isocode = IsoCode;

        CurrencyType ct = [SELECT IsoCode, ConversionRate, IsActive FROM CurrencyType WHERE IsoCode=:isocode];        

        Product2 min_Price = [SELECT MonthlyFee__c FROM Product2 WHERE IsActive = TRUE AND Expose_on_site__c = TRUE ORDER BY MonthlyFee__c ASC LIMIT 1];

        price = min_Price.MonthlyFee__c * ct.ConversionRate;
        
        return price.round(System.RoundingMode.HALF_EVEN);
        
    }
    
}