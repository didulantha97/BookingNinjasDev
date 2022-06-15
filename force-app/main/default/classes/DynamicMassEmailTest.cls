@isTest
public class DynamicMassEmailTest
{
    @isTest
    private static void CreateDynamicMassEmailTest()
    {   
        DynamicMassEmail email = new DynamicMassEmail();
        
        //new account
        Account acc1 = new Account(Name='Danrien Miko Lagman', BillingCountry = 'Philippines', Continent__c = 'Asia');
        insert acc1;
        Account acc2 = new Account(FirstName='Danrien Miko', LastName='Lagman', PersonEmail='danrienl@bookingninjas.com', BillingCountry = 'Philippines', Continent__c = 'Asia');
        insert acc2;
        
        //new contact
        Contact cn1 = new Contact(FirstName='Danrien Miko',LastName='Lagman',Email='danrienl@corporaterentalsinc.com', AccountId=acc1.Id, MailingCountry = 'Philippines', Continent__c = 'Asia');
        insert cn1;
        Contact cn2 = new Contact(FirstName='David',LastName='Harroch',Email='dave@corporaterentalsinc.com', AccountId=acc1.Id, MailingCountry = 'Philippines', Continent__c = 'Asia');
        insert cn2;
        
        //new lead
        Lead lead = new Lead(FirstName='Danrien Miko',LastName='Lagman',Email='danrienlagman@gmail.com',Company='Booking Ninjas', Country = 'Philippines', Continent__c = 'Asia');
        insert lead;
        
        //new Video
        Video__c video = new Video__c(
            Name = 'Demo Video of the Week',
            Video_1_Title__c = 'Video 1',
            Video_1_Description__c = 'Test description',
            Video_1_Cover_Image__c = 'http://res.cloudinary.com/booking-ninjas/image/upload/v1469758034/sf-app/logo.png',
            Video_1_Url__c = 'http://www.bookingninjas.com/',
            Video_2_Title__c = 'Video 2',
            Video_2_Description__c = 'Test description',
            Video_2_Cover_Image__c = 'http://res.cloudinary.com/booking-ninjas/image/upload/v1469758034/sf-app/logo.png',
            Video_2_Url__c = 'http://www.bookingninjas.com/',
            Video_3_Title__c = 'Video 3',
            Video_3_Description__c = 'Test description',
            Video_3_Cover_Image__c = 'http://res.cloudinary.com/booking-ninjas/image/upload/v1469758034/sf-app/logo.png',
            Video_3_Url__c = 'http://www.bookingninjas.com/'
        );
        insert video;
        
        //Campaign
        Campaign campaign = new Campaign(Name='Sample Campaign v1', Video__c=video.Id, Email_Template_Name__c='Video of the Week Email Template', IsActive=true);
        insert campaign;
        
        //CampaignMembers as Contacts
        for(Contact con: [Select Id from Contact Where AccountId=:acc1.Id])
        {
            CampaignMember cm = new CampaignMember(CampaignId=campaign.Id, ContactId=con.Id, Status='Opt-In');
            insert cm;
        }
        
        //CampaignMembers as Leads
        for(Lead le: [Select Id from Lead Where Company=:lead.Company])
        {
            CampaignMember cm = new CampaignMember(CampaignId=campaign.Id, LeadId=le.Id, Status='Opt-In');
            insert cm;
        }
                   
        DynamicMassEmail.CreateDynamicMassEmail(campaign.Video__c, campaign.Id, campaign.Email_Template_Name__c);
    }
}