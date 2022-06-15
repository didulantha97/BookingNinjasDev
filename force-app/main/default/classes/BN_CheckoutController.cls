public class BN_CheckoutController {
    public String title { get; set; }
    public String description { get; set; }
    public String page { get; set; }
    public String ogImage { get; set; }
    public String structuredData { get; set; }
    public String pkgLength { get; set; }
    public String pkgCurrencyName { get; set; }
    public String pkgCurrencySymbol { get; set; }
    public String pkgOrder { get; set; }
    public Boolean forbidden { get; set; }
    public String quoteId { get; set; }
    private Quote quot { get; set; }

    // Form data
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String businessName { get; set; }
    public String email { get; set; }
    public String phone { get; set; }

    // currency conversion
    private final Double usdGBP = 0.74964848;
    private final Double usdEUR = 0.88347145;
    private final Double usdBRL = 5.6100994;
    private Boolean isGBP { get; set; }
    private Boolean isEUR { get; set; }
    private Boolean isBRL { get; set; }

    String pkgSize;

    public BN_CheckoutController() {
        title = 'Checkout | Booking Ninjas';
        description = 'Booking Ninjas checkout page.';
        page = ApexPages.currentPage().getUrl().substringAfter('/').split('\\?')[0];
        ogImage = 'https://s3.us-west-2.amazonaws.com/www.bookingninjas.com/img/booking-ninjas.png';
        quoteId = ApexPages.currentPage().getParameters().get('id');
        quot = getQuote();
        if (quot != null) {
            firstName = quot.Contact.FirstName;
            lastName = quot.Contact.LastName;
            businessName = quot.Account.Name;
            email = quot.Contact.Email;
            phone = quot.Contact.Phone;
        }

        pkgOrder = ApexPages.currentPage().getParameters().get('order');
        forbidden = pkgOrder == null;
        pkgLength = ApexPages.currentPage().getParameters().get('length');
        pkgLength = pkgLength == null ? 'monthly' : pkgLength;
        pkgCurrencyName = ApexPages.currentPage().getParameters().get('currency');
        pkgCurrencyName = pkgCurrencyName != null ? pkgCurrencyName : 'usd';
        isGBP = pkgCurrencyName == 'gbp';
        isEUR = pkgCurrencyName == 'eur';
        isBRL = pkgCurrencyName == 'brl';
        pkgCurrencySymbol = isGBP ? '£' : isEUR ? '€' : isBRL ? 'R$' : '$';
    }

    public pageReference redirectAction() {
        if (forbidden) {
            pageReference pg = new pageReference('/pricing');
            return pg.setRedirect(true);
        }
        return null;
    }

    public PackageWrapper getPackage() {
        Product2 product = [
            SELECT Id, Name, Size__c, AnnualDiscount__c, Hierarchy_Order__c, ImplementationDeposit__c, ImplementationFee__c, MonthlyFee__c
            FROM Product2
            WHERE Hierarchy_Order__c = :Integer.valueOf(pkgOrder)
        ];
        return new PackageWrapper(product, pkgLength, pkgCurrencyName);
    }

    public List<PackageWrapper> getAllPackages() {
        List<Product2> products = [
            SELECT Id, Name, Size__c, AnnualDiscount__c, Hierarchy_Order__c, ImplementationDeposit__c, ImplementationFee__c, MonthlyFee__c
            FROM Product2
            WHERE Hierarchy_Order__c != NULL AND IsActive = TRUE AND Product_Region__c LIKE '(%'
            ORDER BY Hierarchy_Order__c
        ];
        List<PackageWrapper> productsWrapper = new List<PackageWrapper>();
        for (Product2 product : products) {
            productsWrapper.add(new PackageWrapper(product, pkgLength, pkgCurrencyName));
        }
        return productsWrapper;
    }

    public List<SelectOption> getAvailablePackages() {
        List<PackageWrapper> products = getAllPackages();
        List<String> args = new List<String>{ '0', 'number', '#,##0.00' };
        List<SelectOption> options = new List<SelectOption>();
        for (PackageWrapper product : products) {
            options.add(
                new SelectOption(
                    String.valueOf(product.order),
                    product.name + ' (' + pkgCurrencySymbol + formatMoney(String.format(product.depositTotal.format(), args)) + ' Implementation Fee)'
                )
            );
        }
        return options;
    }

    public String getPkgOrder() {
        return pkgOrder;
    }

    public void setPkgOrder(String pkgOrder) {
        this.pkgOrder = pkgOrder;
    }

    public class PackageWrapper {
        public Boolean implDiscounted { get; set; }
        public Boolean subsDiscounted { get; set; }
        public Double depositPercentage { get; set; }
        public Double depositReminder { get; set; }
        public Double depositSplit { get; set; }
        public Double depositTotal { get; set; }
        public Double monthlyAmount { get; set; }
        public Integer depositSplitRounded { get; set; }
        public Integer order { get; set; }
        public String id { get; set; }
        public String name { get; set; }
        public String size { get; set; }                                                                                                         

        public PackageWrapper(Product2 product, String pkgLength, String pkgCurrencyName) {
            Double usdGBP = 0.74964848;
            Double usdEUR = 0.88347145;
            Double usdBRL = 5.6100994;
            Boolean isGBP = pkgCurrencyName == 'gbp';
            Boolean isEUR = pkgCurrencyName == 'eur';
            Boolean isBRL = pkgCurrencyName == 'brl';

            this.id = product.Id;
            this.name = product.Name;
            this.size = product.Size__c;
            this.order = Integer.valueOf(product.Hierarchy_Order__c);
            this.depositPercentage = product.ImplementationDeposit__c;
            String annualDiscount = product.AnnualDiscount__c;
            this.implDiscounted =
                pkgLength == 'annualy' && (annualDiscount == 'All' || annualDiscount == 'Implementation Fee');
            Double implFee = product.ImplementationFee__c;
            this.depositTotal = isGBP
                ? implFee * usdGBP
                : isEUR ? implFee * usdEUR : isBRL ? implFee * usdBRL : implFee;
            this.depositTotal = this.implDiscounted ? this.depositTotal - (this.depositTotal * 0.2) : this.depositTotal;
            Decimal depositNow = Decimal.valueOf((this.depositPercentage / 100) * this.depositTotal).setScale(2);
            this.depositSplit = Double.valueOf(depositNow);
            this.depositSplitRounded = Integer.valueOf(this.depositSplit);
            this.depositReminder = this.depositTotal - this.depositSplit;
            this.subsDiscounted =
                pkgLength == 'annualy' && (annualDiscount == 'All' || annualDiscount == 'Subscription Fee');
            Double subsFee = product.MonthlyFee__c;
            this.monthlyAmount = isGBP
                ? subsFee * usdGBP
                : isEUR ? subsFee * usdEUR : isBRL ? subsFee * usdBRL : subsFee;
            this.monthlyAmount = this.subsDiscounted
                ? (this.monthlyAmount - (this.monthlyAmount * 0.2)) * 12
                : this.monthlyAmount;
        }
    }

    private Quote getQuote() {
        List<Quote> quotes = [
            SELECT Account.Name, Contact.FirstName, Contact.LastName, Contact.Email, Contact.Phone
            FROM Quote
            WHERE Id = :quoteId
        ];

        if (quotes.size() == 1) {
            return quotes[0];
        }
        return null;
    }

    private String formatMoney(String s) {
        if (!s.contains('.')) {
            s = s + '.00';
        } else {
            Integer dPos = s.indexOf('.');
            if (s.length() - dPos < 3) {
                s = s + '0';
            }
        }
        return s;
    }
}