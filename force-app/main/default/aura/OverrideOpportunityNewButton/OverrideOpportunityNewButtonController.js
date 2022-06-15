({
    onRender: function(component, event, helper) {

        const recordTypeId = component.get("v.pageReference").state.recordTypeId;
        //component.set('v.recordType', recordTypeId);
        //Action -1
        let action = component.get('c.getRecordTypeNameById');

        action.setParams({
            "recordTypeId": recordTypeId
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                console.log(result);
                component.set('v.recordTypeName', result);
                //
            }  
        })   
        $A.enqueueAction(action);

        
        //Action-2
        // let acc = component.get('c.getRecordTypeNameById');

        // acc.setParams({
        //     "recordTypeId": recordTypeId
        // });
        // acc.setCallback(this, function(response){
        //     let state = response.getState();
        //     if (state === "SUCCESS") {
        //         let result = response.getReturnValue();
        //         component.set('v.reacordTypeId', result);
        //     }  
        // })   
        // $A.enqueueAction(acc);

    }, 

    closeQuickAction : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire(); 
     } 
})