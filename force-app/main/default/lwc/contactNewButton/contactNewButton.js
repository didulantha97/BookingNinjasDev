import { LightningElement, track }    from 'lwc';
import { loadStyle }           from 'lightning/platformResourceLoader';
import brandStyles             from '@salesforce/resourceUrl/CreateInvoiceStyles';
import { NavigationMixin }     from 'lightning/navigation';
import { ShowToastEvent }      from 'lightning/platformShowToastEvent';
 
/* eslint-disable no-console */ 
export default class ContactNewButton extends NavigationMixin(LightningElement) {
    @track nameButton; 
    @track isLoading = false;
      
    connectedCallback() { 
        loadStyle(this, brandStyles);
        this.handleReset();  
    }  
 
    handleCancel() { 
        this.handleReset();   
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'list'
            }
        }); 
    }

    handleReset() {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
     }  

    handleNameButton(event) {
        this.isLoading = true;
        this.nameButton = event.target.dataset.name;
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if (!field.reportValidity()) {
                    this.isLoading = false;
                }
            }); 
        }
    }         
     
    handleSuccess(event) {  
        this.isLoading = false;
        if (this.nameButton == 'Save') {
            const contactId = event.detail.id;
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {   
                    recordId: contactId,
                    objectApiName: 'namespace__ObjectName',
                    actionName: 'view'
                }
            });  
        }
        else if (this.nameButton == 'Save & New') {
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: { 
                    objectApiName: 'Contact',
                    actionName: 'new'
                }
            });
        }
        const eventToast = new ShowToastEvent({
            "title": "Success!",
            "message": "Record created",
            "variant": "success" 
        });    
        this.dispatchEvent(eventToast);
         
    }   
}