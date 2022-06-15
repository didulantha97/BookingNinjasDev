public with sharing class GenerateInvoicePDFPassthroughController {
    public String quoteId { get; set; }
    public Quote quote { get; set; }
    public QuoteLineItem item { get; set; }
    private Boolean annualy { get; set; }
    private String discountType { get; set; }

    public GenerateInvoicePDFPassthroughController(ApexPages.StandardController stdController) {
        quoteId = ApexPages.currentPage().getParameters().get('id');
        quote = fetchQuote();
        item = fetchItem();
        discountType = item.Product2.AnnualDiscount__c;
        annualy = item.Payment_Type__c == 'Annualy'; 
    }

    private Quote fetchQuote() {
        return [
            SELECT
                Id,
                QuoteNumber,
                ExpirationDate,
                Account.Name,
                Account.Email_1__c,
                Account.Phone,
                Contact.Name,
                Contact.Email,
                Contact.Email_2__c,
                Contact.Phone,
                Grand_Total__c,
                GrandTotal,
                Downpayment__c,
                Notes__c,
                Monthly_Price__c,
                AnnualyPayment__c,
                One_Time_Payment__c,
                Effective_Date__c,
                Due_Now__c,
                Due_Date__c,
                Subtotal
            FROM Quote
            WHERE Id = :quoteId
            LIMIT 1
        ];
    }

    private QuoteLineItem fetchItem() {
        return [
            SELECT
                Id,
                UnitPrice,
                ListPrice,
                Payment_Type__c,
                Notes__c,
                Product2Id,
                Product2.Name,
                Product2.ImplementationFee__c,
                Product2.ImplementationDeposit__c,
                Product2.MonthlyFee__c,
                Product2.AnnualDiscount__c,
                Product2.Hierarchy_Order__c,
                Product2.Size__c,
                Quantity
            FROM QuoteLineItem
            WHERE QuoteId = :quoteId
            LIMIT 1
        ];
    }

    public Decimal getOneTimeAmount() {
        if (annualy) {
            Decimal discountAmount = getOneTimeDiscountAmount();
            return item.Product2.ImplementationFee__c - discountAmount;
        }
        return item.Product2.ImplementationFee__c;
    }

    public Decimal getOneTimeDepositAmount() {
        return (item.Product2.ImplementationDeposit__c / 100) * getOneTimeAmount();
    }

    public Decimal getOneTimeDepositLeftAmount() {
        return getOneTimeAmount() - getOneTimeDepositAmount();
    }

    public Integer getOneTimePercentageAmountLeft() {
        return 100 - Integer.valueOf(item.Product2.ImplementationDeposit__c);
    }

    public Integer getOneTimeDiscountPercentage() {
        if ((discountType == 'All' || discountType == 'Implementation Fee') && annualy) {
            return 20;
        }
        return 0;
    }

    public Decimal getOneTimeDiscountAmount() {
        if (getOneTimeDiscountPercentage() == 20) {
            return item.Product2.ImplementationFee__c - quote.One_Time_Payment__c;
        }
        return 0;
    }

    public Boolean getShowOneTimeDiscount() {
        return getOneTimeDiscountAmount() > 0;
    }

    public Decimal getSubscriptionAmountEach() {
        if (annualy) {
            return quote.AnnualyPayment__c;
        }
        return item.Product2.MonthlyFee__c;
    }

    public Decimal getSubscriptionAmountTotal() {
        return getSubscriptionAmountEach() * item.Quantity;
    }

    public Integer getSubscriptionDiscountPercentage() {
        if ((discountType == 'All' || discountType == 'Subscription Fee') && annualy) {
            return 20;
        }
        return 0;
    }

    public Decimal getSubscriptionDiscountAmount() {
        if (getSubscriptionDiscountPercentage() == 20) {
            return (item.Product2.MonthlyFee__c * 12) - quote.AnnualyPayment__c;
        }
        return 0;
    }

    public Boolean getShowSubscriptioDiscount() {
        return getSubscriptionDiscountAmount() > 0;
    }

    public String getBillingCycle() {
        return annualy ? 'annualy' : 'monthly';
    }
}