public with sharing class OverrideOpportunityNewButtonCntr {
    
    @AuraEnabled (cacheable = true)
    public static String getRecordTypeNameById(String recordTypeId) {
        final Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity; 
        final Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        return rtMapById.get(recordTypeId).getName();
    }  

}