/**
 * Wrapper for LWC component: scheduleCall
 * @author Hung Huynh
 * @date Mar 13, 2021
 * 
 */
({
     doInit : function(component, event, helper) {
        let action = component.get("c.getContactIdByAccountId");
        action.setParams({
            accountId: component.get('v.recordId')
        });   
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                let contacts = response.getReturnValue();
                if(contacts.length > 0){
                    component.set('v.contactId', contacts[0].Id);
                }
            }
        })          
        $A.enqueueAction(action);
    },
	closeQA : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	}
})