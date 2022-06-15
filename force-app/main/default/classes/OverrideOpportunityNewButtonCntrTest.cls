@isTest
private with sharing class OverrideOpportunityNewButtonCntrTest {
    @isTest
    private static void testRecordTypeNameById() {
        String recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        String verifyLabelRecordType = OverrideOpportunityNewButtonCntr.getRecordTypeNameById(recTypeId);
        System.assertEquals('Client', verifyLabelRecordType);
    } 
}