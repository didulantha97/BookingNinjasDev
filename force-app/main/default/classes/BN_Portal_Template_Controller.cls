public virtual class BN_Portal_Template_Controller {
    
    public String username {get;set;}
    public String password {get;set;}
    public String ref {get;set;}
    
    public String page {get;  set;}
    public String title {get; set;}
    public String description {get; set;}
    
    public Email_Subscription__c subscription {get; set;} 
    public String email {get; set;}
    
    public BN_Portal_Template_Controller() {
    
        ref = Apexpages.currentPage().getParameters().get('ref');
        
        page = ApexPages.currentPage().getUrl().substringAfter('/').split('\\?')[0];
        System.Debug('Page: ' + page);
        
        title = 'Best Property Management Software - Cloud-Based PMS | Booking Ninjas';
        description = 'The proper way to handle your property management today. Join our users and enjoy predictable growth';
        
        email = '';
    }
    
    public String getUserRole() {
        return BN_Portal_UserUtils.getUserRole(BN_Portal_UserUtils.getCurrBNUserId());
    }
    
    public Boolean getIsLogout() {
        return BN_Portal_UserUtils.isLogout();
    }
    
    public PageReference checkUserLogin() {
        if (BN_Portal_UserUtils.isLogout()) {
            PageReference fwPage = new PageReference('/login');
            fwPage.getParameters().put('ref', Apexpages.currentPage().getUrl());
            return fwPage.setRedirect(true);
        }
        return null;
    }
    
    public PageReference redirectToLandingPage() {
        if (!BN_Portal_UserUtils.isLogout()) {
            PageReference fwPage = BN_Portal_UserUtils.defaultLandingPage();
            return fwPage.setRedirect(true);
        }
        return null;
    }
    
    public PageReference logoutPage() {
        BN_Portal_UserUtils.logout();
        PageReference newPage = new PageReference('/login');
        return newPage.setRedirect(true);
    }
    
    public PageReference login() {

        String result = BN_Portal_UserUtils.login(username, password);
        System.debug(username);
        if (String.isNotEmpty(result)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, result));
            return null;
        }

        PageReference fwPage;
        if (String.isNotEmpty(ref)){
            fwPage = new PageReference(ref);
        } else {
            fwPage = BN_Portal_UserUtils.defaultLandingPage();
        }

        return fwPage.setRedirect(true);
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
}