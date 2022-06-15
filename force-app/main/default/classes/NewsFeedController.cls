/*****************************************************************************************
 * @Purpose      :  Controller for NewsFeed Visualforce page which bring up new form newsapi.org
 * @Created Date :  23 September 2018
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/
public with sharing class NewsFeedController {
    
    //  headline search params
    public String headLineSearchKey { get; set; }    
    public String selectedCountry { get; set; }
    public String selectedCategory { get; set; }
    
    //  article search params
    public String articleSearchKey { get; set; }
    public String selectedSortFactor { get; set; }
    public String domains { get; set; }
    public String selectedLanguage { get; set; }

    public NewsAPI_HeadLineResponse headLines { get; set; }
    public NewsAPI_HeadLineResponse articles { get; set; }
    
    public NewsFeedController() {
        headLines =  new NewsAPI_HeadLineResponse();
        articles =  new NewsAPI_HeadLineResponse();
    }   
    
    //  Search breaking headlines
    public void headLineSearch() {
        String endPoint = 'https://newsapi.org/v2/top-headlines?';

        if(String.isNotBlank(this.headLineSearchKey) || String.isNotBlank(this.selectedCountry) || String.isNotBlank(this.selectedCategory)) {
            if(String.isNotBlank(headLineSearchKey)) {  //  If a key word is given
                endPoint += 'q=' + EncodingUtil.urlEncode(headLineSearchKey.trim(), 'UTF-8');
            }
            if(String.isNotBlank(this.selectedCountry)) {   // if a country is selected
                endPoint += endPoint.endsWith('?') ? ('country=' + EncodingUtil.urlEncode(this.selectedCountry.trim(), 'UTF-8')) :
                            ('&country=' + EncodingUtil.urlEncode(this.selectedCountry.trim(), 'UTF-8'));
            }
            if(String.isNotBlank(this.selectedCategory)) {  //  if a category been given
                endPoint += endPoint.endsWith('?') ? ('category=' + EncodingUtil.urlEncode(this.selectedCategory.trim(), 'UTF-8')) :
                            ('&category=' + EncodingUtil.urlEncode(this.selectedCategory.trim(), 'UTF-8'));
            }        
        
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPoint);
            req.setMethod('GET');       
            req.setHeader('X-Api-Key', '426b813fa41641f4baa833ac2ced5a33');
            
            Http ht = new Http();
            HttpResponse res = ht.send(req);
            headLines = (NewsAPI_HeadLineResponse)JSON.deserialize(res.getBody(), NewsAPI_HeadLineResponse.class);
        } else {
            headLines.status = 'error';
            headLines.message = 'Select at least one parameter to start search';
        }
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
    
    public List<SelectOption> getCountries() {
        List<SelectOption> countries = new List<SelectOption>();
        countries.add(new SelectOption('','--Select--'));
        countries.add(new SelectOption('ae','United Arab Emirates'));
        countries.add(new SelectOption('ar','Argentina'));
        countries.add(new SelectOption('at','Austria'));
        countries.add(new SelectOption('au','Australia'));
        countries.add(new SelectOption('be','Belgium'));
        countries.add(new SelectOption('bg','Bulgaria'));
        countries.add(new SelectOption('br','Brazil'));
        countries.add(new SelectOption('ca','Canada'));
        countries.add(new SelectOption('ch','Switzerland'));
        countries.add(new SelectOption('cn','China'));
        countries.add(new SelectOption('co','Colombia'));
        countries.add(new SelectOption('cu','Cuba'));
        countries.add(new SelectOption('cz','Czechia'));
        countries.add(new SelectOption('de','Germany'));
        countries.add(new SelectOption('eg','Egypt'));
        countries.add(new SelectOption('fr','France'));
        countries.add(new SelectOption('gb','Great Britain'));
        countries.add(new SelectOption('gr','Greece'));
        countries.add(new SelectOption('hk','Hong Kong'));
        countries.add(new SelectOption('hu','Hungary'));
        countries.add(new SelectOption('id','Indonesia'));
        countries.add(new SelectOption('ie','Ireland'));
        countries.add(new SelectOption('il','Israel'));
        countries.add(new SelectOption('in','India'));
        countries.add(new SelectOption('it','Italy'));
        countries.add(new SelectOption('jp','Japan'));
        countries.add(new SelectOption('kr','Korea'));
        countries.add(new SelectOption('lt','Lithuania'));
        countries.add(new SelectOption('lv','Latvia'));
        countries.add(new SelectOption('ma','Morocco'));
        countries.add(new SelectOption('mx','Mexico'));
        countries.add(new SelectOption('my','Malaysia'));
        countries.add(new SelectOption('ng','Nigeria'));
        countries.add(new SelectOption('nl','Netherlands'));
        countries.add(new SelectOption('no','Norway'));
        countries.add(new SelectOption('nz','New Zealand'));
        countries.add(new SelectOption('ph','Philippines'));
        countries.add(new SelectOption('pl','Poland'));
        countries.add(new SelectOption('pt','Portugal'));
        countries.add(new SelectOption('ro','Romania'));
        countries.add(new SelectOption('rs','Serbia'));
        countries.add(new SelectOption('ru','Russia'));
        countries.add(new SelectOption('sa','Saudi Arabia'));
        countries.add(new SelectOption('se','Sweden'));
        countries.add(new SelectOption('sg','Singapore'));
        countries.add(new SelectOption('si','Slovenia'));
        countries.add(new SelectOption('sk','Slovakia'));
        countries.add(new SelectOption('th','Thailand'));
        countries.add(new SelectOption('tr','Turkey'));
        countries.add(new SelectOption('tw','Taiwan'));
        countries.add(new SelectOption('ua','Ukraine'));
        countries.add(new SelectOption('us','United States of America'));
        countries.add(new SelectOption('ve','Venezuela'));
        countries.add(new SelectOption('za','South Africa'));
        
        return countries;
    }
    
    public List<SelectOption> getCategories() {
        List<SelectOption> categories = new List<SelectOption>();
        categories.add(new SelectOption('','--Select--'));
        categories.add(new SelectOption('business','Business'));
        categories.add(new SelectOption('entertainment','Entertainment'));
        categories.add(new SelectOption('general','General'));
        categories.add(new SelectOption('health','Health'));
        categories.add(new SelectOption('science','Science'));
        categories.add(new SelectOption('sports','Sports'));
        categories.add(new SelectOption('technology','Technology'));
        
        return categories;
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