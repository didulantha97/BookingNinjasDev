public with sharing class YodleeDataService implements DI{
	public interface DI{
		List<SObject> insertRecords(List<SObject> records);
		Map<String, Financial_Account__c> getFinancialAccountMap(Set<String> bankNames);
		Financial_Account_LineItem__c getLastFinAccItem();
		List<Detailed_Category__c> getDetailedCategoryList();
	}

	public List<SObject> insertRecords(List<SObject> records){
		if( !records.isEmpty() && records.get(0).getSObjectType().getDescribe().isCreateable()){
			Database.insert(records, false);
		}
		return records;
	}	

	public Financial_Account_LineItem__c getLastFinAccItem(){
		List<Financial_Account_LineItem__c> finList = new List<Financial_Account_LineItem__c>();
		if(Financial_Account_LineItem__c.SObjectType.getDescribe().isAccessible()){
			finList.addAll([Select Date__c
						   From Financial_Account_LineItem__c
						   Order By Date__c DESC
						   Limit 1]);
		}
 		return finList.isEmpty() ? new Financial_Account_LineItem__c() : finList.get(0);
	}

	public Map<String, Financial_Account__c> getFinancialAccountMap(Set<String> bankNames){
		List<Financial_Account__c> finAccList = new List<Financial_Account__c>();
		if(! bankNames.isEmpty() && Financial_Account__c.SObjectType.getDescribe().isAccessible()){
			finAccList.addAll([Select Id,
									  Name
							   FROM Financial_Account__c
							   Where Name IN : bankNames]);
		}
		Map<String, Financial_Account__c> nameToAccountMap = new Map<String, Financial_Account__c>();
		for(Financial_Account__c item : finAccList){
			nameToAccountMap.put(item.Name, item);
		}
		return nameToAccountMap;
	}

	public List<Detailed_Category__c> getDetailedCategoryList(){
		List<Detailed_Category__c> categoryList = new List<Detailed_Category__c>();
		if(Detailed_Category__c.SObjectType.getDescribe().isAccessible()){
			categoryList.addAll([Select Name
								From Detailed_Category__c]);
		}
		return categoryList;
	}
}