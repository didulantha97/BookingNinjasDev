@isTest
public with sharing class BN_GuestPostController_Test {
    
    public static Lead lead;
    
    static { createTestData(); }
    
    public static void createTestData() 
    {
        lead = new Lead();
        lead.LastName = 'Harroch';
        lead.FirstName = 'David';
        lead.Email = 'david@bookingninjas.com';
        lead.LeadSource = 'Guest Post';
        insert lead;
    }
    
    public static testMethod void testSubmit() 
    {
        Test.startTest();
        
        PageReference pageRef = Page.BN_GuestPost;
        Test.setCurrentPage(pageRef);

        BN_GuestPostController ctrl = new BN_GuestPostController();
        
        ctrl.name = 'Joe Johnson';
        ctrl.email = 'joe@email.com';
        ctrl.pitchIdea = 'Test';
        ctrl.message = 'Test';
        
        ctrl.fileBody = Blob.valueof('Some random String');
        ctrl.fileName = 'File Name';
        ctrl.contentType = 'application/pdf';
        
        ctrl.submit();
        
        
        Test.stopTest();
    }
}