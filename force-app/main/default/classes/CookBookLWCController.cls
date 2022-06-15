public with sharing class CookBookLWCController {

    private static final String AND_CLAUSE = ' AND ';
    private static final String WHERE_CLAUSE = ' WHERE ';
    private static final List<String> callResultsRestriction = new List<String>{
        'Appointments',
        'Call Backs',
        'Contacted',
        'Voice Mail'
    };

    @AuraEnabled(cacheable=true)
    public static List<Account_Executive__c> getAccountExecutives() {
        return [
            SELECT Id, Name, Email__c 
            FROM Account_Executive__c 
            WITH SECURITY_ENFORCED 
            ORDER BY Name DESC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static String search(String searchJson) {

        SearchWrapper sw = (SearchWrapper) JSON.deserialize(searchJson, SearchWrapper.class);
        
        String query = 'SELECT  Id, ' +
                               'Contact__c, ' +
                               'Contact__r.Name, ' +
                               'Contact__r.LinkedIN__c, ' +
                               'Contact__r.Title, ' +
                               'Scheduled_Date__c, ' +
                               'Scheduled_Time__c, ' +
                               'Notes__c, ' +
                               'Type__c, ' +
                               'Account_Executive__c, ' +
                               'Account_Executive__r.Name, ' +
                               'AccountLookup__c, ' +
                               'AccountLookup__r.Name, ' +
                               'AccountLookup__r.Linkedin_Company_URL__c, ' +
                               'Call_Result__c, ' +
                               'Interest_Level__c ' +
                        'FROM Cook_Book__c' + WHERE_CLAUSE; 
        query += '(Call_Result__c IN :callResultsRestriction)' + AND_CLAUSE;

        if(!String.isEmpty(sw.userId)) {
            Id userId = sw.userId;
            query += 'Account_Executive__c = :userId' + AND_CLAUSE;
        }
        if(sw.startDate != null) {
            Date startDate = sw.startDate;
            query += 'Scheduled_Date__c >= :startDate' + AND_CLAUSE;
        }
        if(sw.endDate != null) {
            Date endDate = sw.endDate;
            query += 'Scheduled_Date__c <= :endDate' + AND_CLAUSE;
        }
        if(!String.isEmpty(sw.interestLevel)) {
            String interestLevel = sw.interestLevel;
            query += 'Interest_Level__c = :interestLevel' + AND_CLAUSE;
        }
        if(!String.isEmpty(sw.callResult)) {
            String callResult = sw.callResult;
            query += 'Call_Result__c = :callResult' + AND_CLAUSE;
        }
        if(!String.isEmpty(sw.continent)) {
            String continent = sw.continent;
            query += 'Contact__r.Account.Continent__c = :continent' + AND_CLAUSE;
        }

        if(sw.hasPhone) {
            query += '(Mobile__c <> null OR Phone__c <> null OR X2nd_Phone__c <> null)' + AND_CLAUSE;
        }

        if(sw.linkedinConnect) {
            String acceptedStr = 'Accepted';
            query += 'Contact__r.Linkedin_Activity__c = :acceptedStr' + AND_CLAUSE;
        }

        if(sw.hasAccount) {
            query += '(AccountLookup__c <> null OR Contact__r.AccountId <> null)' + AND_CLAUSE;
        }

        if(query.contains(AND_CLAUSE)) {
            query = query.removeEnd(AND_CLAUSE);
        }
        else {
            query = query.remove(WHERE_CLAUSE);
        }
        query += ' ORDER BY Scheduled_Time__c';
        
        
        List<Cook_Book__c> cookBookList = Database.query(String.escapeSingleQuotes(query));

        List<CookBookWrapper> cookBookWrapperList = new List<CookBookWrapper>();
        for (Cook_Book__c cb : cookBookList) {
            cookBookWrapperList.add(new CookBookWrapper(
                cb.Contact__r.Name,
                cb.AccountLookup__r.Name,
                cb.Contact__r.Title,
                cb.Scheduled_Date__c,
                cb.Interest_Level__c != null ? Integer.valueOf(cb.Interest_Level__c) : null,
                cb.Call_Result__c,
                cb.Contact__r.LinkedIN__c,
                cb.AccountLookup__r.Linkedin_Company_URL__c,
                cb.Account_Executive__r.Name,
                cb.Contact__c,
                cb.Id,
                cb.AccountLookup__c,
                cb.Notes__c
            ));
        }

        Map<String, Object> responseObj = new Map<String, Object>();
        responseObj.put('count', cookBookList.size());
        responseObj.put('searchResult', cookBookWrapperList);

        return JSON.Serialize(responseObj);
    }


    public class SearchWrapper {
        String userId;
        Date startDate;
        Date endDate;
        String interestLevel;
        String continent;
        String callResult;
        Boolean hasPhone;
        Boolean hasAccount;
        Boolean linkedinConnect;

        public SearchWrapper(String userId, Date startDate, Date endDate, String interestLevel, String continent, String callResult, Boolean hasPhone, Boolean hasAccount, Boolean linkedinConnect) {
            this.userId = userId;
            this.startDate = startDate;
            this.endDate = endDate;
            this.interestLevel = interestLevel;
            this.continent = continent;
            this.callResult = callResult;
            this.hasPhone = hasPhone;
            this.hasAccount = hasAccount;
            this.linkedinConnect = linkedinConnect;
        }
    }

    public class CookBookWrapper {
        String contactName;
        String accountName;
        String contactTitle;
        Date scheduledDate;
        Integer interestLevel;
        String callResult;
        String contactLinkedIn;
        String contactLinkedInAccount;
        String accountExecutiveNameAssignedTo;
        String navigateToContactRecordPage;
        String navigateToAccountRecordPage;
        String navigateToCookBookRecordPage;
        String cookBookNotes;

        public CookBookWrapper(
            String contactName,
            String accountName,
            String contactTitle,
            Date scheduledDate,
            Integer interestLevel,
            String callResult,
            String contactLinkedIn,
            String contactLinkedInAccount,
            String accountExecutiveNameAssignedTo,
            String contactId,
            String cookBookId,
            String accountId,
            String cookBookNotes)
        {
            this.contactName = contactName != null ? contactName : '-';
            this.accountName = accountName != null ? accountName : '-';
            this.contactTitle = contactTitle != null ? contactTitle : '-';
            this.scheduledDate = scheduledDate;
            this.interestLevel = interestLevel;
            this.callResult = callResult;
            this.contactLinkedIn = contactLinkedIn != null ? contactLinkedIn : contactLinkedInAccount;
            this.accountExecutiveNameAssignedTo = accountExecutiveNameAssignedTo;
            this.navigateToContactRecordPage = contactId != null ? '/' + contactId : '';
            this.navigateToCookBookRecordPage = cookBookId != null ? '/' + cookBookId : '';
            this.navigateToAccountRecordPage = accountId != null ? '/' + accountId : '';
            this.cookBookNotes = cookBookNotes != null ? cookBookNotes : '-';
        }
    }

}