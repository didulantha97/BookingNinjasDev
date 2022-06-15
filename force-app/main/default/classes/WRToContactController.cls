public with sharing class WRToContactController {

    public Id wrId {get; set;}
    public Webinar_Registration__c registration {get; set;}
    public Contact contact {get; set;}
    
    public WRToContactController(ApexPages.StandardController controller) 
    {
        wrId = (Id)controller.getRecord().get('id');
        registration = getWebinarRegistration(wrId);
    }
    
    private Webinar_Registration__c getWebinarRegistration(Id wrId)
    {
        return [SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Phone__c, Business__c, Country__c FROM Webinar_Registration__c WHERE Id = :wrId];
    }
    
    public PageReference convertToContact()
    {
        // validates record
        if(getContactByEmail(registration.Email__c).size() > 0)
        {
            // fetch contact and do update
            contact = getContactByEmail(registration.Email__c)[0];
            contact.LastName = registration.Last_Name__c;
            contact.FirstName = registration.First_Name__c;
            contact.Email = registration.Email__c;
            contact.Phone = registration.Phone__c;
            update contact;
        }
        else 
        {
            // create new contact
            contact = new Contact();
            contact.LastName = registration.Last_Name__c;
            contact.FirstName = registration.First_Name__c;
            contact.Email = registration.Email__c;
            contact.Phone = registration.Phone__c;
            insert contact;
        }

        // delete registration
        // delete registration;
        
        // redirect to new contact
        PageReference pageRef = new PageReference('/' + contact.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private List<Contact> getContactByEmail(String email) {
        return [SELECT Id, FirstName, LastName, Email, Phone, AccountId, Account.Name FROM Contact WHERE Email = :email];
    }
}