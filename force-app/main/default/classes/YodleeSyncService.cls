public with sharing class YodleeSyncService {
    private String userLogin;
    private String userPassword;
    private String cobrandLogin;
    private String cobrandPassword;
    private String cobrandSession;
    public String userSession{get;private set;}
    public String accessToken{get;private set;}
  
    public YodleeSyncService() {
        cobrandLogin = Configuration.getValue('Yodlee Cobrand Login');
        cobrandPassword = Configuration.getValue('Yodlee Cobrand Password');
    }

    public void login(String userLogin, String userPassword){
        this.userLogin = userLogin;
        this.userPassword = userPassword;
        cobrandSession = postCobrandLogin();
        userSession = postUserLogin(cobrandSession);
        accessToken = getAccessToken();
        
    }

    private String sendRequest(HttpRequest request){
        String body = '';
        try { 
            Http http = new Http();
            HttpResponse response = http.send(request);
            body = response.getBody();
        } catch(Exception e) {}
        return body;
    }

    public String postCobrandLogin(){
        HttpRequest req = new HttpRequest();
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        req.setEndpoint(YodleeOperationTemplate.BASE_URL + '/cobrand/login');
        req.setBody(YodleeOperationTemplate.postCobrandLogin(cobrandLogin, cobrandPassword));
        String body = sendRequest(req);
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(body);
        Map<String, Object> session = (Map<String, Object>)data.get('session');
        return (String)session.get('cobSession');
    }

    public String postUserLogin(String cobSession){
        HttpRequest req = new HttpRequest();
        req.setHeader('content-type', 'application/json');
        req.setMethod('POST');
        req.setEndpoint(YodleeOperationTemplate.BASE_URL + '/user/login');
        req.setBody(YodleeOperationTemplate.postUserLogin(userLogin, userPassword));
        req.setHeader('Authorization', YodleeOperationTemplate.getUserLoginAuthHeader(cobSession));
        String body = sendRequest(req);
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(body);
        Map<String, Object> userNode = (Map<String, Object>)data.get('user');
        Map<String, Object> sessionNode = (Map<String, Object>)userNode.get('session');
        return (String)sessionNode.get('userSession');
    }

    public String getAccessToken(){
        HttpRequest req = new HttpRequest();
        req.setHeader('content-type', 'application/json'); 
        req.setMethod('GET');
        req.setEndpoint(YodleeOperationTemplate.BASE_URL + '/user/accessTokens?appIds=10003600');
        req.setHeader('Authorization', YodleeOperationTemplate.getTransactionsAuthHeader(cobrandSession, userSession));
        String body = sendRequest(req);
        System.debug(LoggingLevel.Info ,'body = ' + body);
        
        return YodleeJsonParser.parseAccessToken(body);
    }


    public List<YodleeObject.Account> getAccounts(){
        HttpRequest req = new HttpRequest();
        req.setHeader('content-type', 'application/json');
        req.setMethod('GET');
        req.setEndpoint(YodleeOperationTemplate.BASE_URL + '/accounts');
        req.setHeader('Authorization', YodleeOperationTemplate.getTransactionsAuthHeader(cobrandSession, userSession));
        String body = sendRequest(req);
        return YodleeJsonParser.parseAccounts(body);
    }

/*    public void getCategories(){
        HttpRequest req = new HttpRequest();
        req.setHeader('content-type', 'application/json');
        req.setMethod('GET');
        req.setEndpoint(YodleeOperationTemplate.BASE_URL + '/transactions/categories');
        req.setHeader('Authorization', YodleeOperationTemplate.getTransactionsAuthHeader(cobrandSession, userSession));
        String body = sendRequest(req);
        YodleeJsonParser.parseDetailedCetegoryList(body);
    }*/

    public List<YodleeObject.Transaction2> getTransactions(Set<String> accIds, String startDate, String endDate, Integer skip){
        HttpRequest req = new HttpRequest();
        req.setHeader('content-type', 'application/json');
        req.setMethod('GET');
        req.setTimeout(60000);
        req.setEndpoint(YodleeOperationTemplate.getTransactionsEndPoint(accIds, startDate, endDate, skip));
        req.setHeader('Authorization', YodleeOperationTemplate.getTransactionsAuthHeader(cobrandSession, userSession));
        String body;
        do{
        	body = sendRequest(req);       
            System.debug(LoggingLevel.Info ,'send = ' + body);
        }while(body == '');
        return YodleeJsonParser.parseTransactions(body);
    }
}