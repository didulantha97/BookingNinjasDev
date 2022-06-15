public class BNES_AuthorController {
    private String contactId;
    public String parameterId { get; set; }

    public BNES_AuthorController() {
        parameterId = ApexPages.currentPage().getParameters().get('id');
        if (parameterId != 'admin') {
            contactId = ApexPages.currentPage().getParameters().get('id');
        }
    }

    public Contact getAuthor() {
        return [
            SELECT Id, Name, LastName, Salutation, Profile_Picture__c, Bio__c, Account.Name, Levels__c, Username__c
            FROM Contact
            WHERE Id = :contactId
        ];
    }

    public List<Article__c> getAuthorArticles() {
        if (parameterId != 'admin') {
            return [
                SELECT
                    Id,
                    Name,
                    Author__c,
                    Author__r.Name,
                    Author__r.Username__c,
                    Author__r.Account.Name,
                    Author__r.Levels__c,
                    Author__r.Profile_Picture__c,
                    Cover_Photo__c,
                    Article_Preview__c,
                    HTML_Content__c,
                    Content__c,
                    Scheduled_Publish_Date__c,
                    CreatedDate
                FROM Article__c
                WHERE Publish__c = TRUE
                AND Author__c = :contactId
                AND Article_Region__c = '(ES) Spain'
                ORDER BY Scheduled_Publish_Date__c DESC
                LIMIT 5
            ];
        } else {
            return [
                SELECT
                    Id,
                    Name,
                    Author__c,
                    Author__r.Name,
                    Author__r.Username__c,
                    Author__r.Account.Name,
                    Author__r.Levels__c,
                    Author__r.Profile_Picture__c,
                    Cover_Photo__c,
                    Article_Preview__c,
                    HTML_Content__c,
                    Content__c,
                    Scheduled_Publish_Date__c,
                    CreatedDate
                FROM Article__c
                WHERE Publish__c = TRUE
                AND Author__c = NULL
                AND Article_Region__c = '(ES) Spain'
                ORDER BY Scheduled_Publish_Date__c DESC
                LIMIT 5
            ];
        }
    }

    public List<Article__c> getTrendingArticles() {
        return [
            SELECT
                Id,
                Name,
                Author__c,
                Author__r.Name,
                Author__r.Username__c,
                Author__r.Profile_Picture__c,
                Author__r.Show_Author_Page__c,
                Cover_Photo__c,
                Article_Preview__c,
                HTML_Content__c,
                Content__c,
                Scheduled_Publish_Date__c,
                CreatedDate
            FROM Article__c
            WHERE Publish__c = TRUE
            AND Scheduled_Publish_Date__c = LAST_N_DAYS:7
            AND Article_Region__c = '(ES) Spain'
            ORDER BY Total_Views__c DESC
            LIMIT 3
        ];
    }
}