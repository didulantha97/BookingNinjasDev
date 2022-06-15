@isTest
public class BN_DataTest {

    public static void deleteDataTest() { 
        DELETE [SELECT Id FROM Account];
        DELETE [SELECT Id FROM Contact];
        DELETE [SELECT Id FROM Lead];
        DELETE [SELECT Id FROM Opportunity];
        
        DELETE [SELECT Id FROM Product2];
        DELETE [SELECT Id FROM PriceBook2];
        DELETE [SELECT Id FROM PriceBookEntry];
        DELETE [SELECT Id FROM Stripe_Transaction__c];
        DELETE [SELECT Id FROM Career__c];
        DELETE [SELECT Id FROM Article__c];
        DELETE [SELECT Id FROM Article_Comment__c];
        DELETE [SELECT Id FROM PreActivation__c];
        DELETE [SELECT Id FROM Wait_List__c];
        DELETE [SELECT Id FROM Card__c];
        DELETE [SELECT Id FROM Check__c];
        DELETE [SELECT Id FROM Email_Subscription__c];
        
        DELETE [SELECT Id FROM BN_User__c];
        DELETE [SELECT Id FROM BN_User_History_Login__c];
        DELETE [SELECT Id FROM Ticket__c];
    }
    
    public static void createDataTest(Boolean isForPortal, Boolean isForWebsite) {
    
        DateTime dt = System.today();
        
        PriceBook2 pb = new PriceBook2();
        pb.Name = 'PriceBook';
        pb.IsActive = true;
        insert pb;
        
        Product2 product = new Product2();
        product.Name = 'Service';
        product.Description = 'Service description';
        product.Product_Region__c = '(EN) English';
        insert product;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PriceBookEntry pbe = new PriceBookEntry();
        pbe.Pricebook2Id = pricebookId;
        pbe.Product2Id = product.Id;
        pbe.IsActive = true;
        pbe.UnitPrice = 100;
        //pbe.StandardPrice = 100;
        insert pbe;
        
        Account account = new Account();
        account.Name =  'Booking Ninjas';
        insert account;
        
        Contact contact = new Contact();
        contact.LastName = 'Harroch';
        contact.FirstName = 'David';
        contact.Email = 'testdavid@bookingninjas.com';
        contact.AccountId = account.Id;
        insert contact;

        Lead lead = new Lead();
        lead.LastName = 'Harroch';
        lead.Email = 'david@bookingninjas.com';
        lead.Phone = '+19176002345';
        lead.MobilePhone = '+19176002345';
        lead.Company = 'Booking Ninjas';
        lead.Property_Name__c = 'Hotel BN';
        lead.Meeting_Date__c = Date.Today();
        lead.Meeting_Time__c  =  Time.newInstance(dt.hour(), dt.minute(), dt.second(), dt.millisecond());
        lead.LeadSource = 'Consulting';
        insert lead;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'New Opportunity';
        opportunity.AccountId = account.Id;
        opportunity.Primary_Contact__c = contact.Id;
        opportunity.Type = 'New Business';
        opportunity.StageName = 'Trial';
        opportunity.LeadSource = 'Booking Ninjas';
        opportunity.CloseDate = Date.Today().addDays(15);
        opportunity.PMS_Text__c =  'Test message';
        insert opportunity;
        
        if(isForWebsite)
        {       
            Card__c card = new Card__c();
            card.Contact__c = contact.Id;
            card.Card_Holder__c = contact.FirstName + ' ' +  contact.LastName;
            card.Card_Number__c = '4242424242424242';
            card.Security_Code__c = '123';
            card.Expiration_Date__c = Date.Today().AddYears(3);
            insert card;
            
            Check__c check = new Check__c();
            check.Contact__c = contact.Id;
            check.Name__c = contact.FirstName + ' ' +  contact.LastName;
            check.Bank_Routing_Number__c  = '123456789';
            check.Checking_Account_Number__c = '123456789';
            check.Issuing_Bank__c = 'Bank of America';
            insert check;
            
            Stripe_Transaction__c st = new Stripe_Transaction__c();
            st.Guest_Contact__c = contact.Id;
            st.Total_Amount__c = 100;
            st.Status__c = 'Succeeded';
            insert st;
        
            PreActivation__c preActivation = new PreActivation__c();
            preActivation.Contact1_Name__c = 'Test1Name';
            preActivation.Contact1_Email__c = 'test1@email.com';
            preActivation.Contact1_Phone__c = '123456789';
            preActivation.Contact2_Name__c = 'Test2Name';
            preActivation.Contact2_Email__c = 'test2@email.com';
            preActivation.Contact2_Phone__c = '123456789';
            preActivation.Contact3_Name__c = 'Test3Name';
            preActivation.Contact3_Email__c = 'test3@email.com';
            preActivation.Contact3_Phone__c = '123456789';
            preActivation.Number_of_units__c = 50;
            preActivation.Number_of_users__c = 10;
            preActivation.Property_Address__c = 'Miami Beach, Florida';
            preActivation.Property_Address_2__c = 'Miami Beach, Florida';
            preActivation.Property_Address_3__c = 'Miami Beach, Florida';
            preActivation.PMS_Requirements__c = 'Test Message';
            preActivation.Questions_about_product__c = 'Test Message';
            insert preActivation;
            
            Wait_List__c waitList = new Wait_List__c();
            waitList.Name__c = 'David Harroch';
            waitList.Email__c = 'david@bookingninjas.com';
            waitList.Phone__c = '+19176002345';
            waitList.Preferred_Contact_Method__c = 'Email Only';
            waitList.Opt_in_to_SMS_System__c = false;
            waitList.Availability_Date__c = Date.Today().addDays(15);
            insert waitList;
            
            List<Article__c> articles = new List<Article__c>{
                new Article__c(Name = 'Test Article 1', Category__c = 'Article', Tags__c = 'Hotel,Hospitality,PMS', Cover_Photo__c = 'https://s3.us-east-2.amazonaws.com/bnsrc/img/Blog_article-img.jpg', HTML_Content__c = 'Test Article 1', Is_Main_Article__c = true, Publish__c = true, Meta_Title__c = 'Article Title', Meta_Description__c = 'Article Desc'),
                new Article__c(Name = 'Test Article 2', Category__c = 'Article', Tags__c = 'Hotel,Hospitality,PMS', Cover_Photo__c = 'https://s3.us-east-2.amazonaws.com/bnsrc/img/Blog_article-img.jpg', HTML_Content__c = 'Test Article 2', Is_Main_Article__c = false, Publish__c = true, Meta_Title__c = 'Article Title', Meta_Description__c = 'Article Desc'),
                new Article__c(Name = 'Test Article 3', Category__c = 'Article', Tags__c = 'Hotel,Hospitality,PMS', Cover_Photo__c = 'https://s3.us-east-2.amazonaws.com/bnsrc/img/Blog_article-img.jpg', HTML_Content__c = 'Test Article 3', Is_Main_Article__c = false, Publish__c = true, Meta_Title__c = 'Article Title', Meta_Description__c = 'Article Desc'),
                new Article__c(Name = 'Test Article 4', Category__c = 'Trending', Tags__c = 'Hotel,Hospitality,PMS', Cover_Photo__c = 'https://s3.us-east-2.amazonaws.com/bnsrc/img/Blog_article-img.jpg', HTML_Content__c = 'Test Article 4', Is_Main_Article__c = false, Publish__c = true, Meta_Title__c = 'Article Title', Meta_Description__c = 'Article Desc'),
                new Article__c(Name = 'Test Article 5', Category__c = 'Trending', Tags__c = 'Hotel,Hospitality,PMS', Cover_Photo__c = 'https://s3.us-east-2.amazonaws.com/bnsrc/img/Blog_article-img.jpg', HTML_Content__c = 'Test Article 5', Is_Main_Article__c = false, Publish__c = true, Meta_Title__c = 'Article Title', Meta_Description__c = 'Article Desc')
            };
            insert articles;
        
            List<Article_Comment__c> comments = new List<Article_Comment__c>{
                new Article_Comment__c(Article__c = articles[0].Id, IP_Address__c = '192.168.1.1', Name__c = 'Dan', Content__c = 'Test comment'),
                new Article_Comment__c(Article__c = articles[0].Id, IP_Address__c = '192.168.1.2', Name__c = 'Dan', Content__c = 'Test comment'),
                new Article_Comment__c(Article__c = articles[2].Id, IP_Address__c = '192.168.1.3', Name__c = 'Dan', Content__c = 'Test comment'),
                new Article_Comment__c(Article__c = articles[0].Id, IP_Address__c = '192.168.1.4', Name__c = 'Dan', Content__c = 'Test comment'),
                new Article_Comment__c(Article__c = articles[0].Id, IP_Address__c = '192.168.1.5', Name__c = 'Dan', Content__c = 'Test comment')
            };
            insert comments;
        }
        
        if(isForPortal)
        {
            // Partner user
            BN_User__c bnPartner = new BN_User__c(Contact__c = contact.Id, Email__c = 'david@bookingninjas.com', Username__c = 'partner', Password__c = '123', Status__c = 'Active', Role__c = 'Partner');
            insert bnPartner;
    
            // Client user
            BN_User__c bnActiveClient = new BN_User__c(Contact__c = contact.Id, Email__c = 'david@bookingninjas.com', Username__c = 'client1', Password__c = '123', Status__c = 'Active', Role__c = 'Client');
            insert bnActiveClient;
            
            BN_User__c bnInactiveClient = new BN_User__c(Contact__c = contact.Id, Email__c = 'david@bookingninjas.com', Username__c = 'client2', Password__c = '123', Status__c = 'Inactive', Role__c = 'Client');
            insert bnInactiveClient;
            
            // Login History 
            BN_User_History_Login__c login = new BN_User_History_Login__c(BN_User__c = bnActiveClient.Id, isLogout__c = true, Status__c = 'Success');
            insert login;
            
            BN_User_History_Login__c logout = new BN_User_History_Login__c(BN_User__c = bnActiveClient.Id, isLogout__c = false, Status__c = 'Success');
            insert logout;
            
            // Services
            Service__c service =  new Service__c(Contact__c = contact.Id, Service_Request__c = 'Test Service', Price__c = 1, Quantity__c = 1);
            insert service;
            
            // Users
            User__c user = new User__c(Contact__c = contact.Id, Name__c = 'David', Email__c = 'david@email.com', Phone__c = '19176002345', Date_of_Activation__c = Date.Today().addDays(7));
            insert user;

            Ticket__c ticket = new Ticket__c(Name__c = 'Test', Email__c = 'test@email.com', Phone__c = '123456789', Message__c = 'Test message', Status__c = 'Open');
            insert ticket;
        }
    }
}