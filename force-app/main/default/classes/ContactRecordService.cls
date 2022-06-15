public class ContactRecordService {

    public void process(List<Account> accountList) {
        
        Set<Id> accIds = new Set<Id>();
        for(Account account : accountList) {
            accIds.add(account.Id);
        }
        
        Map<Id, Account> mappedAccounts = new Map<Id, Account>([SELECT Id, Name, Total_Contact_Records__c FROM Account WHERE Id IN :accIds]);
        Map<Id, Account> accounts_to_update = new Map<Id, Account>();
        
        for(Account account : accountList) {
            Account acc = mappedAccounts.get(account.Id);
            if(acc != null) {
                List<Contact> count = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
                acc.Total_Contact_Records__c = count.size();
                accounts_to_update.put(acc.Id, acc);
            }
            continue;
        }
        
        try {
            update accounts_to_update.values();
        }
        catch(DMLException e) {
            system.debug('Records were not all properly updated.  Error: '+ e);
        }
    }
}