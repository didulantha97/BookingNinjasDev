/*****************************************************************************************
 * @Purpose      :  Response wrapper for top-headline end point on News API
 * @Created Date :  24 September 2018
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/
public with sharing class NewsAPI_HeadLineResponse {

    public String status { get; set; }
    public Integer totalResults { get; set; }
    public List<Article> articles { get; set; }
    
    //  Error response
    public String code { get; set; }
    public String message { get; set; }
    
    public class Article {
        public String author { get; set; }
        public String description { get; set; }
        public String title { get; set; }
        public String url { get; set; }
        public String urlToImage;
        public String publishedAt { get; set; }
        public String content;
        public Source source;
    }
    
    public class Source {
        public String id;
        public String name;
    }
}