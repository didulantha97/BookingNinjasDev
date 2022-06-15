({
    handleGenerate : function(component, event, helper) {
        component.set("v.URL", "https://dev6-bookingninjas-pbo.cs19.force.com/eSignGenieEmbed?id=" + component.get("v.recordId"));
    }
})