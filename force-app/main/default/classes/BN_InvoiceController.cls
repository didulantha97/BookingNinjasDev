public without sharing class BN_InvoiceController {
    private String crediential {
        get {
            List<Stripe_Settings__c> st = [
                SELECT Is_Live__c, Stripe_Secret_Live_Key__c, Stripe_Secret_Test_Key__c
                FROM Stripe_Settings__c
            ];
            if (st.size() > 0) {
                if (st[0].Is_Live__c) {
                    return st[0].Stripe_Secret_Live_Key__c;
                } else {
                    return st[0].Stripe_Secret_Test_Key__c;
                }
            }
            return '';
        }
    }
    public String title { get; set; }
    public String description { get; set; }
    public String page { get; set; }
    public String ogImage { get; set; }
    public String quoteId { get; set; }
    public ItemWrapper item { get; set; }

    public BN_InvoiceController() {
        quoteId = ApexPages.currentPage().getParameters().get('id');
        item = getQuoteItem();
        title = 'Invoice #' + item.quoteNumber + ' | Booking Ninjas';
        description = 'Invoice #' + item.quoteNumber;
        page = ApexPages.currentPage().getUrl().substringAfter('/').split('\\?')[0];
    }

    public PageReference activateQuote() {
        updateQuote();
        PageReference pr = new PageReference('/thank-you?id=' + quoteId);
        pr.setRedirect(true);
        return pr;
    }

    private void updateQuote() {
        Quote quote = [SELECT Id FROM Quote WHERE Id = :quoteId LIMIT 1];
        quote.Status = 'Active';
        quote.ActivationDate__c = Date.today();
        update quote;
    }

    private ItemWrapper getQuoteItem() {
        QuoteLineItem item = [
            SELECT
                Id,
                Payment_Type__c,
                Product2Id,
                Product2.AnnualDiscount__c,
                Product2.ImplementationDeposit__c,
                Product2.ImplementationFee__c,
                Product2.MonthlyFee__c,
                Product2.Name,
                Product2.Features__c,
                Product2.Size__c,
                Quote.Contact.FirstName,
                Quote.Contact.LastName,
                Quote.Contact.Name,
                Quote.Contact.Account.Name,
                Quote.ContactId,
                Quote.StripeChargeId__c,
                Quote.ExpirationDate,
                Quote.Effective_Date__c,
                Quote.Due_Date__c,
                Quote.QuoteNumber
            FROM QuoteLineItem
            WHERE QuoteId = :quoteId AND Product2.IsActive = TRUE AND Product2.Product_Region__c LIKE '(%'
            ORDER BY Product2.Hierarchy_Order__c ASC
            LIMIT 1
        ];
        Map<String, Object> cardData = getCardData(item.Quote.StripeChargeId__c);
        return new ItemWrapper(item, cardData);
    }

    public class ItemWrapper {
        public String id { get; set; }
        public Date effectiveDate { get; set; }
        public Date dueDate { get; set; }
        public String quoteNumber { get; set; }
        public String contactAccountName { get; set; }
        public String contactFirstName { get; set; }
        public String contactLastName { get; set; }
        public String productId { get; set; }
        public String productName { get; set; }
        public List<String> productFeatures { get; set; }
        public String productSize { get; set; }
        public String billingPeriod { get; set; }
        public Decimal annualyPayment { get; set; }
        public Decimal annualyPaymentOriginal { get; set; }
        public Decimal monthlyPayment { get; set; }
        public Boolean subsFeeDiscountable { get; set; }
        public Decimal subsPayment { get; set; }
        public Decimal subsPaymentOriginal { get; set; }
        public String subsPaymentOriginalText { get; set; }
        public Decimal subsPaymentThree { get; set; }
        public Decimal subsPaymentSix { get; set; }
        public Decimal subsPaymentTwelve { get; set; }
        public Boolean implFeeDiscountable { get; set; }
        public Decimal handleFeePayment { get; set; }
        public Decimal handleFeePaymentOriginal { get; set; }
        public String handleFeePaymentOriginalText { get; set; }
        public String stripeChargeId { get; set; }
        public String cardName { get; set; }
        public String cardNumber { get; set; }
        public String cardExpiredDate { get; set; }

        public ItemWrapper(QuoteLineItem item, Map<String, Object> cardData) {
            this.id = item.Id;
            this.effectiveDate = item.Quote.Effective_Date__c;
            this.dueDate = item.Quote.Due_Date__c;
            this.quoteNumber = item.Quote.QuoteNumber;
            this.contactAccountName = item.Quote.Contact.Account.Name;
            this.contactFirstName = item.Quote.Contact.FirstName;
            this.contactLastName = item.Quote.Contact.LastName;
            this.productId = item.Product2Id;
            this.productName = item.Product2.Name;
            this.productFeatures = new List<String>();
            for (String feature : item.Product2.Features__c.split(';')) {
                this.productFeatures.add(feature);
            }
            this.productSize = item.Product2.Size__c;
            this.billingPeriod = item.Payment_Type__c;
            String discountType = item.Product2.AnnualDiscount__c;
            Boolean isAnnualy = this.billingPeriod == 'Annualy';
            this.subsFeeDiscountable = discountType == 'All' || discountType == 'Subscription Fee';
            this.implFeeDiscountable = discountType == 'All' || discountType == 'Implementation Fee';
            this.monthlyPayment = item.Product2.MonthlyFee__c;
            Decimal discountedSubsFee = this.monthlyPayment - (this.monthlyPayment * 0.2);
            this.annualyPayment = isAnnualy
                ? subsFeeDiscountable ? discountedSubsFee * 12 : this.monthlyPayment * 12
                : null;
            this.annualyPaymentOriginal = this.monthlyPayment * 12;
            this.subsPayment = isAnnualy ? this.annualyPayment : this.monthlyPayment;
            this.subsPaymentOriginal = isAnnualy ? this.monthlyPayment * 12 : this.monthlyPayment;
            this.subsPaymentOriginalText = String.valueOf(this.subsPaymentOriginal);
            this.subsPaymentThree = this.subsPayment / 3;
            this.subsPaymentSix = this.subsPayment / 6;
            this.subsPaymentTwelve = this.subsPayment / 12;
            this.handleFeePaymentOriginal = item.Product2.ImplementationFee__c;
            this.handleFeePaymentOriginalText = String.valueOf(this.handleFeePaymentOriginal);
            Decimal discountedImplFee = this.handleFeePaymentOriginal - (this.handleFeePaymentOriginal * 0.2);
            this.handleFeePayment = isAnnualy
                ? implFeeDiscountable ? discountedImplFee : this.handleFeePaymentOriginal
                : this.handleFeePaymentOriginal;
            this.stripeChargeId = item.Quote.StripeChargeId__c;
            Map<String, String> card = getPaymentMethod(cardData);
            this.cardName = card.get('cardName');
            this.cardNumber = card.get('cardNumber');
            this.cardExpiredDate = card.get('cardExpiration');
        }

        private Map<String, String> getPaymentMethod(Map<String, Object> cardData) {
            if (cardData != null) {
                String month = (String) cardData.get('exp_month');
                String year = (String) cardData.get('exp_year');
                return new Map<String, String>{
                    'cardName' => (String) cardData.get('holder'),
                    'cardNumber' => (String) cardData.get('last4'),
                    'cardExpiration' => month + '/' + year
                };
            } else {
                return new Map<String, String>{
                    'cardName' => 'Teguh Prayoga',
                    'cardNumber' => '4242',
                    'cardExpiration' => '12/2025'
                };
            }
        }
    }

    private Map<String, String> getCardData(String chargeId) {
        Map<String, Object> paymentData = getChargeData(chargeId);
        try {
            Map<String, Object> bd = (Map<String, Object>) paymentData.get('billing_details');
            String cardHolder = (String) bd.get('name');
            Map<String, Object> pm = (Map<String, Object>) paymentData.get('payment_method_details');
            Map<String, Object> card = (Map<String, Object>) pm.get('card');
            Map<String, String> cardData = new Map<String, String>{
                'holder' => cardHolder,
                'exp_month' => String.valueOf((Integer) card.get('exp_month')),
                'exp_year' => String.valueOf((Integer) card.get('exp_year')),
                'last4' => (String) card.get('last4')
            };
            return cardData;
        } catch (Exception e) {
            return null;
        }
    }

    private Map<String, Object> getChargeData(String chargeId) {
        String endPoint = 'https://api.stripe.com/v1/charges/' + chargeId;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + crediential);
        request.setEndpoint(endPoint);
        request.setMethod('GET');

        Map<String, Object> respMap;
        if (!Test.isRunningTest()) {
            HttpResponse res = http.send(request);
            respMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        } else {
            respMap = new Map<String, Object>{
                'id' => chargeId,
                'payment_method_details' => new Map<String, Object>{
                    'card' => new Map<String, Object>{
                        'brand' => 'Visa',
                        'exp_month' => 2,
                        'exp_year' => 2022,
                        'last4' => '4242'
                    }
                },
                'billing_details' => new Map<String, Object>{ 'name' => 'Teguh Prayoga' }
            };
        }

        return respMap;
    }
}