public class BN_Portal_PaymentHistory_Controller extends BN_Portal_Template_Controller {
    
    public Contact contact {get; set;}
    public List<Stripe_Transaction__c> stripeTransactions {get; set;}
    
    public Date startDate {get; set;}
    public Date endDate {get; set;}
    public String status {get; set;}
    
    public BN_Portal_PaymentHistory_Controller() {
    
        String bnUserId = BN_Portal_UserUtils.getCurrBNUserId();
        
        contact = BN_Portal_UserUtils.getContactByBNUserId(bnUserId);
        
        startDate = Date.Today();
        endDate = Date.Today().addDays(30);
        status = 'All';
        
        search();
    }
    
    private List<Stripe_Transaction__c> getTransactionsByContactId(String contactId, Date startDate, Date endDate, String status) {
        if(status == 'All') {
            return [SELECT Id, Guest_Contact__r.Name, Receipt_URL__c, Stripe_Transaction_Id__c, Description__c, Status__c, Total_Amount__c, CreatedDate FROM Stripe_Transaction__c WHERE Guest_Contact__c = :contactId AND CreatedDate >= :startDate AND CreatedDate <= :endDate];
        }
        else {
            return [SELECT Id, Guest_Contact__r.Name, Receipt_URL__c, Stripe_Transaction_Id__c, Description__c, Status__c, Total_Amount__c, CreatedDate FROM Stripe_Transaction__c WHERE Guest_Contact__c = :contactId AND CreatedDate >= :startDate AND CreatedDate <= :endDate AND Status__c = :status];
        }
        
    }
    
    public void search()
    {
        stripeTransactions = getTransactionsByContactId(contact.Id, startDate, endDate, status);
    }
    
    public List<SelectOption> getStatusList()
    {       
        List<SelectOption> statusList = new List<SelectOption>();
        statusList.add(new SelectOption('All', 'All'));
        statusList.add(new SelectOption('Pending', 'Pending'));
        statusList.add(new SelectOption('Failed', 'Failed'));
        statusList.add(new SelectOption('Succeeded', 'Succeeded'));
        statusList.add(new SelectOption('Refunded', 'Refunded'));
        statusList.add(new SelectOption('Partial Refund', 'Partial Refund'));
        
        return statusList;
    }
}