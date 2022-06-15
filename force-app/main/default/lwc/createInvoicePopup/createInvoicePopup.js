import { LightningElement, wire, api, track } from 'lwc';
import { parseErrors, showSuccessToast, showFailToast, navigateToRecordPage } from 'c/utils';
import { loadStyle } from 'lightning/platformResourceLoader';
import { label } from 'c/labelUtils';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import brandStyles from '@salesforce/resourceUrl/CreateInvoiceStyles';
import getAllProducts from '@salesforce/apex/CreateInvoiceAuraController.getAllProducts';
import getDraftQuote from '@salesforce/apex/CreateInvoiceAuraController.getDraftQuote';
import saveDraftQuote from '@salesforce/apex/CreateInvoiceAuraController.saveDraftQuote';
import sendQuote from '@salesforce/apex/CreateInvoiceAuraController.sendQuote';
import PRIMARY_CONTACT from '@salesforce/schema/Opportunity.Primary_Contact__c';
import PERSON_ACCOUNT from '@salesforce/schema/Opportunity.AccountId';

const oppfields = [PRIMARY_CONTACT, PERSON_ACCOUNT];

export default class CreateInvoicePopup extends NavigationMixin(LightningElement) {
    @api recordId;
    @track label = label;
    @track isLoading;
    products;
    quote;
    selectedProducts = new Map();

    @wire(getRecord, { recordId: '$recordId', fields: oppfields })
    opportunity({ error, data }) {
        if (data) {
            const contactId = data.fields.Primary_Contact__c.value;
            this.template.querySelector('c-create-invoice-popup-add-products').setContactId(contactId);
            const accountId = data.fields.AccountId.value;
            console.log(accountId);
            this.template.querySelector('c-create-invoice-popup-add-products').setAccountId(accountId);
        }
    }

    connectedCallback() {
        loadStyle(this, brandStyles);
        this.isLoading = true;

        getAllProducts().then((result) => {
            this.products = result;
            getDraftQuote({ opportunityId: this.recordId }).then((result) => this.initQuote(result));
        });
    }

    productSelectHandle(event) {
        const detail = event.detail;

        if (detail.isSelected) {
            const product = this.products.find((item) => item.Product2Id === detail.productId);
            this.template.querySelector('c-create-invoice-popup-data-table').addItem({
                productName: product.Product2.Name,
                productId: product.Product2Id,
                price: product.UnitPrice,
                implFee: product.Product2.ImplementationFee__c,
                implDeposit: product.Product2.ImplementationDeposit__c,
                subsFee: product.Product2.MonthlyFee__c,
                discountType: product.Product2.AnnualDiscount__c,
                quantity: 1,
                notes: '',
                paymentMethod: 'Monthly',
                productUrl: '/' + product.Product2Id,
                removed: false
            });
            this.selectedProducts = this.selectedProducts.set(detail.productId, true);
        } else {
            this.template.querySelector('c-create-invoice-popup-data-table').removeItem(detail.productId);
            this.selectedProducts = this.selectedProducts.set(detail.productId, false);
        }
    }

    productUnselectHandler(event) {
        const detail = event.detail;
        this.template.querySelector('c-create-invoice-popup-add-products').unselectProduct(detail.productId);
        this.selectedProducts = this.selectedProducts.set(detail.productId, false);
    }

    updateTotalsHandle(event) {
        const totals = this.template.querySelector('c-create-invoice-popup-data-table').calculateTotals();
        this.template.querySelector('c-create-invoice-popup-totals').setTotals(totals);
    }

    closeModal() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    clearAll() {
        if (window.confirm(this.label.PBO_CancelConfirmationMessage)) {
            this.isLoading = true;
            getDraftQuote({ opportunityId: this.recordId }).then((result) => this.initQuote(result));
        }
    }

    saveProducts() {
        this.isLoading = true;

        const quote = this.getQuoteDetails();
        const items = this.template.querySelector('c-create-invoice-popup-data-table').getItems();
        saveDraftQuote({ opportunityId: this.recordId, quoteTemplate: quote, items: items })
            .then(() => {
                setTimeout(() => {
                    eval("$A.get('e.force:refreshView').fire();");
                 }, 3000);
                showSuccessToast(this, this.label.PBO_Message_SuccessfullySavedProducts);
                this.closeModal();
            })
            .catch((result) => {
                showFailToast(this, parseErrors(result.body));
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    sendQuote() {
        this.isLoading = true;

        const quote = this.getQuoteDetails();
        const items = this.template.querySelector('c-create-invoice-popup-data-table').getItems();
        sendQuote({ opportunityId: this.recordId, quoteTemplate: quote, items: items })
            .then((result) => {
                showSuccessToast(this, this.label.PBO_Message_SuccessfullySavedQuote);
                navigateToRecordPage(this, result);
            })
            .catch((result) => {
                showFailToast(this, parseErrors(result.body));
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    initQuote(result) {
        this.quote = result;
        const items = [];

        this.template.querySelector('c-create-invoice-popup-data-table').setItems(items);

        const itemsAsObj = items.reduce((obj, item) => {
            obj[item.Product2Id] = item;
            return obj;
        }, {});

        const productsOptions = this.products.map((item) => ({
            value: item.Product2Id,
            label: item.Product2.Name,
            checked: itemsAsObj.hasOwnProperty(item.Product2Id)
        }));
        const addProductsCmp = this.template.querySelector('c-create-invoice-popup-add-products');
        addProductsCmp.setOptions(productsOptions);
        addProductsCmp.setExpirationDate(this.quote.ExpirationDate);
        addProductsCmp.setDueDate(this.quote.Due_Date__c);

        this.template.querySelector('c-create-invoice-popup-totals').setQuote({});

        // let selectedProducts = items.forEach((element) => {
        //     this.selectedProducts.set(element.Product2Id, true);
        // });

        this.isLoading = false;
    }

    getQuoteDetails = () => {
        const quote = this.template.querySelector('c-create-invoice-popup-totals').getQuote();

        const addProductsCmp = this.template.querySelector('c-create-invoice-popup-add-products');
        quote.ExpirationDate = addProductsCmp.getExpirationDate();
        quote.Due_Date__c = addProductsCmp.getDueDate();

        return quote;
    };

    handleSearch(event) {
        let searchString = event.target.value;
        let result = [];
        if (searchString.trim() !== '') {
            result = this.products.filter(
                (product) =>
                    (product.Product2.Name != undefined || product.Product2.Name != null) &&
                    product.Product2.Name.toLowerCase().includes(searchString.toLowerCase().trim())
            );
        } else {
            result = this.products;
        }

        const productsOptions = result.map((item) => ({
            value: item.Product2Id,
            label: item.Product2.Name,
            checked: this.selectedProducts.get(item.Product2Id)
        }));
        const addProductsCmp = this.template.querySelector('c-create-invoice-popup-add-products');
        addProductsCmp.setOptions(productsOptions);
    }
}