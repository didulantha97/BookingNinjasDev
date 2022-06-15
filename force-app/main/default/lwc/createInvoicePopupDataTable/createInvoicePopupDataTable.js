import { LightningElement, track, api, wire } from 'lwc';
import { label } from 'c/labelUtils';
import addNewProducts from '@salesforce/apex/CreateInvoiceController.addNewProducts';

const DELAY = 300;

export default class CreateInvoicePopupDataTable extends LightningElement {
    @track items;
    @track label = label;

    @track textName;
    @track textImplFee;
    @track textImplDep;
    @track textmonFee;
    
    get paymentOptions() {
        return [
            { label: 'Monthly', value: 'Monthly' },
            { label: 'Annualy', value: 'Annualy' }
        ];
    }

    @api
    setItems(items) {
        this.items = this.remapObjectToWrapper(items);
    }

    @api
    getItems() {
        return this.items;
    }

    @api
    addItem(item) {
        this.items.push(item);
    }

    @api
    removeItem(productId) {
        this.items
            .filter((item) => item.productId === productId && !item.removed)
            .forEach((item) => (item.removed = true));
    }

    @api
    calculateTotals() {
        let dueNow = 0,
            oneTimePayment = 0,
            monthlyDues = 0,
            annualyDues = 0;

        this.items
            .filter((item) => !item.removed)
            .forEach((item) => {
                const billingCycle = item.billingCycle ? item.billingCycle : 'Monthly';
                let fixedAmount = 0;
                if (billingCycle === 'Monthly') {
                    monthlyDues += item.subsFee;
                    fixedAmount = item.implFee;
                    oneTimePayment += fixedAmount;
                }

                if (billingCycle === 'Annualy') {
                    if (item.discountType === 'All' || item.discountType === 'Implementation Fee') {
                        fixedAmount = item.implFee - 0.2 * item.implFee;
                        oneTimePayment += fixedAmount;
                    } else {
                        fixedAmount = item.implFee;
                        oneTimePayment += fixedAmount;
                    }
                    if (item.discountType === 'All' || item.discountType === 'Subscription Fee') {
                        annualyDues += (item.subsFee - 0.2 * item.subsFee) * 12;
                    } else {
                        annualyDues += item.subsFee * 12;
                    }
                }

                dueNow += fixedAmount * (item.implDeposit * 0.01);
            });

        return { dueNow, oneTimePayment, monthlyDues, annualyDues };
    }

    deleteItem(event) {
        const itemIndex = event.currentTarget.value;
        this.items[itemIndex].removed = true;

        this.dispatchEvent(
            new CustomEvent('productunselect', {
                detail: {
                    productId: this.items[itemIndex].productId
                }
            })
        );

        this.dispatchEvent(new CustomEvent('updatetotals'));
    }

    onCellClick(event) {
        const index = event.currentTarget.dataset.targetIndex;
        const field = event.currentTarget.dataset.targetField;

        const tableCell = this.template.querySelector(`td[data-target-index='${index}'][data-target-field='${field}']`);
        const lightningInput = tableCell.querySelector('lightning-input') || tableCell.querySelector('selectx');
        lightningInput.focus();
    }

    onValueChangeHandle(event) {
        const index = event.currentTarget.dataset.targetIndex;
        const field = event.currentTarget.dataset.targetField;

        const tableCell = this.template.querySelector(`td[data-target-index='${index}'][data-target-field='${field}']`);
        const lightningInput = tableCell.querySelector('lightning-input') || tableCell.querySelector('select');

        if (!lightningInput.validity.valid) {
            return;
        }

        this.items[index][field] = event.currentTarget.value;

        this.dispatchEvent(new CustomEvent('updatetotals'));
    }

    handleNoteOnChange(event) {
        const index = event.currentTarget.dataset.targetIndex;
        this.items[index].notes = event.currentTarget.value;
    }

    addProducts(){
        console.log(this.textName);

        addNewProducts({name : this.textName, implFee: this.textImplFee, implDep: this.textImplDep, monFee: this.textmonFee})
        .then(result=>{
            let d = JSON.stringify(result);
            console.log(JSON.stringify(result));
        })
        .catch(error=>{
            this.error = error;
            console.log(this.error);
        });
    }

    handlePName(event){
        window.clearTimeout(this.delayTimeout);

        const name = event.target.value;
        
        this.delayTimeout = setTimeout(()=>{
            this.textName = name;
        },DELAY);
    }

    handlePImplFee(event){
        window.clearTimeout(this.delayTimeout);

        const implF = event.target.value;
        
        this.delayTimeout = setTimeout(()=>{
            this.textImplFee = implF;
        },DELAY);
    }

    handlePImplDep(event){
        window.clearTimeout(this.delayTimeout);

        const implD = event.target.value;
        
        this.delayTimeout = setTimeout(()=>{
            this.textImplDep = implD;
        },DELAY);
    }

    handlePMonFee(event){
        window.clearTimeout(this.delayTimeout);

        const monF = event.target.value;
        
        this.delayTimeout = setTimeout(()=>{
            this.textmonFee = monF;
        },DELAY);
    }

    remapObjectToWrapper = (items) => {
        return items.map((item) => ({
            itemId: item.Id,
            productName: item.Product2.Name,
            productId: item.Product2Id,
            price: item.UnitPrice,
            implFee: item.ImplementationFee__c,
            implDeposit: item.ImplementationDeposit__c * 0.01,
            subsFee: item.MonthlyFee__c,
            discountType: item.AnnualDiscount__c,
            quantity: item.Quantity,
            discount: item.Discount,
            notes: item.Notes__c,
            billingCycle: item.Payment_Type__c,
            productUrl: '/' + item.Product2Id,
            removed: false
        }));
    };
}