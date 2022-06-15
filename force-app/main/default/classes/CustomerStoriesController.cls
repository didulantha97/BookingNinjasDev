public class CustomerStoriesController {

    public List<CustomerStories__c> getCustomerStories() {
        return [SELECT Id, Name, About__c, ClientSince__c, Description__c, Industry__c, Location__c, Logo__c
                FROM CustomerStories__c
                WHERE IsActive__c = true
               ];
    }

}