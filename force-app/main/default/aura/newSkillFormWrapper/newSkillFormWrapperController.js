({
    doInit : function(component, event, helper) {
        // Extract state and attributes from the page reference
        const pageRef = component.get("v.pageReference") || {};
        const attrs = pageRef.attributes || {};
        const state  = pageRef.state || {};

        // Log the full pageRef for debugging
        console.log('page ref:\n', JSON.stringify(pageRef, null, 2));

        // Parse local vars
        let objectApiName = state.objectApiName || attrs.objectApiName || null;

        component.set("v.objectApiName", objectApiName);
    }
})