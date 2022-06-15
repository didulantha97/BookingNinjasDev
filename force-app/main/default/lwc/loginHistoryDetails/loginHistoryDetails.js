import {LightningElement, api, track} from 'lwc';
import getLoginHistoryDetails from '@salesforce/apex/LoginHistory.getLoginHistoryDetails'
import Utils from "c/utils";

export default class LoginHistoryDetails extends LightningElement {
    details;
    isLoading = false;

    @api getLoginHistoryDetails({serverUrl, sessionId, datePeriod, userId}) {
        this.isLoading = true;
        getLoginHistoryDetails({
            serverUrl  : serverUrl,
            sessionId  : sessionId,
            datePeriod : datePeriod,
            userId     : userId
        }).then(result => {
            this.details = result;
        })
        .catch(error => {
            Utils.handleError(error)
        })
        .finally(() => this.isLoading = false)
    };
}