import {LightningElement, track} from 'lwc';
import fetchOrgsCredentials   from '@salesforce/apex/LoginHistory.fetchOrgsCredentials'
import getDatePeriodOptions   from '@salesforce/apex/LoginHistory.getDatePeriodOptions'
import logInOrg               from '@salesforce/apex/LoginHistory.logInOrg'
import fetchLoginHistory      from '@salesforce/apex/LoginHistory.fetchLoginHistory'

import Utils from "c/utils";

const ERROR_MESSAGE_WRONG_CREDENTIALS = 'Wrong credentials. Please check the username and password.';

export default class LoginHistoryContainer extends LightningElement {
    @track records;

    arrOrgCredentials;
    datePeriodOptions;
    selectedDatePeriod;
    selectedOrgCredentialId;
    mapSessionOrgsData = {};
    isLoading = false;

    get orgCredentialsOptions() {
        return this.arrOrgCredentials
            ? this.arrOrgCredentials.map(cred => {
                return {label : cred.MasterLabel, value : cred.Id}
              })
            : [];
    }

    get choosedOrgCredential() {
        return this.arrOrgCredentials.find(cred => cred.Id === this.selectedOrgCredentialId);
    }

    connectedCallback() {
        fetchOrgsCredentials().then(result => {
            this.arrOrgCredentials = result;
        });

        getDatePeriodOptions().then(result => {
            this.datePeriodOptions = result;
            if (result.length > 0) this.selectedDatePeriod = result[0].value;
        });
    }

   handleSelectOrg(event) {
        this.selectedOrgCredentialId = event.detail.value;
        this.getLoginHistory();
    }

    async getLoginHistory() {
        this.isLoading = true;
        this.getSessionOrgData().then(res => {
            return this.queryLoginHistory();
        })
        .catch(error => {
            Utils.handleError(error)
        })
        .finally(() => this.isLoading = false)
    }

    async getSessionOrgData() {
        if (this.mapSessionOrgsData.hasOwnProperty(this.selectedOrgCredentialId)) return;
        return  logInOrg({
            userName  : this.choosedOrgCredential.UserName__c,
            password  : this.choosedOrgCredential.Password__c,
            isSandbox : this.choosedOrgCredential.isSandbox__c
        }).then(result => {
            this.mapSessionOrgsData[this.selectedOrgCredentialId] = result;
        })
        .catch(error => {
            throw new Error(ERROR_MESSAGE_WRONG_CREDENTIALS);
        })
    }

    async queryLoginHistory() {
        return  fetchLoginHistory({
            serverUrl  : this.mapSessionOrgsData[this.selectedOrgCredentialId].serverUrl,
            sessionId  : this.mapSessionOrgsData[this.selectedOrgCredentialId].sessionId,
            datePeriod : this.selectedDatePeriod
        }).then(result => {
            this.records = result;
        })
        .catch(error => Utils.handleError(error))
    }

    handleSelectDatePeriod(event) {
        this.selectedDatePeriod = event.detail.value;
        if (this.selectedOrgCredentialId) this.getLoginHistory();
    }

    handleExpandDetails(event) {
        this.showDetails(event.currentTarget.dataset.targetId);
        const loginDetails = this.template.querySelector(`c-login-history-details[data-record-id='${event.currentTarget.dataset.targetId}']`);
        loginDetails.getLoginHistoryDetails({
            serverUrl  : this.mapSessionOrgsData[this.selectedOrgCredentialId].serverUrl,
            sessionId  : this.mapSessionOrgsData[this.selectedOrgCredentialId].sessionId,
            datePeriod : this.selectedDatePeriod,
            userId     : event.currentTarget.dataset.targetId
        });
    }

    showDetails(recordId) {
        this.template.querySelector(`lightning-icon.chevronup[data-target-id='${recordId}']`).classList.remove('slds-hide');//icon
        this.template.querySelector(`lightning-icon.chevrondown[data-target-id='${recordId}']`).classList.add('slds-hide');//icon
        this.template.querySelector(`tr[data-detail-id='${recordId}']`).classList.remove('slds-hide'); //details section show
    }

    handleHideDetails(event) {
        this.template.querySelector(`lightning-icon.chevronup[data-target-id='${event.currentTarget.dataset.targetId}']`).classList.add('slds-hide');//icon
        this.template.querySelector(`lightning-icon.chevrondown[data-target-id='${event.currentTarget.dataset.targetId}']`).classList.remove('slds-hide');//icon
        this.template.querySelector(`tr[data-detail-id='${event.currentTarget.dataset.targetId}']`).classList.add('slds-hide'); //details section show
    }
}