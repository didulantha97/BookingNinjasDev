public with sharing class YodleeJsonParser {

	public static String parseAccessToken(String text) {
   		Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(text);
           		System.debug(LoggingLevel.Info ,'data = ' + data);

        String token = '';
   		if( !data.isEmpty()){
			Map<String, Object> userNode = (Map<String, Object>)data.get('user');
			List<Object> tokenList = (List<Object>)userNode.get('accessTokens');
			System.debug(LoggingLevel.Info ,' = ' + tokenList);
			Map<String, Object> tokenMap = (Map<String, Object>)tokenList.get(0);
            token = (String)tokenMap.get('value');
		}
		return token;
	}

	public static List<YodleeObject.Account> parseAccounts(String text) {
		System.debug(LoggingLevel.Info ,'text = ' + text);
        List<YodleeObject.Account> accList = new List<YodleeObject.Account>();
   		Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(text);
   		if( !data.isEmpty()){
			List<Object> dataList = (List<Object>)data.get('account');
			for(Object item : dataList){
				Map<String, Object> accNode = (Map<String, Object>)item;
				YodleeObject.Account accItem = new YodleeObject.Account();
				accItem.id = String.valueOf(accNode.get('id'));
				accItem.providerName = String.valueOf(accNode.get('providerName'));
				String accountName = accNode.get('accountName') != null ? (String)accNode.get('accountName') : '';
				accItem.accountName = String.valueOf(accountName);
				accList.add(accItem);
			}
		}
			System.debug(LoggingLevel.Info ,'accList = ' + accList);
		return accList;
	}

	public static List<YodleeObject.Transaction2> parseTransactions(String text) {
		System.debug(LoggingLevel.Info ,'text = ' + text);
		List<YodleeObject.Transaction2> transList = new List<YodleeObject.Transaction2>();
   		Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(text);
   		if( !data.isEmpty()){
			List<Object> dataList = (List<Object>)data.get('transaction');
			for(Object item : dataList){
				YodleeObject.Transaction2 transItem = new YodleeObject.Transaction2();
				Map<String, Object> transn = (Map<String, Object>)item;
				Map<String, Object> amountNode = (Map<String, Object>)transn.get('amount');
				Map<String, Object> descrNode = (Map<String, Object>)transn.get('description');
				transItem.amount = Double.valueOf(amountNode.get('amount'));
				transItem.curency = String.valueOf(amountNode.get('currency')); 
				transItem.categoryType = String.valueOf(transn.get('categoryType'));
				transItem.id = String.valueOf(transn.get('id'));
				transItem.category = String.valueOf(transn.get('category'));
				Object transactionDate = transn.get('transactionDate');
				transactionDate = transactionDate == null ? transn.get('postDate') : transactionDate;
				transItem.transactionDate = Date.valueOf((String)transactionDate);
				transItem.accountId = String.valueOf(transn.get('accountId'));
				transItem.descriptionOriginal = String.valueOf(descrNode.get('original'));
				transItem.descriptionConsumer = String.valueOf(descrNode.get('consumer'));
				transItem.descriptionSimple = String.valueOf(descrNode.get('simple'));

				transList.add(transItem);
			}
   		}
		System.debug(LoggingLevel.Info ,'transList = ' + transList);
		return transList;
	}

	public static void parseDetailedCetegoryList(String text){
		List<String> dCategoryList = new List<String>();
   		Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(text);
   		if( !data.isEmpty()){
			List<Object> dataList = (List<Object>)data.get('transactionCategory');
			for(Object item : dataList){
				Map<String, Object> itemObject = (Map<String, Object>)item;
				dCategoryList.add(String.valueOf(itemObject.get('category')));
			}
		}
		List<Detailed_Category__c> dList = [Select Id, name From Detailed_Category__c where Name IN : dCategoryList];
		System.debug(LoggingLevel.Info ,'dList = ' + dList.size());
		System.debug(LoggingLevel.Info ,'dCategoryList = ' + dCategoryList.size());

	}
}