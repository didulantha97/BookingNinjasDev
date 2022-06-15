public class BN_CheckoutSucceedController {
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
    private String quoteId = '';
    private String contactId;
    private String pkgOrder;
    private String pkgLength;
    private Product2 product;
    private Opportunity opp;
    private Quote quot;
    private String paymentIntent;
    private Map<String, String> customer;
    private String invoiceId;
    private Map<String, Object> paymentData;
    public Decimal amountPaid { get; set; }
    public Boolean forbidden { get; set; }

    public BN_CheckoutSucceedController() {
        paymentIntent = ApexPages.currentPage().getParameters().get('id');
        paymentIntent = paymentIntent.split('_secret_')[0];
        pkgOrder = ApexPages.currentPage().getParameters().get('order');
        if (paymentIntent == null || pkgOrder == null) {
            forbidden = true;
        } else {
            forbidden = false;
        }
        paymentData = getPaymentData();
        amountPaid = getChargedAmount();
        customer = getCustomer();

        // set cookie
        Cookie visited = ApexPages.currentPage().getCookies().get('visited-' + paymentIntent);
        if (visited == null) {
            visited = new Cookie('visited-' + paymentIntent, '1', null, -1, true);
        } else {
            // If this isn't the first time the user is accessing the page
            // create a new cookie, incrementing the value of the original count by 1
            Integer count = Integer.valueOf(visited.getValue());
            visited = new Cookie('visited-' + paymentIntent, String.valueOf(count + 1), null, -1, true);
        }
        ApexPages.currentPage().setCookies(new List<Cookie>{ visited });
    }

    public PageReference addSuccessActions() {
        Cookie visited = ApexPages.currentPage().getCookies().get('visited-' + paymentIntent);
        if (customer.size() > 0 && visited.getValue() == '1' && forbidden == false) {
            // Create Contact
            contactId = AlatAlat.createGuest(customer);
            // Update Quote if exist
            quoteId = ApexPages.currentPage().getParameters().get('invoice');
            if (quoteId != null && quoteId != '') {
                quot = getQuote();
                quot.Total_Paid_Amount__c = amountPaid;
                quot.Status = 'Accepted';
                quot.Invoice_URL__c = getReceiptUrl();
                quot.StripeChargeId__c = getChargeId();
                update quot;
            } else {
                pkgLength = ApexPages.currentPage().getParameters().get('length');
                product = getProduct();
                opp = createOpportunity();
                quot = createQuote();
                createQuoteLineItem();
            }
            // Send email
            String emailConfirmationBody =
                'Hello ' +
                customer.get('name') +
                ',<br/><br/>' +
                'Your payment of $' +
                amountPaid +
                ' has been successfully processed. ' +
                'Your Booking Ninjas system is currently being set up, and you should receive your account information in less than 24 hours.<br/><br/>' +
                'If you have any questions or need to make any change to your application, we can easily be reached by replying to this email or you can ' +
                'send an email to any Booking Ninjas representative you are currently having a conversation with.<br/><br/>' +
                'Thank you for choosing Booking Ninjas.<br/><br/>' +
                'Regards, <br/>Booking Ninjas<br/>';
            sendEmail(customer.get('email'), 'Your payment has been processed - Booking Ninjas', emailConfirmationBody);
            String emailNotificationBody =
                'Product order from ' +
                customer.get('name') +
                ' from ' +
                customer.get('company') +
                ' ' +
                'has successfully pay $' +
                amountPaid +
                ' for Booking Ninjas Products.<br/><br/>' +
                'Quote URL: ' +
                System.URL.getOrgDomainUrl().toExternalForm() +
                '/' +
                quot.Id +
                '<br/>' +
                'Receipt URL: ' +
                getReceiptUrl() +
                '<br/>';
            if (!Test.isRunningTest()) {
                sendEmail(
                    'ceo@bookingninjas.com',
                    'Product Order from ' + customer.get('email'),
                    emailNotificationBody
                );
            }

            return null;
        } else {
            pageReference pg = new pageReference('/');
            return pg.setRedirect(true);
        }
    }

    private Map<String, Object> getPaymentData() {
        String endPoint = 'https://api.stripe.com/v1/payment_intents/' + paymentIntent;

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
                'id' => 'stripe-payment-intent-id',
                'customer' => 'customer-id',
                'amount_received' => 25000,
                'status' => 'succeeded',
                'charges' => new Map<String, Object>{
                    'data' => new List<Object>{
                        new Map<String, Object>{ 'receipt_url' => 'https://pay.stripe.com/receipts/acct_xyz' }
                    }
                }
            };
        }

        return respMap;
    }

    private Decimal getChargedAmount() {
        if (paymentData.containsKey('id')) {
            String status = (String) paymentData.get('status');
            if (status == 'succeeded') {
                Integer amount = (Integer) paymentData.get('amount_received');
                return amount / 100;
            }
        }
        return null;
    }

    private String getReceiptUrl() {
        if (paymentData.containsKey('id')) {
            Map<String, Object> chargesObj = (Map<String, Object>) paymentData.get('charges');
            List<Object> chargesDataList = (List<Object>) chargesObj.get('data');
            Map<String, Object> chargesData = (Map<String, Object>) chargesDataList[0];
            return (String) chargesData.get('receipt_url');
        }
        return null;
    }

    private String getChargeId() {
        if (paymentData.containsKey('id')) {
            Map<String, Object> chargesObj = (Map<String, Object>) paymentData.get('charges');
            List<Object> chargesDataList = (List<Object>) chargesObj.get('data');
            Map<String, Object> chargesData = (Map<String, Object>) chargesDataList[0];
            return (String) chargesData.get('id');
        }
        return null;
    }

    private String getCustomerId() {
        if (paymentData.containsKey('id')) {
            return (String) paymentData.get('customer');
        }
        return null;
    }

    private Map<String, String> getCustomer() {
        String endPoint = 'https://api.stripe.com/v1/customers/' + getCustomerId();

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
                'id' => 'cus-id',
                'name' => 'Prayoga Teguh',
                'email' => 'teguh@bookingninjas.com',
                'phone' => '+6281234030898',
                'metadata' => new Map<String, String>{ 'company' => 'Booking Ninjas' }
            };
        }

        Map<String, String> customer = new Map<String, String>();
        if (respMap.containsKey('id')) {
            customer.put('id', (String) respMap.get('id'));
            customer.put('name', (String) respMap.get('name'));
            customer.put('email', (String) respMap.get('email'));
            customer.put('phone', (String) respMap.get('phone'));
            Object metaObj = (Object) respMap.get('metadata');
            Map<String, Object> m = (Map<String, Object>) metaObj;
            customer.put('company', (String) m.get('company'));
        }

        return customer;
    }

    private List<Opportunity> getOpportunity() {
        return [
            SELECT
                Id,
                Name,
                AccountId,
                Primary_Contact__c,
                Primary_Contact__r.Name,
                Primary_Contact__r.Email,
                Primary_Contact__r.Phone,
                Primary_Contact__r.MobilePhone
            FROM Opportunity
            WHERE AccountId = :getContact().AccountId
        ];
    }

    private Opportunity createOpportunity() {
        List<Opportunity> opps = getOpportunity();
        Opportunity opp;
        if (opps.size() == 0) {
            opp = new Opportunity(
                Name = customer.get('name'),
                Type = 'New Business',
                StageName = 'Top Opps',
                Probability = 95,
                Effective_Date__c = Date.Today(),
                CloseDate = Date.Today().addMonths(1),
                AccountId = getContact().AccountId,
                Primary_Contact__c = contactId
            );
            insert opp;
        } else {
            opp = opps[0];
            opp.Type = 'New Business';
            opp.StageName = 'Top Opps';
            opp.Probability = 95;
            opp.Effective_Date__c = Date.Today();
            opp.CloseDate = Date.Today().addMonths(1);
            update opp;
        }

        return opp;
    }

    private Quote createQuote() {
        Pricebook2 standardPricebook = getStandardPricebook();
        Boolean isAnnualy = pkgLength == 'annualy';
        Boolean isImplDiscounted =
            product.AnnualDiscount__c == 'All' ||
            product.AnnualDiscount__c == 'Implementation Fee';
        Double discountedImplFee = product.ImplementationFee__c - (0.2 * product.ImplementationFee__c);
        Double implFee = product.ImplementationFee__c;
        Double grandTotal = isAnnualy && isImplDiscounted ? discountedImplFee : implFee;
        Boolean isSubsDiscounted =
            product.AnnualDiscount__c == 'All' ||
            product.AnnualDiscount__c == 'Subscription Fee';
        Double discountedSubsFee = product.MonthlyFee__c - (0.2 * product.MonthlyFee__c);
        Double subsFee = product.MonthlyFee__c;
        Double recurringFee = isAnnualy && isSubsDiscounted ? discountedSubsFee * 12 : subsFee;
        Double dueNow = (product.ImplementationDeposit__c / 100) * grandTotal;

        Quote quot = new Quote(
            OpportunityId = opp.Id,
            Name = 'Quote: ' + opp.Name,
            ContactId = opp.Primary_Contact__c,
            ExpirationDate = Date.Today().addMonths(1),
            Due_Date__c = Date.Today(),
            Effective_Date__c = Date.Today(),
            BillingName = opp.Primary_Contact__r.Name,
            Pricebook2Id = standardPricebook.Id,
            Grand_Total__c = grandTotal,
            One_Time_Payment__c = grandTotal,
            Monthly_Price__c = isAnnualy ? null : subsFee,
            AnnualyPayment__c = isAnnualy ? recurringFee : null,
            Phone = opp.Primary_Contact__r.Phone == null
                ? opp.Primary_Contact__r.MobilePhone
                : opp.Primary_Contact__r.Phone,
            Email = opp.Primary_Contact__r.Email,
            Due_Now__c = dueNow,
            Total_Paid_Amount__c = amountPaid,
            Status = 'Accepted',
            Invoice_URL__c = getReceiptUrl(),
            StripeChargeId__c = getChargeId()
        );
        insert quot;
        return quot;
    }

    private void createQuoteLineItem() {
        Map<Id, Id> productIdToPricebookEntryIdMap = getProductToPricebookEntryMap();
        insert new QuoteLineItem(
            Payment_Type__c = pkgLength.capitalize(),
            QuoteId = quot.Id,
            Quantity = 1,
            Product2Id = product.Id,
            PricebookEntryId = productIdToPricebookEntryIdMap.get(product.Id),
            UnitPrice = product.ImplementationFee__c
        );
    }

    private void sendEmail(String email, String emailSubject, String emailBody) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new List<String>{ email };
        message.setSenderDisplayName('Booking Ninjas');
        message.optOutPolicy = 'FILTER';
        message.subject = emailSubject;
        message.setHtmlBody(emailBody);
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }

    private Quote getQuote() {
        return [SELECT Id FROM Quote WHERE Id = :quoteId LIMIT 1];
    }

    private Contact getContact() {
        return [SELECT Id, AccountId FROM Contact WHERE Id = :contactId LIMIT 1];
    }

    private Pricebook2 getStandardPricebook() {
        return [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book'];
    }

    private Map<Id, Id> getProductToPricebookEntryMap() {
        Map<Id, Id> result = new Map<Id, Id>();
        for (PricebookEntry pbe : [
            SELECT Id, Product2Id
            FROM PricebookEntry
            WHERE IsActive = TRUE AND Pricebook2.Name = 'Standard Price Book'
        ]) {
            result.put(pbe.Product2Id, pbe.Id);
        }

        return result;
    }

    private Product2 getProduct() {
        return [
            SELECT Id, Name, Size__c, AnnualDiscount__c, ImplementationDeposit__c, ImplementationFee__c, MonthlyFee__c
            FROM Product2
            WHERE Hierarchy_Order__c = :Integer.valueOf(pkgOrder)
        ];
    }
}