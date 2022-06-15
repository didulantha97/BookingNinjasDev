@isTest
private class BNES_UrlRewriterTest {
    
    static testMethod void testURLrewriter() { 
        pageReference myPage = new pageReference('/ventajas-de-nuestro-sistema-de-gestión-de-propiedades');
        Test.setCurrentPage(myPage);
        myPage.setRedirect(true);
        
        List<PageReference> res = new List<PageReference>();
        res.add(myPage);
        res.add(new PageReference('/s/sitemap.xml'));
        res.add(new PageReference('/integración-einstein-analytics')); 
        res.add(new PageReference('/blog')); 
        res.add(new PageReference('/valores-centrales-del-producto-booking-ninjas')); 
        res.add(new PageReference('/automatic-data-processing-system')); 
        res.add(new PageReference('/einstein-form')); 
        res.add(new PageReference('/faqs')); 
        res.add(new PageReference('/booking-ninjas-pms-case-studies')); 
        res.add(new PageReference('/cumplimiento-del-gdpr')); 
        res.add(new PageReference('/pms-implementation')); 
        res.add(new PageReference('/revolución-industrial')); 
        res.add(new PageReference('/integración-pms')); 
        res.add(new PageReference('/myths')); 
        res.add(new PageReference('/proceso-de-compra')); 
        res.add(new PageReference('/resoures')); 
        res.add(new PageReference('/soluciones-de-gestión-de-propiedades')); 
        res.add(new PageReference('/one-platform-for-all-property-operations'));
        res.add(new PageReference('/time-to-think'));  
        res.add(new PageReference('/why'));
        res.add(new PageReference('/prueba-gratis-de-14-días'));
        res.add(new PageReference('/thank-you'));
        res.add(new PageReference('/thank-you-for-your-interest'));
        res.add(new PageReference('/sobre-nosotros'));
        res.add(new PageReference('/expression-of-interest'));
        res.add(new PageReference('/thank-you-for-expressing-your-interest'));
        res.add(new PageReference('/booking-ninjas-careers'));
        res.add(new PageReference('/career-application'));
        res.add(new PageReference('/software-pms'));
        res.add(new PageReference('/servicios-de-consultoría-de-salesforce'));
        res.add(new PageReference('/consultation-form'));
        res.add(new PageReference('/programe-una-reunión'));
        res.add(new PageReference('/customer-stories')); 
        res.add(new PageReference('/customer-stories/hftp-south-florida'));
        res.add(new PageReference('/customer-stories/cty-books'));
        res.add(new PageReference('/historias-de-clientes/industrious-office'));
        res.add(new PageReference('/customer-stories/worldwide-properties'));
        res.add(new PageReference('/software-de-gestión-de-clubes-de-campo'));
        res.add(new PageReference('/software-de-gestión-de-espacios-cooperativos'));
        res.add(new PageReference('/software-de-gestión-de-hostales'));
        res.add(new PageReference('/gestión-de-almacenamiento')); 
        res.add(new PageReference('/software-de-gestión-de-restaurantes'));
        res.add(new PageReference('/parking-management-system')); 
        res.add(new PageReference('/software-de-gestión-de-propiedades-para-estudiantes')); 
        res.add(new PageReference('/software-de-gestión-de-propiedades-de-hoteles')); 
        res.add(new PageReference('/software-para-administradores-de-propiedades'));
        res.add(new PageReference('/software-de-gestión-de-propiedades-del-gobierno'));
        res.add(new PageReference('/software-de-gestión-de-propiedades-de-hogares-de-ancianos'));
        res.add(new PageReference('/software-de-gestión-de-propiedades-de-alquileres-vacacionales')); 
        res.add(new PageReference('/compare-property-management-software'));
        res.add(new PageReference('/capabilities-of-booking-ninjas-product')); 
        res.add(new PageReference('/feature-spotlights'));
        res.add(new PageReference('/conference'));
        res.add(new PageReference('/tour'));
        res.add(new PageReference('/tour/availability'));
        res.add(new PageReference('/tour/hotel-booking-engine'));
        res.add(new PageReference('/tour/hotel-channel-manager'));
        res.add(new PageReference('/tour/einstein-analytics'));
        res.add(new PageReference('/tour/electronic-signature-software'));
        res.add(new PageReference('/tour/pms-mobile-apps'));
        res.add(new PageReference('/tour/advance-payment-features'));
        res.add(new PageReference('/tour/point-of-sales-software'));
        res.add(new PageReference('/tour/custom-reporting-software'));
        res.add(new PageReference('/tour/room-booking-software'));
        res.add(new PageReference('/tour-ticketing-system'));
        res.add(new PageReference('/tour/twilio-flex-integrations'));
        res.add(new PageReference('/tour/hotel-door-access-control-system'));
        res.add(new PageReference('/tour/salesforce-appexchange-integration'));
        res.add(new PageReference('/careers/salesforce-admins'));
        res.add(new PageReference('/careers/salesforce-developers'));
        res.add(new PageReference('/careers/front-end-developers'));
        res.add(new PageReference('/careers/content-writers'));
        res.add(new PageReference('/careers/script-writers'));
        res.add(new PageReference('/careers/designers'));
        res.add(new PageReference('/careers/growth-hackers'));
        res.add(new PageReference('/careers/project-managers'));
        res.add(new PageReference('/careers/account-executives'));
        res.add(new PageReference('/careers/mobile-developers'));
        res.add(new PageReference('/careers/customer-service-representatives'));
        res.add(new PageReference('/careers/social-media-ninjas'));
        res.add(new PageReference('/careers/seo-ninjas'));
        res.add(new PageReference('/wait-list'));
        res.add(new PageReference('/integration-with-salesforce-platform'));
        res.add(new PageReference('/pt/pricing'));
        res.add(new PageReference('/espricing'));
        res.add(new PageReference('/pre-activation-form'));
        res.add(new PageReference('/third-party-hotel-booking-sites-integration'));
        res.add(new PageReference('/deje-su-opinión'));
        res.add(new PageReference('/covid-19'));
        res.add(new PageReference('/contact-us'));
        res.add(new PageReference('/partners'));
        res.add(new PageReference('/partners/hftp'));
        res.add(new PageReference('/partners/salesforce'));
        res.add(new PageReference('/partners/twilio'));
        res.add(new PageReference('/partners/channelrush'));
        res.add(new PageReference('/partners/yieldplanet'));
        res.add(new PageReference('/partners/esign-genie'));
        res.add(new PageReference('/partners/latino-hotel-association'));
        res.add(new PageReference('/partners/nabhood'));
        res.add(new PageReference('/surveys'));
        res.add(new PageReference('/surveys/rate-my-pms'));
        res.add(new PageReference('/surveys/hotel-industry'));
        res.add(new PageReference('/surveys/covid-19'));
        res.add(new PageReference('/surveys/general-hospitality'));
        res.add(new PageReference('/booking-ninjas-webinars'));
        res.add(new PageReference('/checkout'));
        res.add(new PageReference('/pos-checkout'));
        res.add(new PageReference('/villas-property-management-software'));
        res.add(new PageReference('/government-property-management-software'));
        res.add(new PageReference('/non-profit-property-management-software'));
        res.add(new PageReference('/es-student-housing-property-management-software'));
        res.add(new PageReference('/esdemo'));
        
        //portal
        res.add(new PageReference('/login'));
        res.add(new PageReference('/forgot-password'));
        res.add(new PageReference('/portal'));
        res.add(new PageReference('/portal/payments'));
        res.add(new PageReference('/portal/cards'));
        res.add(new PageReference('/portal/users'));
        res.add(new PageReference('/portal/services'));
        res.add(new PageReference('/portal/v2mom'));
        res.add(new PageReference('/portal/videos'));
        
        BNES_UrlRewriter urlClass = new BNES_UrlRewriter();
        urlClass.mapRequestUrl(myPage);
        urlClass.generateUrlFor(res);
    }
    
