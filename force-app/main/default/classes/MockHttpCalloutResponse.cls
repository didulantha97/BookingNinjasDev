/*****************************************************************************************
 * @Purpose      :  Mock callout for unit test implementations
 * @Created Date :  30 August 2017
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/ 
@isTest
public class MockHttpCalloutResponse implements HttpCalloutMock {
    
    public HTTPResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        //	FullContact Mock starts
        List<FullContact_Login__mdt> fullContactLogin = [SELECT Id, API_Key__c, Endpoint__c, Recipients__c 
                                                         FROM FullContact_Login__mdt WHERE MasterLabel = 'Primary'];
        String endPoint = req.getEndpoint();
        if(endPoint.startsWith(fullContactLogin.get(0).Endpoint__c)) {
            PersonResponse resBody = new PersonResponse();
            resBody.fullName = 'Full Contact';
            
            PersonResponse.Emails emails = new PersonResponse.Emails();
            emails.label = 'Personal';
            emails.value = 'abc@def.ghi';
            
            PersonResponse.Details details = new PersonResponse.Details();
            details.emails = new List<PersonResponse.Emails>{emails};
            resBody.details = details;
            
            res.setBody(JSON.serialize(resBody));
            res.setStatusCode(200);
        }	//	FullContact Mock Ends 
        //	News API success callout mock
        else if(String.isNotBlank(req.getEndpoint()) && req.getEndpoint().startsWith('https://newsapi.org')) {
            NewsAPI_HeadLineResponse resBody = new NewsAPI_HeadLineResponse();
            resBody.status = 'ok';
            resBody.totalResults = 1;
            
            //	Creating a mock source
            NewsAPI_HeadLineResponse.Source source = new NewsAPI_HeadLineResponse.Source();
            source.id = 'test id';
            source.name = 'test source';
            
            //	Creating a mock article
            NewsAPI_HeadLineResponse.Article article  = new NewsAPI_HeadLineResponse.Article();
            article.author = 'test Author';
            article.content = 'test content';
            article.description = 'test description';
            article.publishedAt = '2018-01-01';
            article.source = source;
            article.title = 'test title';
            article.url = 'www.test.com';
            article.urlToImage = 'www.test.com/photo1';
            
            resBody.articles = new List<NewsAPI_HeadLineResponse.Article>{article};	//setting mock article into the mock response
                
            res.setBody(JSON.serialize(resBody));	// setting mock response body
        }
        //	Twilio Mock Starts
        else {                
            res.setStatusCode(200);
            res.setBody('{"example":"test", "status":401, "message":"Wrong mobile number"}');
        }	//Twilio Mock Ends
        
        return res;
    }

}