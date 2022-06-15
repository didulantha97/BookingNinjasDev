public with sharing class AccountingMainController {

    public List<Financial_Account__c> listOfAccounts;

    //Tab control - in order to prevent inactive tabs scipts to execute - Start
    public String tabInFocus {get; set;}
    //Tab Control - End

    public ReconcileExpensePopUp expensePopUp {get; set;}
    public ReconcileSalePopUp salePopUp {get; set;}

    //Split item props - Start
    public SplitExpenseReconcilePopUp SplitExpenseItemPopup {get; set;}
    public SplitSaleReconcilePopUp SplitSaleItemPopup {get; set;}
    public List<Expenses__c> splittedExpenseList {get; set;}
    public List<Sales__c> splittedSaleList {get; set;}
    public Financial_Account_LineItem__c ItemToSplitTemp {get; set;}
    public Expenses__c expense {get; set;}
    public Sales__c sale {get; set;}
    public Expenses__c splittedExpense {get; set;}
    public Sales__c splittedSale {get; set;}

    public decimal totalLeft {get; set;}
    public Integer numberOfRowToRemove {get; set;}
    //Split item props - End

    public id selectedFAccount {get; set;}

    //Populated When Item is selected list to reconcile
    public id selectedFAccountLineItem {get; set;}

    public id MainCategorySelection {get; set;}
    public id DetailedCategorySelection {get; set;}

    public Booking__c booking {get; set;}
    public Financial_Account_LineItem__c accountLIDummy {get; set;}
    public static final String NEW_TRANSACTIONS_STATUS = 'New Transactions';
    public static final String EXCLUDED_STATUS = 'Excluded';
    public static final String RECONSILED_STATUS = 'Reconciled';
    public static final String NEW_TRANSACTIONS_TAB = 'NewTransactionsT';
    public static final String EXCLUDED_TAB = 'ExcludedT';
    public static final String RECONCILED_TAB = 'ReconciledT';
    public static final Integer PAGE_SIZE = 10;
    private AccountingDataService dataService = new AccountingDataService();
    public ApexPages.StandardSetController newTranactionsControl {get; set;}
    public ApexPages.StandardSetController excludedControl {get; set;}
    public ApexPages.StandardSetController reconciledControl {get; set;}

    public AccountingMainController(ApexPages.StandardController controller) {
        accountLIDummy = new Financial_Account_LineItem__c();
        booking = new Booking__c(
            Start_Date__c = System.today().addMonths(-1),
            End_Date__c = System.today()
        );

        initObjects();

        getFAccountList();
    }

    public String getStatus() {
        System.debug(LoggingLevel.Info , 'tabInFocus = ' + tabInFocus);
        if (tabInFocus == EXCLUDED_TAB) {
            return EXCLUDED_STATUS;
        }
        if (tabInFocus == RECONCILED_TAB) {
            return RECONSILED_STATUS;
        }
        return NEW_TRANSACTIONS_STATUS;
    }

    public void search() {
        initControls();
    }

    public List<Financial_Account_LineItem__c> getTransactions(String status) {
        return AccountingDataService.getAccountLIList(booking.Start_Date__c, booking.End_Date__c, status, selectedFAccount, accountLIDummy);
    }


    private void initControls() {
        newTranactionsControl = reInitControl(newTranactionsControl, getTransactions(NEW_TRANSACTIONS_STATUS));
        System.debug('**** newTranactionsControl: ' + newTranactionsControl);
        excludedControl = reInitControl(excludedControl, getTransactions(EXCLUDED_STATUS));
        reconciledControl = reInitControl(reconciledControl, getTransactions(RECONSILED_STATUS));
    }

    public List<Financial_Account_LineItem__c> getNewTransactionList() {
        return getControlRecords(newTranactionsControl);
    }

    public List<Financial_Account_LineItem__c> getExcludedList() {
        return getControlRecords(excludedControl);
    }

    public List<Financial_Account_LineItem__c> getReconciledList() {
        return getControlRecords(reconciledControl);
    }

    private ApexPages.StandardSetController reInitControl(ApexPages.StandardSetController control, List<Financial_Account_LineItem__c> records) {
        Integer pageNumber = 1;

        if (control != null) {
            pageNumber = control.getPageNumber();
        }
        System.debug(LoggingLevel.Info , 'pageNumber = ' + pageNumber);
        ApexPages.StandardSetController newControl = new ApexPages.StandardSetController(records);
        newControl.setPageSize(PAGE_SIZE);
        newControl.setPageNumber(pageNumber);
        return newControl;
    }

    private List<Financial_Account_LineItem__c> getControlRecords(ApexPages.StandardSetController control) {
        return control != null ? control.getRecords() : new List<Financial_Account_LineItem__c>();
    }

    private void initObjects() {
        SplitExpenseItemPopup = new SplitExpenseReconcilePopUp();
        SplitSaleItemPopup = new SplitSaleReconcilePopUp();
        //test instantiate partial list
    }

    private void getFAccountList() {
        if (Financial_Account__c.SObjectType.getDescribe().isAccessible()) {
            listOfAccounts = [select Id, Name, Items_To_Reconcile__c, Balance__c from Financial_Account__c limit 50000];
        }

    }

    public void selectFAccount() {
        newTranactionsControl = reInitControl(null, getTransactions(NEW_TRANSACTIONS_STATUS));
        excludedControl = reInitControl(null, getTransactions(EXCLUDED_STATUS));
        reconciledControl = reInitControl(null, getTransactions(RECONSILED_STATUS));
    }

    public List<Financial_Account__c> getFinancialAccounts() {
        return listOfAccounts;
    }
    Public List<SelectOption> getCategoryList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select Category --'));
        for (Category_List__c c : [select Id, Name from Category_List__c])
            options.add(new SelectOption(c.Id, c.Name));

        return options;
    }
    Public List<SelectOption> getDetailedCategoryList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select Category --'));
        for (Detailed_Category__c c : [select Id, Name from Detailed_Category__c])
            options.add(new SelectOption(c.Id, c.Name));

        return options;
    }
    Public List<SelectOption> getCategoryListDependent() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select Category --'));
        for (Category_List__c c : [select Id, Name from Category_List__c]) {
            for (Detailed_Category__c s : [select Id, Name from Detailed_Category__c where Category_List__c = : c.Id])
                options.add(new SelectOption(s.Id, c.Name + ' | ' + s.Name));
        }
        return options;
    }

    //reset values after submission
    public void ClearValues() {
        splittedExpense = null;
        splittedSale = null;
        DetailedCategorySelection = null;
        sale = null;
        expense = null;
    }

    //Popups
    public void popupSelector() {
        if (Financial_Account_LineItem__c.SObjectType.getDescribe().isAccessible()) {
            ItemToSplitTemp = [select Name, Transaction_Amount__c from Financial_Account_LineItem__c where id = : selectedFAccountLineItem limit 10];
        }


        if (ItemToSplitTemp.Transaction_Amount__c > 0) {
            salePopUp = new ReconcileSalePopUp();
            salePopUp.showReconcilePopUp();
            //instantiate the sale object to reconcile
            sale = new Sales__c();
        } else {
            expensePopUp = new ReconcileExpensePopUp();
            expensePopUp.showReconcilePopUp();
            //instantiate the expense object to reconcile
            expense = new Expenses__c();
        }
    }

    public class ReconcileSalePopUp {

        public boolean displayReconcilePopUp {get; set;}

        public void closeReconcilePopUp() {
            displayReconcilePopUp = false;
        }
        public void showReconcilePopUp() {
            displayReconcilePopUp = true;
        }

    }
    public class ReconcileExpensePopUp {

        public boolean displayReconcilePopUp {get; set;}

        public void closeReconcilePopUp() {
            displayReconcilePopUp = false;
        }
        public void showReconcilePopUp() {
            displayReconcilePopUp = true;
        }

    }
    public class SplitExpenseReconcilePopUp {

        public boolean displaySplitReconcilePopUp {get; set;}

        public void closeSplitReconcilePopUp() {
            displaySplitReconcilePopUp = false;
        }
        public void showSplitReconcilePopUp() {
            displaySplitReconcilePopUp = true;
        }

    }
    public class SplitSaleReconcilePopUp {

        public boolean displaySplitReconcilePopUp {get; set;}

        public void closeSplitReconcilePopUp() {
            displaySplitReconcilePopUp = false;
        }
        public void showSplitReconcilePopUp() {
            displaySplitReconcilePopUp = true;
        }

    }

    //close split popup
    public void CloseSplitPopup() {

        if (ItemToSplitTemp.Transaction_Amount__c > 0 ) {
            SplitSaleItemPopup.closeSplitReconcilePopUp();
        } else {
            SplitExpenseItemPopup.closeSplitReconcilePopUp();
        }

        //ClearValues();
    }

    //Function created in order to solve issue when closing one popup and opening the split popup.
    public void SplitItemPopupControl() {
        //populate the temp item that need to be splitted;
        if (Financial_Account_LineItem__c.SObjectType.getDescribe().isAccessible()) {
            ItemToSplitTemp = [select id, Name, Date__c, Description__c, Detailed_Category__c, Status__c, Transaction_Amount__c, Type__c from Financial_Account_LineItem__c where id = : selectedFAccountLineItem limit 1];
        }

        totalLeft = ItemToSplitTemp.Transaction_Amount__c;

        if (totalLeft > 0) {
            salePopUp.closeReconcilePopUp();

            splittedSaleList = new List<Sales__c>();
            splittedSale = new Sales__c();
            SplitSaleItemPopup.showSplitReconcilePopUp();
        } else {
            expensePopUp.closeReconcilePopUp();

            splittedExpenseList = new List<Expenses__c>();
            splittedExpense = new Expenses__c();
            SplitExpenseItemPopup.showSplitReconcilePopUp();
        }


    }

    //Splitting Functions
    public void AddSplittedItem() {

        if (splittedExpense != null && splittedExpense.Amount__c < 0) {
            Expenses__c exToAdd = new Expenses__c();

            //Adding checks for FLS create.
            if (Schema.sObjectType.Expenses__c.fields.Name.isCreateable()) {
                exToAdd.Name = ItemToSplitTemp.Name;
            }
            if (Schema.sObjectType.Expenses__c.fields.Amount__c.isCreateable()) {
                exToAdd.Amount__c = splittedExpense.Amount__c;
            }
            if (Schema.sObjectType.Expenses__c.fields.Description__c.isCreateable()) {
                exToAdd.Description__c = splittedExpense.Description__c;
            }
            if (Schema.sObjectType.Expenses__c.fields.Payee_Account__c.isCreateable()) {
                exToAdd.Payee_Account__c = splittedExpense.Payee_Account__c;
            }
            if (Schema.sObjectType.Expenses__c.fields.Payee_Contact__c.isCreateable()) {
                exToAdd.Payee_Contact__c = splittedExpense.Payee_Contact__c;
            }
            if (Schema.sObjectType.Expenses__c.fields.Payee_Contact__c.isCreateable()) {
                exToAdd.Payee_Contact__c = splittedExpense.Payee_Contact__c;
            }
            if (Schema.sObjectType.Expenses__c.fields.Date__c.isCreateable()) {
                exToAdd.Date__c = ItemToSplitTemp.Date__c;
            }
            if (Schema.sObjectType.Expenses__c.fields.Detailed_Category__c.isCreateable()) {
                exToAdd.Detailed_Category__c = DetailedCategorySelection;
            }
            if (Schema.sObjectType.Expenses__c.fields.Related_FA_LineItem__c.isCreateable()) {
                exToAdd.Related_FA_LineItem__c = ItemToSplitTemp.Id;
            }

            try {
                splittedExpenseList.add(exToAdd);
                totalLeft = totalLeft - splittedExpense.Amount__c;
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Make sure the amount is a positive number'));
            }

        } else if (splittedSale != null && splittedSale.Amount__c > 0) {

            Sales__c saToAdd = new Sales__c();
            if (Schema.sObjectType.Sales__c.fields.Name.isCreateable()) {
                saToAdd.Name = ItemToSplitTemp.Name;
            }

            if (Schema.sObjectType.Sales__c.fields.Amount__c.isCreateable()) {
                saToAdd.Amount__c = splittedSale.Amount__c;
            }

            if (Schema.sObjectType.Sales__c.fields.Description__c.isCreateable()) {
                saToAdd.Description__c = splittedSale.Description__c;
            }

            if (Schema.sObjectType.Sales__c.fields.Payee_Account__c.isCreateable()) {
                saToAdd.Payee_Account__c = splittedSale.Payee_Account__c;
            }
            
            if (Schema.sObjectType.Sales__c.fields.Payee_Contact__c.isCreateable()) {
                saToAdd.Payee_Contact__c = splittedSale.Payee_Contact__c;
            }
            
            if (Schema.sObjectType.Sales__c.fields.Date__c.isCreateable()) {
                saToAdd.Date__c = ItemToSplitTemp.Date__c;
            }

            if (Schema.sObjectType.Sales__c.fields.Detailed_Category__c.isCreateable()) {
                saToAdd.Detailed_Category__c = DetailedCategorySelection;
            }

            if (Schema.sObjectType.Sales__c.fields.Related_FA_LineItem__c.isCreateable()) {
                saToAdd.Related_FA_LineItem__c = ItemToSplitTemp.Id;
            }


            try {
                splittedSaleList.add(saToAdd);
                totalLeft = totalLeft - splittedSale.Amount__c;
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Make sure the amount is a negative number'));
            }

        }


    }
    public void RemoveSplittedItem() {
        if (splittedExpenseList != null && splittedExpenseList.size() > 0) {
            Expenses__c tempExpense = splittedExpenseList[numberOfRowToRemove - 1];
            totalLeft = totalLeft + tempExpense.Amount__c;
            splittedExpenseList.remove(numberOfRowToRemove - 1);
        } else {
            Sales__c tempSale = splittedSaleList[numberOfRowToRemove - 1];
            totalLeft = totalLeft + tempSale.Amount__c;
            splittedSaleList.remove(numberOfRowToRemove - 1);
        }
    }


    //Reconciliation functions
    public void reconcileItem() {
        System.debug(LoggingLevel.Info , 'reconcileItem = '  );
        Financial_Account_LineItem__c  fli = [select Name, Type__c, Date__c, Transaction_Amount__c, Description__c from Financial_Account_LineItem__c where id = : selectedFAccountLineItem limit 1];
        if (fli.Transaction_Amount__c < 0 && Expenses__c.SObjectType.getDescribe().isCreateable()) {
            Expenses__c exToAdd = new Expenses__c();
            try {
                System.debug('--------@@@----------' + expense.Payee_Account__c);

                if (Schema.sObjectType.Expenses__c.fields.Name.isCreateable()) {
                   exToAdd.Name = fli.Name;
                }
                if (Schema.sObjectType.Expenses__c.fields.Related_FA_LineItem__c.isCreateable()) {
                   exToAdd.Related_FA_LineItem__c = fli.id;
                }
                if (Schema.sObjectType.Expenses__c.fields.Amount__c.isCreateable()) {
                   exToAdd.Amount__c = fli.Transaction_Amount__c;
                }
                if (Schema.sObjectType.Expenses__c.fields.Date__c.isCreateable()) {
                   exToAdd.Date__c = fli.Date__c;
                }
                if (Schema.sObjectType.Expenses__c.fields.Detailed_Category__c.isCreateable()) {
                   exToAdd.Detailed_Category__c = DetailedCategorySelection;
                }
                if (Schema.sObjectType.Expenses__c.fields.Description__c.isCreateable()) {
                    if (expense.Description__c == '') {
                        exToAdd.Description__c = fli.Description__c;
                    } 
                    else {
                        exToAdd.Description__c = expense.Description__c;
                    }
                }
                if (Schema.sObjectType.Expenses__c.fields.Payee_Account__c.isCreateable()) {
                   exToAdd.Payee_Account__c = expense.Payee_Account__c;
                }
                if (Schema.sObjectType.Expenses__c.fields.Payee_Contact__c.isCreateable()) {
                   exToAdd.Payee_Contact__c = expense.Payee_Contact__c;
                }
                
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
            }

            if(Financial_Account_LineItem__c.SObjectType.getDescribe().isUpdateable()){
                if (Schema.sObjectType.Financial_Account_LineItem__c.fields.Status__c.isUpdateable()) {
                   fli.Status__c = 'Reconciled';
                }
                if (Schema.sObjectType.Financial_Account_LineItem__c.fields.Detailed_Category__c.isUpdateable()) {
                   fli.Detailed_Category__c = DetailedCategorySelection ;
                }
                update fli;
            }

            insert exToAdd;
            System.debug(LoggingLevel.Info , 'exToAdd = ' + exToAdd);
            ClearValues();
            //Repopulate FAccounts for rerendering to function
            getFAccountList();
            //close popup
            expensePopUp.closeReconcilePopUp();

            //return success message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Item ' + fli.Name + ' was reconciled'));
        } else if (fli.Transaction_Amount__c > 0 && Sales__c.SObjectType.getDescribe().isCreateable()) {

            Sales__c saToAdd = new Sales__c();
            try {
                if (Schema.sObjectType.Sales__c.fields.Name.isCreateable()) {
                   saToAdd.Name = fli.Name;
                }
                if (Schema.sObjectType.Sales__c.fields.Related_FA_LineItem__c.isCreateable()) {
                   saToAdd.Related_FA_LineItem__c  = fli.id;
                }
                if (Schema.sObjectType.Sales__c.fields.Amount__c.isCreateable()) {
                   saToAdd.Amount__c = fli.Transaction_Amount__c;
                }
                if (Schema.sObjectType.Sales__c.fields.Date__c.isCreateable()) {
                   saToAdd.Date__c = fli.Date__c;
                }
                if (Schema.sObjectType.Sales__c.fields.Detailed_Category__c.isCreateable()) {
                   saToAdd.Detailed_Category__c = DetailedCategorySelection;
                }
                if (Schema.sObjectType.Sales__c.fields.Description__c.isCreateable()) {
                    if (sale.Description__c == '') {
                        saToAdd.Description__c = fli.Description__c;
                    } 
                    else {
                        saToAdd.Description__c = sale.Description__c;
                    }
                }
                if (sale.Description__c == '') {
                    if (Schema.sObjectType.Sales__c.fields.Description__c.isCreateable()) {
                       saToAdd.Description__c = fli.Description__c;
                    }
                    
                } else {
                    if (Schema.sObjectType.Sales__c.fields.Description__c.isCreateable()) {
                       saToAdd.Description__c = sale.Description__c;
                    } 
                }
                
                if (Schema.sObjectType.Sales__c.fields.Payee_Account__c.isCreateable()) {
                   saToAdd.Payee_Account__c = sale.Payee_Account__c;
                }
                if (Schema.sObjectType.Sales__c.fields.Payee_Contact__c.isCreateable()) {
                   saToAdd.Payee_Contact__c = sale.Payee_Contact__c;
                }  
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
            }

            if(Financial_Account_LineItem__c.SObjectType.getDescribe().isUpdateable()){
                if (Schema.sObjectType.Financial_Account_LineItem__c.fields.Status__c.isUpdateable()) {
                   fli.Status__c = 'Reconciled';
                }
                if (Schema.sObjectType.Financial_Account_LineItem__c.fields.Detailed_Category__c.isUpdateable()) {
                   fli.Detailed_Category__c = DetailedCategorySelection ;
                }
                update fli;
            }

            insert saToAdd;
            ClearValues();
            //Repopulate FAccounts for rerendering to function
            getFAccountList();
            //close popup
            salePopUp.closeReconcilePopUp();

            //return success message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Item ' + fli.Name + ' was reconciled'));
        }

        //Reset List and populate without reconciled item
        initControls();
    }
    public void reconcileSplitted() {

        if (totalLeft != 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Amount to reconcile should be 0 in order to reconcile this transaction record!'));
        }
        Financial_Account_LineItem__c  fli = new Financial_Account_LineItem__c();
        if (selectedFAccountLineItem != null && Financial_Account_LineItem__c.SObjectType.getDescribe().isAccessible()) {
            fli = [select Name, Type__c, Date__c, Transaction_Amount__c, Description__c from Financial_Account_LineItem__c where id = : selectedFAccountLineItem limit 1];
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You have no Financial Account Line Item.'));
        }


        for (Financial_Account_LineItem__c item : getNewTransactionList()) {
            if (item.Id == fli.Id) {

                if (Schema.sObjectType.Financial_Account_LineItem__c.fields.Status__c.isUpdateable()) {

                    item.Status__c = 'Reconciled';
                }
                if (Schema.sObjectType.Financial_Account_LineItem__c.fields.Detailed_Category__c.isUpdateable()) {

                    item.Detailed_Category__c = [select id from Detailed_Category__c where Name = : 'Splitted' limit 1].id;
                }
                update Item;
            }
        }

        //check which list is populated and insert
        if (splittedExpenseList != null  && !splittedExpenseList.isEmpty() && Expenses__c.SObjectType.getDescribe().isCreateable()) {
            insert splittedExpenseList;
        } else if (splittedSaleList != null  && !splittedSaleList.isEmpty() && Sales__c.SObjectType.getDescribe().isCreateable()) {
            insert splittedSaleList;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'List is empty, no items to reconcile'));
        }

        //Reset List and populate without reconciled item
        initControls();
        //Repopulate FAccounts for rerendering to function
        getFAccountList();
        //Close popup
        CloseSplitPopup();
        //return success message
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Item was successfully splitted and reconciled!.'));
    }
    public void excludeItem() {
        Financial_Account_LineItem__c  fli = new Financial_Account_LineItem__c();
        if (Financial_Account_LineItem__c.SObjectType.getDescribe().isAccessible()) {
            fli = [select Name, Type__c, Date__c, Transaction_Amount__c, Status__c from Financial_Account_LineItem__c where id = : selectedFAccountLineItem limit 1];
        }


        for (Financial_Account_LineItem__c item : getNewTransactionList()) {
            if (item.Id == fli.Id) {

                if (Schema.sObjectType.Financial_Account_LineItem__c.fields.Status__c.isUpdateable() && Financial_Account_LineItem__c.SObjectType.getDescribe().isUpdateable()) {

                    item.Status__c = 'Excluded';
                }
                update Item;
            }
        }

        if (fli.Transaction_Amount__c > 0) {
            salePopUp.closeReconcilePopUp();
        } else {
            expensePopUp.closeReconcilePopUp();
        }

        //Repopulate FAccounts for rerendering to function
        getFAccountList();
        //Reset List and populate without reconciled item
        initControls();
    }
    public void undoReconciliation() {

        List<Financial_Account_LineItem__c> undoList = new List<Financial_Account_LineItem__c>();
        undoList.addAll(getReconciledList());
        undoList.addAll(getExcludedList());

        for (Financial_Account_LineItem__c item : undoList)
            if (item.id == selectedFAccountLineItem) {
                if (Schema.sObjectType.Financial_Account_LineItem__c.fields.Status__c.isUpdateable()) {

                    item.Status__c = NEW_TRANSACTIONS_STATUS;
                }
                if (Schema.sObjectType.Financial_Account_LineItem__c.fields.Detailed_Category__c.isUpdateable() && Financial_Account_LineItem__c.SObjectType.getDescribe().isAccessible()) {

                    item.Detailed_Category__c = [select id from Detailed_Category__c where Name = : 'UnCategorized' limit 1].id;
                }


                if (item.Transaction_Amount__c < 0) {
                    try {
                        Schema.DescribeSObjectResult drSObj = Schema.sObjectType.Expenses__c;
                        if (drSObj.isDeletable())
                            delete new List<Expenses__c >([select id from Expenses__c where Related_FA_LineItem__c = : item.Id]);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Item Was Unreconciled --- '  + item.Name));

                    } catch (DmlException de) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Dml exeption' + de.getMessage()));
                    }
                } else {
                    try {
                        Schema.DescribeSObjectResult drSObj = Schema.sObjectType.Sales__c;
                        if (drSObj.isDeletable())
                            delete new List<Sales__c >([select id from Sales__c where Related_FA_LineItem__c = : item.Id]);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Success ' + item.id));

                    } catch (DmlException de) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Dml exeption' + de.getMessage()));
                    }
                }
                update item;
            }

        //Repopulate FAccounts for rerendering to function
        getFAccountList();
        initControls();
    }
    
}