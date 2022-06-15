public class BN_Portal_ClientV2MOM_Controller extends BN_Portal_Template_Controller {
    
    public Contact contact {get; set;}
    
    public String vision {get; set;}
    public String values {get; set;}
    public String methods {get; set;}
    public String obstacles {get; set;}
    public String measures {get; set;}
    
    public BN_Portal_ClientV2MOM_Controller() {
        
        String bnUserId = BN_Portal_UserUtils.getCurrBNUserId();
        
        contact = BN_Portal_UserUtils.getContactByBNUserId(bnUserId);
        if(contact != null) {
            vision = contact.Vision__c;
            values =  contact.Values__c;
            methods = contact.Methods__c;
            obstacles = contact.Obstacles__c;
            measures = contact.Measures__c;
        }
    }
    
    public PageReference saveV2MOM()
    {
        try {
            contact.Id = contact.Id;
            contact.Vision__c = vision;
            contact.Values__c = values;
            contact.Methods__c = methods;
            contact.Obstacles__c = obstacles;
            contact.Measures__c = measures;
            update contact;
            
            PageReference pageRef = new PageReference('/portal/v2mom');
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
            return null;
        }
    }
}