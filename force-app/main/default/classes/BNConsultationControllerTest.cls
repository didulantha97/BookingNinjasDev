@isTest
public class BNConsultationControllerTest {

    @testSetup
    static void setupTestData() {
        List<Lead> leads = new List<Lead>{
            new Lead(LastName = 'Lagman', FirstName = 'Danrien', Email = 'danrienl@bookingninjas.com', Phone = '+639171591414'),
            new Lead(LastName = 'Harroch', FirstName = 'David', Email = 'david@bookingninjas.com', Phone = '+19176002345')
        };
        insert leads;
    }
    
    @isTest
    static void testGenerateLead() {
        Test.startTest();
        
        BNConsultationController ctrl = new BNConsultationController();
        ctrl.name = 'Joe Johnson';
        ctrl.phone = '+13051111111';
        ctrl.company = 'Company A';
        ctrl.numberOfRooms = '20';
        ctrl.currentPMS = 'Software A';
        ctrl.email = 'joe@bookingninjas.com';
        ctrl.selectedDate = '03/30/2019';
        ctrl.message = 'test message';
        ctrl.SaveWithRedirect();
        //ctrl.SaveWithoutRedirect();
        ctrl.Subscribe();
        
        Test.stopTest();
    }
    
    @isTest
    static void validateExistingLead() {
        Test.startTest();
        
        BNConsultationController ctrl = new BNConsultationController();
        ctrl.name = 'Uncle Sam';
        ctrl.phone = '+3052222222';
        ctrl.company = '';
        ctrl.numberOfRooms = '';
        ctrl.currentPMS = '';
        ctrl.email= 'sam@bookingninjas.com';
        ctrl.selectedDate = '';
        ctrl.message = '';
        //ctrl.SaveWithRedirect();
        ctrl.SaveWithoutRedirect();
        ctrl.Subscribe();
        
        Test.stopTest();
    }
}