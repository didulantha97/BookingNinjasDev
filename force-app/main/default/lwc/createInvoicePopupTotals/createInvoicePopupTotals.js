import { LightningElement, track, api } from 'lwc';
import { label } from 'c/labelUtils';

export default class CreateInvoicePopupTotals extends LightningElement {
    @track label = label;
    @track quote;
    @track customDownPayment = 0;

    @api
    getQuote() {
        return this.quote;
    }

    get dueNow() {
        let amount = this.quote.Due_Now__c ? this.quote.Due_Now__c : 0;
        if (this.customDownPayment) {
            amount = this.oneTimePayment * (this.customDownPayment / 100);
        }
        return amount;
    }

    get annualPayment() {
        return this.quote.AnnualyPayment__c ? this.quote.AnnualyPayment__c : 0;
    }

    get monthlyPayment() {
        return this.quote.Monthly_Price__c ? this.quote.Monthly_Price__c : 0;
    }

    get oneTimePayment() {
        return this.quote.One_Time_Payment__c ? this.quote.One_Time_Payment__c : 0;
    }

    @api
    setQuote(value) {
        this.quote = { ...value };
    }

    @api
    setTotals(totals) {
        this.quote.Grand_Total__c = totals.oneTimePayment;
        this.quote.Due_Now__c = totals.dueNow;
        this.quote.One_Time_Payment__c = totals.oneTimePayment;
        this.quote.Monthly_Price__c = totals.monthlyDues;
        this.quote.AnnualyPayment__c = totals.annualyDues;
    }

    setCustomDownPayment(event) {
        this.customDownPayment = event.target.value;
    }
}