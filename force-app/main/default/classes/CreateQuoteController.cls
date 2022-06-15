public with sharing class CreateQuoteController{

    Private final Opportunity Opp { get; set; }
    Private final Id OppId;
    
    //Product
    Product2 product;
    
    public List<Product2> products = new List<Product2>();
    public List<PriceBookEntry> standardPrices = new List<PriceBookEntry>();
    
    public boolean showQuoteBlock { get; set; }
    public Boolean quotesent{ get; set{ quotesent = false; } }
    public boolean quoteExists { get; set; }
    public boolean isQuoteForUpdate {get; set;}
    public boolean isProductFieldPopulated {get; set;}
    
    List<QuoteLineItem> listQli = new list<QuoteLineItem >();
    
    //Vars to catch from user inputs
    public double Discount { get; set; }
    public Decimal TotalPrice { get; set; }
    public Decimal TotalPriceAfterDiscount { get; set; }
    public Decimal IncludedPriceForDiscount { get; set; }
    public Decimal ExcludedPriceForDiscount { get; set; }
    public Decimal OneTimePaymentWithNoDiscount { get; set; }
    public Decimal MonthlyDues { get; set; }
    public Decimal GrandTotal { get; set; }
    
    //getters
    public List<Product2> getProducts() { return products; }
    public List<PriceBookEntry> getstandardPrices() { return standardPrices; }
    public Opportunity getOpp() { return Opp; }
        
    Contact primaryContact;
    
    public boolean noStandardPrice { get; set; }
    
    public void showBlockCreate()
    {
        showQuoteBlock = true;
        isQuoteForUpdate = false;
    }
    
    public void showBlockUpdate()
    {
        showQuoteBlock = true;
        isQuoteForUpdate = true;
    }

    public CreateQuoteController(ApexPages.StandardController controller) { 
        TotalPrice = 0;
        TotalPriceAfterDiscount = 0;
        IncludedPriceForDiscount = 0;
        ExcludedPriceForDiscount = 0;
        OneTimePaymentWithNoDiscount = 0;
        GrandTotal = 0;
        MonthlyDues = 0;
        
        isQuoteForUpdate = false;
         
        OppID = (Id)controller.getRecord().get('Id');
        Opp = [select Id,Name,Primary_Contact__c,Contact_2__c,Contact_3__c,Contact_4__c,Contact_5__c,Product_Item_1__c,Product_Item_2__c,Product_Item_3__c,Product_Item_4__c,Product_Item_5__c,SyncedQuoteId from Opportunity where id =: OppID];              
        quoteExists = Opp.SyncedQuoteId != null ? PrepareQuote() : false;
        isProductFieldPopulated = Opp.Product_Item_1__c != null ? true : false;
    }
    
    
    public boolean PrepareQuote() {
    
        if (Opp.Primary_contact__c != null) {
            
                primaryContact = [ select Id, Name, Email, Phone, MobilePhone from Contact where id=: Opp.Primary_contact__c ];
                
                for (Integer i = 1; i <= 5; i++) {
                    
                    product = new Product2();
                    
                    if(i == 1) {
                        if(Opp.Product_Item_1__c != null) {
                            product = [ select id, name, Family, Account__c, Contact__c, Quantity__c from Product2 where id =: Opp.Product_Item_1__c ];
                            products.add(product);
                        }
                    }
                    else if(i == 2) {
                        if(Opp.Product_Item_2__c != null) {
                            product = [ select id, name, Family, Account__c, Contact__c, Quantity__c from Product2 where id =: Opp.Product_Item_2__c ];
                            products.add(product);
                        }
                    }
                    else if(i == 3) {
                        if(Opp.Product_Item_3__c != null) {
                            product = [ select id, name, Family, Account__c, Contact__c, Quantity__c from Product2 where id =: Opp.Product_Item_3__c ];
                            products.add(product);
                        }
                    }
                    else if(i == 4) {
                        if(Opp.Product_Item_4__c != null) {
                            product = [ select id, name, Family, Account__c, Contact__c, Quantity__c from Product2 where id =: Opp.Product_Item_4__c ];
                            products.add(product);
                        }
                    }
                    else if(i == 5) {
                        if(Opp.Product_Item_5__c != null) {
                            product = [ select id, name, Family, Account__c, Contact__c, Quantity__c from Product2 where id =: Opp.Product_Item_5__c ];
                            products.add(product);
                        }
                    }
                }
                
                Discount = 0;
                
                for (Product2 p : products) {
                    try {
                        PriceBookEntry pbe = [ select id, name, pricebook2id, product2id, product2.name, product2.Quantity__c, unitprice, isactive from pricebookentry where Product2Id =: p.Id ];
                        standardPrices.add(pbe);
                    }
                    catch(Exception e) {
                        System.Debug('See exception at line ' + e.getLineNumber() + ' : ' + e.getMessage());
                        continue;
                    }
                }
                
                noStandardPrice = standardPrices.isEmpty();
                
                CalcTotalPrice();
            }
            
            return true;
    }
    
    //needs to reconfigure computation
    public void CalcTotalPrice()
    {
        TotalPrice = 0;
        TotalPriceAfterDiscount = 0;
        IncludedPriceForDiscount = 0;
        ExcludedPriceForDiscount = 0;
        OneTimePaymentWithNoDiscount = 0;
        GrandTotal = 0;
        MonthlyDues = 0;
        
        System.debug(LoggingLevel.Info, 'CalcTotalPrice');
        if (TotalPrice != null) {
            //gets the total amount for listed product items
            for( PriceBookEntry p : standardPrices ) {
                TotalPrice += (p.unitprice * p.product2.Quantity__c); //sets one time payment (total)
                
                if (p.Product2.Name <> 'Channel Manager' && p.Product2.Name <> 'E-signature Integration' && p.Product2.Name <> 'Set-up Fee + Data Migration')
                {
                    IncludedPriceForDiscount += (p.unitprice * p.product2.Quantity__c); // included price for discount
                }
                else
                {
                    if(p.Product2.Name == 'Channel Manager')
                    {
                        ExcludedPriceForDiscount += (p.unitprice * p.product2.Quantity__c); // excluded price for discount
                    }
                    else if(p.Product2.Name == 'E-signature Integration' || p.Product2.Name == 'Set-up Fee + Data Migration')
                    {
                        OneTimePaymentWithNoDiscount += (p.unitprice * p.product2.Quantity__c); // one time payment without discount
                    }
                }
            }
            
            //sets price after discount
           if (Discount > 0)
           {
               Discount = Discount;
               TotalPriceAfterDiscount = IncludedPriceForDiscount * (1-(Discount/100));
               TotalPriceAfterDiscount = TotalPriceAfterDiscount.setScale(2);
           }
           else
           {
               Discount = Discount;
               TotalPriceAfterDiscount = IncludedPriceForDiscount;
               TotalPriceAfterDiscount = TotalPriceAfterDiscount.setScale(2); 
           }
           
           GrandTotal = TotalPriceAfterDiscount + ExcludedPriceForDiscount + OneTimePaymentWithNoDiscount;
           GrandTotal = GrandTotal.setScale(2);
           
           MonthlyDues = TotalPriceAfterDiscount + ExcludedPriceForDiscount;
           MonthlyDues = MonthlyDues.setScale(2);
        }
    }
    
    public void ClearAll()
    {
        Discount = 0.0;
        CalcTotalPrice();
    }
    
    
    Quote q;
    public PageReference BuildQuote()
    {
        if(!isQuoteForUpdate)
        {
            // delete existing invoices
            List<Quote> quotes = [SELECT Id FROM Quote WHERE OpportunityId = :Opp.Id];
            for(Quote quote : quotes) {
                delete quote;
            }
            
            q = new Quote();
        }
        else 
        {
            // get existing invoice
            q = [SELECT Id, OpportunityId, Name, ContactId, Contact_2__c, Contact_3__c, Contact_4__c, Contact_5__c, ExpirationDate,
                BillingName, PriceBook2Id, Discount__c, Total_Price_With_Discount__c, Total_Price_After_Discount__c, Grand_Total__c,
                One_Time_Payment__c, Monthly_Price__c, Phone, Email FROM Quote WHERE Id = :Opp.SyncedQuoteId];
        }
        
        q.OpportunityId = OppId;   
        q.Name = 'Quote: '+ Opp.Name;   
        q.ContactId = primaryContact.Id;
        q.Contact_2__c = Opp.Contact_2__c;
        q.Contact_3__c = Opp.Contact_3__c;
        q.Contact_4__c = Opp.Contact_4__c;
        q.Contact_5__c = Opp.Contact_5__c;
        q.ExpirationDate = date.today().addDays(2);
        q.BillingName = primaryContact.Name;
        q.Pricebook2Id = [select Pricebook2Id from PricebookEntry limit 1].Pricebook2Id;
        q.Discount__c = Discount;
        q.Total_Price_With_Discount__c = IncludedPriceForDiscount;
        q.Total_Price_After_Discount__c = TotalPriceAfterDiscount;
        q.Grand_Total__c = GrandTotal;
        q.One_Time_Payment__c = GrandTotal;
        q.Monthly_Price__c = MonthlyDues;
        q.Phone = primaryContact.Phone == null ? primaryContact.MobilePhone : primaryContact.Phone;
        q.Email = primaryContact.Email;
      
        if(!isQuoteForUpdate)
            insert q;
        else
            update q;
       
        
        for (Product2 p : products) {
            PriceBookEntry pbe = [select id, name, pricebook2id, product2id, unitprice, isactive from pricebookentry where Product2Id =: p.Id limit 1];
            QuoteLineItem qli = new QuoteLineItem();
            qli.PricebookEntryId = [select Id from PricebookEntry where Product2Id =: p.Id  limit 1].Id;
            qli.QuoteId = q.Id;
            qli.Discount = 0;
            qli.Quantity = p.Quantity__c;
            qli.UnitPrice = pbe.UnitPrice;
            listQli.add(qli);
        }
        insert listQli;
        
        Opp.SyncedQuoteId = q.Id;
        Opp.One_Time_Payment__c = GrandTotal;
        Opp.Monthly_Price__c = MonthlyDues;
        update Opp;

        quoteSent = true;
        
        return generateOrder(OppId);
    }
    
    
    private Pagereference generateOrder(Id OppId)
    {
        return new Pagereference('/apex/OrderCreation?id=' + OppId);
    }
}