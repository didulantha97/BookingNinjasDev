public without sharing class BNES_ArticleController {
    public String articleId { get; set; }

    public BNES_ArticleController() {
        articleId = ApexPages.currentPage().getParameters().get('id');
    }

    public Article__c getArticle() {
        return [
            SELECT
                Id,
                Name,
                Author__r.Name,
                Article_Link__c,
                Author__r.Username__c,
                Author__r.Profile_Picture__c,
                Author__r.Show_Author_Page__c,
                Total_Views__c,
                Category__c,
                Cover_Photo__c,
                HTML_Content__c,
                Content__c,
                Tags__c,
                Scheduled_Publish_Date__c,
                CreatedDate,
                CreatedBy.Name,
                (SELECT Id FROM Article_Views__r)
            FROM Article__c
            WHERE Id = :articleId
        ];
    }

    public List<Article__c> getTrendingArticles() {
        return [
            SELECT
                Id,
                Name,
                Author__c,
                Author__r.Name,
                Author__r.Username__c,
                Article_Link__c,
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

    public void saveArticleView() {
        String ipAddress = getUserIPAddress();
        List<String> location = getUserLocation(ipAddress);
        Article_Views__c av = new Article_Views__c();
        av.IP_Address__c = ipAddress;
        av.ArticleId__c = articleId;
        av.City__c = location[0];
        av.Country__c = location[1];
        insert av;
    }

    public static String getUserIPAddress() {
        String ipAddress = ApexPages.currentPage().getHeaders().get('True-Client-IP');

        // X-Salesforce-SIP has the value when no caching integration or via secure URL.
        if (ipAddress == '' || ipAddress == null) {
            ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        } 

        // get IP address when no caching (sandbox, dev, secure urls)        
        if (ipAddress == '' || ipAddress == null) {
            ipAddress = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
        }

        return ipAddress;
    }

    public static List<String> getUserLocation(String ipAddress) {
        String endPoint = 'http://ip-api.com/json/' + ipAddress;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        HttpResponse res = http.send(request);

        Map<String, Object> respMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        
        List<String> location = new List<String>();
        if(respMap.get('status').equals('success')) {
            location.add((String)respMap.get('city'));
            location.add((String)respMap.get('country'));
        }

        return location;
    }
}