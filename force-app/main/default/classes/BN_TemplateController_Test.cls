@isTest()
public class BN_TemplateController_Test {

    public static String[] pages = new List<String>();
    
    public static Email_Subscription__c subscription;
    
    
    static 
    {
        createTestData();
    }
    
    public static void createTestData() 
    {
        subscription= new Email_Subscription__c();
        subscription.Email__c  = 'david@bookingninjas.com';
        insert subscription;
    }
    
    public static testMethod void testSubscribe() 
    {
        Test.startTest();
        
            PageReference pageRef = Page.BN_LP_Club;
            Test.setCurrentPage(pageRef);

            BN_EmailSubscribeController ctrl = new BN_EmailSubscribeController();
            
            ctrl.email = 'joee@johnson.com';
            ctrl.subscribe(); 
            
        Test.stopTest();
    }
    
    public static testMethod void testSend404Message() 
    {
        Test.startTest();
        
            PageReference pageRef = Page.BN_404;
            Test.setCurrentPage(pageRef);

            BN_TemplateController ctrl = new BN_TemplateController();
            
            ctrl.send404Message(); 
            
        Test.stopTest();
    }
    
    static testMethod void testPageTitle() { 
    
        pages.add('/about-us');
        pages.add('/advantages-of-our-property-management-system');
        pages.add('/einstein-analytics-integration'); 
        pages.add('/blog'); 
        pages.add('/core-values-of-booking-ninjas-product'); 
        pages.add('/automatic-data-processing-system'); 
        pages.add('/einstein-form'); 
        pages.add('/faqs'); 
        pages.add('/booking-ninjas-pms-case-studies'); 
        pages.add('/gdpr-compliance'); 
        pages.add('/pms-implementation'); 
        pages.add('/industrial-revolution'); 
        pages.add('/pms-integration'); 
        pages.add('/myths'); 
        pages.add('/buying-process'); 
        pages.add('/pagesoupages'); 
        pages.add('/solutions-for-property-management'); 
        pages.add('/time-to-think'); 
        pages.add('/features'); 
        pages.add('/why');
        pages.add('/14-day-free-trial');
        pages.add('/thank-you');
        pages.add('/about-us');
        pages.add('/booking-ninjas-careers');
        pages.add('/schedule-an-appointment');
        pages.add('/customer-stories'); 
        pages.add('/customer-stories/hftp-south-florida');
        pages.add('/customer-stories/cty-books');
        pages.add('/customer-stories/industrious-office'); 
        pages.add('/rate-my-pms');
        pages.add('/salesforce-consulting-services');
        pages.add('/pms-software');
        pages.add('/country-club-management-software');
        pages.add('/coworking-space-management-software');
        pages.add('/storage-management');
        pages.add('/compare-property-management-software');
        pages.add('/capabilities-of-booking-ninjas-product');
        pages.add('/student-housing-property-management-software');
        pages.add('/hostel-management-software');
        pages.add('/hotel-property-management-software');
        pages.add('/software-for-property-managers');
        pages.add('/restaurant-management-software');
        pages.add('/parking-management-system');
        pages.add('/event-management-software');
        pages.add('/senior-living-property-management-software');
        pages.add('/vacation-rental-property-management-software');
        pages.add('/villas-property-management-software');
        pages.add('/government-property-management-software');
        pages.add('/one-platform-for-all-property-operations');
        pages.add('/consultation-form');
        pages.add('/expression-of-interest');
        pages.add('/thank-you-for-expressing-your-interest');
        pages.add('/career-application');
        pages.add('/third-party-hotel-booking-sites-integration');
        pages.add('/leave-your-feedback');
        pages.add('/covid-19');
        pages.add('/contact-us');
        pages.add('/pre-activation-form');
        pages.add('/wait-list');
        pages.add('/booking-ninjas-webinars');
        pages.add('/booking-ninjas-webinars/intro-to-booking-ninjas');
        pages.add('/booking-ninjas-webinars/the-features-of-booking-ninjas');
        pages.add('/booking-ninjas-webinars/booking-ninjas-use-cases');
        pages.add('/booking-ninjas-webinars/the-salesforce-connection');
        pages.add('/booking-ninjas-webinars/integrations');
        pages.add('/booking-ninjas-webinars/feature-spotlight');
        pages.add('/partners');
        pages.add('/partners/hftp');
        pages.add('/partners/salesforce');
        pages.add('/partners/channelrush');
        pages.add('/partners/twilio');
        pages.add('/partners/yieldplanet');
        pages.add('/partners/esign-genie');
        pages.add('/partners/latino-hotel-association');
        pages.add('/partners/nabhood');
        pages.add('/tour/advance-payment-features');
        pages.add('/tour/reservation-management-system');
        pages.add('/tour/hotel-booking-engine');
        pages.add('/tour/hotel-channel-manager');
        pages.add('/tour/custom-reporting-software');
        pages.add('/tour/einstein-analytics');
        pages.add('/tour/electronic-signature-software');
        pages.add('/tour/pms-mobile-apps');
        pages.add('/tour/point-of-sales-software');
        pages.add('/tour/room-booking-software');
        pages.add('/tour/event-ticketing-system');
        pages.add('/tour/twilio-flex-integrations');
        pages.add('/tour/hotel-door-access-control-system');
        pages.add('/tour/salesforce-appexchange-integration');
        pages.add('/careers/salesforce-admins');
        pages.add('/careers/salesforce-developers');
        pages.add('/careers/front-end-designers');
        pages.add('/careers/content-writers');
        pages.add('/careers/script-writers');
        pages.add('/careers/designers');
        pages.add('/careers/growth-hackers');
        pages.add('/careers/project-managers');
        pages.add('/careers/account-executives');
        pages.add('/careers/customer-service-representatives');
        pages.add('/careers/mobile-developers');
        pages.add('/careers/social-media-ninjas');
        pages.add('/careers/seo-ninjas');
        pages.add('/surveys');
        pages.add('/surveys/rate-my-pms');
        pages.add('/surveys/hotel-industry');
        pages.add('/surveys/covid-19');
        pages.add('/surveys/general-hospitality');
        
        Test.startTest();
            
            for(String page : pages)
            {
                PageReference pageRef = new PageReference(page);
                Test.setCurrentPage(pageRef);
                
                BN_TemplateController ctrl = new BN_TemplateController();
                String pageName = ApexPages.currentPage().getUrl().substringAfter('/').split('\\?')[0];
                ctrl.page = pageName;
                ctrl.amp = 'https://bnamp.s3.us-east-2.amazonaws.com/index.html';
                ctrl.title = 'Best Hotel Management Software - Cloud-Based PMS | Booking Ninjas';
                ctrl.description = 'The proper way to handle your property management today. Join our users and enjoy predictable growth';
                ctrl.structuredData = '<script type="application/ld+json">{ "@context": "http://schema.org", "@type": "BreadcrumbList", "itemListElement": [  {   "@type": "ListItem",   "position": 1,   "item":   {    "@type": "WebSite",    "@id": "https://www.bookingninjas.com/",    "name": "Home"     }  },  {   "@type": "ListItem",   "position": 2,   "item":   {    "@type": "WebPage",    "@id": "https://www.bookingninjas.com/einstein-analytics-integration",    "name": "Artificial intelligence"    }   } ]}</script><script type="application/ld+json">    {  "@context": "https://schema.org",  "@type": "Organization",  "name": "Booking Ninjas",  "url": "https://www.bookingninjas.com/",  "address": "1815 Purdy Avenue, Miami Beach, FL 33139",  "sameAs": [    "https://www.facebook.com/bookingninjas",    "https://www.instagram.com/bookingninjas/",    "https://www.youtube.com/channel/UCOrcTzmQnmY7DG2nzwfa8zw", "https://www.linkedin.com/company/booking-ninjas",    "https://twitter.com/bookingninjas", "https://www.pinterest.com/bookingninjas/",    "https://appexchange.salesforce.com/listingDetail?listingId=a0N3A00000DvKtaUAF"        ],  "description": "RELIABLE PROPERTY MANAGEMENT FOR YOUR BUSINESS",  "contactPoint":   { "@type": "ContactPoint",     "contactType": "client service",     "email":       "sales@bookingninjas.com"  },  "logo": {   "@type": "imageObject",   "url": "https://d1b89zc79exfxt.cloudfront.net/img/logo.png",   "width": "332",   "height": "92"   }}</script><script type="application/ld+json">{"@context":"https://schema.org/", "@type": "Service", "url": "https://www.bookingninjas.com/einstein-analytics-integration", "category": " Property and hospitality industry ", "serviceType": "Property Management", "provider":  {   "@type": "Organization",   "name": "Booking Ninjas " },  "description": "RELIABLE PROPERTY MANAGEMENT FOR YOUR BUSINESS", "hasOfferCatalog": {  "@type": "OfferCatalog",  "name": "Einstein Analytics",  "itemListElement": [   {     "@type": "Offer",     "name": "Relationships",  "description": "Einstein Analytics helps businesses build deeper relationships with customers. This is a major break for service-based enterprises like hotels, where guests experience is of great importance. Einstein Analytics provides a 360-degree view in order to improve guests’ experience. This 360-degree view provides the hotels with relevant information they need to effectively manage their day-to-day interactions with guests."                                                                         },   {     "@type": "Offer",     "name": "Guests happy", "description": "Einstein Analytics helps businesses build deeper relationships with customers. This is a major break for service-based enterprises like hotels, where guests experience is of great importance. Einstein Analytics provides a 360-degree view in order to improve guests’ experience. This 360-degree view provides the hotels with relevant information they need to effectively manage their day-to-day interactions with guests."                                                                         },   {     "@type": "Offer",     "name": "Data collection", "description": "Einstein Analytics helps businesses build deeper relationships with customers. This is a major break for service-based enterprises like hotels, where guests experience is of great importance. Einstein Analytics provides a 360-degree view in order to improve guests’ experience. This 360-degree view provides the hotels with relevant information they need to effectively manage their day-to-day interactions with guests."                                                                         }                                                                        ]                                                                       }                                                                      }</script>';
            }

        Test.stopTest();
    }

    public static testMethod void testMonthlyFee() 
    {
        Test.startTest();
        
            PageReference pageRef = Page.BN_LP_Club;
            Test.setCurrentPage(pageRef);

            BN_TemplateController ctrl = new BN_TemplateController();
            
            ctrl.email = 'joee@johnson.com';
            ctrl.getMonthlyFee(); 
            ctrl.getMinPrice();
            
        Test.stopTest();
    }
}