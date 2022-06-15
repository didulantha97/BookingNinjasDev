global with sharing class OrderPaymentController {
    public ChargentOrders__ChargentOrder__c orderObj{get;set;}
    public Account accObj{get;set;}
    public Contact conObj{get;set;}
    public String queId{get;set;}
    public String recId{get;set;}
    public String accId{get;set;}
    public List<SelectOption> Items{set;}
    public List<QuoteLineItem> qliList{get;set;}
    
    public class CCWrapper{
        public id oppId {get;set;}
        public String cardtype {get;set;}
        public String expmonth {get;set;}
        public String expyear {get;set;}
        public string name{get;set;}
        public string cardnum {get;set;}
        public string cvv {get;set;}
    }

    public List<SelectOption> getMonth(){
        List<SelectOption> monthList = new List<SelectOption> ();
        monthList.add(new SelectOption('','--Month--'));
        monthList.add(new SelectOption('01','Jan'));
        monthList.add(new SelectOption('02','Feb'));
        monthList.add(new SelectOption('03','Mar'));
        monthList.add(new SelectOption('04','Apr'));
        monthList.add(new SelectOption('05','May'));
        monthList.add(new SelectOption('06','Jun'));
        monthList.add(new SelectOption('07','Jul'));
        monthList.add(new SelectOption('08','Aug'));
        monthList.add(new SelectOption('09','Sep'));
        monthList.add(new SelectOption('10','Oct'));
        monthList.add(new SelectOption('11','Nov'));
        monthList.add(new SelectOption('12','Dec'));
        return monthList;
    }
    
    public List<SelectOption> getYear(){
        List<SelectOption> monthList = new List<SelectOption> ();
        Integer year = System.today().year();
        monthList.add(new SelectOption('','--Year--'));
        for(integer i=0;i<20;i++)
            monthList.add(new SelectOption((year+i)+'',''+(year+i)));
        return monthList;
    }
    
    public OrderPaymentController() {
        if(ApexPages.currentPage().getParameters().get('id')!= null)
            recId = ApexPages.currentPage().getParameters().get('id');  
                      
        List<ChargentOrders__ChargentOrder__c> orList =  new List<ChargentOrders__ChargentOrder__c>();
        if(recId!= null){
        orList = [Select id,name,
                            ChargentOrders__Subtotal__c,
                            ChargentOrders__Total__c,
                            ChargentOrders__Account__c,                                                                                                          
                            ChargentOrders__Account__r.Name,
                            Client__c,
                            Client__r.Name,
                            Client__r.Card_Number__c,
                            Client__r.Card_Type__c,
                            Client__r.Card_Expiration_Month__c,
                            Client__r.Card_Expiration_Year__c,
                            Client__r.Card_Security_Code__c,
                            Client__r.MailingStreet,
                            Client__r.MailingCity,
                            Client__r.MailingState,
                            Client__r.MailingPostalCode,
                            Client__r.MailingCountry,
                            ChargentOrders__Card_Expiration_Month__c,
                            ChargentOrders__Card_Expiration_Year__c,
                            ChargentOrders__Card_Number__c,
                            ChargentOrders__Card_Security_Code__c,
                            ChargentOrders__Billing_Address__c,
                            ChargentOrders__Billing_City__c,
                            ChargentOrders__Billing_Country__c,
                            ChargentOrders__Billing_Email__c,
                            ChargentOrders__Billing_First_Name__c,
                            ChargentOrders__Billing_Last_Name__c,
                            ChargentOrders__Billing_State__c,
                            ChargentOrders__Billing_Phone__c,
                            ChargentOrders__Billing_State_Province__c,
                            ChargentOrders__Billing_Zip_Postal__c,
                            ChargentOrders__Card_Type__c,
                            Opportunity__r.One_Time_Payment__c,
                            Opportunity__r.Monthly_Price__c,
                            Expiry_Date__c,
                            ChargentOrders__Payment_Method__c,
                            ChargentOrders__Charge_Amount__c,
                            ChargentOrders__Transaction_Total__c,
                            Opportunity__r.Product_Item_1__c,
                            Opportunity__r.Product_Item_1__r.Name,
                            Opportunity__r.Product_Item_1__r.Quantity__c,
                            Opportunity__r.Product_Item_2__c,
                            Opportunity__r.Product_Item_2__r.Name,
                            Opportunity__r.Product_Item_2__r.Quantity__c,
                            Opportunity__r.Product_Item_3__c,
                            Opportunity__r.Product_Item_3__r.Name,
                            Opportunity__r.Product_Item_3__r.Quantity__c,
                            Opportunity__r.Product_Item_4__c,
                            Opportunity__r.Product_Item_4__r.Name,
                            Opportunity__r.Product_Item_4__r.Quantity__c,
                            Opportunity__r.Product_Item_5__c,
                            Opportunity__r.Product_Item_5__r.Name,
                            Opportunity__r.Product_Item_5__r.Quantity__c,
                            Opportunity__r.Balance_Due_Amount__c,
                            Opportunity__r.Balance_Paid_Amount__c
                 from ChargentOrders__ChargentOrder__c
                 where Id = :recId
                 AND Expiry_Date__c >= : Date.today()
                 LIMIT 1 ];                  
        } 
                                                                  
        if(orList!=null && !orList.isEmpty()){
            orderObj = orList[0];
            accObj = [select id,LastName,FirstName,IsPersonAccount,PersonContactId from Account where Id = :orderObj.ChargentOrders__Account__c AND isPersonAccount=True ];  
        }     
    }
    
    public Pagereference redirectExpirationDate(){
      if(orderObj != null){
        if(orderObj.ChargentOrders__Transaction_Total__c >= orderObj.ChargentOrders__Charge_Amount__c){
          Pagereference res = new PageReference('/Thank_You?paid=true&tid='+recId);
           return res;
        }
        return null;
      }else{
        Pagereference res = new PageReference('/Thank_You?expired=true&tid='+recId);
        return res;  
      }
    }
    
    public PageReference save() {   
       if(orderObj.ChargentOrders__Transaction_Total__c >= orderObj.ChargentOrders__Charge_Amount__c){
           Pagereference res = new PageReference('/Thank_You?paid=true&tid='+recId);
         return res;
       }
       else
          upsert orderObj;
          return null;                
    }
    
    public Pagereference doPayment(){
        system.debug('==============calling save method====='+orderObj);
          ChargentOrders.TChargentOperations cntrl = new ChargentOrders.TChargentOperations();          
          ChargentOrders.TChargentOperations.TChargentResult result = ChargentOrders.TChargentOperations.ChargeOrder_Click(recId);
           
          system.debug('==============calling save result====='+result);
          system.debug('========INNNN===1===='+Result.Message);
          system.debug('========INNNN===1===='+Result.Message.containsIgnoreCase('Warning'));
          if(Result.DebugString!= null || (Result.Message != null && Result.Message.containsIgnoreCase('approved'))){
            if(Result.Message == null || Result.Message.containsIgnoreCase('approved')){
                Pagereference res = new PageReference('/Thank_You?tk=true&tid='+recId);
                return res;
            }else{
                 system.debug('========INNNN======='+Result.Message);
                 //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Result.Message.substringafter('Warning:').substringbefore('(')));
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Result.Message.substringafter('message: "').substringbefore('"')));
                    
            }
          }else{
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,Result.Message.substringafter('message: "').substringbefore('"')));
          }
        return null;
      }
        
      public Pagereference cancel(){
        Pagereference pr = new PageReference('/'+recId);
        return pr;
      }
       
       public void fetchCardDetails(){
            if(orderObj.Opportunity__c != null){
                orderObj.ChargentOrders__Card_Number__c  = orderObj.Client__r.Card_Number__c;
                orderObj.ChargentOrders__Card_Type__c = orderObj.Client__r.Card_Type__c;
                orderObj.ChargentOrders__Card_Expiration_Month__c = orderObj.Client__r.Card_Expiration_Month__c;
                orderObj.ChargentOrders__Card_Expiration_Year__c = orderObj.Client__r.Card_Expiration_Year__c;
                orderObj.ChargentOrders__Card_Security_Code__c = orderObj.Client__r.Card_Security_Code__c;
                orderObj.ChargentOrders__Billing_Address__c  = orderObj.Client__r.MailingStreet;
                orderObj.ChargentOrders__Billing_City__c = orderObj.Client__r.MailingCity;
                orderObj.ChargentOrders__Billing_State__c = orderObj.Client__r.MailingState;
                orderObj.ChargentOrders__Billing_Zip_Postal__c = orderObj.Client__r.MailingPostalCode;
                orderObj.ChargentOrders__Billing_Country__c = orderObj.Client__r.MailingCountry;
            }       
       }      
}