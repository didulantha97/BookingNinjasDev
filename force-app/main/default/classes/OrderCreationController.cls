public without sharing class OrderCreationController {

    Id recId {get;set;}
    
    public OrderCreationController(ApexPages.standardController controller){
        recId = (Id)controller.getRecord().get('Id');
    }
    public OrderCreationController(ID oppId){
        if (recId == null) {
            recId = oppId;
            init();
        }
    }
    public PageReference init(){
        Opportunity oppObj = [
                                SELECT
                                    ID,
                                    Name,
                                    AccountId,
                                    Primary_Contact__c,
                                    Primary_Contact__r.Id,
                                    Primary_Contact__r.Name,
                                    Primary_Contact__r.FirstName,
                                    Primary_Contact__r.LastName,
                                    Primary_Contact__r.MailingStreet,
                                    Primary_Contact__r.MailingCity,
                                    Primary_Contact__r.MailingState,
                                    Primary_Contact__r.MailingPostalCode,
                                    Primary_Contact__r.MailingCountry,
                                    Primary_Contact__r.Phone,
                                    Primary_Contact__r.Email,
                                    Primary_Contact__r.Card_Expiration_Month__c,
                                    Primary_Contact__r.Card_Expiration_Year__c,
                                    Primary_Contact__r.Card_Number__c,
                                    Primary_Contact__r.Card_Security_Code__c,
                                    Primary_Contact__r.Card_Type__c,
                                    One_Time_Payment__c,
                                    Monthly_Price__c,
                                    SyncedQuoteId,
                                    Order_ID__c 
                                From Opportunity
                                WHERE Id = :recId
                            ];
                      
        /*List<ChargentBase__Gateway__c> gatewayList = new List<ChargentBase__Gateway__c>();
		gatewayList.addAll([Select ID from ChargentBase__Gateway__c  WHERE ChargentBase__Active__c = true]);
        
        ChargentOrders__ChargentOrder__c orderObj = new ChargentOrders__ChargentOrder__c();
        orderObj.opportunity__c = oppObj.Id;
        orderObj.ChargentOrders__Account__c = oppObj.accountId;
        orderObj.Client__c = oppObj.Primary_Contact__c;
        orderObj.ChargentOrders__Billing_Address__c = oppObj.Primary_Contact__r.MailingStreet;
        orderObj.ChargentOrders__Billing_City__c = oppObj.Primary_Contact__r.MailingCity;
        orderObj.ChargentOrders__Billing_State_Province__c = oppObj.Primary_Contact__r.MailingState;
        orderObj.ChargentOrders__Billing_Zip_Postal__c = oppObj.Primary_Contact__r.MailingPostalCode;
        orderObj.ChargentOrders__Billing_Country__c = oppObj.Primary_Contact__r.MailingCountry;
        orderObj.ChargentOrders__Billing_Email__c = oppObj.Primary_Contact__r.Email;
        orderObj.ChargentOrders__Billing_Phone__c = oppObj.Primary_Contact__r.phone;
        orderObj.ChargentOrders__Billing_First_Name__c = oppObj.Primary_Contact__r.FirstName;
        orderObj.ChargentOrders__Billing_Last_Name__c = oppObj.Primary_Contact__r.LastName;
        orderObj.ChargentOrders__Date__c = system.now();
        orderObj.ChargentOrders__Payment_Start_Date__c = system.today();
        orderObj.ChargentOrders__Payment_End_Date__c = System.today() + 1;
        orderObj.ChargentOrders__Currency__c = 'US Dollar';
        orderObj.Expiry_date__c = System.today() + 2;
        orderObj.ChargentOrders__Manual_Charge__c = true;
        orderObj.ChargentOrders__Payment_Method__c = 'Credit Card';
        orderObj.ChargentOrders__Payment_Received__c = 'Partial';
        
        if(oppObj.One_Time_Payment__c != null) {
            orderObj.ChargentOrders__Charge_Amount__c = oppObj.One_Time_Payment__c * 0.3;
        }
        
        orderObj.ChargentOrders__Subtotal__c = oppObj.One_Time_Payment__c;
        orderObj.ChargentOrders__Tax__c = 0;
        orderObj.ChargentOrders__Shipping__c = 0;
        
        for(ChargentBase__Gateway__c gatewayObj : gatewayList){
            orderObj.ChargentOrders__Gateway__c = gatewayObj.Id;
        }
        insert orderObj;
        
        Quote q = [select id, Order_ID__c from Quote where id =: oppObj.SyncedQuoteId];
        q.Order_ID__c = orderObj.id;
        update q;
        
        oppObj.Order_Id__c = orderObj.id;
        update oppObj;*/
        
        GenerateQuotePDFPassthroughController createQuote  =  new GenerateQuotePDFPassthroughController();
        createQuote.GenerateQuotePDFAndRedirectToQuotePage(oppObj.SyncedQuoteId);
        PageReference pageRef = Page.QuoteCreated;
       
        return pageRef;
    }
}