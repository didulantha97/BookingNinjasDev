public with sharing class YodleeOperationTemplate {
	public static final String BASE_URL = Configuration.getValue('Yodlee API URL');
	public static String postCobrandLogin(String cobrandLogin, String cobrandPassword) {
		return '{' +
				    '"cobrand": {' +
				    '  "cobrandLogin": "'+ cobrandLogin +'",' +
				    '  "cobrandPassword": "'+ cobrandPassword +'",' +
				    '  "locale": "en_US"' +
				    ' }' +
				'}';
	}

	public static String postUserLogin(String userLogin, String userPassword) {
		return '{' +
				    '"user": {' +
				    '  "loginName": "'+ userLogin +'",' +
				    '  "password": "'+ userPassword +'",' +
				    '  "locale": "en_US"' +
				    ' }' +
				'}';
	}	

	public static String getTransactionsAuthHeader(String cobSession, String userSession) {
		return '{cobSession=' + cobSession + ',' + 'userSession=' + userSession + '}';
	}	

	public static String getTransactionsEndPoint(Set<String> accIds, String startDate, String endDate, Integer skip) {
		//String result = '/transactions';
		String result = '/transactions?accountId=';
		for(String item : accIds){
			result += item + '%2C';
		}
		result = result.removeEnd('%2C');
        if(String.isNotBlank(startDate)){
          result += '&fromDate=' + startDate;      
        }
        if(String.isNotBlank(endDate)){
          result += '&toDate=' + endDate;      
        }    
        if(skip > 0){
          result += '&skip=' + skip;
        }

		return BASE_URL + result;
	}	

	public static String getUserLoginAuthHeader(String cobSession) {
		return '{cobSession=' + cobSession + '}';
	}	

  public static String getAccountsTemplate(){
    return ' {' +
            '"account": [' +
             '  {' +
              '    "accountName": "getAccountsTemplate",' +
               '   "id": 801503,' +
                '  "providerName": "Dag Site"' +
               '}' +
            ']' +
            '}';
  }

  public static String postCobrandLoginTemplate(){
    return '{ '+
            '"session" : {'+
             '   "cobSession": "postCobrandLoginTemplate" '+
            '}'+
          '} ';
  }

  public static String postUserLoginTemplate(){
    return '{'+
            '"user":{'+
             ' "session": { "userSession": "postUserLoginTemplate" }'+
             ' }'+
            '}';
  }

  public static String getAccessTokenTemplate(){
    return '{'+
           '"user":{'+
            '"accessTokens":['+
             '{'+
              '  "appId":"10003600",'+
              '  "value":"9670352f863c07bed8c2ce606bf8a23cc701f2a5f72821e5c11f42e5e821f053"'+
             '}'+
            ']'+
           '}'+
        '}';
  }  

  public static String getTransactionsTemplate(){
    return '{'+
            ' "transaction": ['+
             '{'+
              '  "id": 2829798,'+
               ' "amount": {'+
                '  "amount": 12345.12,'+
                 ' "currency": "USD"'+
                '},'+
                '"baseType": "DEBIT",'+
                '"categoryType": "EXPENSE",'+
                '"categoryId": 143,'+
                '"category": "Electronics / General Merchandise",'+
                '"date": "2014-07-01",'+
                '"transactionDate": "2014-07-01",'+
                '"postDate": "2014-07-01",'+
                '"description":{'+
                 ' "original": "0150 Amazon  Santa Ana CA 55.73USD",'+
                  '"consumer": "Electronic Purchases",'+
                  '"simple": "Amazon Purchase"'+
                '},'+
                '"accountId": 801503'+
             '}'+
             ']'+
          '}';
  }  
}