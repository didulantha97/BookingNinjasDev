({
	handleUploadFinished : function(component, event, helper) {        
        var action = component.get("c.updatePicturePath");
        action.setParams({
            recId : component.get("v.recordId")
        }); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' || state === 'DRAFT') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type" : "success",
                    "title" : "Success!",
                    "message" : "File uploaded successfully!"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})