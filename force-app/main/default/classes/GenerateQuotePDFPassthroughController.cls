public with sharing class GenerateQuotePDFPassthroughController {
    //private final Id QuoteId = (Id) ApexPages.currentPage().getParameters().get('quoteId');
    private final Id QuotePDFTemplateId = (Id)Label.QuotePDFTemplate;
    Private Quote Quote;
    Private String quoteAttachmentName;
    Private List<String> ccAddresses;
    
    public void GenerateQuotePDFAndRedirectToQuotePage(id QuoteID) {
         Quote = [select id, name, ContactID, Contact.Email, Contact_2__c, Contact_2__r.Email, Contact_3__c, Contact_3__r.Email, Contact_4__c, Contact_4__r.Email, Contact_5__c, Contact_5__r.Email, OpportunityID, Opportunity.name from Quote where id = :QuoteId limit 1];
         quoteAttachmentName = (String)Quote.Opportunity.name + '_' + quote.name;
         String emailID = quote.Contact.Email;
         
         ccAddresses = new List<String>();
         if(Quote.Contact_2__c != null) {
             ccAddresses.add(Quote.Contact_2__r.Email);
         }
         else if(Quote.Contact_3__c != null) {
             ccAddresses.add(Quote.Contact_3__r.Email);
         }
         else if(Quote.Contact_4__c != null) {
             ccAddresses.add(Quote.Contact_4__r.Email);
         }
         else if(Quote.Contact_5__c != null) {
             ccAddresses.add(Quote.Contact_5__r.Email);
         }

        GenerateQuoteDocument(QuoteId, emailID);
    }

    private void GenerateQuoteDocument(Id quotesId, String emailID) {
        String quoteURL = '/quote/quoteTemplateDataViewer.apexp?id=' + quotesId
                          + '&headerHeight=190&footerHeight=188&summlid=' + QuotePDFTemplateId
                          + '#toolbar=1&navpanes=0&zoom=90';
        System.debug('quoteURL==' + quoteURL);
        PageReference pageReferenceForPDF = new PageReference(quoteURL);
        System.debug('Here');

        QuoteDocument newQuoteDocument = new QuoteDocument();
        Blob renderedPDF;
        renderedPDF = Test.isRunningTest()==true? Blob.valueOf('BLob when occur error'):pageReferenceForPDF.getContentAsPDF();
        newQuoteDocument.Document = renderedPDF;
        newQuoteDocument.QuoteId = quotesId;
        INSERT newQuoteDocument;
        
        if (emailID != null && emailID != '') {
            List<String> emailIDs = new List<String>();
            emailIDs.add(emailID);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            efa1.setFileName(quoteAttachmentName+'.pdf');
            efa1.setBody(renderedPDF);
            EmailTemplate et =[Select id from EmailTemplate where DeveloperName=:'Quotes_Email'];
            email.setTemplateId(et.id);
            email.setTargetObjectId(quote.ContactID);
            email.setWhatID(quote.opportunityid);
            email.setToAddresses( EmailIds);
            if (ccAddresses != null && ccAddresses.size() > 0)
            {
                email.setccAddresses(ccAddresses);
            }
            email.setBccSender(true);
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
            System.debug('quoteURL==' + quoteURL);
        }
    }
}