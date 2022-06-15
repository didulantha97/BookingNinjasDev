public with sharing class CookBookController {
    
    private static final String AND_CLAUSE = ' AND ';
    private static final String WHERE_CLAUSE = ' WHERE ';
    private static final String APPOINTMENTS = 'Appointments';
    private static final String CALL_BACKS = 'Call Backs';
    private static final String VOICE_MAIL = 'Voice Mail';
    
    
    public List<CookBook> CookBooks { get; set; }
    public Integer count { get; set; }
    public Date StartDate { get; set; }
    public Date EndDate { get; set; }
    public Id UserId { get; set; }
    public String InterestLevel { get; set; }
    public String Continent { get; set; }
    public String CallResult { get; set; }
    public Boolean HasPhone { get; set; }
        
    public CookBookController()
    {
        UserId = apexpages.currentpage().getparameters().get('id');
        StartDate = String.isEmpty(apexpages.currentpage().getparameters().get('date')) ? Date.Today() : Date.valueOf(apexpages.currentpage().getparameters().get('date'));
        EndDate = StartDate;
        HasPhone = true;
        count = 0;
        
        search();
    }
    
    public void search()
    { 
        String query = 'SELECT Id, Contact__c, Contact__r.Name, Contact__r.LinkedIN__c, Contact__r.Title, Scheduled_Date__c, Scheduled_Time__c, Type__c, Account_Executive__c, Account_Executive__r.Name, Call_Result__c, Interest_Level__c FROM Cook_Book__c' + WHERE_CLAUSE;
        query += '(Call_Result__c = :APPOINTMENTS OR Call_Result__c = :CALL_BACKS OR Call_Result__c = :VOICE_MAIL)' + AND_CLAUSE;
        if(UserId != null) {
            query += 'Account_Executive__c = :UserId' + AND_CLAUSE;
        }              
        if(StartDate != null) {
            query += 'Scheduled_Date__c >= :StartDate' + AND_CLAUSE;
        }
        if(EndDate != null) {
            query += 'Scheduled_Date__c <= :EndDate' + AND_CLAUSE;
        }
        if(!String.isEmpty(InterestLevel)) {
            query += 'Interest_Level__c = :InterestLevel' + AND_CLAUSE;
        }
        if(!String.isEmpty(CallResult)) {
            query += 'Call_Result__c = :CallResult' + AND_CLAUSE;
        }
        if(!String.isEmpty(Continent)) {
            query += 'Contact__r.Account.Continent__c = :Continent' + AND_CLAUSE;
        }
        
        if(HasPhone) {
            query += '(Mobile__c <> null OR Phone__c <> null OR X2nd_Phone__c <> null)' + AND_CLAUSE;
        }
        else {
            query += '(Mobile__c = null AND Phone__c = null AND X2nd_Phone__c = null)' + AND_CLAUSE;
        }
        
        if(query.contains(AND_CLAUSE)) {
            query = query.removeEnd(AND_CLAUSE);
        }
        else {
            query = query.remove(WHERE_CLAUSE);
        }
        query += ' ORDER BY Scheduled_Time__c';
        System.debug(LoggingLevel.Info ,'query = ' + query);
        
        Cook_Book__c[] results = Database.query(String.escapeSingleQuotes(query));
        
        CookBooks = new List<CookBook>();
        for(Cook_Book__c cb : results) {
            CookBooks.add(new CookBook(cb));
        }
        
        count = CookBooks.size();
    }
    
    // wrapper class to hold aggregate data
    public class CookBook 
    {
        public String Id { get; private set; }
        public String Contact { get; private set; }
        public String AE { get; private set; }
        public String ScheduledDate { get; private set; }
        public String ScheduledTime { get; private set; }
        public String CallResult { get; private set; }
        public String InterestLevel { get; private set; }
        public String Linkedin { get; private set; }
        public String Title { get; private set; }

        public CookBook(Cook_Book__c cb) {
            Id = cb.Id;
            Contact = cb.Contact__r.Name;
            ScheduledDate = cb.Scheduled_Date__c == null ? '' : cb.Scheduled_Date__c.Month() + '/' + cb.Scheduled_Date__c.Day() + '/' + cb.Scheduled_Date__c.Year();
            ScheduledTime = cb.Scheduled_Time__c == null ? '' : cb.Scheduled_Time__c.Hour() + ':' + cb.Scheduled_Time__c.Minute();
            AE = cb.Account_Executive__r.Name;
            CallResult = cb.Call_Result__c;
            InterestLevel = cb.Interest_Level__c;
            Linkedin = cb.Contact__r.LinkedIN__c;
            Title = cb.Contact__r.Title;
        }
    }
    
    public List<SelectOption> getListOfUsers() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        for(Account_Executive__c ae : [Select Id, Name, Email__c from Account_Executive__c]) {
            options.add(new SelectOption(ae.Id, ae.Email__c));
        }
        return options;
    }
    
    public List<SelectOption> getListOfInterestLevel() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        for(Integer i = 0; i <= 10; i++) {
            options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        return options;
    }
    
    public List<SelectOption> getListOfCallResult() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        //options.add(new SelectOption('Contacted', 'Contacted'));
        options.add(new SelectOption('Voice Mail', 'Voice Mail'));
        options.add(new SelectOption('Call Backs', 'Call Backs'));
        options.add(new SelectOption('Appointments', 'Appointments'));
        //options.add(new SelectOption('2nd Meetings', '2nd Meetings'));
        //options.add(new SelectOption('Demo/Trial', 'Demo/Trial'));
        //options.add(new SelectOption('Proposal', 'Proposal'));
        //options.add(new SelectOption('Close', 'Close'));
        return options;
    }
    
    public List<SelectOption> getListOfContinents() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        options.add(new SelectOption('Africa', 'Africa'));
        options.add(new SelectOption('Asia', 'Asia'));
        options.add(new SelectOption('Australia & Oceania', 'Australia & Oceania'));
        options.add(new SelectOption('EC America', 'EC America'));
        options.add(new SelectOption('EMEA', 'EMEA'));
        options.add(new SelectOption('Europe', 'Europe'));
        options.add(new SelectOption('South America', 'South America'));
        options.add(new SelectOption('WC America', 'WC America'));
        return options;
    }
}