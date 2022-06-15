public class BNES_BlogController {
    List<Article__c> recentArticles;
    List<Article__c> popularArticles;
    public String subEmail { get; set; }
    Article__c mainArticle;
    private Integer countTotalRecords;
    private Integer offsetSize = 0;
    private Integer queryLimit = 12;
    private List<String> queryFilters = new List<String>();
    private String pageParameter;
    public String categoryParameter { get; set; }
    public String searchParameter { get; set; }
    public String searchQuery { get; set; }
    public Integer currentPageNumber {
        get {
            return (offsetSize / queryLimit) + 1;
        }
        set;
    }

    public BNES_BlogController() {
        // get total published articles
        countTotalRecords = [SELECT COUNT() FROM Article__c WHERE Publish__c = TRUE AND Article_Region__c = '(ES) Spain'];
        pageParameter = ApexPages.currentPage().getParameters().get('page');
        if (pageParameter != null) {
            // get current page offset
            offsetSize = (Integer.valueOf(pageParameter) - 1) * queryLimit;
        }
        searchParameter = ApexPages.currentPage().getParameters().get('search');
        if (searchParameter != null) {
            for (String qf : searchParameter.split('-')) {
                queryFilters.add('%' + qf + '%');
            }
            // update total published articles based on search query
            countTotalRecords = [
                SELECT COUNT()
                FROM Article__c
                WHERE Publish__c = TRUE
                AND (Name LIKE :queryFilters OR Article_Preview__c LIKE :queryFilters)
                AND Article_Region__c = '(ES) Spain'
            ];
        }
        categoryParameter = ApexPages.currentPage().getParameters().get('category');
        if (categoryParameter != null) {
            // update total published articles based on search query
            countTotalRecords = [
                SELECT COUNT()
                FROM Article__c
                WHERE Publish__c = TRUE
                AND Category__c = :categoryParameter
                AND Article_Region__c = '(ES) Spain'
            ];
        }
    }

    public List<Article__c> getRecentArticles() {
        if (queryFilters.size() > 0) {
            // filter by search query
            return [
                SELECT
                    Id,
                    Name,
                    Author__c,
                    Article_Link__c,
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
                AND (Name LIKE :queryFilters OR Article_Preview__c LIKE :queryFilters)
                AND Article_Region__c = '(ES) Spain'
                ORDER BY Scheduled_Publish_Date__c DESC
                LIMIT :queryLimit
                OFFSET :offsetSize
            ];
        } else if (categoryParameter != null) {
            categoryParameter = categoryParameter.replace('-', ' ');
            // filter by category query
            return [
                SELECT
                    Id,
                    Name,
                    Author__c,
                    Author__r.Name,
                    Article_Link__c,
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
                AND Category__c = :categoryParameter
                AND Article_Region__c = '(ES) Spain'
                ORDER BY Scheduled_Publish_Date__c DESC
                LIMIT :queryLimit
                OFFSET :offsetSize
            ];
        } else {
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
                    Article_Link__c,
                    HTML_Content__c,
                    Content__c,
                    Scheduled_Publish_Date__c,
                    CreatedDate
                FROM Article__c
                WHERE Publish__c = TRUE
                AND Article_Region__c = '(ES) Spain'
                ORDER BY Scheduled_Publish_Date__c DESC
                LIMIT :queryLimit
                OFFSET :offsetSize
            ];
        }
    }

    public boolean getTrendingArc(){
        List<Article__c> lstArticles =  [
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
                Article_Link__c,
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
        if(lstArticles.size() > 0 && lstArticles.size() != null){
            return true;
        }else{
            return false;
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
                Article_Link__c,
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

    public List<blogCategoryWrapper> getArticleCategories(){
        
        List<blogCategoryWrapper> catWarpperList = new List<blogCategoryWrapper>();

        Set<String> setArticles = new Set<String>();
        
        for(Article__c s: [SELECT Category__c FROM Article__c WHERE Article_Region__c = '(ES) Spain']){
            setArticles.add(s.Category__c);
        }
        
        for(String s : setArticles){
            String active= 'active';
            blogCategoryWrapper cwarpper = new blogCategoryWrapper();
            cwarpper.href = '/es/blog?category=' + s;
            cwarpper.category =  s;
            cwarpper.categoryParam = '{!if(categoryParameter == '+ s +', '+'active'+', '+ +')}';
            catWarpperList.add(cwarpper);
        }
        return catWarpperList;
    }

    public PageReference search() {
        searchQuery = searchQuery.replace(' ', '-');
        PageReference fwPage = new PageReference('es/blog?');
        fwPage.getParameters().put('search', searchQuery.toLowerCase());
        return fwPage.setRedirect(true);
    }

    public PageReference next() {
        offsetSize += queryLimit;
        currentPageNumber = (offsetSize / queryLimit) + 1;
        PageReference fwPage = Page.BN_Blog;
        if (currentPageNumber > 1) {
            fwPage.getParameters().put('page', String.valueOf(currentPageNumber));
        }
        return fwPage.setRedirect(true);
    }

    public PageReference previous() {
        offsetSize -= queryLimit;
        currentPageNumber = (offsetSize / queryLimit) + 1;
        PageReference fwPage = Page.BN_Blog;
        if (currentPageNumber > 1) {
            fwPage.getParameters().put('page', String.valueOf(currentPageNumber));
        }
        return fwPage.setRedirect(true);
    }

    public Boolean getDisablePrevious() {
        if (offsetSize > 0) {
            return false;
        } else {
            return true;
        }
    }

    public Boolean getDisableNext() {
        if (offsetSize + queryLimit < countTotalRecords) {
            return false;
        } else {
            return true;
        }
    }

    public void subscribe() {
        System.debug('email:' + subEmail);
        if (!checkExistingEmail(subEmail)) {
            insert new Email_Subscription__c(Email__c = subEmail);
        }

        subEmail = '';
    }

    private boolean checkExistingEmail(string email) {
        List<Email_Subscription__c> emails = [
            SELECT Id, Email__c
            FROM Email_Subscription__c
            WHERE Email__c = :email
        ];
        return emails.size() > 0;
    }
}