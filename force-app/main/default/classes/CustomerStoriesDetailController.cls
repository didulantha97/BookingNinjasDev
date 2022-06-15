public class CustomerStoriesDetailController {

    public CustomerStories__c story {get; set;}

    public CustomerStoriesDetailController(){
        this.story = [SELECT Id, Name, About__c, ClientSince__c, MainImage__c, Description__c,
                      Industry__c, Location__c, Logo__c, LongDescription__c, Quote__c
                      FROM CustomerStories__c
                      WHERE Id =: ApexPages.currentPage().getParameters().get('id')
                    ];
    }
    
}