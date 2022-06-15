/**
 * @description       : 
 * @author            : 
 * @group             : 
 * @last modified on  : 12-13-2020
 * @last modified by  : teguh@bookingninjas.com
**/
@isTest()
public class BNES_RegisterController_Test {
    
    public static Account account;
    public static Contact contact;
    public static Opportunity opportunity;
    
    static 
    {
        createTestData();
    }
    
    public static void createTestData() 
    {
        account = new Account();
        account.Name =  'Booking Ninjas';
        insert account;
        
        contact = new Contact();
        contact.LastName = 'Harroch';
        contact.FirstName = 'David';
        contact.Email = 'testdavid@bookingninjas.com';
        contact.AccountId = account.Id;
        insert contact;
        
        opportunity = new Opportunity();
        opportunity.Name = 'New Opportunity';
        opportunity.AccountId = account.Id;
        opportunity.Primary_Contact__c = contact.Id;
        opportunity.Type = 'New Business';
        opportunity.StageName = 'Trial';
        opportunity.LeadSource = 'Booking Ninjas';
        opportunity.CloseDate = Date.Today().addDays(15);
        insert opportunity;
    }
    
    public static testMethod void testRegisterExistingContact() 
    {
        Contact con = [SELECT Email FROM Contact WHERE Email = 'testdavid@bookingninjas.com' LIMIT 1];
 
        BNES_RegisterController ctrl = new BNES_RegisterController();

        Test.startTest();
    
        ctrl.firstName = 'David';
        ctrl.lastName = 'Harroch';
        ctrl.businessName = 'Booking Ninjas';
        ctrl.email = 'testdavid@bookingninjas.com';
        ctrl.phone = '+191760023245';
        ctrl.register();
            
        Test.stopTest();
        
        System.AssertEquals(con.Email, 'testdavid@bookingninjas.com');
    }
    
    public static testMethod void testRegisterNewContact() 
    {
        BNES_RegisterController ctrl = new BNES_RegisterController();
        
        Test.startTest();
        
        ctrl.firstName = 'David';
        ctrl.lastName = 'Harroch';
        ctrl.businessName = 'Booking Ninjas';
        ctrl.email = 'davidtest@bookingninjas.com';
        ctrl.phone = '+191760023245';
        ctrl.register();
            
        Test.stopTest();
            
        Contact con = [SELECT Email FROM Contact WHERE Email = 'davidtest@bookingninjas.com' LIMIT 1];

        System.AssertEquals(con.Email, 'davidtest@bookingninjas.com');
    }
}