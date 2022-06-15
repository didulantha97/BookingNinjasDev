public with sharing class LoginHistory {

    public static final String LAST_7_DAYS   = '7';
    public static final String LAST_14_DAYS  = '14';
    public static final String LAST_30_DAYS  = '30';
    public static final String CURRENT_MONTH = 'currentMonth';

    public static final String sandboxUrl          = 'https://test.salesforce.com';
    public static final String prodUrl             = 'https://login.salesforce.com';
    public static final String versionServiceClass = '49.0';

    public static final String ERROR_MESSAGE_NO_USERNAME = 'Dont populated userName';
    public static final String ERROR_MESSAGE_NO_PASSWORD = 'Dont populated password';
    public static final String ERROR_MESSAGE_WRONG_PERIOD = 'Dont populated date period';

    @AuraEnabled
    public static Map<String, String> logInOrg(String userName, String password, Boolean isSandbox) {
        validateCredential(userName, password);

        Map<String, String> result = new Map<String, String>();
        partnerSoapSforceAPI.Soap partner = new partnerSoapSforceAPI.Soap();

        partner.endpoint_x = (isSandbox ? sandboxUrl : prodUrl) + '/services/Soap/u/' + versionServiceClass;
        partnerSoapSforceAPI.LoginResult responce = partner.login(userName, password);

        result.put('sessionId', responce.sessionId);
        result.put('serverUrl', responce.serverUrl);
        return result;
    }

    @AuraEnabled
    public static List<UserLoginHistoryWrapper> fetchLoginHistory(String serverUrl, String sessionId, String datePeriod) {
        List<UserLoginHistoryWrapper> result            = new List<UserLoginHistoryWrapper>();
        String responceUsersRecords                     = queryDateFromOrg (serverUrl, sessionId, getUserQueryByDatePeriod(datePeriod));
        String responceLoginHistoryRecords              = queryDateFromOrg (serverUrl, sessionId, getLoginHistoryGroupedQueryByDatePeriod(datePeriod));
        UserResponce         parsedUsersResponce        = (UserResponce) System.JSON.deserialize(responceUsersRecords, UserResponce.class);
        LoginHistoryResponce parsedLoginHistoryResponce = (LoginHistoryResponce) System.JSON.deserialize(responceLoginHistoryRecords, LoginHistoryResponce.class);

        Map<Id,User> users = new Map<Id,User>(parsedUsersResponce.records);

        for (LoginHistoryAgregateResultResponce usersLogins : parsedLoginHistoryResponce.records) {
            result.add(new UserLoginHistoryWrapper(usersLogins.numOfLogins, users.get(usersLogins.UserId)));
        }
        return result;
    }

    @AuraEnabled
    public static List<LoginHistoryWraper> getLoginHistoryDetails(String serverUrl, String sessionId, String datePeriod, String userId) {
        String responceLoginHistoryDetails = queryDateFromOrg (serverUrl, sessionId, getLoginHistoryDetailsQueryByDatePeriod(userId, datePeriod));
        LoginHistoryDetailsResponce parsedUsersResponce = (LoginHistoryDetailsResponce) System.JSON.deserialize(responceLoginHistoryDetails, LoginHistoryDetailsResponce.class);
        return parsedUsersResponce.records;
    }

    public static String getLoginHistoryDetailsQueryByDatePeriod(String userId, String datePeriod) {
        return 'SELECT Id, UserId, LoginTime, LoginGeo.Country, LoginGeo.City, Browser, Status, ApiType  FROM LoginHistory WHERE LoginTime > '
            + getDateTimeByDatePeriod(datePeriod) + ' AND UserId = \'' + String.escapeSingleQuotes(userId)+'\' ORDER BY LoginTime DESC';
    }

    public static String getLoginHistoryGroupedQueryByDatePeriod(String datePeriod) {
        return 'SELECT COUNT(Id) numOfLogins, UserId FROM LoginHistory WHERE LoginTime > '
            + getDateTimeByDatePeriod(datePeriod) + ' GROUP BY UserId';
    }

    public static String getDateTimeByDatePeriod(String datePeriod) {
        Date today;

        if (datePeriod == LAST_7_DAYS) {
            today = System.today().addDays(-7);
        } else if (datePeriod == LAST_14_DAYS) {
            today = System.today().addDays(-14);
        } else if (datePeriod == LAST_30_DAYS) {
            today = System.today().addDays(-30);
        } else if (datePeriod == CURRENT_MONTH) {
            today = System.today().toStartOfMonth();
        } else {
            throw new LoginException(ERROR_MESSAGE_WRONG_PERIOD);
        }

        Datetime dt = datetime.newInstance(today.year(), today.month(),today.day());
        return dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
    }

    public static String getUserQueryByDatePeriod(String datePeriod) {
        return 'SELECT Id, Username, LastName, FirstName, Name, LastLoginDate FROM User WHERE LastLoginDate > '
            + getDateTimeByDatePeriod(datePeriod);
    }

    static String queryDateFromOrg(String serverUrl, String sessionId, String query) {
        HttpRequest request = new HttpRequest();

        String url = serverUrl.split('/services')[0];
        PageReference theUrl = new PageReference(url + '/services/data/v' + versionServiceClass + '/query/');
        theUrl.getParameters().put('q', query);

        request.setMethod('GET');
        request.setEndPoint(theUrl.getUrl());

        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization','Bearer ' + sessionId);

        Http http = new Http();
        HTTPResponse res = http.send(request);
        return res.getBody();
    }

    @AuraEnabled
    public static List<Org_Credential__mdt> fetchOrgsCredentials() {
        return [SELECT MasterLabel, isSandbox__c, Password__c ,UserName__c FROM Org_Credential__mdt];
    }

    @AuraEnabled
    public static List<CustomOptions> getDatePeriodOptions() {
        List<CustomOptions> options = new List<CustomOptions>();
        options.add(new CustomOptions('Last 7 days', LAST_7_DAYS));
        options.add(new CustomOptions('Last 14 days', LAST_14_DAYS));
        options.add(new CustomOptions('Last 30 days', LAST_30_DAYS));
        options.add(new CustomOptions('Current month', CURRENT_MONTH));
        return options;
    }

    static void validateCredential(String userName, String password) {
        if (String.isBlank(userName)) {
            throw new LoginException(ERROR_MESSAGE_NO_USERNAME);
        }
        if (String.isBlank(password)) {
            throw new LoginException(ERROR_MESSAGE_NO_PASSWORD);
        }
    }

    public class LoginHistoryDetailsResponce {
        public Integer    totalSize;
        public Boolean    done;
        public List<LoginHistoryWraper> records;
    }

    public class LoginHistoryWraper {
        @AuraEnabled public String Id;
        @AuraEnabled public Datetime LoginTime;
        @AuraEnabled public String Browser;
        @AuraEnabled public String ApiType;
        @AuraEnabled public String Status;
        @AuraEnabled public LoginGeoWraper LoginGeo;
    }

    public class LoginGeoWraper {
        @AuraEnabled public String  Country;
        @AuraEnabled public String  City;
    }

    public class UserResponce {
        public Integer    totalSize;
        public Boolean    done;
        public List<User> records;
    }

    public class LoginHistoryResponce {
        public Integer    totalSize;
        public Boolean    done;
        public List<LoginHistoryAgregateResultResponce> records;
    }

    public class LoginHistoryAgregateResultResponce {
        public Integer numOfLogins;
        public String  UserId;
    }

    public class UserLoginHistoryWrapper {
        @AuraEnabled public String   Id;
        @AuraEnabled public String   name;
        @AuraEnabled public String   userName;
        @AuraEnabled public Datetime lastLoginDate;
        @AuraEnabled public Integer  numOfLogin;

        public UserLoginHistoryWrapper(Integer numOfLogin, User user) {
            this.numOfLogin    = numOfLogin;
            this.Id            = user.Id;
            this.name          = user.Name;
            this.lastLoginDate = user.LastLoginDate;
            this.userName      = user.Username;
        }
    }

    public class CustomOptions {
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        public customOptions(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    public class LoginException extends Exception{}


}