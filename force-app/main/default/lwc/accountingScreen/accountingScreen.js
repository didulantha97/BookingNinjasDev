import { LightningElement, wire, track } from 'lwc';
import getFAccountList from '@salesforce/apex/AccountingScreenController.getFAccountList';
import getAllRelatedItems from '@salesforce/apex/AccountingScreenController.getRelatedLists';
import createSplitRecords from '@salesforce/apex/AccountingScreenController.insertSplitItems';
import getRequiredCategoryNames from '@salesforce/apex/AccountingScreenController.getDetailedCategories';
import getCategoryNames from '@salesforce/apex/AccountingScreenController.getCategoryListDependent';
import removeRelatedRecords from '@salesforce/apex/AccountingScreenController.removeRelatedRecords';
import updateFAccountLineItem from '@salesforce/apex/AccountingScreenController.updateFAccountLineItem';
import { refreshApex } from '@salesforce/apex';
import { createRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import FORM_FACTOR from '@salesforce/client/formFactor';
import FINANCIAL_ACCOUNT_LINEITEM_OBJECT from '@salesforce/schema/Financial_Account_LineItem__c'
import DETAILED_CATEGORY_OBJECT from '@salesforce/schema/Detailed_Category__c'
import EXPENSES_OBJECT from '@salesforce/schema/Expenses__c'
import SALES_OBJECT from '@salesforce/schema/Sales__c'

const INDICATOR_ACTION = 'slds-carousel__indicator-action';
const SLDS_ACTIVE = 'slds-is-active';
const FALSE_STRING = 'false';
const TRUE_STRING = 'true';
let   SPLIT_ITEMS_COUNT = 0;


export default class AccountingScreen extends NavigationMixin(LightningElement) {

    // DATA FIELDS

    @track fAccounts;
    wiredData;
    selectedFinancialAccountId;
    formattedTodayDate = new Date(Date.now()).toISOString().slice(0,10);
    searchDateData = {
        StartDate: this.formattedTodayDate,
        EndDate: this.formattedTodayDate
    }
    recentFilters;
    relatedItems = {};
    categoryNameToId = new Map();
    selectedNewItems = [''];
    selectedReconciledItems = [''];
    selectedExcludedItems = [''];

    // MAIN SCREEN FIELDS

    showSpinner = true;
    showFilterForm = false;

    //MODAL WINDOW FIELDS

    modalTitle;
    modalSplitMode;
    showModalSpinner = false;
    selectedItem;
    selectedItemList = [];
    isModalOpen = false;
    modalTotalAmount;
    allCategories;
    detailedCategoryOptions;
    @track splitRecords = [];

    // PAGINATION CAROUSEL FIELDS

    @track paginationItems = [];
    @track carouselPanelsStyle;
    activeIndexItem = 0;

    // DATATABLE COLUMNS

    modalSplitViewListColumns = [
        {
            label: 'Detailed Category',
            type: 'text',
            fieldName: 'CategoryName',
            sortable: true,
            initialWidth: 100
        },
        {
            label: 'Description',
            type: 'text',
            fieldName: 'Description__c',
            sortable: true,
            initialWidth: 290
        },
        {
            label: 'Amount',
            type: 'number',
            fieldName: 'Amount__c',
            sortable: true,
            initialWidth: 100,
        },
        {
            label: '',
            type: 'button-icon',
            fieldName: '',
            typeAttributes: {
                iconName: "utility:close"
            },
            initialWidth: 40,
        },

    ];

    columns = [
        {
            label: 'Name',
            type: 'button',
            fieldName: 'Name',
            sortable: false,
            initialWidth: 100,
            typeAttributes: {
                label: {
                    fieldName: 'Name',
                },
                variant: 'base',
                name: 'navigateToItem',
                class: 'navigate-to-article'
            }
        },
        {
            label: 'Date',
            type: 'date',
            fieldName: 'Date__c',
            initialWidth: 105,
            sortable: true
        },
        {
            label: 'Description',
            type: 'text',
            fieldName: 'Description__c',
            //initialWidth: 600,
            sortable: true
        },
        {
            label: 'Status',
            type: 'text',
            fieldName: 'Status__c',
            initialWidth: 125,
            sortable: true
        },
        {
            label: 'Detailed Category',
            type: 'button',
            fieldName: 'CategoryName',
            sortable: false,
            typeAttributes: {
                label: {
                    fieldName: 'CategoryName',
                },
                variant: 'base',
                name: 'navigateToDetailedCategory',
                class: 'navigate-to-category'
            },
            initialWidth: 170
        },
        {
            label: 'Transaction Amount',
            type: 'currency',
            fieldName: 'Transaction_Amount__c',
            initialWidth: 115,
            sortable: true
        },
        {
            label: 'Type',
            type: 'text',
            fieldName: 'Type__c',
            initialWidth: 80,
            sortable: true
        },
    ];

    reconcileViewListColumns = [
        {
            label: 'Description',
            type: 'text',
            fieldName: 'Description__c',
            sortable: true,
        },
        {
            label: 'Amount',
            type: 'number',
            fieldName: 'Transaction_Amount__c',
            sortable: true,
            initialWidth: 150,
        }

    ];

    // MAIN SCREEN METHODS

    @wire(getFAccountList)
    retrieveAllFAccounts(wiredResult) {
        this.wiredData = wiredResult;
        if (wiredResult && wiredResult.data) {
            this.fAccounts = [];
            this.paginationItems = [];
            let container = [];
            const imagesPerPage = FORM_FACTOR === 'Large' ? 6 : 1;

            wiredResult.data.forEach(
                (currentFAccount, i, arr) => {
                    container.push(currentFAccount);

                    if (container.length == imagesPerPage) {
                        this.addNewCarouselPage();
                        this.fAccounts.push(container);
                        container = [];
                    }
                }
            );

            if (container.length != 0) {
                this.addNewCarouselPage();
                this.fAccounts.push(container);
            }

            this.showSpinner = false;
        }
    }

    @wire(getRequiredCategoryNames)
    getDetailedCategories({error, data}) {
        if (data) {
            data.forEach((currentCategory, i, arr) => {
                this.categoryNameToId.set(currentCategory.Name, currentCategory.Id);
            });
        }
    }

    selectFAccount(event) {
        this.selectedFinancialAccountId = event.target.dataset.id;
        this.showFilterForm = true;

        this.fAccounts = this.fAccounts.map(fAccountSection => {
            return  fAccountSection.map(currentFAccount => {
                return {
                    ...currentFAccount,
                    SelectedStyle : currentFAccount.Id == this.selectedFinancialAccountId ? 'background: beige;' : ''
                }
            });
        });
    }

    searchRelatedItems(event) {
        this.showSpinner = true;
        event.preventDefault();
        this.recentFilters = {
            startDate : this.searchDateData.StartDate,
            endDate : this.searchDateData.EndDate,
            finAccId : this.selectedFinancialAccountId,
            description : event.detail.fields.Description__c,
            detailedCategoryId : event.detail.fields.Detailed_Category__c,
            transactionAmount : event.detail.fields.Transaction_Amount__c,
            type : event.detail.fields.Type__c
        };

        getAllRelatedItems(this.recentFilters).then(
            result => {
                for (let list in result) {
                    result[list] = result[list].map(row => {
                        return {...row, CategoryName: row.Detailed_Category__r ? row.Detailed_Category__r.Name : null}
                    })
                }

                this.relatedItems = result;
                this.showSpinner = false;
            }
        );

    }

    handleTimeIntervalChange(event) {
        this.searchDateData[event.target.name] = event.target.value;
    }

    handleRowAction(event) {
        switch (event.detail.action.name) {
            case 'reconcile':
                this.modalTitle = 'Reconcile Expense Transaction';
                this.selectedItem = event.detail.row;
                if(this.selectedItemList.length == 0){
                    this.selectedItemList.push(this.selectedItem);
                }
                this.openModal();
                break;
            case 'undo':
                this.selectedItem = event.detail.row;
                this.submitUndo();
                break;
            case 'navigateToItem':
                this.navigateToRecord(event.detail.row.Id, FINANCIAL_ACCOUNT_LINEITEM_OBJECT);
                break;
            case 'navigateToDetailedCategory':
                this.navigateToRecord(event.detail.row.Detailed_Category__c, DETAILED_CATEGORY_OBJECT);
                break;
            default:
                break;
        }
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedItemList = selectedRows;
    }

    tempSelectedItem = null;
    handleSplitRow(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedItem = selectedRows[0];
        this.tempSelectedItem = selectedRows[0];
    }

    navigateToRecord(rowId, sobjectType) {
        this[NavigationMixin.GenerateUrl]({
            type: "standard__recordPage",
            attributes: {
                recordId: rowId,
                objectApiName: sobjectType,
                actionName: 'view'
            }
        }).then(url => {
            window.open(url, "_blank");
        });
    }

    handleReconcileSelected(){
        this.selectedItem = this.selectedItemList.length > 0 ? this.selectedItemList[0] : null;
        this.openModal();
    }
    get hideCheckboxReconcileList(){
        return this.selectedItemList.length == 1 ? true : false;
    }
    
    get disableSplitButton(){
        let disabled = true;
        
        if(this.selectedItemList.length > 1 && this.tempSelectedItem != null){
            disabled = false;
        }
        else if(this.selectedItemList.length == 1){
            disabled = false;
        } 
        return disabled;
    }

    get selectedItemsNames(){
        let name = '';
        if(this.selectedItemList.length > 0){
            this.selectedItemList.forEach(item => {
                name += item.Name + ', ';
            });
            name = name.trim().slice(0, -1);
        }
        else{
            name = this.selectedItem.Name;
        }
        
        return name;
    }


    get newListColumns() {
        return this.columns.concat(
            {
                label: '',
                type: 'button',
                fieldName: '',
                typeAttributes: {
                    label: 'Reconcile',
                    name: 'reconcile'
                },
                initialWidth: 110,
                cellAttributes: { alignment: 'center' }
            },
        )
    }

    get reconciledOrExcludedListColumns() {
        return this.columns.concat(
            {
                label: '',
                type: 'button',
                fieldName: '',
                typeAttributes: {
                    label: 'Undo',
                    name: 'undo'
                },
                initialWidth: 84,
                cellAttributes: { alignment: 'center' }
            },
        )
    }
    get disableMassButton(){
        return this.selectedItemList.length > 0 ? false : true;
    }
    

    submitUndo() {
        this.showSpinner = true;

        // const itemFields = {};
        // itemFields.Id = this.selectedItem.Id;
        // itemFields.Status__c = 'New Transactions';
        // itemFields.Detailed_Category__c = this.categoryNameToId.get('UnCategorized');
        
        let updateItems = [];
        let lineItemIds = [];
       
        if(this.selectedItemList.length == 0){
            const itemFields = {};
            itemFields.Id = this.selectedItem.Id;
            itemFields.Status__c = 'New Transactions';
            itemFields.Detailed_Category__c = this.categoryNameToId.get('UnCategorized');
            updateItems.push(itemFields);
            lineItemIds.push(this.selectedItem.Id);      
        }
        else{
            this.selectedItemList.forEach(item => {
                const itemFields = {};
                itemFields.Id = item.Id;
                itemFields.Status__c = 'New Transactions';
                itemFields.Detailed_Category__c = this.categoryNameToId.get('UnCategorized');
                updateItems.push(itemFields);
                lineItemIds.push(item.Id);
            });
        }
            
        Promise.all([removeRelatedRecords({
                lineItemIds : lineItemIds
            }), updateFAccountLineItem({updateItems: JSON.stringify(updateItems)})]
        )
            .then(() => {
                return Promise.all([refreshApex(this.wiredData), getAllRelatedItems(this.recentFilters)]);
            })
            .then(results => {
                this.relatedItems = results[1];
                this.showSpinner = false;
                let message = this.selectedItemList.length > 1 ? this.selectedItemList.length + ' items were canceled' : 'Item ' + this.selectedItem.Name ? this.selectedItem.Name : '' + ' was canceled';

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: message,
                        variant: 'success'
                    }),
                );    
                this.selectedItem = [];
                this.selectedItemList = [];            

            })
            .catch(error => {
                this.showSpinner = false;
                console.log(JSON.stringify(error));
                let message = error.body != null ? error.body.message : 'Error';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: message,
                        variant: 'error'
                    }),
                );
            });
    }

    // MODAL WINDOW METHODS

    openModal() {
        this.isModalOpen = true;
        this.showModalSpinner = true;
        this.splitRecords = [];
        this.modalTotalAmount = this.selectedItem.Transaction_Amount__c;
    
        getCategoryNames()
            .then(categories => {
                this.allCategories = categories;
                const picklistValues = [];
                picklistValues.push({value : null, label : '-- Select Category --'});

                for (let categoryId in categories)
                {
                    picklistValues.push({value : categoryId, label : categories[categoryId]});
                }

                this.detailedCategoryOptions = picklistValues;

            })
            .catch(error => {
                console.log(JSON.stringify(error));
                let message = error.body != null ? error.body.message : 'Error';

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: message,
                        variant: 'error'
                    }),
                );
            });
    }

    closeModal() {
        this.modalSplitMode = false;
        this.isModalOpen = false;
        this.selectedItem = [];
        this.selectedItemList = [];
        this.selectedNewItems = [''];
        this.tempSelectedItem = null;
    }

    get sObjectTypeForReconcile() {
        if (this.selectedItem) {
            return this.selectedItem.Transaction_Amount__c < 0 ? EXPENSES_OBJECT : SALES_OBJECT;
        }

        return null;
    }

    handleModalLoad(event) {
        this.showModalSpinner = false;
    }

    submitReconcile(event) {
        event.preventDefault();

        const fields = event.detail.fields;

        if (!fields.Description__c) {
            fields.Description__c = this.selectedItem.Description__c;
        }
        let detailedCategory = this.template.querySelector('[data-id="detailedCategory"]');
        fields.Detailed_Category__c = detailedCategory.value;

        if (this.modalSplitMode) {
            const newSplitItem = Object.assign({}, fields);
            newSplitItem.ItemId = SPLIT_ITEMS_COUNT++;
            newSplitItem.SobjectType = this.sObjectTypeForReconcile.objectApiName;
            newSplitItem.CategoryName = this.allCategories[newSplitItem.Detailed_Category__c] ?  this.allCategories[newSplitItem.Detailed_Category__c].split(' | ')[1] : null;
            this.splitRecords = this.splitRecords.concat(newSplitItem);
            this.modalTotalAmount -= fields.Amount__c;
        } else {
            this.showModalSpinner = true;
            const recordInput = { apiName: this.sObjectTypeForReconcile.objectApiName, fields };
            
            let updateItems = [];
            if(this.selectedItemList.length == 0){
                const itemFields = {};
                itemFields.Id = this.selectedItem.Id;
                itemFields.Status__c = 'Reconciled';
                itemFields.Detailed_Category__c = fields.Detailed_Category__c;
                updateItems.push(itemFields);   
            }
            else{
                this.selectedItemList.forEach(item => {
                    const itemFields = {};
                    itemFields.Id = item.Id;
                    itemFields.Status__c = 'Reconciled';
                    itemFields.Detailed_Category__c = fields.Detailed_Category__c;
                    updateItems.push(itemFields);
                });
            }

            Promise.all([createRecord(recordInput),
            updateFAccountLineItem({
                updateItems: JSON.stringify(updateItems),
                detailedCategory: fields.Detailed_Category__c
            })])
                .then(updatedRecord => {
                    return Promise.all([refreshApex(this.wiredData), getAllRelatedItems(this.recentFilters)]);
                })
                .then(results => {
                    this.relatedItems = results[1];
                    this.showModalSpinner = false;
                    let message = this.selectedItemList.length > 1 ? this.selectedItemList.length + ' items were reconciled' : 'Item ' + this.selectedItem.Name ? this.selectedItem.Name : '' + ' was reconciled';

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message:  message,
                            variant: 'success',
                        }),
                    );
                    this.closeModal();
                })
                .catch(error => {
                    this.showModalSpinner = false;
                    console.log(JSON.stringify(error));
                    let message = error.body != null ? error.body.message : 'Error';

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: message,
                            variant: 'error'
                        }),
                    );
                });
        }
    }

    submitExclude(event) {
        this.showModalSpinner = true;
        event.preventDefault();

        // const itemFields = {};
        // itemFields.Id = this.selectedItem.Id;
        // itemFields.Status__c = 'Excluded';

        let updateItems = [];
        
        if(this.selectedItemList.length == 0){
            const itemFields = {};
            itemFields.Id = this.selectedItem.Id;
            itemFields.Status__c = 'Excluded';
            updateItems.push(itemFields);   
        }
        else{
            this.selectedItemList.forEach(item => {
                const itemFields = {};
                itemFields.Id = item.Id;
                itemFields.Status__c = 'Excluded';
                updateItems.push(itemFields);
            });
        }
        

        updateFAccountLineItem({updateItems: JSON.stringify(updateItems)})
            .then(() => {
                return getAllRelatedItems(this.recentFilters);
            })
            .then(result => {
                this.relatedItems = result;
                this.showModalSpinner = false;

                let message = this.selectedItemList.length > 1 ? this.selectedItemList.length + ' items were excluded' : 'Item ' + this.selectedItem.Name + ' was excluded';

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: message,
                        variant: 'success',
                    }),
                );
                this.closeModal();

            })
            .catch(error => {
                this.showModalSpinner = false;
                console.log(JSON.stringify(error));
                let message = error.body != null ? error.body.message : 'Error';

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: message,
                        variant: 'error'
                    }),
                );
            });
    }

    enableSplitMode() {
        this.modalSplitMode = true;
    }

    removeSplitItem(event) {
        const row = event.detail.row;
        this.splitRecords = this.splitRecords.filter(splitItem => splitItem.ItemId != row.ItemId);
        this.modalTotalAmount += parseInt(row.Amount__c);
    }

    submitSplitListReconcile(event) {
        this.showModalSpinner = true;
        const itemFields = {};
        itemFields.Id = this.selectedItem.Id;
        itemFields.Status__c = 'Reconciled';
        itemFields.Detailed_Category__c = this.categoryNameToId.get('Splitted');
        Promise.all([
            createSplitRecords({
                splittedItems: this.splitRecords.map(item => {
                    delete item.ItemId;
                    delete item.CategoryName;
                    return item;
                })
            }),
            updateRecord({fields: itemFields})]
        )
            .then(results => {
                return Promise.all([refreshApex(this.wiredData), getAllRelatedItems(this.recentFilters)]);
            })
            .then(results => {
                this.relatedItems = results[1];
                this.showModalSpinner = false;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Split Items ' + this.selectedItem.Name + ' were reconciled',
                        variant: 'success',
                    }),
                );
                this.closeModal();
            })
            .catch(error => {
                this.showModalSpinner = false;
                console.log(JSON.stringify(error));
            });
    }
    

    handleActive(event) {
        if (event.target.label == 'New Transactions'){
            this.selectedNewItems = [''];
        }
        if (event.target.label == 'Reconciled'){
            this.selectedReconciledItems = [''];
        }
        if (event.target.label == 'Excluded'){
            this.selectedExcludedItems = [''];
        }
    }


    //PAGINATION CAROUSEL METHODS

    addNewCarouselPage() {
        const currentIndex = this.paginationItems.length,
            isItemActive = currentIndex === this.activeIndexItem,
            paginationItemDetail = {
                id: `pagination-item-${currentIndex}`,
                className: isItemActive
                    ? INDICATOR_ACTION + ' ' + SLDS_ACTIVE
                    : INDICATOR_ACTION,
                tabIndex: isItemActive ? '0' : '-1',
                ariaSelected: isItemActive ? TRUE_STRING : FALSE_STRING
            };

        this.paginationItems.push(paginationItemDetail);
    }

    nextPage(event) {
        const currentIndex = event.currentTarget.getAttribute('data-index');
        let newIndex;

        if (this.activeIndexItem + 1 == this.paginationItems.length) {
            newIndex = 0;
        } else {
            newIndex = this.activeIndexItem + 1;
        }

        this.changePage(currentIndex, newIndex);
    }

    previousPage(event) {
        const currentIndex = event.currentTarget.getAttribute('data-index');
        let newIndex;

        if (this.activeIndexItem == 0) {
            newIndex = this.paginationItems.length - 1;
        } else {
            newIndex = this.activeIndexItem - 1;
        }

        this.changePage(currentIndex, newIndex);

    }

    changePage(currentIndex, newIndex) {
        if (this.activeIndexItem !== currentIndex) {
            this.unselectCurrentPage();
            this.selectNewPage(newIndex);
            this.activeIndexItem = parseInt(this.activeIndexItem, 10);
        }
    }

    unselectCurrentPage() {
        const activePaginationItem = this.paginationItems[this.activeIndexItem];

        activePaginationItem.tabIndex = '-1';
        activePaginationItem.ariaSelected = FALSE_STRING;
        activePaginationItem.className = INDICATOR_ACTION;
    }

    selectNewPage(newIndex) {
        const activePaginationItem = this.paginationItems[newIndex];

        activePaginationItem.tabIndex = '0';
        activePaginationItem.ariaSelected = TRUE_STRING;
        activePaginationItem.className =
            INDICATOR_ACTION + ' ' + SLDS_ACTIVE;

        this.carouselPanelsStyle = `transform:translateX(-${newIndex *
        100}%);`;
        this.activeIndexItem = newIndex;
    }

}