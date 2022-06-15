public with sharing class YodleeImportDataController {
	public String username{get;set;}
	public String password{get;set;}
	private YodleeImportDataService importService;
	public List<YodleeObject.Account> accList{get;set;}
	public Booking__c booking{get;set;}
    public Boolean isLogged{get;set;}

	public YodleeImportDataController() {
		this(new YodleeImportDataService(new YodleeDataService()));
	}

	@TestVisible
	private YodleeImportDataController(YodleeImportDataService importService){
		this.importService = importService;
		//username = 'sbMembel0rus2';
		//password = 'sbMembel0rus2#123';
		isLogged = false;
		accList = new List<YodleeObject.Account>();
		booking = new Booking__c(
			End_Date__c = System.today().addDays(-1),
			Start_Date__c = System.today().addDays(-1).addMonths(-1)
		);
	}
	public void clickConnect(){
        try{
			List<Financial_Account_LineItem__c> finAccItemList = importService.importTransactions(accList, booking.Start_Date__c, booking.End_Date__c);   
			List<Financial_Account_LineItem__c> insertedItemList = importService.getInsertedRecords(finAccItemList);
            String message = 'Import completed. Imported items : ' + insertedItemList.size();
            message += '. Duplicate items: ' + (finAccItemList.size() - insertedItemList.size());
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, message));
        }catch(Exception e){
        	System.debug(LoggingLevel.Info ,'e = ' + e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error occured during import.'));
        }
        
	}

	public void clickLogin(){
        try{
			importService.login(username, password);
			isLogged = true;            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Wrong username or password.'));
        }
	}


	public void clickLoadAccounts(){
		accList = importService.getAccountList();
	}

	public List<YodleeObject.Account> getFilteredAccounts(){
		List<YodleeObject.Account> filteredAccountList = new List<YodleeObject.Account>();
		for(YodleeObject.Account acc : accList){
			if(String.isNotBlank(acc.accountName)){
				filteredAccountList.add(acc);
			}
		}
		return filteredAccountList;
	}

	public String getUserSession(){
		return importService.getUserSession();
	}

	public String getAccessToken(){
		return importService.getAccessToken();
	}

	public String getLastImportDateMessage(){
		Date importDate = importService.getLastImportDate();
        String message = 'You have never imported data.';
        if(importDate != null){
            message = 'Date of last transaction: ' + importDate.format();
        }
		return message;
	}

}