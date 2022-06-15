({
    handleCancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },

    handleSaveQuote : function(component, event, helper) {
        component.set('v.isLoading', true);
        
        let action = component.get("c.generatePdfAndSendToEmail");
        action.setParams({
            quoteId: component.get('v.recordId')
        });   
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success"
                });   
                toastEvent.fire();  
                $A.get("e.force:closeQuickAction").fire(); 
                component.set('v.isLoading', false);
                $A.get('e.force:refreshView').fire(); 
            }
        })          
        $A.enqueueAction(action);
    },
    
})