    static testMethod void test_mapRequestUrl_UseCase1(){
        PageReference pageRef = Page.BNES_Advantages;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/ventajas-de-nuestro-sistema-de-gestión-de-propiedades'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase2(){
        PageReference pageRef = Page.BNES_ArtificialIntelligence;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/integración-einstein-analytics'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase3(){
        PageReference pageRef = Page.BNES_Blog;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/blog'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase5(){
        PageReference pageRef = Page.BNES_CoreValues;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/valores-centrales-del-producto-booking-ninjas'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase6(){
        PageReference pageRef = Page.BN_Data;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/automatic-data-processing-system'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase7(){
        PageReference pageRef = Page.BN_EinsteinForm;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/einstein-form'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase8(){
        PageReference pageRef = Page.BN_FAQs;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/faqs'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase9(){
        PageReference pageRef = Page.BN_Gallery;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/booking-ninjas-pms-case-studies'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase10(){
        PageReference pageRef = Page.BNES_Gdpr;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/cumplimiento-del-gdpr'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase11(){
        PageReference pageRef = Page.BN_Implementation;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/pms-implementation'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase12(){
        PageReference pageRef = Page.BNES_IndustrialRevolution;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/revolución-industrial'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase13(){
        PageReference pageRef = Page.BNES_Integrations;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/integración-pms'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase14(){
        PageReference pageRef = Page.BN_Myths;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/myths'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase15(){
        PageReference pageRef = Page.BNES_Process;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/proceso-de-compra'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase16(){
        PageReference pageRef = Page.BN_Resources;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/resources'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase17(){
        PageReference pageRef = Page.BNES_Solutions;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/soluciones-de-gestión-de-propiedades'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase18(){
        PageReference pageRef = Page.BN_TimeToThink;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/time-to-think'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase19(){
        PageReference pageRef = Page.BN_FeatureSpotlights;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase20(){
        PageReference pageRef = Page.BN_Why;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/why-booking-ninjas'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase21(){
        PageReference pageRef = Page.BNCalendly;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/programe-una-reunión'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase22(){
        PageReference pageRef = Page.BN_CustomerStories;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/customer-stories'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase23(){
        PageReference pageRef = Page.BN_Pricing;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/pricing'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase24(){
        PageReference pageRef = Page.BN_CustomerStories_HFTP;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/customer-stories/hftp-south-florida'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase25(){
        PageReference pageRef = Page.BN_CustomerStories_CTY;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/customer-stories/cty-books'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase26(){
        PageReference pageRef = Page.BNES_CustomerStories_Industrious;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/historias-de-clientes/industrious-office'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase27(){
        PageReference pageRef = Page.BNES_Register;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/prueba-gratis-de-14-días'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase28(){
        PageReference pageRef = Page.BNES_About;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/sobre-nosotros'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase29(){
        PageReference pageRef = Page.BN_ThankYou;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/thank-you'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase30(){
        PageReference pageRef = Page.BN_Form_RateMyPMS;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/rate-my-pms'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase31(){
        PageReference pageRef = Page.BN_Career;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/booking-ninjas-careers'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase32(){
        PageReference pageRef = Page.BN_Form_HotelIndustrySurvey;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/hotel-industry-survey'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase33(){
        PageReference pageRef = Page.BNES_PMS;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/software-pms'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase34(){
        PageReference pageRef = Page.BNES_Consulting;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/servicios-de-consultoría-de-salesforce'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase35(){
        PageReference pageRef = Page.BNES_LP_Club;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/software-de-gestión-de-clubes-de-campo'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase36(){
        PageReference pageRef = Page.BNES_LP_CoWorking;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/software-de-gestión-de-espacios-cooperativos'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase37(){
        PageReference pageRef = Page.BNES_LP_Hostels;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/software-de-gestión-de-hostales'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase38(){
        PageReference pageRef = Page.BNES_LP_Storage;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/gestión-de-almacenamiento'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase39(){
        PageReference pageRef = Page.BN_ThankYou2;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/thank-you-for-your-interest'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase40(){
        PageReference pageRef = Page.BN_Matrix;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/compare-property-management-software'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase41(){
        PageReference pageRef = Page.BN_Glance;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/capabilities-of-booking-ninjas-product'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase42(){
        PageReference pageRef = Page.BN_FeatureSpotlights;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/feature-spotlights'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase43(){
        PageReference pageRef = Page.BN_Conference;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/conference'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase44(){
        PageReference pageRef = Page.BNES_LP_StudentHousing;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/es-student-housing-property-management-software'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase46(){
        PageReference pageRef = Page.BN_FeatureSpotlight_AvailabilityGrid;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/reservation-management-system'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase47(){
        PageReference pageRef = Page.BN_FeatureSpotlight_BE;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/hotel-booking-engine'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase48(){
        PageReference pageRef = Page.BN_FeatureSpotlight_Channel;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/hotel-channel-manager'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase49(){
        PageReference pageRef = Page.BN_FeatureSpotlight_Einstein;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/einstein-analytics'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase50(){
        PageReference pageRef = Page.BN_FeatureSpotlight_ESign;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/electronic-signature-software'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase51(){
        PageReference pageRef = Page.BN_FeatureSpotlight_Mobile;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/pms-mobile-apps'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase52(){
        PageReference pageRef = Page.BN_FeatureSpotlight_Payment;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/advance-payment-features'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase53(){
        PageReference pageRef = Page.BN_FeatureSpotlight_POS;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/point-of-sales-software'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase54(){
        PageReference pageRef = Page.BN_FeatureSpotlight_Report;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/custom-reporting-software'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase55(){
        PageReference pageRef = Page.BN_FeatureSpotlight_RRC;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/room-booking-software'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase56(){
        PageReference pageRef = Page.BN_FeatureSpotlight_Ticket;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/event-ticketing-system'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase57(){
        PageReference pageRef = Page.BN_FeatureSpotlight_Twilio;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/twilio-flex-integrations'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase58(){
        PageReference pageRef = Page.BNES_LP_Restaurant;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/software-de-gestión-de-restaurantes'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase59(){
        PageReference pageRef = Page.BNES_LP_Parking;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/parking-management-system'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase60(){
        PageReference pageRef = Page.BNES_LP_PropertyManagers;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/software-para-administradores-de-propiedades'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase61(){
        PageReference pageRef = Page.BNES_LP_Hotels;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/software-de-gestión-de-propiedades-de-hoteles'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase62(){
        PageReference pageRef = Page.BN_CareerLeadForm;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career-application'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase63(){
        PageReference pageRef = Page.BN_Career_SalesforceAdmin;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/salesforce-admins'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase64(){
        PageReference pageRef = Page.BN_Career_SalesforceDeveloper;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/salesforce-developers'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase65(){
        PageReference pageRef = Page.BN_Career_FrontEndDeveloper;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/front-end-developers'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase66(){
        PageReference pageRef = Page.BN_Career_ContentWriter;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/content-writers'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase67(){
        PageReference pageRef = Page.BN_Career_ScriptWriter;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/script-writers'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase68(){
        PageReference pageRef = Page.BN_Career_Designer;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/designers'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase69(){
        PageReference pageRef = Page.BN_Career_GrowthHacker;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/growth-hackers'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase70(){
        PageReference pageRef = Page.sitemap;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/s/sitemap.xml'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase71(){
        PageReference pageRef = Page.BN_Career_ProjectManager;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/project-managers'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase72(){
        PageReference pageRef = Page.BN_Career_AccountExecutive;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/account-executives'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase73(){
        PageReference pageRef = Page.BN_Career_MobileDeveloper;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/mobile-developers'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase74(){
        PageReference pageRef = Page.BN_Career_CSR;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/customer-service-representatives'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase75(){
        PageReference pageRef = Page.BN_Career_SocialMediaNinja;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/social-media-ninjas'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase76(){
        PageReference pageRef = Page.BN_Career_SEONinja;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/career/seo-ninjas'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase77(){
        PageReference pageRef = Page.BNES_ConsultingForm;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/consultation-form'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase78(){
        PageReference pageRef = Page.BN_HotelPMS;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/one-platform-for-all-property-operations'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase79(){
        PageReference pageRef = Page.BNES_LP_Event;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/software-de-gestión-de-propiedades-del-gobierno'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase80(){
        PageReference pageRef = Page.BN_Interest;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/expression-of-interest'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase81(){
        PageReference pageRef = Page.BN_ThankYou3;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/thank-you-for-expressing-your-interest'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase82(){
        PageReference pageRef = Page.BN_WaitList;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/wait-list'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase84(){
        PageReference pageRef = Page.BN_PMS_Salesforce;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/integration-with-salesforce-platform'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase85(){
        PageReference pageRef = Page.BN_ActivationForm;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/pre-activation-form'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase86(){
        PageReference pageRef = Page.BN_CustomerStories_WDS;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/worldwide-properties'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase87(){
        PageReference pageRef = Page.BN_Form_Covid19;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/covid19-survey'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase88(){
        PageReference pageRef = Page.BN_Form_GeneralHospitalitySurvey;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/general-hospitality-survey'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase89(){
        PageReference pageRef = Page.BN_ChannelListing;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/third-party-hotel-booking-sites-integration'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase90(){
        PageReference pageRef = Page.BNES_Reviews;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/deje-su-opinión'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase91(){
        PageReference pageRef = Page.BN_Covid19;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/covid-19'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase92(){
        PageReference pageRef = Page.BN_Contact;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/contact-us'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase93(){
        PageReference pageRef = Page.BN_Partners;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/partners'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase94(){
        PageReference pageRef = Page.BN_Partners_HFTP;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/partners/hftp'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase95(){
        PageReference pageRef = Page.BN_Partners_Salesforce;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/partners/salesforce'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase96(){
        PageReference pageRef = Page.BN_Partners_Twilio;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/partners/twilio'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase97(){
        PageReference pageRef = Page.BN_Partners_ChannelRush;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/partners/channelrush'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase98(){
        PageReference pageRef = Page.BN_Partners_YieldPlanet;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/partners/yieldplanet'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase99(){
        PageReference pageRef = Page.BN_Partners_Latino;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/partners/latino-hotel-association'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase100(){
        PageReference pageRef = Page.BN_Partners_ESign;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/partners/esign-genie'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase101(){
        PageReference pageRef = Page.BN_Partners_Nabhood;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/partners/nabhood'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase102(){
        PageReference pageRef = Page.BN_Survey;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/surveys'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase103(){
        PageReference pageRef = Page.BNES_LP_Senior;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/software-de-gestión-de-propiedades-de-hogares-de-ancianos'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase104(){
        PageReference pageRef = Page.BNES_LP_Vacation;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/software-de-gestión-de-propiedades-de-alquileres-vacacionales'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase105(){
        PageReference pageRef = Page.BN_Webinars;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/booking-ninjas-webinars'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase106(){
        PageReference pageRef = Page.BN_CheckOut;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/checkout'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase107(){
        PageReference pageRef = Page.BN_LP_Villa;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/villas-property-management-software'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase108(){
        PageReference pageRef = Page.BN_POS;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/pos-checkout'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase109(){
        PageReference pageRef = Page.BN_FeatureSpotlight_AccessControl;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/hotel-door-access-control-system'));
    }
    
    static testMethod void test_mapRequestUrl_UseCase111(){
        PageReference pageRef = Page.BN_FeatureSpotlight_Appexchange;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/tour/salesforce-appexchange-integration'));
    }

    static testMethod void test_mapRequestUrl_UseCase112(){
        PageReference pageRef = Page.BNES_LP_Government;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/government-property-management-software'));
    }

    static testMethod void test_mapRequestUrl_UseCase110(){
        PageReference pageRef = Page.BN_LP_NonProfit;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/non-profit-property-management-software'));
    }
    
    // PORTAL TEST CLASSES
    static testMethod void test_mapRequestUrl_UseCaseP01(){
        PageReference pageRef = Page.BN_Portal_Home;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/login'));
    }
    
    static testMethod void test_mapRequestUrl_UseCaseP02(){
        PageReference pageRef = Page.BN_Portal_Account;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/portal'));
    }
    
    static testMethod void test_mapRequestUrl_UseCaseP03(){
        PageReference pageRef = Page.BN_Portal_PaymentHistory;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/portal/payments'));
    }
    
    static testMethod void test_mapRequestUrl_UseCaseP04(){
        PageReference pageRef = Page.BN_Portal_Cards;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/portal/cards'));
    }
    
    static testMethod void test_mapRequestUrl_UseCaseP05(){
        PageReference pageRef = Page.BN_Portal_Users;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/portal/users'));
    }
    
    static testMethod void test_mapRequestUrl_UseCaseP06(){
        PageReference pageRef = Page.BN_Portal_Services;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/portal/services'));
    }
    
    static testMethod void test_mapRequestUrl_UseCaseP07(){
        PageReference pageRef = Page.BN_Portal_ClientV2MOM;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/portal/v2mom'));
    }
    
    static testMethod void test_mapRequestUrl_UseCaseP08(){
        PageReference pageRef = Page.BN_Portal_ForgotPassword;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/forgot-password'));
    }
    
    static testMethod void test_mapRequestUrl_UseCaseP09(){
        PageReference pageRef = Page.BN_Portal_Videos;
        Test.setCurrentPage(pageRef);

        BNES_UrlRewriter obj = new BNES_UrlRewriter();
        
        obj.mapRequestUrl(new PageReference('/portal/videos'));
    }
}