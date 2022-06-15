public without sharing class BNES_PricingController {
   
    public static List<ProductWrapper> getProducts() {
        List<Product2> products = [
            SELECT
                Id,
                Name,
                AnnualDiscount__c,
                Features__c,
                ImplementationDeposit__c,
                ImplementationFee__c,
                MonthlyFee__c,
                Size__c,
                Hierarchy_Order__c
            FROM Product2
            WHERE Expose_on_site__c = TRUE AND IsActive = TRUE AND Product_Region__c = '(ES) Spain' AND Type__c = 'Web'
            ORDER BY Hierarchy_Order__c ASC
        ];

        List<ProductWrapper> wrappers = new List<ProductWrapper>();
        Integer idx = 0;
        for (Product2 product : products) {
            ProductWrapper wrapper = new ProductWrapper(product, idx == 0);
            wrappers.add(wrapper);
            idx += 1;
        }
        return wrappers;
    }

    //To Use Multi currency on layout
    public static List<CurrencyWrapper> getCurrency(){
        
        List<CurrencyWrapper> currencyWrapperList = new List<CurrencyWrapper>();
        
        for(CurrencyType__c sym : [SELECT Name, ISOCode__c, Symbol__c, ConversionRate__c  FROM CurrencyType__c WHERE IsActive__c=:TRUE ORDER BY ConversionRate__c DESC]){
            CurrencyWrapper cw = new CurrencyWrapper();
            cw.cname = sym.Name;
            cw.code = sym.ISOCode__c;
            cw.symbol = sym.Symbol__c;
            cw.rate = sym.ConversionRate__c;
            currencyWrapperList.add(cw);
        }
        return currencyWrapperList;

    }

    public class ProductWrapper {
        public String id { get; set; }
        public String name { get; set; }
        public String annualDiscount { get; set; }
        public Integer implementationDeposit { get; set; }
        public Integer implementationFee { get; set; }
        public Integer implementationFeeAfterDiscount { get; set; }
        public Integer monthlyFee { get; set; }
        public Integer monthlyFeeAfterDiscount { get; set; }
        public String size { get; set; }
        public Boolean primary { get; set; }
        public Integer order { get; set; }
        public List<ProductFeatureWrapper> features { get; set; }
        
        public ProductWrapper(Product2 product, Boolean isPrimary) {
            this.id = product.Id;
            this.name = product.Name;
            this.annualDiscount = product.AnnualDiscount__c;
            this.implementationDeposit = Integer.valueOf(product.ImplementationDeposit__c);
            this.implementationFee = Integer.valueOf(product.ImplementationFee__c);
            Boolean implDiscounted = this.annualDiscount == 'All' || this.annualDiscount == 'Implementation Fee';
            this.implementationFeeAfterDiscount = implDiscounted
                ? Integer.valueOf(this.implementationFee - (0.2 * this.implementationFee))
                : this.implementationFee;
            this.monthlyFee = Integer.valueOf(product.MonthlyFee__c);
            Boolean subsDiscounted = this.annualDiscount == 'All' || this.annualDiscount == 'Subscription Fee';
            this.monthlyFeeAfterDiscount = subsDiscounted
                ? Integer.valueOf(this.monthlyFee - (0.2 * this.monthlyFee))
                : this.monthlyFee;
            this.size = product.Size__c;
            this.primary = isPrimary;
            this.order = Integer.valueOf(product.Hierarchy_Order__c);
            this.features = new List<ProductFeatureWrapper>();
            for (String feature : product.Features__c.split(';')) {
                ProductFeatureWrapper wrapper = new ProductFeatureWrapper();
                wrapper.name = feature;
                wrapper.description = featureMap().get(feature);
                this.features.add(wrapper);
            }
        }

        private Map<String, String> featureMap() {
            Map<String, String> featuresMap = new Map<String, String>();
            for (Schema.PicklistEntry ple : Schema.SObjectType.Product2.fields.Features__c.getPicklistValues()) {
                featuresMap.put(ple.getValue(), ple.getLabel());
            }
            return featuresMap;
        }
    }

    public class ProductFeatureWrapper {
        public String name { get; set; }
        public String description { get; set; }
    }

    //Use Multi currency
    public class CurrencyWrapper {
        public String cname { get; set; }
        public String code { get; set; }
        public String symbol { get; set; }
        public Decimal rate { get; set; }
    }

}