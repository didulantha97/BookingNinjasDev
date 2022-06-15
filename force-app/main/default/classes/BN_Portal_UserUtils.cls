public class BN_Portal_UserUtils {
    
    public static Boolean isLogout() {
        
        DateTime dt =  DateTime.now();
        String strdate = dt.format('MMddyyyy');
        String uniqueId = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP') + '.' + strdate;
        
        List<BN_User_History_Login__c> loginHis = [SELECT Id, isLogout__c
                                           FROM BN_User_History_Login__c
                                           WHERE Status__c = 'Success' 
                                            AND Session_Id__c = :uniqueId
                                           ORDER BY CreatedDate DESC];
                                           
        if (loginHis.size() == 0) return true;
            
        if (loginHis[0].isLogout__c) return true;

        return false;
    }
    
    public static String logout() {
    
        DateTime dt =  DateTime.now();
        String strdate = dt.format('MMddyyyy');
        String uniqueId = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP') + '.' + strdate;
        
        List<BN_User_History_Login__c> loginHists = [SELECT Id, isLogout__c
                                           FROM BN_User_History_Login__c
                                           WHERE isLogout__c = false 
                                            AND Session_Id__c = :uniqueId
                                            ORDER BY CreatedDate DESC];
        try {
            if (loginHists.size() > 0) {
                for (BN_User_History_Login__c loginHist : loginHists) {
                    loginHist.isLogout__c = true;
                }
            }
            UPDATE loginHists;
        } catch (Exception e) {
            System.debug('Login Exception: ' + e);
            return e.getMessage();
        }
        
        return '';
    }
    
    public static String login(String username, String password) {
        if (String.isEmpty(username))
            return System.Label.BN_User_Username_Empty;
        if (String.isEmpty(password))
            return System.Label.BN_User_Password_Empty;
        
        DateTime dt =  DateTime.now();
        String strdate = dt.format('MMddyyyy');
        String uniqueId = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP') + '.' + strdate;
          
        try {
            List<BN_User__c> beUsers = [SELECT Id, Password__c, Status__c, Contact__c
                            FROM BN_User__c 
                            WHERE Username__c = :username];
            if (beUsers.size() == 0) {
                System.debug(System.Label.BN_User_No_Exist);
                return System.Label.BN_User_No_Exist;
            } else {
                if (beUsers[0].Password__c != password) {
                    System.debug(System.Label.BN_User_Pass_Incorrect);
                    BN_User_History_Login__c newLogin = new BN_User_History_Login__c(                       
                        BN_User__c = beUsers[0].Id,
                        Status__c = 'Password Incorrect',
                        Session_Id__c = uniqueId,
                        Source_IP__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'));
                    INSERT newLogin;
                    return System.Label.BN_User_Pass_Incorrect;
                } if (beUsers[0].Contact__c == null) {
                    return 'This user is not link to any opportunity. Please contact with our administrator.';
                } else if (beUsers[0].Status__c == 'Inactive' || beUsers[0].Status__c == 'Locked') {
                    System.debug(System.Label.BN_User_Inactive);
                    BN_User_History_Login__c newLogin = new BN_User_History_Login__c(
                        BN_User__c = beUsers[0].Id,
                        Status__c = 'User Inactive',
                        Session_Id__c = uniqueId,
                        Source_IP__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'));
                    INSERT newLogin;
                    return System.Label.BN_User_Inactive;
                }
            }
        
            System.debug('Login Success');
            BN_User_History_Login__c newLogin = new BN_User_History_Login__c(
                BN_User__c = beUsers[0].Id,
                Status__c = 'Success',
                Session_Id__c = uniqueId,
                Source_IP__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP'));
            INSERT newLogin;
        } catch (Exception e) {
            System.debug('Login Exception: ' + e);
            return e.getMessage();
        }

        return '';
    }
    
    public static String getCurrBNUserId() {

        DateTime dt =  DateTime.now();
        String strdate = dt.format('MMddyyyy');
        String uniqueId = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP') + '.' + strdate;
        
        List<BN_User_History_Login__c> loginHis = [SELECT Id, BN_User__c
                                           FROM BN_User_History_Login__c
                                           WHERE Status__c = 'Success' 
                                            AND isLogout__c = false
                                            AND Session_Id__c = :uniqueId
                                           ORDER BY CreatedDate DESC LIMIT 1];
        if (loginHis.size() > 0) return loginHis[0].BN_User__c;
        return '';
    }
    
    public static Contact getContactByBNUserId(string userId) {
        
        BN_User__c user = [SELECT Id, Contact__c FROM BN_User__c WHERE Id = :userId];
        if (user != null) 
        {
            return [SELECT Id, Name, Email, Phone, AccountId, Account.Name, Vision__c, Values__c, Methods__c, Obstacles__c, Measures__c FROM Contact WHERE Id = :user.Contact__c];
        }
        return null;
    }
    
    public static String getUserRole(String userId) {
        return [SELECT Id, Role__c FROM BN_User__c WHERE Id = :userId].Role__c;
    }
    
    public static PageReference defaultLandingPage() {
        PageReference fwPage = new PageReference('/portal');

        return fwPage;
    }
}