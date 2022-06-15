import { LightningElement, api,track, wire } from 'lwc';
import getAccountExecutives    from '@salesforce/apex/ScheduleCallLWCController.getAccountExecutives';
import { ShowToastEvent }      from 'lightning/platformShowToastEvent'
import scheduleCallAndCreateCB from '@salesforce/apex/ScheduleCallLWCController.scheduleCallAndCreateCB';
import { loadStyle }           from 'lightning/platformResourceLoader';
import brandStyles             from '@salesforce/resourceUrl/CreateInvoiceStyles';

export default class ScheduleCall extends LightningElement {
    @wire(getAccountExecutives) accExecs;
    @api isLoading = false;
    @api scheduledDate;
    @track userId;
    @api label;
    @track note;
    @track interestLevel;
    @track message = 'Schedule a Call and Create Cook Book Record';
    @track msgColor = 'slds-theme_inverse';
    colorError = 'slds-theme_error';
    colorInverse = 'slds-theme_inverse'; 
    colorSuccess = 'slds-theme_success';

    closeQuickAction() {
        const closeQA = new CustomEvent('close');
        // Dispatches the event.
        this.dispatchEvent(closeQA);
    }
     
    connectedCallback() {
        loadStyle(this, brandStyles);
    }

    get accExecOptions() {
        let options = [];
        if(this.accExecs.data){  
            options = this.accExecs.data.map(record => ({ label: record.Name, value : record.Id }));
        }
        options.unshift({ label: 'Select', value: '' });
        return options;
    }

    get interestLvlOptions(){
        return [
            { label: '0', value: '0' },
            { label: '1', value: '1' },
            { label: '2', value: '2' },
            { label: '3', value: '3' },
            { label: '4', value: '4' },
            { label: '5', value: '5' },
            { label: '6', value: '6' },
            { label: '7', value: '7' },
            { label: '8', value: '8' },
            { label: '9', value: '9' },
            { label: '10', value: '10' }
        ];
    }

    handleFormInputChange(event) {
        switch(event.target.name) {
            case 'accExec':
                this.userId = event.detail.value;
                break;
            case 'date':
                this.scheduledDate = event.detail.value;
                break;
            case 'note':
                this.note = event.detail.value;
                break;
            case 'lvl':
                this.interestLevel = event.detail.value;
                break;
        }
    }

    handleClick() {
        let recordId = this.label;
        if(this.checkIfFormValid){
            this.isLoading = true;
            let cookBookObj = {
                value: this.value,
                scheduledDate: this.scheduledDate,
                userId: this.userId,
                recordId: recordId,
                interestLevel: this.interestLevel,
                notes: this.note
            };

            let cookBookJSON = JSON.stringify(cookBookObj);
            scheduleCallAndCreateCB({cbRecordJSON: cookBookJSON})
                .then(result => {
                    this.showToastMessage(result);
                    if(result.isSuccess){
                        this.closeQuickAction();
                    }
                })
                .catch(error => {
                    this.showToastMessage(error);
                })
                .finally(() => {
                    this.isLoading = false;
                });
        }
       
        
    }

    checkIfFormValid(result){
        const isFormValid = [
            ...this.template.querySelectorAll(
                "lightning-combobox, lightning-input"
            )
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
    }

    showToastMessage(result) {
        let variant = (result.isSuccess) ? 'success' : 'error';
        const event = new ShowToastEvent({
            title: 'Message',
            message: result.responseMessage,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}