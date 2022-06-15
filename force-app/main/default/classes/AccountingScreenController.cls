public with sharing class AccountingScreenController
{
    public static final String NEW_TRANSACTIONS_STATUS = 'New Transactions';
    public static final String EXCLUDED_STATUS = 'Excluded';
    public static final String RECONSILED_STATUS = 'Reconciled';

    @AuraEnabled(cacheable=true)
    public static List<Financial_Account__c> getFAccountList()
    {
        List<Financial_Account__c> listOfAccounts;

        if (Financial_Account__c.SObjectType.getDescribe().isAccessible()) {
            listOfAccounts = [
                    SELECT Id, Name, Items_To_Reconcile__c, Balance__c
                    FROM   Financial_Account__c
                    LIMIT  50000
            ];
        }

        return listOfAccounts;
    }

    @AuraEnabled(cacheable=true)
    public static List<Detailed_Category__c> getDetailedCategories()
    {
        Set<String> necessaryCategoryNames = new Set<String>
        {
                'Splitted', 'UnCategorized'
        };

        List<Detailed_Category__c> categories = [
                SELECT Id, Name
                FROM  Detailed_Category__c
                WHERE Name IN :necessaryCategoryNames
                LIMIT 10
        ];

        return categories;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, String> getCategoryListDependent()
    {
        Map<String, String> result = new Map<String, String>();

        List<Category_List__c> categoryLists = [
                SELECT Name,
                        (SELECT Name FROM Detailed_Categories__r)
                FROM Category_List__c
                LIMIT 1000
        ];

        for (Category_List__c currentCategoryList : categoryLists)
        {
            for (Detailed_Category__c currentDetailedCategory : currentCategoryList.Detailed_Categories__r)
            {
                result.put(currentDetailedCategory.Id, currentCategoryList.Name + ' | ' + currentDetailedCategory.Name);
            }
        }

        return result;
    }

    @AuraEnabled
    public static RelatedListsWrapper getRelatedLists(Date startDate, Date endDate,
            String finAccId, String description, String detailedCategoryId, String transactionAmount, String type)
    {
        AccountingDataService dataService = new AccountingDataService();
        Financial_Account_LineItem__c accLI = new Financial_Account_LineItem__c();
        accLI.Description__c = description;
        accLI.Detailed_Category__c = String.isNotBlank(detailedCategoryId) ? detailedCategoryId : accLI.Detailed_Category__c;
        accLI.Transaction_Amount__c = String.isNotBlank(transactionAmount) ? Double.valueOf(transactionAmount) : accLI.Transaction_Amount__c;
        accLI.Type__c = type;

        RelatedListsWrapper result = new RelatedListsWrapper();
        result.newTransactions = dataService.getAccountLIListExtended(startDate, endDate, NEW_TRANSACTIONS_STATUS, finAccId, accLI);
        result.reconciled = dataService.getAccountLIListExtended(startDate, endDate, RECONSILED_STATUS, finAccId, accLI);
        result.excluded = dataService.getAccountLIListExtended(startDate, endDate, EXCLUDED_STATUS, finAccId, accLI);

        return result;
    }

    @AuraEnabled
    public static void removeRelatedRecords(List<ID> lineItemIds)
    {
        List<Financial_Account_LineItem__c> accountLineItems = [
                SELECT (SELECT Id FROM Sales__r), (SELECT Id FROM Expenses__r)
                FROM Financial_Account_LineItem__c
                WHERE Id IN :lineItemIds
        ];

        if (!accountLineItems.isEmpty())
        {
            List<SObject> recordsToDelete = new List<SObject>();

            for(Financial_Account_LineItem__c item : accountLineItems){
                recordsToDelete.addAll(item.Sales__r);
                recordsToDelete.addAll(item.Expenses__r);
            }
            
            if (!recordsToDelete.isEmpty())
            {
                delete recordsToDelete;
            }
        }
    }

    @AuraEnabled
    public static void insertSplitItems(List<Map<String, String>> splittedItems)
    {
        Map<String, Schema.SObjectType> sobjectsDescribes = Schema.getGlobalDescribe();
        List<SObject> recordsToInsert = new List<SObject>();

        for (Map<String, String> currentObjectData : splittedItems)
        {
            SObject newRecord = sobjectsDescribes.get(currentObjectData.get('SobjectType')).newSObject();
            currentObjectData.remove('SobjectType');

            for (String fieldName : currentObjectData.keySet())
            {
                if (fieldName == 'Amount__c')
                {
                    newRecord.put(fieldName, Double.valueOf(currentObjectData.get(fieldName)));
                }
                else if (fieldName == 'Date__c')
                {
                    newRecord.put(fieldName, Date.valueOf(currentObjectData.get(fieldName)));
                }
                else
                {
                    newRecord.put(fieldName, currentObjectData.get(fieldName));
                }
            }

            recordsToInsert.add(newRecord);
        }        

        insert recordsToInsert;
    }

    @AuraEnabled
    public static List<Financial_Account_LineItem__c> updateFAccountLineItem(String updateItems, String detailedCategory)
    {
        List<Financial_Account_LineItem__c> itemList = (List<Financial_Account_LineItem__c> )JSON.deserialize(updateItems, List<Financial_Account_LineItem__c>.class);
        List<Financial_Account_LineItem__c> updatedFAItems = new List<Financial_Account_LineItem__c>();
        
        Map<Id, Financial_Account_LineItem__c> mapFALineItems = new Map<Id, Financial_Account_LineItem__c>(itemList);
        Detailed_Category__c detailCategory;
        if(String.isNotEmpty(detailedCategory)){
            detailCategory = [SELECT ID FROM Detailed_Category__c WHERE Id = :detailedCategory LIMIT 1];
        }

        for(Financial_Account_LineItem__c updatedItem : [SELECT ID, Status__c, Detailed_Category__c FROM Financial_Account_LineItem__c WHERE ID IN :mapFALineItems.keySet()]){
            updatedItem.Status__c = mapFALineItems.get(updatedItem.Id).Status__c;
            updatedItem.Detailed_Category__c = detailCategory != null ? detailCategory.Id : updatedItem.Detailed_Category__c;
            updatedFAItems.add(updatedItem);
        }
        update updatedFAItems;
        return updatedFAItems;
    }


    public class RelatedListsWrapper
    {
        @AuraEnabled public List<Financial_Account_LineItem__c> newTransactions;
        @AuraEnabled public List<Financial_Account_LineItem__c> reconciled;
        @AuraEnabled public List<Financial_Account_LineItem__c> excluded;
    }
    
}