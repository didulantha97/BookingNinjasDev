/**
 * @description       : 
 * @author            : 
 * @group             : 
 * @last modified on  : 12-13-2020
 * @last modified by  : teguh@bookingninjas.com
 * Modifications Log 
 * Ver   Date         Author                    Modification
 * 1.0   12-13-2020   teguh@bookingninjas.com   Stripe built-int checkout
**/
public with sharing class BNES_RegisterController {
    private Map<String, String> customerData;
    public String contactId {get; set;}
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String businessName {get; set;}
    public String email {get; set;}
    public String phone {get; set;}
    
    public BNES_RegisterController() {
        customerData = new Map<String, String>();
    }
    
    public void register() 
    {
        customerData.put('businessName', businessName);
        customerData.put('firstName', firstName);
        customerData.put('lastName', lastName);
        customerData.put('email', email);
        customerData.put('phone', phone);
        // create contact if not exist
        contactId = createContact(customerData);
        // opportunity record
        createOpportunity(customerData);
    }

    private Id createContact(Map<String, String> customerData) {
        Contact contact = new Contact();
        contact.trialBusinessName__c = customerData.get('businessName');
        contact.firstName = customerData.get('firstName');
        contact.lastName = customerData.get('lastName');
        contact.Email = customerData.get('email');
        contact.Phone = customerData.get('phone');
        insert contact;
        return contact.Id;
    }

    private void createOpportunity(Map<String, String> customerData) {
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'New Opportunity: ' + customerData.get('firstName') + '  ' + customerData.get('lastName');
        opportunity.trialEmail__c = customerData.get('email');
        opportunity.Type = 'New Business';
        opportunity.StageName = 'Trial';
        opportunity.LeadSource = 'Booking Ninjas';
        opportunity.CloseDate = Date.Today().addDays(15);
        insert opportunity;
    }
}