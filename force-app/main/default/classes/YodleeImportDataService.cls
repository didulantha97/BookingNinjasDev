public with sharing class YodleeImportDataService {
	private YodleeSyncService syncService;
	private YodleeDataService.DI dataService;
	public static final String SPENT = 'SPENT';
	public static final String RECEIVED = 'RECEIVED';
	public static final String EXPENSE = 'EXPENSE';

	public YodleeImportDataService(YodleeDataService.DI dataService) {
		syncService = new YodleeSyncService();
		this.dataService = dataService;
	}

	public void login(String userLogin, String userPassword){
		syncService.login(userLogin, userPassword);
	}

	public String getAccessToken(){
		return syncService.accessToken;
	}

	public String getUserSession(){
		return syncService.userSession;
	}

	public List<YodleeObject.Account> getAccountList(){
		return syncService.getAccounts();
	}

	public Map<String, Financial_Account__c>  processFinancialAccounts(Set<String> bankNames){
		Map<String, Financial_Account__c> nameToAccountMap = dataService.getFinancialAccountMap(bankNames);
		List<Financial_Account__c> finAccountList = new List<Financial_Account__c>();
		for(String name : bankNames){
			if( !nameToAccountMap.containsKey(name)){
				Financial_Account__c finAccount = new Financial_Account__c();
				finAccount.Name = name;
				finAccountList.add(finAccount);
				nameToAccountMap.put(name, finAccount);
			}
		}
		dataService.insertRecords(finAccountList);
		return nameToAccountMap;
	}

	public List<Financial_Account_LineItem__c> importTransactions(List<YodleeObject.Account> accList, Date startDate, Date endDate){
		System.debug(LoggingLevel.Info ,'accList = ' + accList);
		Set<String> accIds = new Set<String>();
		Set<String> bankNames = new Set<String>();

		for(YodleeObject.Account acc : accList){
		   accIds.add(acc.id);
		   bankNames.add(acc.providerName);
		}
		String startDt = startDate == null ? null : IntegrationSetting.formatDate(startDate);
		String endDt = endDate == null ? null : IntegrationSetting.formatDate(endDate);
		List<YodleeObject.Transaction2> transnList = new List<YodleeObject.Transaction2>();
		List<YodleeObject.Transaction2> transnListItem = new List<YodleeObject.Transaction2>();
		Integer skip = 0;
		Integer skipLimit = 500;
		do{
			transnListItem.clear();
			transnListItem.addAll(syncService.getTransactions(accIds, startDt, endDt, skip));
			transnList.addAll(transnListItem);
			skip = transnListItem.size();
		}
		while(skip == skipLimit);
		
		Map<String, Financial_Account__c> nameToAccountMap = processFinancialAccounts(bankNames);
		System.debug(LoggingLevel.Info ,'nameToAccountMap = ' + nameToAccountMap);
		Map<String, Financial_Account__c> bankIdToAccountMap = new Map<String, Financial_Account__c>();
		System.debug(LoggingLevel.Info ,'accList = ' + accList);
		for(YodleeObject.Account acc : accList){
			Financial_Account__c finAccount = nameToAccountMap.get(acc.providerName);
			if(finAccount != null){
				bankIdToAccountMap.put(acc.id, finAccount);
			}
		}
		System.debug(LoggingLevel.Info ,'bankIdToAccountMap = ' + bankIdToAccountMap);
		Map<String, Id> nameToCategoryMap = buildNameToDetailedCategoryMap(dataService.getDetailedCategoryList());
		List<Financial_Account_LineItem__c> finAccItemList = getFinlAccountItemList(transnList, bankIdToAccountMap, nameToCategoryMap);
		return dataService.insertRecords(finAccItemList);
	}

	private List<Financial_Account_LineItem__c> getFinlAccountItemList(List<YodleeObject.Transaction2> transnList, 
						Map<String, Financial_Account__c> bankIdToFinAccountMap, Map<String, Id> nameToCategoryMap){
		List<Financial_Account_LineItem__c> finAccItemList = new List<Financial_Account_LineItem__c>();
		for(YodleeObject.Transaction2 transn : transnList){
			Financial_Account__c finAccount = bankIdToFinAccountMap.get(transn.accountId);
			Financial_Account_LineItem__c item = new Financial_Account_LineItem__c();
			item.Detailed_Category__c = nameToCategoryMap.get(transn.category);
			item.Description__c = transn.descriptionOriginal;
			item.Date__c = transn.transactionDate;
			item.Transaction_Amount__c = transn.categoryType == EXPENSE ? -transn.amount : transn.amount;
			item.Financial_Account__c = finAccount != null ? finAccount.Id : null;
			item.Type__c = transn.categoryType == EXPENSE ? SPENT : RECEIVED;
			item.Yodlee_Id__c = transn.id;
			finAccItemList.add(item);
		}
		return finAccItemList;
	}
    
	public List<Financial_Account_LineItem__c> getInsertedRecords(List<Financial_Account_LineItem__c> itemList){
		List<Financial_Account_LineItem__c> insertedItemList = new List<Financial_Account_LineItem__c>();
		for(Financial_Account_LineItem__c item : itemList){
			if(item.Id != null){
				insertedItemList.add(item);
			}
		}
		return insertedItemList;
	}    

	private Map<String, Id> buildNameToDetailedCategoryMap(List<Detailed_Category__c> categoryList){
		Map<String, Id> nameToCategoryMap = new Map<String, Id>();
		for(Detailed_Category__c category : categoryList){
			nameToCategoryMap.put(category.Name, category.Id);
		}
		return nameToCategoryMap;
	}

	public Date getLastImportDate(){ 
		Financial_Account_LineItem__c item = dataService.getLastFinAccItem();
		return item.Date__c;
	}

	public List<Financial_Account_LineItem__c> deduplicate(String startDt, String endDt){
		List<YodleeObject.Account> accList = getAccountList();
		System.debug(LoggingLevel.Info ,'accList = ' + accList);
		Set<String> accIds = new Set<String>();
		Set<String> bankNames = new Set<String>();

		for(YodleeObject.Account acc : accList){
		   accIds.add(acc.id);
		   bankNames.add(acc.providerName);
		}

		List<YodleeObject.Transaction2> transnList = new List<YodleeObject.Transaction2>();
		List<YodleeObject.Transaction2> transnListItem = new List<YodleeObject.Transaction2>();
		Integer skip = 0;
		Integer skipLimit = 500;
		do{
			transnListItem.clear();
			transnListItem.addAll(syncService.getTransactions(accIds, startDt, endDt, skip));
			transnList.addAll(transnListItem);
			skip = transnListItem.size();
		}
		while(skip == skipLimit);
		
		Map<String, Financial_Account__c> nameToAccountMap = processFinancialAccounts(bankNames);
		Map<String, Financial_Account__c> bankIdToAccountMap = new Map<String, Financial_Account__c>();
		for(YodleeObject.Account acc : accList){
			Financial_Account__c finAccount = nameToAccountMap.get(acc.providerName);
			if(finAccount != null){
				bankIdToAccountMap.put(acc.id, finAccount);
			}
		}
		Map<String, Id> nameToCategoryMap = buildNameToDetailedCategoryMap(dataService.getDetailedCategoryList());

		List<Financial_Account_LineItem__c> yoItems = getFinlAccountItemList(transnList, bankIdToAccountMap, nameToCategoryMap);
		
		List<Financial_Account_LineItem__c> bnItems = [Select Date__c, Description__c, Transaction_Amount__c, Yodlee_Id__c From Financial_Account_LineItem__c Order By Date__c DESC];
		Set<String> yoIds = new Set<String>();
        for(Financial_Account_LineItem__c item : bnItems){
            if(item.Yodlee_Id__c != null){
                yoIds.add(item.Yodlee_Id__c);
            }
        }
        List<Financial_Account_LineItem__c> updItems = new List<Financial_Account_LineItem__c>();
        for(Financial_Account_LineItem__c yoItem : yoItems){
            if(yoIds.contains(yoItem.Yodlee_Id__c)){
                continue;
            }
			//String yoKey = String.valueOf(yoItem.Date__c) +String.valueOf(yoItem.Description__c) +String.valueOf(Math.abs(yoItem.Transaction_Amount__c.setScale(2)));
			String yoKey = String.valueOf(yoItem.Description__c) +String.valueOf(Math.abs(yoItem.Transaction_Amount__c.setScale(2)));
			for(Integer i = 0; i < bnItems.size(); i++){
                Financial_Account_LineItem__c bnItem = bnItems[i];
				//String bnKey = String.valueOf(bnItem.Date__c) + String.valueOf(bnItem.Description__c) + String.valueOf(Math.abs(bnItem.Transaction_Amount__c));
				String bnKey = String.valueOf(bnItem.Description__c) + String.valueOf(Math.abs(bnItem.Transaction_Amount__c));
                    System.debug(LoggingLevel.Info ,'yoKey = ' + yoKey);
                    System.debug(LoggingLevel.Info ,'bnKey = ' + bnKey);

                if(bnKey == yoKey && bnItem.Yodlee_Id__c == null){
                    
					bnItem.Yodlee_Id__c = yoItem.Yodlee_Id__c;
                    updItems.add(bnItem);
                    System.debug(LoggingLevel.Info ,'bnItem = ' + bnItem);
					break;
				}
			}
		}
        		System.debug(LoggingLevel.Info ,'updItems = ' + updItems);
        		System.debug(LoggingLevel.Info ,'updItems = ' + updItems.size());
        return updItems;
		//update updItems;
	}

}