/*****************************************************************************************
 * @Purpose      : Test class for StrieService class
 * @Created Date : 20 August 2019
 * @Author       : Madhura Priyadarshana 
 *****************************************************************************************/
@isTest
private class StripeServiceTest {

    @isTest
    static void testCustomerCreation() {
        StripeService service = new StripeService();  // calling the constructor
        Test.setMock(System.HttpCalloutMock.class, new MockHttpResponseGenerator());
        HttpResponse respCustomer = StripeService.createCustomer('description', 'abc@email.com');
        System.assert(respCustomer != null);
    }
    
    @isTest
    static void testChargeByCustomer() {
        Test.setMock(System.HttpCalloutMock.class, new MockHttpResponseGenerator());
        HttpResponse respChargeByCustomer = StripeService.chargeByCustomer('3200', 'description', 'customerStripeId');        
        System.assert(respChargeByCustomer != null);
    }
    
    @isTest
    static void testChargeByCard() {
        Test.setMock(System.HttpCalloutMock.class, new MockHttpResponseGenerator());
        HttpResponse respChargeByCard = StripeService.chargeByCard('2500', 'description', 'sf_dsf3$to345ke545n'); 
        System.assert(respChargeByCard != null);
    }
    
    @isTest
    static void testCardTokenCreation() {
        Test.setMock(System.HttpCalloutMock.class, new MockHttpResponseGenerator());
        String token = StripeService.createCardToken('250032343243', '03', '12', '145');        
        System.assert(String.isNotBlank(token));
    }
     
     @isTest
    static void testRefund() {
        Test.setMock(System.HttpCalloutMock.class, new MockHttpResponseGenerator());
        HttpResponse resp = StripeService.getRefund('ch_1EpZcpLJXa2cEwUA312DoOLM',  1);        
        System.assert(resp != null);
    }   
}