@isTest
public class Test_AccountingMainController {

    public static testMethod void testAccountingMainController() {
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


        ////////////////////////////
        //Splitted Objects - Start//
        ////////////////////////////
        Expenses__c ex1 = new Expenses__c();
        ex1.Amount__c = -100;
        ex1.Date__c = system.today();
        ex1.Description__c = 'Some Description';

        Expenses__c ex2 = new Expenses__c();
        ex2.Amount__c = -1100;
        ex2.Date__c = system.today();
        ex2.Description__c = 'Some Description';

        Sales__c sa1 = new Sales__c();
        sa1.Amount__c = 100;
        sa1.Date__c = system.today();
        sa1.Description__c = 'Some Description';

        Sales__c sa2 = new Sales__c();
        sa2.Amount__c = 200;
        sa2.Date__c = system.today();
        sa2.Description__c = 'Some Description';

        List<Expenses__c> exList = new List<Expenses__c>();
        exList.add(ex1);
        exList.add(ex2);

        List<Sales__c> sList = new List<Sales__c>();
        sList.add(sa1);
        sList.add(sa2);


        PageReference AccountingMainPage = page.AccountingMain;
        test.setCurrentPage(AccountingMainPage);

        Test.startTest();

        AccountingMainController amc = new AccountingMainController(new ApexPages.StandardController(faObj));
        amc.selectedFAccount = faObj.Id;
        amc.DetailedCategorySelection = dcObj.id;

        amc.selectedFAccountLineItem = faliObj.id;
        amc.accountLIDummy.Description__c = 'Descr';
        amc.search();
        amc.popupSelector();
        amc.reconcileItem();
        amc.undoReconciliation();

        amc.accountLIDummy.Description__c = null;

        amc.selectedFAccountLineItem = faliObj2.id;
        amc.popupSelector();
        amc.reconcileItem();
        amc.undoReconciliation();
        amc.getReconciledList();
        amc.getExcludedList();
        amc.getNewTransactionList();

        //excluded item
        amc.selectedFAccountLineItem = faliObj3.id;
        amc.popupSelector();
        amc.undoReconciliation();

        amc.getFinancialAccounts();
        amc.selectFAccount();
        amc.getCategoryList();
        amc.getDetailedCategoryList();
        amc.getCategoryListDependent();
        amc.getStatus();

        amc.excludeItem();

        //Test Splitting and unsplitting - populate lists
        amc.selectedFAccountLineItem = faliObj.id;
        amc.popupSelector();

        amc.SplitItemPopupControl();

        amc.numberOfRowToRemove = 1;
        amc.splittedExpenseList = exList;

        amc.AddSplittedItem();
        amc.reconcileSplitted();
        amc.RemoveSplittedItem();
        amc.CloseSplitPopup();


        //Test splitSale
        amc.selectedFAccountLineItem = faliObj4.id;
        amc.popupSelector();

        amc.SplitItemPopupControl();
        amc.numberOfRowToRemove = 2;
        amc.splittedSaleList = sList;

        amc.AddSplittedItem();
        amc.reconcileSplitted();
        amc.RemoveSplittedItem();
        amc.CloseSplitPopup();
        amc.ClearValues();

        amc.splittedExpense = new Expenses__c(Amount__c = -1);
        amc.AddSplittedItem();

        Test.stopTest();
    }
}