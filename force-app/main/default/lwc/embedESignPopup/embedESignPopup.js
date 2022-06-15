import { LightningElement, track, api } from 'lwc';

import getEmbedSessionURL from '@salesforce/apex/EmbedESignPopupController.getEmbedSessionURL';
import attachDocument from '@salesforce/apex/EmbedESignPopupController.attachDocument';
import getOpp from '@salesforce/apex/EmbedESignPopupController.getOpp';

const FIELDS = [
    'Opportunity.Primary_Contact__c',
    'Opportunity.ESignGenie_FolderId__c'
];

export default class EmbedESignPopup extends LightningElement {
    @api recordId;
    opportunity;
    @track error;

    connectedCallback() {
        this.recordId = this.getUrlParamValue(window.location.href, 'id');
        this.getOpp(this.recordId);
        this.fetchEmbedSessionURL();
        this.includeScript();
    }

    includeScript() {
        var script = document.createElement('script');
        script.src = 'https://esigngenie.com/esign/js/esignGeniePostMessageParent.js';
        script.type = 'text/javascript';
        document.head.appendChild(script);
    }

    getUrlParamValue(url, key) {
        return new URL(url).searchParams.get(key);
    }

    async getOpp(oppId) {
        this.showSpinner = true;
        try {
            const returnValue = await getOpp({
                recordId: oppId
            });
            this.opportunity = returnValue;
        }
        catch(error) {
            this.displayErr(error);
        }
        finally {
            this.showSpinner = false;
        }
    }

    showSpinner = true;

    @track embedSessionURL = ''; 
    @track closeModal = false;
    @track isSuccess = false;

    handleSubmit() {
        this.attachSignedDoc()
            .then(()=>this.closeModal=true)
            .then(()=>this.isSuccess=true);
    }

    async fetchEmbedSessionURL() {
        this.showSpinner = true;
        try {
            const returnValue = await getEmbedSessionURL({
                recordId: this.recordId
            });
            this.embedSessionURL = returnValue;
            this.getOpp(this.recordId);
        }
        catch(error) {
            this.displayErr(error);
        }
        finally {
            this.showSpinner = false;
        }
    }

    async attachSignedDoc() {
        this.showSpinner = true;
        try {
            await attachDocument({
                recordId: this.recordId,
                contId: this.opportunity.Primary_Contact__c,
                folderId: this.opportunity.ESignGenie_FolderId__c
            }).then(()=>{

            });
        }
        catch(error) {
            this.displayErr(error);
        }
        finally {
            this.showSpinner = false;
        }
    }

    displayErr(error) {
        this.error = 'Unknown error';
        if (Array.isArray(error.body)) {
            this.error = error.body.map(e => e.message).join(', ');
        } else if (typeof error.body.message === 'string') {
            this.error = error.body.message;
        }
        setTimeout( ()=> this.error=null, 5000);
    }

    handleRemove() {
        this.error = null;
    }
}