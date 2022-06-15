import { LightningElement, api, track, wire } from 'lwc';
import { loadStyle }        from 'lightning/platformResourceLoader';
import brandStyles          from '@salesforce/resourceUrl/CreateInvoiceStyles';
import { NavigationMixin }  from 'lightning/navigation';
import { ShowToastEvent }   from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import OPP_OBJECT from '@salesforce/schema/Opportunity';
 
export default class OpportunityNewButton extends NavigationMixin(LightningElement) {
    
    @api recordTypeName; 

    @track nameButton; 
    @track isLoading = false;

    @api objectApiName;
    

    connectedCallback() { 
        loadStyle(this, brandStyles); 
        this.handleReset(); 
    }   

    @track objectInfo;

    @wire(getObjectInfo, { objectApiName: OPP_OBJECT })
    objectInfo;
    
    get recordTypeId() {
        if(this.objectInfo){
           if(this.objectInfo.data){
              if(this.objectInfo.data.recordTypeInfos){
                 const rtis = this.objectInfo.data.recordTypeInfos;
                 return Object.keys(rtis).find((rti) => rtis[rti].name === this.recordTypeName);
              }
           }
        }
        return null;
      }

    handleCancel(event) { 
        event.preventDefault();
        this.handleReset();   
        this.dispatchEvent(new CustomEvent('close'));
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity', 
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
    
    handleError(event) {
        this.isLoading = false;
        const eventToast = new ShowToastEvent({
            "title": "Fail!",   
            "message": event.detail.message, 
            "variant": "error"        
        });       
        this.dispatchEvent(eventToast);
    }  


     
    handleSuccess(event) {  
        this.isLoading = false;
        if (this.nameButton == 'Save') {
            const opportunityId = event.detail.id;
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {   
                    recordId: opportunityId,
                    objectApiName: 'namespace__ObjectName',
                    actionName: 'view'
                }
            });  
        }
        else if (this.nameButton == 'Save & New') {
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: { 
                    objectApiName: 'Opportunity',
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