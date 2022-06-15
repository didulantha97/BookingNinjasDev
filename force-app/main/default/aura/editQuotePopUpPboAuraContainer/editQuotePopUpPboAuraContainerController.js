/**
 * Wrapper for LWC component: editQuotePopUpPbo
 * @author Hung Huynh
 * @date Mar 12, 2021
 * 
 */

({
    doInit : function(component, event, helper) {
        let action = component.get("c.getQuoteById");
        action.setParams({
            quoteId: component.get('v.recordId')
        });   
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                let opportunities = response.getReturnValue();
                if(opportunities.length > 0){
                    component.set('v.opportunityId', opportunities[0].OpportunityId);
                }
            }
        })          
        $A.enqueueAction(action);
    },
    closeQuickAction : function(component, event, helper) {
       $A.get("e.force:closeQuickAction").fire();
    }
});