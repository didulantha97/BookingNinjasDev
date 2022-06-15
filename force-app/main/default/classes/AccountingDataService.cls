public with sharing class AccountingDataService {
	private static final String AND_CLAUSE = ' AND ';

	public static List<Financial_Account_LineItem__c> getAccountLIList(Date startDate, Date endDate, 
		String status, Id finAccId, Financial_Account_LineItem__c accLI) {
		List<Financial_Account_LineItem__c> accLiList = new List<Financial_Account_LineItem__c>();
    	if(Financial_Account_LineItem__c.SObjectType.getDescribe().isAccessible()){
            status = String.escapeSingleQuotes(status);
			String query = 'SELECT   Id, ' +
								    'Date__c,' +
                           		    'Description__c,' +
                           		    'Detailed_Category__c,' +
                           			'Status__c,' +
                           			'Transaction_Amount__c,' +
                           			'Name,' +
                           			'Type__c  ' +
                           	'From Financial_Account_LineItem__c ' +
                           	'WHERE Status__c =: status ' +
                           	'AND Financial_Account__c =: finAccId' + AND_CLAUSE;

            String description = accLI.Description__c;
            String category = accLI.Detailed_Category__c;
            Decimal amount = accLI.Transaction_Amount__c;
            String typeTransaction = accLI.Type__c;
            System.debug(LoggingLevel.Info ,'description = ' + description);

			if(startDate != null){
				query += 'Date__c >=: startDate' + AND_CLAUSE;
			}
			if(endDate != null){
				query += 'Date__c <=: endDate' + AND_CLAUSE;
			}
			if(category != null){
				category = String.escapeSingleQuotes(category);
				query += 'Detailed_Category__c =: category' + AND_CLAUSE;
			}
			if(amount != null){
				query += 'Transaction_Amount__c =: amount' + AND_CLAUSE;
			}
			if(typeTransaction != null){
				typeTransaction = String.escapeSingleQuotes(typeTransaction);
				query += 'Type__c =: typeTransaction' + AND_CLAUSE;
			}
			if(description != null){
				description = '\'%' + String.escapeSingleQuotes(description)  + '%\'';
				query += 'Description__c LIKE ' + description + AND_CLAUSE;
			}

			if(query.contains(AND_CLAUSE)){
				query = query.removeEnd(AND_CLAUSE);
			}
			accLiList = Database.query(query);
		}
		return accLiList;
	}


	public List<Financial_Account_LineItem__c> getAccountLIListExtended(Date startDate, Date endDate,
			String status, Id finAccId, Financial_Account_LineItem__c accLI) {

		List<Financial_Account_LineItem__c> accLiList = new List<Financial_Account_LineItem__c>();
		if(Financial_Account_LineItem__c.SObjectType.getDescribe().isAccessible()){
			status = String.escapeSingleQuotes(status);
			String query = 'SELECT   Id, ' +
					'Date__c,' +
					'Description__c,' +
					'Detailed_Category__c,' +
					'Detailed_Category__r.Name,' +
					'Status__c,' +
					'Transaction_Amount__c,' +
					'Name,' +
					'Type__c  ' +
					'From Financial_Account_LineItem__c ' +
					'WHERE Status__c =: status ' +
					'AND Financial_Account__c =: finAccId' + AND_CLAUSE;

			String description = accLI.Description__c;
			String category = accLI.Detailed_Category__c;
			Decimal amount = accLI.Transaction_Amount__c;
			String typeTransaction = accLI.Type__c;
			System.debug(LoggingLevel.Info ,'description = ' + description);

			if(startDate != null){
				query += 'Date__c >=: startDate' + AND_CLAUSE;
			}
			if(endDate != null){
				query += 'Date__c <=: endDate' + AND_CLAUSE;
			}
			if(String.isNotBlank(category)){
				category = String.escapeSingleQuotes(category);
				query += 'Detailed_Category__c =: category' + AND_CLAUSE;
			}
			if(amount != null){
				query += 'Transaction_Amount__c =: amount' + AND_CLAUSE;
			}
			if(String.isNotBlank(typeTransaction)){
				typeTransaction = String.escapeSingleQuotes(typeTransaction);
				query += 'Type__c =: typeTransaction' + AND_CLAUSE;
			}
			if(String.isNotBlank(description)){
				description = '\'%' + String.escapeSingleQuotes(description)  + '%\'';
				query += 'Description__c LIKE ' + description + AND_CLAUSE;
			}

			if(query.contains(AND_CLAUSE)){
				query = query.removeEnd(AND_CLAUSE);
			}

			accLiList = Database.query(query);
		}
		return accLiList;
	}
}