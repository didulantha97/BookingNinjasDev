import { LightningElement, track, api } from 'lwc';
import { label } from 'c/labelUtils';

export default class CreateInvoicePopupAddProducts extends LightningElement {
    @track label = label;
    @track products;
    @track contactId;
    @track expirationDate;
    @track dueDate;
    @track accountId;

    @api recordId;

    @api
    getExpirationDate() {
        return this.expirationDate;
    }

    @api
    setExpirationDate(value) {
        this.expirationDate = value;
    }

    @api
    getDueDate() {
        return this.dueDate;
    }

    @api
    setDueDate(value) {
        this.dueDate = value;
    }

    @api
    setOptions(products) {
        this.products = [...products];
    }

    @api
    setContactId(contactId) {
        this.contactId = contactId;
    }

    @api
    setAccountId(accountId){
        this.accountId = accountId;
    }

    @api
    unselectProduct(productId) {
        const product = this.products.find((item) => item.value === productId);
        if (product) {
            product.checked = false;
        }
    }

    handleOnChange(event) {
        const productId = event.target.value;
        const isSelected = event.target.checked;

        const product = this.products.find((item) => item.value === productId);
        product.checked = isSelected;

        const productSelectEvent = new CustomEvent('productselect', {
            detail: {
                isSelected: isSelected,
                productId: productId
            }
        });
        this.dispatchEvent(productSelectEvent);

        this.dispatchEvent(new CustomEvent('updatetotals'));
    }

    handleInputOnchange(event) {
        const fieldApiName = event.target.name;
        this[fieldApiName] = event.target.value;
    }
}