@isTest
public with sharing class AccountingScreenControllerTest
{
	@testSetup
	private static void init()
	{
		Financial_Account__c faObj = new Financial_Account__c();
		faObj.Name = 'TestFa';
		insert faObj;

		Financial_Account_LineItem__c faliObj = new Financial_Account_LineItem__c();
		faliObj.Financial_Account__c = faObj.id;
		faliObj.Date__c = system.today();
		faliObj.Status__c = 'New Transactions';
		faliObj.Type__c = 'RECEIVED';
		faliObj.Description__c = 'Description';
		faliObj.Transaction_Amount__c = 100;
		insert faliObj;



		Financial_Account_LineItem__c faliObj2 = new Financial_Account_LineItem__c();
		faliObj2.Financial_Account__c = faObj.id;
		faliObj2.Date__c = system.today();
		faliObj2.Status__c = 'Reconciled';
		faliObj2.Type__c = 'SPENT';
		faliObj2.Transaction_Amount__c = -100;
		insert faliObj2;

		Financial_Account_LineItem__c faliObj3 = new Financial_Account_LineItem__c();
		faliObj3.Financial_Account__c = faObj.id;
		faliObj3.Date__c = system.today();
		faliObj3.Status__c = 'Excluded';
		faliObj3.Type__c = 'SPENT';
		faliObj3.Transaction_Amount__c = -100;
		insert faliObj3;

		Financial_Account_LineItem__c faliObj4 = new Financial_Account_LineItem__c();
		faliObj4.Financial_Account__c = faObj.id;
		faliObj4.Date__c = system.today();
		faliObj4.Status__c = 'New Transactions';
		faliObj4.Type__c = 'SPENT';
		faliObj4.Transaction_Amount__c = -100;
		insert faliObj4;

		Financial_Account_LineItem__c faliObj5 = new Financial_Account_LineItem__c();
		faliObj5.Financial_Account__c = faObj.id;
		faliObj5.Date__c = system.today();
		faliObj5.Status__c = 'New Transactions';
		faliObj5.Type__c = 'SPENT';
		faliObj5.Transaction_Amount__c = -100;
		insert faliObj5;


		Financial_Account_LineItem__c faliObj6 = new Financial_Account_LineItem__c();
		faliObj6.Financial_Account__c = faObj.id;
		faliObj6.Date__c = system.today();
		faliObj6.Status__c = 'New Transactions';
		faliObj6.Type__c = 'SPENT';
		faliObj6.Transaction_Amount__c = -100;
		insert faliObj6;


		Financial_Account_LineItem__c faliObj7 = new Financial_Account_LineItem__c();
		faliObj7.Financial_Account__c = faObj.id;
		faliObj7.Date__c = system.today();
		faliObj7.Status__c = 'New Transactions';
		faliObj7.Type__c = 'SPENT';
		faliObj7.Transaction_Amount__c = -100;
		insert faliObj7;

		Financial_Account_LineItem__c faliObj8 = new Financial_Account_LineItem__c();
		faliObj8.Financial_Account__c = faObj.id;
		faliObj8.Date__c = system.today();
		faliObj8.Status__c = 'New Transactions';
		faliObj8.Type__c = 'SPENT';
		faliObj8.Transaction_Amount__c = -100;
		insert faliObj8;

		Financial_Account_LineItem__c faliObj9 = new Financial_Account_LineItem__c();
		faliObj9.Financial_Account__c = faObj.id;
		faliObj9.Date__c = system.today();
		faliObj9.Status__c = 'New Transactions';
		faliObj9.Type__c = 'SPENT';
		faliObj9.Transaction_Amount__c = -100;
		insert faliObj9;

		Financial_Account_LineItem__c faliObj10 = new Financial_Account_LineItem__c();
		faliObj10.Financial_Account__c = faObj.id;
		faliObj10.Date__c = system.today();
		faliObj10.Status__c = 'New Transactions';
		faliObj10.Type__c = 'SPENT';
		faliObj10.Transaction_Amount__c = -100;
		insert faliObj10;


		Category_List__c clObj = new Category_List__c();
		clObj.name = 'New Test Category';
		insert clObj;

		Category_List__c clObj2 = new Category_List__c();
		clObj2.name = 'UnCategorized';
		insert clObj2;

		Detailed_Category__c dcObj = new Detailed_Category__c();
		dcObj.Name = 'Test detail Category';
		dcObj.Category_List__c = clObj.id;
		insert dcObj;

		Detailed_Category__c dcObj2 = new Detailed_Category__c();
		dcObj2.Name = 'UnCategorized';
		dcObj2.Category_List__c = clObj.id;
		insert dcObj2;

		Detailed_Category__c dcObj3 = new Detailed_Category__c();
		dcObj3.Name = 'Splitted';
		dcObj3.Category_List__c = clObj.id;
		insert dcObj3;
	}

	@isTest
	private static void testGetFAccounts()
	{
		Test.startTest();
		List<Financial_Account__c> testFinancialAccounts = AccountingScreenController.getFAccountList();
		Test.stopTest();

		System.assert(testFinancialAccounts != null, 'Financial Accounts were not found!');
		System.assert(!testFinancialAccounts.isEmpty(), 'Not all Financial Accounts were not found!');
	}

	@isTest
	private static void testGetDetailedCategories()
	{
		Test.startTest();
		List<Detailed_Category__c> testDetailedCategories = AccountingScreenController.getDetailedCategories();
		Test.stopTest();

		System.assert(!testDetailedCategories.isEmpty(), 'Not all Detailed Categories were not found!');
	}

	@isTest
	private static void testGetCategoryListDependent()
	{
		Test.startTest();
		Map<String, String> testCategories = AccountingScreenController.getCategoryListDependent();
		Test.stopTest();

		System.assert(!testCategories.isEmpty(), 'Not all Depended Detailed Categories were not found!');
	}

	@isTest
	private static void testGetRelatedLists()
	{
		Date yesterday = System.today().addDays(-1);
		Date tomorrow = System.today().addDays(1);

		Test.startTest();
		AccountingScreenController.RelatedListsWrapper testResult = AccountingScreenController.getRelatedLists(yesterday,
				tomorrow, null, 'Description', null, '300', 'SPENT');
		Test.stopTest();

		System.assert(testResult.newTransactions != null, 'New Transactions were not retrieved!');
		System.assert(testResult.reconciled != null, 'Reconciled Transactions were not retrieved!');
		System.assert(testResult.excluded != null, 'Excluded Transactions were not retrieved!');
	}

	@isTest
	private static void testRemoveRelatedRecords()
	{
		Financial_Account_LineItem__c faliObj = [
				SELECT Id
				FROM Financial_Account_LineItem__c
				WHERE Status__c = 'New Transactions'
				LIMIT 1
		];

		Expenses__c ex1 = new Expenses__c();
		ex1.Related_FA_LineItem__c = faliObj.Id;
		ex1.Amount__c = -100;
		ex1.Date__c = system.today();
		ex1.Description__c = 'Some Description';

		Expenses__c ex2 = new Expenses__c();
		ex2.Related_FA_LineItem__c = faliObj.Id;
		ex2.Amount__c = -1100;
		ex2.Date__c = system.today();
		ex2.Description__c = 'Some Description';

		Sales__c sa1 = new Sales__c();
		sa1.Related_FA_LineItem__c = faliObj.Id;
		sa1.Amount__c = 100;
		sa1.Date__c = system.today();
		sa1.Description__c = 'Some Description';

		Sales__c sa2 = new Sales__c();
		sa2.Related_FA_LineItem__c = faliObj.Id;
		sa2.Amount__c = 200;
		sa2.Date__c = system.today();
		sa2.Description__c = 'Some Description';

		List<Expenses__c> exList = new List<Expenses__c>();
		exList.add(ex1);
		exList.add(ex2);

		List<Sales__c> sList = new List<Sales__c>();
		sList.add(sa1);
		sList.add(sa2);

		insert exList;
		insert sList;

		Test.startTest();
        List<ID> recordIds = new List<ID>();
        recordIds.add(faliObj.Id);
        AccountingScreenController.removeRelatedRecords(recordIds);
		Test.stopTest();

		exList = [
				SELECT Id
				FROM Expenses__c
		];

		sList = [
				SELECT Id
				FROM Sales__c
		];

		System.assert(exList.isEmpty(), 'Expenses were not removed during Undo!');
		System.assert(sList.isEmpty(), 'Sales were not removed during Undo!');
	}

	@isTest
	private static void testInsertSplitItems()
	{
		Financial_Account_LineItem__c faliObj = [
				SELECT Id
				FROM Financial_Account_LineItem__c
				WHERE Status__c = 'New Transactions'
				LIMIT 1
		];

		List<Map<String, String>> splittedItemsData = new List<Map<String, String>>
		{
				new Map<String, String>{
						'SobjectType' => 'Sales__c',
						'Related_FA_LineItem__c' => faliObj.Id,
						'Amount__c' => '100'
				},
				new Map<String, String>{
						'SobjectType' => 'Sales__c',
						'Related_FA_LineItem__c' => faliObj.Id,
						'Amount__c' => '100'
				}
		};

		Test.startTest();
		AccountingScreenController.insertSplitItems(splittedItemsData);
		Test.stopTest();

		List<Sales__c> sList = [
				SELECT Id
				FROM Sales__c
		];

		System.assert(!sList.isEmpty(), 'Splitted items were not inserted!');
	}
    @isTest
	private static void testUpdateFAccountLineItem()
	{
		List<Financial_Account_LineItem__c> faliList = [
				SELECT Id, Status__c, Detailed_Category__c
				FROM Financial_Account_LineItem__c
				WHERE Status__c = 'New Transactions'
				LIMIT 1
		];
        Detailed_Category__c detailCategory = [
				SELECT Id
				FROM Detailed_Category__c
				WHERE Name = 'Test detail Category'
				LIMIT 1
		];
		Test.startTest();
		List<Financial_Account_LineItem__c> faLineItems = AccountingScreenController.updateFAccountLineItem(JSON.serialize(faliList), detailCategory.Id);
		Test.stopTest();
        System.assertEquals(detailCategory.Id, faLineItems[0].Detailed_Category__c);
	}
    @isTest
	private static void testGetAccountLIList()
	{
		Date yesterday = System.today().addDays(-1);
		Date tomorrow = System.today().addDays(1);
        Financial_Account_LineItem__c faliObj = [
            SELECT Id, Name, Status__c, Detailed_Category__c, Description__c, Transaction_Amount__c, Date__c, Type__c, Financial_Account__c
            FROM Financial_Account_LineItem__c
            WHERE Status__c = 'New Transactions'
            LIMIT 1
        ];
		Test.startTest();
		List<Financial_Account_LineItem__c> testResult = AccountingDataService.getAccountLIList(yesterday,
				tomorrow, 'New Transactions', faliObj.Financial_Account__c, faliObj);
		Test.stopTest();

		System.assert(testResult[0].Transaction_Amount__c == 100);
	}
    
}