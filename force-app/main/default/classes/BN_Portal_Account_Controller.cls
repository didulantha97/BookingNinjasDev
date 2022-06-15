public class BN_Portal_Account_Controller extends BN_Portal_Template_Controller {
    
    public Contact contact {get; set;}
    public List<Opportunity> opportunities {get; set;}
    
    public String userRole {get; set;}
    
    public BN_Portal_Account_Controller() {
        
        String bnUserId = BN_Portal_UserUtils.getCurrBNUserId();
        userRole = BN_Portal_UserUtils.getUserRole(bnUserId);
        
        contact = BN_Portal_UserUtils.getContactByBNUserId(bnUserId);
        if(contact != null)
        {
            opportunities = getOpportunitiesByContactId(contact.Id);
        }
    }
    
    private List<Opportunity> getOpportunitiesByContactId(string contactId)
    {
        return [SELECT Id, Name, Account.Name, StageName, CloseDate FROM Opportunity WHERE Primary_Contact__c = :contactId];
    }
}