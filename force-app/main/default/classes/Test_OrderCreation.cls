@isTest
public class Test_OrderCreation {
    @TestSetup
    static void testSetup() {
        Account accObj = new Account();
        accObj.FirstName= 'Test';
        accObj.LastName= 'Test';
        accObj.BillingCountry = 'Philippines';
        accObj.Continent__c = 'Asia';
        insert accObj;
        
        Contact Con = new Contact();
        Con.FirstName = 'Juan';
        Con.LastName = 'DC';
        Con.email='juandc14@gmail.com';
        Con.Card_Expiration_Month__c = '04';
        Con.Card_Expiration_Year__c = '2016';
        Con.Card_Number__c = '1213232323232';
        Con.Card_Security_Code__c = '143';
        Con.Card_Type__c = 'Visa';
        Con.MailingCountry = 'Philippines';
        Con.Continent__c = 'Asia';
        insert Con;
        
        
        
        //Product Item 1
        Product2 pObj1 = new Product2();
        pObj1.Name = 'Product 1';
        pObj1.Family = 'No. of Units';
        pObj1.IsActive = true;
        pObj1.Quantity__c = 1;
        pObj1.Product_Region__c = '(EN) English';
        insert pObj1;
        
        //Price Book Entry for Product Item 1
        PriceBookEntry pbeObj1 = new PriceBookEntry();
        pbeObj1.Pricebook2Id = Test.getStandardPricebookId();
        pbeObj1.UnitPrice = 500;
        pbeObj1.Product2Id = pObj1.Id;
        pbeObj1.IsActive = true;
        insert pbeObj1;
        
        //Product Item 2
        Product2 pObj2 = new Product2();
        pObj2.Name = 'Product 2';
        pObj2.Family = 'No. of Users';
        pObj2.IsActive = true;
        pObj2.Quantity__c = 10;
        pObj2.Product_Region__c = '(EN) English';
        insert pObj2;
        
        //Price Book Entry for Product Item 2
        PriceBookEntry pbeObj2 = new PriceBookEntry();
        pbeObj2.Pricebook2Id = Test.getStandardPricebookId();
        pbeObj2.UnitPrice = 65;
        pbeObj2.Product2Id = pObj2.Id;
        pbeObj2.IsActive = true;
        insert pbeObj2;
        
        //Product Item 3
        Product2 pObj3 = new Product2();
        pObj3.Name = 'Product 3';
        pObj3.Family = 'Integration';
        pObj3.IsActive = true;
        pObj3.Quantity__c = 1;
        pObj3.Product_Region__c = '(EN) English';
        insert pObj3;
        
        //Price Book Entry for Product Item 3
        PriceBookEntry pbeObj3 = new PriceBookEntry();
        pbeObj3.Pricebook2Id = Test.getStandardPricebookId();
        pbeObj3.UnitPrice = 500;
        pbeObj3.Product2Id = pObj3.Id;
        pbeObj3.IsActive = true;
        insert pbeObj3;
    
        //Opportunity
        Opportunity OppTest = new Opportunity();
        opptest.Name = 'TestOppName';
        OppTest.AccountId = accObj.Id;
        OppTest.Type = 'New Business';
        OppTest.CloseDate = Date.today();
        OppTest.StageName = 'Prospecting';
        OppTest.Primary_contact__c = con.id;
        OppTest.Product_Item_1__c = pObj1.Id;
        OppTest.Product_Item_2__c = pObj2.Id;
        OppTest.Product_Item_3__c = pObj3.Id;
        insert OppTest;
        
        //Opportunity Line Item
        OpportunityLineItem oliObj = new OpportunityLineItem();
        oliObj.opportunityid = opptest.id;
        oliObj.pricebookentryid = pbeObj1.id;
        oliObj.quantity = 1;
        oliObj.unitprice = 500;
        insert oliObj;
        
        //Quote
        Quote qObj = new Quote();
        qObj.Name = 'Test Quote';
        qObj.OpportunityId = OppTest.Id;
        qObj.ContactId = Con.Id;
        qObj.Pricebook2Id = Test.getStandardPricebookId();
        insert qObj;

        OppTest.SyncedQuoteId = qObj.Id;
        update OppTest;
    }
	@IsTest
    static void TestOrderCreation() {        
    	Opportunity OppTest = [select Id, Name, AccountId, Type, CloseDate, StageName, Primary_contact__c, Product_Item_2__c, Product_Item_3__c, Product_Item_1__c from Opportunity limit 1];
        Test.startTest();        
        
        OrderCreationController controller = new OrderCreationController(new ApexPages.StandardController(OppTest));
        controller.init();
        controller = new OrderCreationController(OppTest.Id);
        
        Test.stopTest();
		/*List<ChargentOrders__ChargentOrder__c> orderList = [Select id from ChargentOrders__ChargentOrder__c where Opportunity__c= :OppTest.id];
        Apexpages.currentPage().getParameters().put('id',orderList[0].id);
        OrderPaymentController cont = new OrderPaymentController();
        cont.redirectExpirationDate();  
        cont.getMonth();
        cont.getYear();
        cont.cancel();
        cont.save();
        cont.doPayment();
        cont.fetchCardDetails();*/
    }
}