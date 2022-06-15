@isTest
public class GenerateLeasdControllerTest {

    @testSetup
    static void setupTestData() {
        List<Lead> leads = new List<Lead>{
            new Lead(LastName = 'Lagman', FirstName = 'Danrien', Email = 'danrienl@bookingninjas.com'),
            new Lead(LastName = 'Harroch', FirstName = 'David', Email = 'david@bookingninjas.com')
        };
        insert leads;
    }
    
    @isTest
    static void testGenerateLead() {
        Test.startTest();
        
        GenerateLeadController ctrl = new GenerateLeadController();
        ctrl.firstName = 'Juan';
        ctrl.lastName = 'Dela Cruz';
        ctrl.email = 'juan@bookingninjas.com';
        ctrl.phone = '';
        ctrl.Company = '';
        ctrl.Position = '';
        ctrl.Save();
        
        Test.stopTest();
    }
    
    @isTest
    static void validateExistingLead() {
        Test.startTest();
        
        GenerateLeadController ctrl = new GenerateLeadController();
        ctrl.firstName = 'Juan';
        ctrl.lastName = 'Dela Cruz';
        ctrl.email = 'david@bookingninjas.com';
        ctrl.phone = '';
        ctrl.Company = '';
        ctrl.Position = '';
        ctrl.Save();
        
        Test.stopTest();
    }
}