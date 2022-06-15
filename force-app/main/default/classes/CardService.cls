public without sharing class CardService {
    /**
     * creates Card record to related contact
     * @param fieldVals fieldValues that sent by call out response
     * @param contId related contactId
     */
    public static void createCardRecord(List<EsignEmbedService.FieldValue> fieldVals, Id contId) {
        Map<String, String> valuesByFieldName = new Map<String, String>();

        for(EsignEmbedService.FieldValue field: fieldVals){
            if(String.isNotEmpty(field.name)) {
                valuesByFieldName.put(field.name, field.value);
            }
        }
        try {
            insert new Card__c(
                Contact__c = contId,
                Card_Holder__c = valuesByFieldName.get('Signer Name'),
                Card_Number__c = valuesByFieldName.get('Card Number'),
                Expiration_Date__c = Date.newInstance(2000 + Integer.valueOf(valuesByFieldName.get('Expiration Year')), Integer.valueOf(valuesByFieldName.get('Expiration Month')), 1),
                Security_Code__c = valuesByFieldName.get('Security Code')
            );
        }
        catch(Exception ex) {
            throw new EsignEmbedService.EmbedServiceException(ex.getMessage());
        }
    }
}