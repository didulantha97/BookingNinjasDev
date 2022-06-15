global with sharing class IntegrationSetting {
    private static Integrations__c intgn;
    public static final String RU_SETTING = 'RU Settings';

    static{
        Map<String, Integrations__c> propty = Integrations__c.getAll();
        intgn = propty.get(RU_SETTING);
        if(intgn == null){
            intgn = new Integrations__c();
        }
    }

    public static String userName = intgn.User_Name__c;
    public static String password = intgn.Password__c;
    public static String ruAPIurl = intgn.RU_API_URL__c;
    public static Boolean isRuSyncActive = intgn.is_RU_Sync_Active__c;

    public static final String NOT_REQUIRED = 'Not required';
    public static final String REQUIRED = 'Required';
    public static final String BLOCKED_STATUS = 'Blocked';
    public static final String CANCELLED_BY_CLIENT_STATUS = 'Cancelled By Client';
    public static final String APPROVED_STATUS = 'Approved';
    public static final String CREDIT_CARD_METHOD = 'Credit Card';

    public static String formatDate(Date dt){
        return Datetime.newInstance(dt.year(), dt.month(), dt.day()).format('YYYY-MM-dd');
    }

}