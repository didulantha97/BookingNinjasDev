@isTest
public class BN_PricingController_Test {
    @testSetup
    static void setup() {
        List<Product2> newProductList = new List<Product2>();
        newProductList.add(
            new Product2(
                Name = 'test1',
                AnnualDiscount__c = 'Implementation Fee',
                Features__c = 'Guest Management',
                ImplementationDeposit__c = 50,
                ImplementationFee__c = 500,
                MonthlyFee__c = 125,
                Size__c = '5-50',
                Hierarchy_Order__c = 1,
                Expose_on_site__c = true,
                IsActive = true,
                Type__c = 'Web',
                Product_Region__c = '(EN) English'
            )
        );
        insert newProductList;
        
        CurrencyType__c cs = new CurrencyType__c();
        cs.Name = 'Test Currency';
        cs.ConversionRate__c = 379.00;
        cs.ISOCode__c = 'TSO';
        cs.IsActive__c = true;
        cs.Symbol__c = '$';
        
        insert cs;
    }

    @isTest
    static void getProductsTest() {
        Test.startTest();
        List<BN_PricingController.ProductWrapper> products = BN_PricingController.getProducts();
        Test.stopTest();
    }
    
    @isTest
    static void getCurrenciesTest() {
        Test.startTest();
        List<BN_PricingController.CurrencyWrapper> ps = BN_PricingController.getCurrency();
        Test.stopTest();
    }
    
}