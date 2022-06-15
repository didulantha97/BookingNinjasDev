/*
 * Dynamic sitemap links generator for blogs, etc.
 * 
 * @author: <mustafasahin.mshn@gmail.com>
 * 
 * Tester: SitemapControllerTest
 */
public with sharing class SitemapController {

    public List<String> blogPages {get; set;}

    public SitemapController(){
        this.blogPages = new List<String>();
        for(Article__c art : [SELECT Article_Link__c FROM Article__c WHERE Publish__c = true]){
            blogPages.add(art.Article_Link__c);
        }
    }

}