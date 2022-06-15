/**
 * Wrapper for LWC component: opportunityQuotePopUpPbo
 * @author Alex Tsytsiura
 * @date July 8, 2020
 * @link https://trello.com/c/YOC3AXrD/186-opportunity-pbo-design
 */

({
    closeQuickAction : function(component, event, helper) {
       $A.get("e.force:closeQuickAction").fire();
    }
});