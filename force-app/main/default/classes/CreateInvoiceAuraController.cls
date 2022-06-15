public with sharing class CreateInvoiceAuraController {
    @TestVisible
    private final static String PRICEBOOK_STANDARD_NAME = 'Standard Price Book';
    
    @AuraEnabled(Cacheable=true)
    public static List<PricebookEntry> getAllProducts() {
        return [
            SELECT
            Product2Id,
            Product2.Name,
            Product2.MonthlyFee__c,
            Product2.ImplementationFee__c,
            Product2.ImplementationDeposit__c,
            Product2.AnnualDiscount__c
            FROM PricebookEntry
            WHERE
            IsActive = TRUE
            AND Product2.IsActive = TRUE
            AND Pricebook2.Name = :PRICEBOOK_STANDARD_NAME
            AND Product2.Product_Region__c LIKE '(%'
            ORDER BY Product2.Hierarchy_Order__c ASC
        ];
    }
    
    @AuraEnabled
    public static Quote getDraftQuote(Id opportunityId) {
        Quote result = new Quote(
            Downpayment__c = 100,
            Due_Now__c = 0,
            Grand_Total__c = 0,
            One_Time_Payment__c = 0,
            Monthly_Price__c = 0,
            AnnualyPayment__c = 0,
            ExpirationDate = Date.today().addDays(14),
            Due_Date__c = Date.today().addDays(14),
            Notes__c = ''
        );
        
        return result;
    }
    
    @AuraEnabled
    public static Quote saveDraftQuote(
        String opportunityId,
        final Quote quoteTemplate,
        final List<ProductWrapper> items
    ) {
        try {
            final Quote quote = handleQuote(quoteTemplate, opportunityId);
            quote.IsDraft__c = true;
            upsert quote;
            
            handleLineItems(quote, items);
            
            return getDraftQuote(opportunityId);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static Id sendQuote(String opportunityId, final Quote quoteTemplate, final List<ProductWrapper> items) {
        try {
            final Quote quote = handleQuote(quoteTemplate, opportunityId);
            quote.IsDraft__c = false;
            upsert quote;
            
            handleLineItems(quote, items);
            
            // update opp totals
            Opportunity toUpdateOpportunity = new Opportunity(
                Id = opportunityId,
                Total_Amount__c = quote.Grand_Total__c
            );
            update toUpdateOpportunity;
            
            // generate pdf and send by email
            generatePdfAndSendToEmailAsync(quote.Id);
            return quote.Id;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static void generatePdfAndSendToEmail(String quoteId) {
        Quote quote = [SELECT Id, QuoteNumber, AccountId, Email, ContactId, OpportunityId FROM Quote WHERE Id = :quoteId];
        Contact con = [SELECT Email_2__c FROM Contact Where Id =: quote.ContactId];
        
        if(con.Email_2__c != null && con.Email_2__c != ''){
            Blob body;
            try {
                PageReference pdf = Page.QuotePdf;
                pdf.getParameters().put('id', quoteId);
                body = pdf.getContentAsPDF();
            } catch (VisualforceException e) {
                body = Blob.valueOf('Couldn\'t get the content of - ' + String.valueOf(quoteId));
            }
            
            QuoteDocument quoteDocument = new QuoteDocument();
            quoteDocument.Document = body;
            quoteDocument.QuoteId = quoteId;
            insert quoteDocument;
            
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setContentType('application/pdf');
            efa.setFileName(quote.QuoteNumber + '.pdf');
            efa.setInline(false);
            efa.body = body;
            
            EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :'Quotes_Email'];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(et.Id);
            email.setTargetObjectId(quote.ContactId);
            email.setWhatId(quote.OpportunityId);
            
            email.setToAddresses(new List<String>{ con.Email_2__c });
            email.setBccSender(true);
            email.setFileAttachments(new List<Messaging.EmailFileAttachment>{ efa });
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
        }
        
        
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Quote> getQuoteById(Id quoteId) {
        return [SELECT Id, OpportunityId FROM Quote WHERE Id = :quoteId LIMIT 1];
    }
    
    private static void handleLineItems(Quote q, final List<ProductWrapper> items) {
        List<QuoteLineItem> itemsToUpsert = new List<QuoteLineItem>();
        List<QuoteLineItem> itemsToDelete = new List<QuoteLineItem>();
        
        // query Pricebook Entries and generate map of ProductId to PricebookEntryId
        Map<Id, Id> productIdToPricebookEntryIdMap = queryProductIdToPricebookEntryIdMap();
        
        // create quote line items
        for (ProductWrapper wrapper : items) {
            if (String.isNotBlank(wrapper.itemId) && wrapper.removed) {
                itemsToDelete.add(new QuoteLineItem(Id = wrapper.itemId));
            } else if (!wrapper.removed) {
                itemsToUpsert.add(
                    createQuoteLineItem(q.Id, productIdToPricebookEntryIdMap.get(wrapper.productId), wrapper)
                );
            }
        }
        
        delete itemsToDelete;
        upsert itemsToUpsert;
    }
    
    @Future(Callout=true)
    public static void generatePdfAndSendToEmailAsync(String quoteId) {
        generatePdfAndSendToEmail(quoteId);
    }
    
    private static Pricebook2 queryStandardPricebook() {
        return [SELECT Id FROM Pricebook2 WHERE Name = :PRICEBOOK_STANDARD_NAME];
    }
    
    private static Map<Id, Id> queryProductIdToPricebookEntryIdMap() {
        Map<Id, Id> result = new Map<Id, Id>();
        for (PricebookEntry pbe : [
            SELECT Id, Product2Id
            FROM PricebookEntry
            WHERE IsActive = TRUE AND Pricebook2.Name = :PRICEBOOK_STANDARD_NAME
        ]) {
            result.put(pbe.Product2Id, pbe.Id);
        }
        
        return result;
    }
    
    private static Opportunity queryOpportunity(String opportunityId) {
        return [
            SELECT
            Id,
            Name,
            Effective_Date__c,
            Primary_Contact__c,
            Primary_Contact__r.Name,
            Primary_Contact__r.Email,
            Primary_Contact__r.Phone,
            Primary_Contact__r.MobilePhone
            FROM Opportunity
            WHERE Id = :opportunityId
        ];
    }
    
    private static Quote handleQuote(final Quote quote, String opportunityId) {
        final Pricebook2 standardPricebook = queryStandardPricebook();
        final Opportunity opportunity = queryOpportunity(opportunityId);
        return new Schema.Quote(
            Id = quote.Id,
            OpportunityId = opportunity.Id,
            Name = 'Quote: ' + opportunity.Name,
            ContactId = opportunity.Primary_Contact__c,
            ExpirationDate = quote.ExpirationDate,
            Due_Date__c = quote.Due_Date__c,
            BillingName = opportunity.Primary_Contact__r.Name,
            Pricebook2Id = standardPricebook.Id,
            Grand_Total__c = quote.Grand_Total__c,
            One_Time_Payment__c = quote.One_Time_Payment__c,
            Monthly_Price__c = quote.Monthly_Price__c,
            AnnualyPayment__c = quote.AnnualyPayment__c,
            Phone = opportunity.Primary_Contact__r.Phone == null
            ? opportunity.Primary_Contact__r.MobilePhone
            : opportunity.Primary_Contact__r.Phone,
            Email = opportunity.Primary_Contact__r.Email,
            Notes__c = quote.Notes__c,
            DownPayment__c = quote.DownPayment__c,
            Due_Now__c = quote.Due_Now__c,
            Effective_Date__c = quote.Due_Date__c
        );
    }
    
    private static QuoteLineItem createQuoteLineItem(Id quoteId, Id pbeId, final ProductWrapper p) {
        return new QuoteLineItem(
            Id = p.itemId,
            PricebookEntryId = pbeId,
            Payment_Type__c = p.billingCycle != null ? p.billingCycle : 'Monthly',
            QuoteId = quoteId,
            Discount = p.discount,
            Quantity = p.quantity,
            UnitPrice = p.implFee,
            Notes__c = p.notes
        );
    }
    
    public class ProductWrapper {
        @AuraEnabled
        public String itemId { get; set; }
        @AuraEnabled
        public String productId { get; set; }
        @AuraEnabled
        public Decimal price { get; set; }
        @AuraEnabled
        public Decimal implFee { get; set; }
        @AuraEnabled
        public Decimal implDeposit { get; set; }
        @AuraEnabled
        public Decimal subsFee { get; set; }
        @AuraEnabled
        public Decimal quantity { get; set; }
        @AuraEnabled
        public Decimal discount { get; set; }
        @AuraEnabled
        public String notes { get; set; }
        @AuraEnabled
        public String discountType { get; set; }
        @AuraEnabled
        public String billingCycle { get; set; }
        @AuraEnabled
        public String paymentMethod { get; set; }
        @AuraEnabled
        public Boolean removed { get; set; }
    }
}