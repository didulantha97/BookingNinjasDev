@isTest()
public class BN_RegisterController_Test {
    @isTest static void testGetCheckoutSession() {
        BN_RegisterController rc = new BN_RegisterController();

        Test.startTest();
        rc.firstName = 'Teguh';
        rc.lastName = 'Teguh';
        rc.email = 'teguh@bookingninjas.com';
        rc.phone = '+6281222290905';
        rc.businessName = 'Booking Ninjas';
        Test.stopTest();

    }
}