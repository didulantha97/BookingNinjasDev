@isTest
public class TestYodleeImportData {
	public class ResponseMock implements HttpCalloutMock {
		public String body = '';
		public ResponseMock(String body){
			this.body = body;
		}

		public HTTPResponse respond(HTTPRequest req) {
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/xml');
			res.setBody(body);
			res.setStatusCode(200);
			return res;

		}
	}    
	public class MultiRequestMock implements HttpCalloutMock {
		public Map<String, HttpCalloutMock> requests = new Map<String, HttpCalloutMock>();

		public HTTPResponse respond(HTTPRequest req) {
			String body = req.getEndpoint();
			System.debug(LoggingLevel.Info ,'body = ' + body);
			for(String template : requests.keySet()){
				if(body.containsIgnoreCase(template)){
					HttpCalloutMock mock = requests.get(template);
					return mock.respond(req);
				}
			}
			return null;
		}

		public void addRequestMock(String template, HttpCalloutMock mock) {
			requests.put(template, mock);
		}
	}
    
	public class DataService implements YodleeDataService.DI{
		public Map<String, Financial_Account__c> finAccountsMap = new Map<String, Financial_Account__c>();

		public List<SObject> insertRecords(List<SObject> records){
			return records;
		}
		public Map<String, Financial_Account__c> getFinancialAccountMap(Set<String> bankNames){
			return finAccountsMap;
		}
		public Financial_Account_LineItem__c getLastFinAccItem(){
			return new Financial_Account_LineItem__c();
		}
		public List<Detailed_Category__c> getDetailedCategoryList(){
			return new List<Detailed_Category__c>();
		}

	}
	@isTest static void testController() {
		ResponseMock cobrandLogin = new ResponseMock(YodleeOperationTemplate.postCobrandLoginTemplate());
		ResponseMock userLogin = new ResponseMock(YodleeOperationTemplate.postUserLoginTemplate());
		ResponseMock accessToken = new ResponseMock(YodleeOperationTemplate.getAccessTokenTemplate());
		ResponseMock getAccounts = new ResponseMock(YodleeOperationTemplate.getAccountsTemplate());
		ResponseMock getTransactions = new ResponseMock(YodleeOperationTemplate.getTransactionsTemplate());
		MultiRequestMock multiMock = new MultiRequestMock();
		multiMock.addRequestMock('/cobrand/login', cobrandLogin);
		multiMock.addRequestMock('/user/login', userLogin);
		multiMock.addRequestMock('/user/accessTokens', accessToken);
		multiMock.addRequestMock('/accounts', getAccounts);
		multiMock.addRequestMock('/transactions', getTransactions);
		Test.setMock(HttpCalloutMock.class, multiMock);

		DataService dataService = new DataService();
		YodleeImportDataService importService = new YodleeImportDataService(dataService);
		YodleeImportDataController contr = new YodleeImportDataController(importService);
		contr.clickLogin();
		System.assert(contr.isLogged);
		contr.clickLoadAccounts();
		System.assert(!contr.getFilteredAccounts().isEmpty());
		contr.clickConnect();
		contr.getAccessToken();
		contr.getUserSession();
		contr.getLastImportDateMessage();
        importService.deduplicate('2016-12-01', '2016-12-01');
	}

	@isTest static void testDataService() {
		YodleeDataService service = new YodleeDataService();
		service.insertRecords(new List<SObject>{new Log_Message__c()});
		service.getFinancialAccountMap(new Set<String>{'123'});
        service.getLastFinAccItem();
        service.getDetailedCategoryList();
		Configuration.setValue('test', 'test');
	}
}