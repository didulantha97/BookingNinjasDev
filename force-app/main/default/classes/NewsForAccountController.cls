/*****************************************************************************************
 * @Purpose      :  Controller for NewsForAccount Visualforce page which bring up new from newsapi.org
 *                  for a given account
 * @Created Date :  30 September 2018
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/
public with sharing class NewsForAccountController {

    //  standard controller
    public Account acc { get; set; }
    
    //  article search params
    public String articleSearchKey { get; set; }
    public String selectedSortFactor { get; set; }
    public String domains { get; set; }
    public String selectedLanguage { get; set; }
    
    public NewsAPI_HeadLineResponse articles { get; set; }
    
    public NewsForAccountController(ApexPages.StandardController ctrl) {
        acc = [SELECT Name FROM Account WHERE Id =: ctrl.getId()];
        
        articles =  new NewsAPI_HeadLineResponse();
        
        articleSearchKey = acc.Name;
        
        this.searchArticles();
    }        
    
    //  Article search
    public void searchArticles() {
        if(String.isNotBlank(this.articleSearchKey)) {
            String endPoint = 'https://newsapi.org/v2/everything?';
            endPoint += 'q=' + EncodingUtil.urlEncode(this.articleSearchKey, 'UTF-8');
            
            if(String.isNotBlank(this.selectedLanguage))
                endPoint += '&language=' + this.selectedLanguage;
            if(String.isNotBlank(this.selectedSortFactor))
                endPoint += '&sortBy=' + this.selectedSortFactor;
            if(String.isNotBlank(this.domains))
                endPoint += '&domains=' + this.domains;
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPoint);
            req.setMethod('GET');       
            req.setHeader('X-Api-Key', '426b813fa41641f4baa833ac2ced5a33');
            
            Http ht = new Http();
            HttpResponse res = ht.send(req);
            articles = (NewsAPI_HeadLineResponse)JSON.deserialize(res.getBody(), NewsAPI_HeadLineResponse.class);
            System.debug('res : ' + res.getBody());
        } else {
            articles.status = 'error';
            articles.message = 'Enter a search phrase to start search';
        }
    }
    
    //  Sort options for article search
    public List<SelectOption> getSortFactors() {
        return new List<SelectOption>{
            new SelectOption('','--Select--'),
            new SelectOption('relevancy','Relevancy'),
            new SelectOption('popularity','Popularity')
        };
    }
    
    //  Languages options
    public List<SelectOption> getLanguages() {
        return new List<SelectOption> {
            new SelectOption('','--Select--'),
            new SelectOption('ar','Arabic'),
            new SelectOption('de','German'),
            new SelectOption('en','English'),
            new SelectOption('es','Spanish'),
            new SelectOption('fr','French'),
            new SelectOption('he','Hebrew'),
            new SelectOption('it','Italian'),
            new SelectOption('nl','Dutch'),
            new SelectOption('no','Norwegian'),
            new SelectOption('pt','Portuguese'),
            new SelectOption('ru','Russian'),
            new SelectOption('se','Northern Sami'),
            new SelectOption('de','German'),
            new SelectOption('zh','Chinese')
        };
    }
}