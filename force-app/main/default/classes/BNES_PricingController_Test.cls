@isTest
public with sharing class BNES_PricingController_Test {
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
                Product_Region__c = '(ES) Spain'
            )
        );
        insert newProductList;
    }

    @isTest
    static void getProductsTest() {
        Test.startTest();
        List<BNES_PricingController.ProductWrapper> products = BNES_PricingController.getProducts();
        Test.stopTest();
    }

    @isTest
    static void getCurrenciesTest() {
        Test.startTest();
        List<BN_PricingController.CurrencyWrapper> ps = BN_PricingController.getCurrency();
        Test.stopTest();
    }
}