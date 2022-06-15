public with sharing class CreateInvoiceController 
{
    public Id opportunityId {get; set;}
    public Opportunity opportunity {get; set;}
    
    private List<SelectOption> productsAvailableOptions {get; set;}
    private List<SelectOption> productPaymentTypeOptions {get; set;}
    public Selected_Product__c[] selectedProducts {get; set;}
    public Product2[] products {get; set;}
    public List<Selected_Product__c> productsToSave {get; set;}
    public Id removeProductId {get; set;}
    public String productSelected {get; set;}
    public String paymentType {get; set;}
    
    public List<PriceBookEntry> standardPrices {get; set;}
    
    public List<QuoteLineItem> listQli = new list<QuoteLineItem >();
    
    public double Quantity {get; set;}
    public double Downpayment {get; set;}
    public Decimal TotalPrice { get; set; }
    public Decimal OneTimePayment { get; set; }
    public Decimal MonthlyDues { get; set; }
    public Decimal GrandTotal { get; set; }
    
    public String ProductNotes {get; set;}
    public String Notes {get; set;}
    
    Contact primaryContact;
    
    public CreateInvoiceController(ApexPages.StandardController controller) 
    {
        opportunityId = (Id)controller.getRecord().get('id');
        opportunity = getOpportunity(opportunityId);
        
        primaryContact = [ select Id, Name, Email, Phone, MobilePhone from Contact where id=: opportunity.Primary_contact__c ];
        
        products = new List<Product2>();
        selectedProducts = new List<Selected_Product__c>();
        
        Quantity = 1;
        Downpayment = 100;
        TotalPrice = 0;
        GrandTotal = 0;
        OneTimePayment = 0;
        MonthlyDues = 0;
        
        initAvailableProducts();
        initSelectedProducts();
    }
    
    private Opportunity getOpportunity(Id oppId) 
    {
        system.debug('currentOppId');
        system.debug(oppId);
        return [SELECT Id, Name, Primary_Contact__c, One_Time_Payment__c, Monthly_Price__c, Total_Amount__c, Effective_Date__c FROM Opportunity WHERE Id = :oppId];
    }
    
    public void initSelectedProducts()
    {
        selectedProducts.clear();
        selectedProducts = [SELECT Id, Name, Opportunity__c, Product__c, Product__r.Name, Quantity__c, Price__c, Notes__c FROM Selected_Product__c WHERE Opportunity__c = :opportunityId AND IsQuoted__c = false];
    }
    
    public void initAvailableProducts() 
    {
        products.clear();
        products = [SELECT Id, Name FROM Product2];
    }
    
    public void removeSelectedProduct() 
    {
        Selected_Product__c sp = new Selected_Product__c(Id = removeProductId);
        delete sp;
        
        initSelectedProducts();
        initAvailableProducts();
        
        CalcTotalPrice();
    }
    
    public void addSelectedProduct() 
    {
        productsToSave = new List<Selected_Product__c>();
        
        if(!String.isEmpty(productSelected) && Quantity > 0) {
            PriceBookEntry pbe = [SELECT Id, UnitPrice FROM PriceBookEntry WHERE Product2Id = :productSelected LIMIT 1];
            Selected_Product__c sp = new Selected_Product__c();
            sp.Opportunity__c = opportunityId;
            sp.Product__c = (Id)productSelected;
            sp.Price__c = pbe != null ? pbe.UnitPrice : 0;
            sp.Quantity__c = Quantity;
            sp.Notes__c = ProductNotes;
            sp.Payment_Type__c =  paymentType;
            productsToSave.add(sp);
            
            insert productsToSave;
            
            initSelectedProducts();
            initAvailableProducts();
            
            Quantity = 1; //reset quantity
            ProductNotes = ''; // reset notes
            paymentType = 'Monthly'; // reset payment type
            
            CalcTotalPrice();
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No selected product or Quantity must be atleast 1.'));
        }
    }
    
    public void CalcTotalPrice()
    {
        TotalPrice = 0;
        OneTimePayment = 0;
        GrandTotal = 0;
        MonthlyDues = 0;
        
        if (TotalPrice != null) {
            //gets the total amount for listed product items
            for( Selected_Product__c sp : [SELECT Id, Product__r.Name, Quantity__c, Price__c, Payment_Type__c FROM Selected_Product__c WHERE Opportunity__c = :opportunityId AND isQuoted__c = false] ) {
                TotalPrice += (sp.Price__c * sp.Quantity__c); //sets one time payment (total)
                
                if(sp.Payment_Type__c == 'One-Time') {
                    OneTimePayment += (sp.Price__c * sp.Quantity__c); // one time payment 
                }
                else if(sp.Payment_Type__c == 'Monthly') {
                    MonthlyDues += (sp.Price__c * sp.Quantity__c); // monthly dues
                }
            }
            
            GrandTotal = TotalPrice;
            
            GrandTotal = GrandTotal.setScale(2);
            OneTimePayment = OneTimePayment.setScale(2);
            MonthlyDues = MonthlyDues.setScale(2);
        }
    }
    
    public void ClearAll()
    {
        DownPayment = 100;
        CalcTotalPrice();
    }
    
    public List<SelectOption> getProductsAvailable()
    {
        productsAvailableOptions = new List<SelectOption>();
        if(!products.isEmpty()) {
            for(Product2 p : products) 
            {
                productsAvailableOptions.add(new SelectOption(p.Id, p.Name));
            }
        }
        else {
            productsAvailableOptions.Add(new SelectOption('null', 'No products available'));
        }
        
        return productsAvailableOptions;
    }
    
    public List<SelectOption> getProductPaymentTypes()
    {
        productPaymentTypeOptions = new List<SelectOption>();
        productPaymentTypeOptions.add(new SelectOption('Monthly', 'Monthly'));
        productPaymentTypeOptions.add(new SelectOption('One-Time', 'One-Time'));        
        return productPaymentTypeOptions;
    }
    
    Quote q;
    public PageReference BuildQuote()
    {
        q = new Quote();
        q.OpportunityId = opportunityId;   
        q.Name = 'Quote: '+ opportunity.Name;   
        q.ContactId = primaryContact.Id;
        q.ExpirationDate = date.today().addDays(2);
        q.BillingName = primaryContact.Name;
        q.Pricebook2Id = [select Pricebook2Id from PricebookEntry limit 1].Pricebook2Id;
        q.Grand_Total__c = GrandTotal;
        q.One_Time_Payment__c = OneTimePayment;
        q.Monthly_Price__c = MonthlyDues;
        q.Phone = primaryContact.Phone == null ? primaryContact.MobilePhone : primaryContact.Phone;
        q.Email = primaryContact.Email;
        q.Notes__c = Notes;
        q.Downpayment__c = Downpayment;
        q.Effective_Date__c = opportunity.Effective_Date__c;

        try{
            insert q;
        }catch(Exception ex) {
            system.debug('EXCEPTION WITH INSERTION');
            ex.getMessage();
            ex.getStackTraceString();
        }

        system.debug('currentQuote');
        system.debug(q);

        for (Selected_Product__c p : selectedProducts) {
            // update product
            p.IsQuoted__c = true;
            update p;
            // insert quote line items
            QuoteLineItem qli = new QuoteLineItem();
            qli.PricebookEntryId = [select Id from PricebookEntry where Product2Id =: p.Product__c limit 1].Id;
            qli.QuoteId = q.Id;
            qli.Discount = 0;
            qli.Quantity = p.Quantity__c;
            qli.UnitPrice = p.Price__c;
            qli.Notes__c = p.Notes__c;
            listQli.add(qli);
        }
        insert listQli;
        
        // update opportunity
        opportunity.Total_Amount__c += GrandTotal;
        update opportunity;
        
        system.debug('quoteInserted');
        
        // generate pdf and send to email
        String quoteId = q.Id;
        System.Debug('QuoteId: ' + quoteId);

        // redirect to page
        PageReference pageRef = Page.QuoteCreated;

        generatePdfAndSendToEmail(quoteId);
        return pageRef;
    }

    //Create New Product
    @AuraEnabled
    public static Product2 addNewProducts(String textName, Decimal textImplFee, Decimal textImplDep, Decimal textmonFee){
        try {
            
            Product2 newProduct = new Product2();
            newProduct.Name =  textName;
            newProduct.ImplementationFee__c = textImplFee;
            newProduct.ImplementationDeposit__c = textImplDep;
            newProduct.MonthlyFee__c = textmonFee;
            insert newProduct;
            return newProduct;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @future(callout=true)
    private static void generatePdfAndSendToEmail(String quoteId) {
        Blob body;
        Quote q = [SELECT Id, QuoteNumber, Email, ContactId, OpportunityId FROM Quote WHERE Id = :quoteId LIMIT 1];
        
        // generate pdf
        String quoteAttachmentName = q.QuoteNumber;
        String emailId = q.Email;
        
        PageReference pdf = Page.QuotePdf;
        pdf.getParameters().put('id', String.valueOf(q.Id));
        
        System.Debug('Generate pdf: ' + pdf);
        
        QuoteDocument qd = new QuoteDocument();
        try {
             body = pdf.getContentAsPDF();
        } catch (VisualforceException e) {
             body = Blob.valueOf('Couldn\'t get the content of - ' + String.valueOf(q.Id));
        }
        qd.Document = body;
        qd.QuoteId = q.Id;
        insert qd;
        
        // send to email
        List<String> emailIDs = new List<String>();
        emailIDs.add(emailId);
        
        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        efa1.setContentType('application/pdf');
        efa1.setFileName(quoteAttachmentName + '.pdf');
        efa1.setInline(false);
        efa1.Body = body;
        
        EmailTemplate et = [Select id from EmailTemplate where DeveloperName=:'Quotes_Email'];
      
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(et.id);
        email.setTargetObjectId(q.ContactId);
        email.setWhatID(q.OpportunityId);

        email.setToAddresses( EmailIds);
        email.setBccSender(true);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}