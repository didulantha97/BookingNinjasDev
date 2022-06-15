@isTest()
public class BNES_TemplateControllerTest {

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
        
            PageReference pageRef = Page.BNES_LP_Club;
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

            BNES_TemplateController ctrl = new BNES_TemplateController();
            
            ctrl.send404Message(); 
            
        Test.stopTest();
    }
    
    static testMethod void testPageTitle() { 
    
        pages.add('/sobre-nosotros');
        pages.add('/ventajas-de-nuestro-sistema-de-gestión-de-propiedades');
        pages.add('/integración-einstein-analytics'); 
        pages.add('/blog'); 
        pages.add('/valores-centrales-del-producto-booking-ninjas'); 
        pages.add('/automatic-data-processing-system'); 
        pages.add('/einstein-form'); 
        pages.add('/faqs'); 
        pages.add('/booking-ninjas-pms-case-studies'); 
        pages.add('/cumplimiento-del-gdpr'); 
        pages.add('/pms-implementation'); 
        pages.add('/revolución-industrial'); 
        pages.add('/integración-pms'); 
        pages.add('/myths'); 
        pages.add('/proceso-de-compra'); 
        pages.add('/pagesoupages'); 
        pages.add('/soluciones-de-gestión-de-propiedades'); 
        pages.add('/time-to-think'); 
        pages.add('/tour'); 
        pages.add('/why');
        pages.add('/prueba-gratis-de-14-días');
        pages.add('/thank-you');
        pages.add('/sobre-nosotros');
        pages.add('/booking-ninjas-careers');
        pages.add('/esdemo');
        pages.add('/customer-stories'); 
        pages.add('/customer-stories/hftp-south-florida');
        pages.add('/customer-stories/cty-books');
        pages.add('/historias-de-clientes/industrious-office'); 
        pages.add('/rate-my-pms');
        pages.add('/servicios-de-consultoría-de-salesforce');
        pages.add('/software-pms');
        pages.add('/software-de-gestión-de-clubes-de-campo');
        pages.add('/software-de-gestión-de-espacios-cooperativos');
        pages.add('/gestión-de-almacenamiento');
        pages.add('/compare-property-management-software');
        pages.add('/capabilities-of-booking-ninjas-product');
        pages.add('/es-student-housing-property-management-software');
        pages.add('/software-de-gestión-de-hostales');
        pages.add('/software-de-gestión-de-propiedades-de-hoteles');
        pages.add('/software-para-administradores-de-propiedades');
        pages.add('/software-de-gestión-de-restaurantes');
        pages.add('/parking-management-system');
        pages.add('/software-de-gestión-de-propiedades-del-gobierno');
        pages.add('/software-de-gestión-de-propiedades-de-hogares-de-ancianos');
        pages.add('/software-de-gestión-de-propiedades-de-alquileres-vacacionales');
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
        pages.add('/ESPricing');
        
        Test.startTest();
            
            for(String page : pages)
            {
                PageReference pageRef = new PageReference(page);
                Test.setCurrentPage(pageRef);
                
                BNES_TemplateController ctrl = new BNES_TemplateController();
                String pageName = ApexPages.currentPage().getUrl().substringAfter('/').split('\\?')[0];
                ctrl.page = pageName;
                ctrl.amp = 'https://bnamp.s3.us-east-2.amazonaws.com/index.html';
                ctrl.title = 'Best Hotel Management Software - Cloud-Based PMS | Booking Ninjas';
                ctrl.description = 'The proper way to handle your property management today. Join our users and enjoy predictable growth';
                ctrl.structuredData = '<script type="application/ld+json">{ "@context": "http://schema.org", "@type": "BreadcrumbList", "itemListElement": [  {   "@type": "ListItem",   "position": 1,   "item":   {    "@type": "WebSite",    "@id": "https://es.bookingninjas.com/",    "name": "Home"     }  },  {   "@type": "ListItem",   "position": 2,   "item":   {    "@type": "WebPage",    "@id": "https://es.bookingninjas.com/integración-einstein-analytics",    "name": "Artificial intelligence"    }   } ]}</script><script type="application/ld+json">    {  "@context": "https://schema.org",  "@type": "Organization",  "name": "Booking Ninjas",  "url": "https://es.bookingninjas.com/",  "address": "1815 Purdy Avenue, Miami Beach, FL 33139",  "sameAs": [    "https://www.facebook.com/bookingninjas",    "https://www.instagram.com/bookingninjas/",    "https://www.youtube.com/channel/UCOrcTzmQnmY7DG2nzwfa8zw", "https://www.linkedin.com/company/booking-ninjas",    "https://twitter.com/bookingninjas", "https://www.pinterest.com/bookingninjas/",    "https://appexchange.salesforce.com/listingDetail?listingId=a0N3A00000DvKtaUAF"        ],  "description": "RELIABLE PROPERTY MANAGEMENT FOR YOUR BUSINESS",  "contactPoint":   { "@type": "ContactPoint",     "contactType": "client service",     "email":       "sales@bookingninjas.com"  },  "logo": {   "@type": "imageObject",   "url": "https://d1b89zc79exfxt.cloudfront.net/img/logo.png",   "width": "332",   "height": "92"   }}</script><script type="application/ld+json">{"@context":"https://schema.org/", "@type": "Service", "url": "https://es.bookingninjas.com/integración-einstein-analytics", "category": " Property and hospitality industry ", "serviceType": "Property Management", "provider":  {   "@type": "Organization",   "name": "Booking Ninjas " },  "description": "RELIABLE PROPERTY MANAGEMENT FOR YOUR BUSINESS", "hasOfferCatalog": {  "@type": "OfferCatalog",  "name": "Einstein Analytics",  "itemListElement": [   {     "@type": "Offer",     "name": "Relationships",  "description": "Einstein Analytics helps businesses build deeper relationships with customers. This is a major break for service-based enterprises like hotels, where guests experience is of great importance. Einstein Analytics provides a 360-degree view in order to improve guests’ experience. This 360-degree view provides the hotels with relevant information they need to effectively manage their day-to-day interactions with guests."                                                                         },   {     "@type": "Offer",     "name": "Guests happy", "description": "Einstein Analytics helps businesses build deeper relationships with customers. This is a major break for service-based enterprises like hotels, where guests experience is of great importance. Einstein Analytics provides a 360-degree view in order to improve guests’ experience. This 360-degree view provides the hotels with relevant information they need to effectively manage their day-to-day interactions with guests."                                                                         },   {     "@type": "Offer",     "name": "Data collection", "description": "Einstein Analytics helps businesses build deeper relationships with customers. This is a major break for service-based enterprises like hotels, where guests experience is of great importance. Einstein Analytics provides a 360-degree view in order to improve guests’ experience. This 360-degree view provides the hotels with relevant information they need to effectively manage their day-to-day interactions with guests."                                                                         }                                                                        ]                                                                       }                                                                      }</script>';
            }

        Test.stopTest();
    }
}