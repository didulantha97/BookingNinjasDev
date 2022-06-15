global class BNES_UrlRewriter implements Site.UrlRewriter {

    String regEx = '[^a-zA-Z0-9]';

    // Variables to represent the user-friendly URLs
    String ADVANTAGES_PAGE = '/ventajas-de-nuestro-sistema-de-gestión-de-propiedades';
    String ARTIFICIAL_INTELLIGENCE_PAGE = '/integración-einstein-analytics';
    String AUTHOR_PAGE = '/author?id=';
    String BLOG_PAGE = '/blog';
    String ARTICLE_PAGE = '/blog/';
    String CORE_VALUES_PAGE = '/valores-centrales-del-producto-booking-ninjas';
    String DATA_PAGE = '/automatic-data-processing-system';
    String EINSTEIN_FORM_PAGE = '/einstein-form';
    String FAQS_PAGE = '/faqs';
    String GALLERY_PAGE = '/booking-ninjas-pms-case-studies';
    String GDPR_PAGE = '/cumplimiento-del-gdpr';
    String IMPLEMENTATION_PAGE = '/pms-implementation';
    String INDUSTRIAL_REVOLUTION_PAGE = '/revolución-industrial';
    String INTEGRATIONS_PAGE = '/integración-pms';
    String MYTHS_PAGE = '/myths';
    String PROCESS_PAGE = '/proceso-de-compra';
    String PRICING_PAGE = '/pricing';
    String PRICING_PT_PAGE = '/pt/pricing';
    String RESOURCES_PAGE = '/resources';
    String SOLUTIONS_PAGE = '/soluciones-de-gestión-de-propiedades';
    String TIME_TO_THINK_PAGE = '/time-to-think';
    String WHY_PAGE = '/why-booking-ninjas';
    String REGISTER_PAGE = '/prueba-gratis-de-14-días';
    String THANKYOU_PAGE = '/thank-you';
    String ABOUT_PAGE = '/sobre-nosotros';
    String CAREER_PAGE = '/booking-ninjas-careers';
    String CAREER_APPLICATION_PAGE = '/career-application';
    String PMS_PAGE = '/software-pms';
    String CONSULTATION_PAGE = '/servicios-de-consultoría-de-salesforce';
    String CONSULTATION_FORM_PAGE = '/formulario-de-servicios-de-consultoría-de-salesforce';
    String CALENDLY_PAGE = '/programe-una-reunión';
    String CUSTOMER_STORIES_PAGE = '/customer-stories';
    String CUSTOMER_STORIES_HFTP_PAGE = '/customer-stories/hftp-south-florida';
    String CUSTOMER_STORIES_CTY_PAGE = '/customer-stories/cty-books';
    String CUSTOMER_STORIES_INDUSTRIOUS_PAGE = '/historias-de-clientes/industrious-office';
    String CUSTOMER_STORIES_WDS_PAGE = '/customer-stories/worldwide-properties';
    String CLUB_LANDING_PAGE = '/software-de-gestión-de-clubes-de-campo';
    String COWORKING_LANDING_PAGE = '/software-de-gestión-de-espacios-cooperativos';
    String HOSTEL_LANDING_PAGE = '/software-de-gestión-de-hostales';
    String STORAGE_LANDING_PAGE = '/gestión-de-almacenamiento';
    String STUDENTHOUSING_LANDING_PAGE = '/software-de-gestión-de-propiedades-para-estudiantes';
    String RESTAURANT_LANDING_PAGE = '/software-de-gestión-de-restaurantes';
    String PARKING_LANDING_PAGE = '/parking-management-system';
    String HOTEL_LANDING_PAGE = '/software-de-gestión-de-propiedades-de-hoteles';
    String PROPERTY_LANDING_PAGE = '/software-para-administradores-de-propiedades';
    String EVENT_LANDING_PAGE = '/software-de-gestión-de-propiedades-del-gobierno';
    String SENIOR_LANDING_PAGE = '/software-de-gestión-de-propiedades-de-hogares-de-ancianos';
    String VACATION_LANDING_PAGE = '/software-de-gestión-de-propiedades-de-alquileres-vacacionales';
    String VILLA_LANDING_PAGE = '/villas-propiedad-administración-software';
    String GOVERNMENT_LANDING_PAGE = '/government-property-management-software';
    String NONPROFIT_LANDING_PAGE = '/non-profit-property-management-software';
    String CAREER_THANKYOU_PAGE = '/thank-you-for-your-interest';
    String COMPETITIVE_MATRIX_PAGE = '/compare-property-management-software';
    String GLANCE_PAGE = '/capabilities-of-booking-ninjas-product';
    String CONFERENCE_PAGE = '/conference';
    String TOUR_PAGE = '/tour';
    String TOUR_AVAILABILITY_PAGE = '/tour/reservation-management-system';
    String TOUR_BE_PAGE = '/tour/hotel-booking-engine';
    String TOUR_CM_PAGE = '/tour/hotel-channel-manager';
    String TOUR_EA_PAGE = '/tour/einstein-analytics';
    String TOUR_ESIGN_PAGE = '/tour/electronic-signature-software';
    String TOUR_MOBILE_PAGE = '/tour/pms-mobile-apps';
    String TOUR_PAYMENT_PAGE = '/tour/advance-payment-features';
    String TOUR_POS_PAGE = '/tour/point-of-sales-software';
    String TOUR_REPORT_PAGE = '/tour/custom-reporting-software';
    String TOUR_RRC_PAGE = '/tour/room-booking-software';
    String TOUR_TICKET_PAGE = '/tour/event-ticketing-system';
    String TOUR_TWILIO_PAGE = '/tour/twilio-flex-integrations';
    String TOUR_ACCESSCONTROL_PAGE = '/tour/hotel-door-access-control-system';
    String TOUR_APPEXCHANGE_PAGE = '/tour/salesforce-appexchange-integration';
    String CAREER_SALESFORCEADMIN_PAGE = '/careers/salesforce-admins';
    String CAREER_SALESFORCEDEVELOPER_PAGE = '/careers/salesforce-developers';
    String CAREER_FRONTENDDEVELOPER_PAGE = '/careers/front-end-developers';
    String CAREER_CONTENTWRITER_PAGE = '/careers/content-writers';
    String CAREER_SCRIPTWRITER_PAGE = '/careers/script-writers';
    String CAREER_DESIGNER_PAGE = '/careers/designers';
    String CAREER_GROWTHHACKER_PAGE = '/careers/growth-hackers';
    String CAREER_PROJECTMANAGER_PAGE = '/careers/project-managers';
    String CAREER_ACCOUNTEXECUTIVE_PAGE = '/careers/account-executives';
    String CAREER_MOBILEDEVELOPER_PAGE = '/careers/mobile-developers';
    String CAREER_CSR_PAGE = '/careers/customer-service-representatives';
    String CAREER_SOCIALMEDIANINJA_PAGE = '/careers/social-media-ninjas';
    String CAREER_SEONINJA_PAGE = '/careers/seo-ninjas';
    String BEST_HOTEL_PMS_PAGE = '/one-platform-for-all-property-operations';
    String INTEREST_PAGE = '/expression-of-interest';
    String INTEREST_THANKYOU_PAGE = '/thank-you-for-expressing-your-interest';
    String WAITLIST_PAGE = '/wait-list';
    String PMS_SALESFORCE_PAGE = '/integration-with-salesforce-platform';
    String PREACTIVATIONFORM_PAGE = '/pre-activation-form';
    String SURVEYS_PAGE = '/surveys';
    String FORM_RATEMYPMS_PAGE = '/surveys/rate-my-pms';
    String FORM_HOTELINDUSTRYSURVEY_PAGE = '/surveys/hotel-industry';
    String FORM_COVID19_PAGE = '/surveys/covid-19';
    String FORM_GENHOSPITALITYSURVEY_PAGE = '/surveys/general-hospitality';
    String CHANNEL_LISTING_PAGE = '/third-party-hotel-booking-sites-integration';
    String REVIEWS_PAGE = '/deje-su-opinión';
    String COVID19_PAGE = '/covid-19';
    String CONTACT_PAGE = '/contact-us';
    String PARTNER_PAGE = '/partners';
    String PARTNER_SALESFORCE_PAGE = '/partners/salesforce';
    String PARTNER_HFTP_PAGE = '/partners/hftp';
    String PARTNER_TWILIO_PAGE = '/partners/twilio';
    String PARTNER_CHANNELRUSH_PAGE = '/partners/channelrush';
    String PARTNER_YIELD_PAGE = '/partners/yieldplanet';
    String PARTNER_ESIGN_PAGE = '/partners/esign-genie';
    String PARTNER_LATINO_PAGE = '/partners/latino-hotel-association';
    String PARTNER_NABHOOD_PAGE = '/partners/nabhood';
    String WEBINARS_PAGE = '/booking-ninjas-webinars';
    String WEBINAR_PAGE = '/webinars/';
    String GUEST_POST_SUBMISSION_PAGE = '/guest-post-submission';
    String SUBMISSION_THANKYOU_PAGE = '/thank-you-for-your-submission';
    String CHECKOUT_PAGE = '/checkout';
    String POS_CHECKOUT_PAGE = '/pos-checkout';
    String REFERRAL_PROGRAM_PAGE = '/referral-program';
    String SITEMAP_PAGE = '/sitemap';
    
    // portal
    String PORTAL_HOME_PAGE = '/login';
    String PORTAL_FORGOTPASSWORD_PAGE = '/forgot-password';
    String PORTAL_RESETPASSWORD_PAGE = '/reset-password?id=';
    String PORTAL_ACCOUNT_PAGE = '/portal';
    String PORTAL_PAYMENT_PAGE = '/portal/payments';
    String PORTAL_CARD_PAGE = '/portal/cards';
    String PORTAL_USER_PAGE = '/portal/users';
    String PORTAL_SERVICE_PAGE = '/portal/services';
    String PORTAL_CLIENTV2MOM_PAGE = '/portal/v2mom';
    String PORTAL_VIDEOS_PAGE = '/portal/videos';
    
    
    //Variables to represent my custom Visualforce pages
    String ADVANTAGES_VF_PAGE = '/BNES_Advantages';
    String ARTIFICIAL_INTELLIGENCE_VF_PAGE = '/BNES_ArtificialIntelligence';
    String AUTHOR_VF_PAGE = '/BNES_Author?id=';
    String BLOG_VF_PAGE = '/BNES_Blog';
    String ARTICLE_VF_PAGE = '/BNES_Article?id=';
    String CORE_VALUES_VF_PAGE = '/BNES_CoreValues';
    String DATA_VF_PAGE = '/BN_Data';
    String EINSTEIN_FORM_VF_PAGE = '/BN_EinsteinForm';
    String FAQS_VF_PAGE = '/BN_FAQs';
    String GALLERY_VF_PAGE = '/BN_Gallery';
    String GDPR_VF_PAGE = '/BNES_Gdpr';
    String IMPLEMENTATION_VF_PAGE = '/BN_Implementation';
    String INDUSTRIAL_REVOLUTION_VF_PAGE = '/BNES_IndustrialRevolution';
    String INTEGRATIONS_VF_PAGE = '/BNES_Integrations';
    String MYTHS_VF_PAGE = '/BN_Myths';
    String PROCESS_VF_PAGE = '/BNES_Process';
    String PRICING_VF_PAGE = '/BNES_Pricing';
    String PRICING_PT_VF_PAGE = '/BN_Pricing_PT';
    String RESOURCES_VF_PAGE = '/BN_Resources';
    String SOLUTIONS_VF_PAGE = '/BNES_Solutions';
    String TIME_TO_THINK_VF_PAGE = '/BN_TimeToThink';
    String WHY_VF_PAGE = '/BN_Why';
    String REGISTER_VF_PAGE = '/BNES_Register';
    String THANKYOU_VF_PAGE = '/BN_ThankYou';
    String ABOUT_VF_PAGE = '/BNES_About';
    String FORM_RATEMYPMS_VF_PAGE = '/BN_Form_RateMyPMS';
    String FORM_HOTELINDUSTRYSURVEY_VF_PAGE = '/BN_Form_HotelIndustrySurvey';
    String CAREER_VF_PAGE = '/BN_Career';
    String CAREER_APPLICATION_VF_PAGE = '/BN_CareerLeadForm';
    String PMS_VF_PAGE = '/BNES_PMS';
    String CONSULTATION_VF_PAGE = '/BNES_Consulting';
    String CONSULTATION_FORM_VF_PAGE = '/BNES_ConsultingForm';
    String CALENDLY_VF_PAGE = '/BNES_Demo';
    String CUSTOMER_STORIES_VF_PAGE = '/BN_CustomerStories';
    String CUSTOMER_STORIES_HFTP_VF_PAGE = '/BN_CustomerStories_HFTP';
    String CUSTOMER_STORIES_CTY_VF_PAGE = '/BN_CustomerStories_CTY';
    String CUSTOMER_STORIES_INDUSTRIOUS_VF_PAGE = '/BNES_CustomerStories_Industrious';
    String CUSTOMER_STORIES_WDS_VF_PAGE = '/BN_CustomerStories_WDS';
    String CLUB_LANDING_VF_PAGE = '/BNES_LP_Club';
    String COWORKING_LANDING_VF_PAGE = '/BNES_LP_CoWorking';
    String HOSTEL_LANDING_VF_PAGE = '/BNES_LP_Hostels';
    String STORAGE_LANDING_VF_PAGE = '/BNES_LP_Storage';
    String STUDENTHOUSING_LANDING_VF_PAGE = '/BNES_LP_StudentHousing';
    String RESTAURANT_LANDING_VF_PAGE = '/BNES_LP_Restaurant';
    String PARKING_LANDING_VF_PAGE = '/BNES_LP_Parking';
    String HOTEL_LANDING_VF_PAGE = '/BNES_LP_Hotels';
    String PROPERTY_LANDING_VF_PAGE = '/BNES_LP_PropertyManagers';
    String EVENT_LANDING_VF_PAGE = '/BNES_LP_Event';
    String SENIOR_LANDING_VF_PAGE = '/BNES_LP_Senior';
    String VACATION_LANDING_VF_PAGE = '/BNES_LP_Vacation';
    String VILLA_LANDING_VF_PAGE = '/BNES_LP_Villa';
    String GOVERNMENT_LANDING_VF_PAGE = '/BNES_LP_Government';
    String NONPROFIT_LANDING_VF_PAGE = '/BN_LP_NonProfit';
    String CAREER_THANKYOU_VF_PAGE = '/BN_ThankYou2';
    String COMPETITIVE_MATRIX_VF_PAGE = '/BN_Matrix';
    String GLANCE_VF_PAGE = '/BN_Glance';
    String CONFERENCE_VF_PAGE = '/BN_Conference';
    String TOUR_VF_PAGE = '/BN_FeatureSpotlights';
    String TOUR_AVAILABILITY_VF_PAGE = '/BN_FeatureSpotlight_AvailabilityGrid';
    String TOUR_BE_VF_PAGE = '/BN_FeatureSpotlight_BE';
    String TOUR_CM_VF_PAGE = '/BN_FeatureSpotlight_Channel';
    String TOUR_EA_VF_PAGE = '/BN_FeatureSpotlight_Einstein';
    String TOUR_ESIGN_VF_PAGE = '/BN_FeatureSpotlight_ESign';
    String TOUR_MOBILE_VF_PAGE = '/BN_FeatureSpotlight_Mobile';
    String TOUR_PAYMENT_VF_PAGE = '/BN_FeatureSpotlight_Payment';
    String TOUR_POS_VF_PAGE = '/BN_FeatureSpotlight_POS';
    String TOUR_REPORT_VF_PAGE = '/BN_FeatureSpotlight_Report';
    String TOUR_RRC_VF_PAGE = '/BN_FeatureSpotlight_RRC';
    String TOUR_TICKET_VF_PAGE = '/BN_FeatureSpotlight_Ticket';
    String TOUR_TWILIO_VF_PAGE = '/BN_FeatureSpotlight_Twilio';
    String TOUR_ACCESSCONTROL_VF_PAGE = '/BN_FeatureSpotlight_AccessControl';
    String TOUR_APPEXCHANGE_VF_PAGE = '/BN_FeatureSpotlight_Appexchange';
    String CAREER_SALESFORCEADMIN_VF_PAGE = '/BN_Career_SalesforceAdmin';
    String CAREER_SALESFORCEDEVELOPER_VF_PAGE = '/BN_Career_SalesforceDeveloper';
    String CAREER_FRONTENDDEVELOPER_VF_PAGE = '/BN_Career_FrontEndDeveloper';
    String CAREER_CONTENTWRITER_VF_PAGE = '/BN_Career_ContentWriter';
    String CAREER_SCRIPTWRITER_VF_PAGE = '/BN_Career_ScriptWriter';
    String CAREER_DESIGNER_VF_PAGE = '/BN_Career_Designer';
    String CAREER_GROWTHHACKER_VF_PAGE = '/BN_Career_GrowthHacker';
    String CAREER_PROJECTMANAGER_VF_PAGE = '/BN_Career_ProjectManager';
    String CAREER_ACCOUNTEXECUTIVE_VF_PAGE = '/BN_Career_AccountExecutive';
    String CAREER_MOBILEDEVELOPER_VF_PAGE = '/BN_Career_MobileDeveloper';
    String CAREER_CSR_VF_PAGE = '/BN_Career_CSR';
    String CAREER_SOCIALMEDIANINJA_VF_PAGE = '/BN_Career_SocialMediaNinja';
    String CAREER_SEONINJA_VF_PAGE = '/BN_Career_SEONinja';
    String BEST_HOTEL_PMS_VF_PAGE = '/BN_HotelPMS';
    String INTEREST_VF_PAGE = '/BN_Interest';
    String INTEREST_THANKYOU_VF_PAGE = '/BN_ThankYou3';
    String WAITLIST_VF_PAGE = '/BN_WaitList';
    String PMS_SALESFORCE_VF_PAGE = '/BN_PMS_Salesforce';
    String PREACTIVATIONFORM_VF_PAGE = '/BN_ActivationForm';
    String FORM_COVID19_VF_PAGE = '/BN_Form_Covid19';
    String FORM_GENHOSPITALITYSURVEY_VF_PAGE = '/BN_Form_GeneralHospitalitySurvey';
    String CHANNEL_LISTING_VF_PAGE = '/BN_ChannelListing';
    String REVIEWS_VF_PAGE = '/BNES_Reviews';
    String COVID19_VF_PAGE = '/BN_Covid19';
    String CONTACT_VF_PAGE = '/BN_Contact';
    String PARTNER_VF_PAGE = '/BN_Partners';
    String PARTNER_SALESFORCE_VF_PAGE = '/BN_Partners_Salesforce';
    String PARTNER_HFTP_VF_PAGE = '/BN_Partners_HFTP';
    String PARTNER_TWILIO_VF_PAGE = '/BN_Partners_Twilio';
    String PARTNER_CHANNELRUSH_VF_PAGE = '/BN_Partners_ChannelRush';
    String PARTNER_YIELD_VF_PAGE = '/BN_Partners_YieldPlanet';
    String PARTNER_ESIGN_VF_PAGE = '/BN_Partners_ESign';
    String PARTNER_LATINO_VF_PAGE = '/BN_Partners_Latino';
    String PARTNER_NABHOOD_VF_PAGE = '/BN_Partners_Nabhood';
    String SURVEYS_VF_PAGE = '/BN_Survey';
    String WEBINARS_VF_PAGE = '/BN_Webinars';
    String WEBINAR_VF_PAGE = '/BN_WebinarLeadForm?id=';
    String GUEST_POST_SUBMISSION_VF_PAGE = '/BN_GuestPost';
    String SUBMISSION_THANKYOU_VF_PAGE = '/BN_GuestPost_TY';
    String CHECKOUT_VF_PAGE = '/BN_CheckOut';
    String POS_CHECKOUT_VF_PAGE = '/BN_POS';
    String REFERRAL_PROGRAM_VF_PAGE = '/BN_ReferralProgram';
    String SITEMAP_VF_PAGE = '/BNES_Sitemap';
    
    // portal
    String PORTAL_HOME_VF_PAGE = '/BN_Portal_Home';
    String PORTAL_FORGOTPASSWORD_VF_PAGE = '/BN_Portal_ForgotPassword';
    String PORTAL_RESETPASSWORD_VF_PAGE = '/BN_Portal_ResetPassword?id=';
    String PORTAL_ACCOUNT_VF_PAGE = '/BN_Portal_Account';
    String PORTAL_PAYMENT_VF_PAGE = '/BN_Portal_PaymentHistory';
    String PORTAL_CARD_VF_PAGE = '/BN_Portal_Cards';
    String PORTAL_USER_VF_PAGE = '/BN_Portal_Users';
    String PORTAL_SERVICE_VF_PAGE = '/BN_Portal_Services';
    String PORTAL_CLIENTV2MOM_VF_PAGE = '/BN_Portal_ClientV2MOM';
    String PORTAL_VIDEOS_VF_PAGE = '/BN_Portal_Videos';
    
    
    global PageReference mapRequestUrl(PageReference myFriendlyUrl) {
        String url = myFriendlyUrl.getUrl();
        
        if(url.startsWith(ARTICLE_PAGE)) {
            String slug = url.substring(ARTICLE_PAGE.length(), url.length());
            String slugSearch = '%'+slug;
            Article__c article = [SELECT Id FROM Article__c WHERE Article_Link__c like :slugSearch LIMIT 1];
            if(article != null) {
                return new PageReference(ARTICLE_VF_PAGE + article.Id);
            }
        }
        if(url.startsWith(WEBINAR_PAGE)) {
            String nameUrl = url.substring(WEBINAR_PAGE.length(), url.length());
            String name = nameUrl.replaceAll('-', ' ');
            if(url.startsWith(WEBINAR_PAGE + nameUrl)) {
                Webinar__c webinar = [SELECT Id FROM Webinar__c WHERE Name = :name];
                return new PageReference(WEBINAR_VF_PAGE + webinar.Id);
            }
        }
        if(url.startsWith(PORTAL_RESETPASSWORD_PAGE)) {
            String userId = url.substring(PORTAL_RESETPASSWORD_PAGE.length(), url.length());
            if(url.startsWith(PORTAL_RESETPASSWORD_PAGE + userId)) {
                return new PageReference(PORTAL_RESETPASSWORD_VF_PAGE + userId);
            }
        }
       
        if(url == ADVANTAGES_PAGE) {
            return new PageReference(ADVANTAGES_VF_PAGE);
        }
        if(url == ARTIFICIAL_INTELLIGENCE_PAGE) {
            return new PageReference(ARTIFICIAL_INTELLIGENCE_VF_PAGE);
        }
        if(url.startsWith(AUTHOR_PAGE)) {
            String contactId = url.substring(AUTHOR_PAGE.length(), url.length());
            return new PageReference(AUTHOR_VF_PAGE + contactId);
        }
        if(url == BLOG_PAGE || url.startsWith(BLOG_PAGE + '?')) {
            if (url.startsWith(BLOG_PAGE + '?')){
                String querySearch = url.substring(BLOG_PAGE.length(), url.length());
                return new PageReference(BLOG_VF_PAGE + querySearch);
            } else {
                return new PageReference(BLOG_VF_PAGE);
            }
        }
        if(url == CORE_VALUES_PAGE) {
            return new PageReference(CORE_VALUES_VF_PAGE);
        }
        if(url == DATA_PAGE) {
            return new PageReference(DATA_VF_PAGE);
        }
        if(url == EINSTEIN_FORM_PAGE) {
            return new PageReference(EINSTEIN_FORM_VF_PAGE);
        }
        if(url == FAQS_PAGE) {
            return new PageReference(FAQS_VF_PAGE);
        }
        if(url == GALLERY_PAGE) {
            return new PageReference(GALLERY_VF_PAGE);
        }
        if(url == GDPR_PAGE) {
            return new PageReference(GDPR_VF_PAGE);
        }
        if(url == IMPLEMENTATION_PAGE) {
            return new PageReference(IMPLEMENTATION_VF_PAGE);
        }
        if(url == INDUSTRIAL_REVOLUTION_PAGE) {
            return new PageReference(INDUSTRIAL_REVOLUTION_VF_PAGE);
        }
        if(url == INTEGRATIONS_PAGE) {
            return new PageReference(INTEGRATIONS_VF_PAGE);
        }
        if(url == MYTHS_PAGE) {
            return new PageReference(MYTHS_VF_PAGE);
        }
        if(url == PROCESS_PAGE) {
            return new PageReference(PROCESS_VF_PAGE);
        }
        if(url == PRICING_PAGE) {
            return new PageReference(PRICING_VF_PAGE);
        }
        if(url == PRICING_PT_PAGE) {
            return new PageReference(PRICING_PT_VF_PAGE);
        }
        if(url == RESOURCES_PAGE) {
            return new PageReference(RESOURCES_VF_PAGE);
        }
        if(url == SOLUTIONS_PAGE) {
            return new PageReference(SOLUTIONS_VF_PAGE);
        }
        if(url == TIME_TO_THINK_PAGE) {
            return new PageReference(TIME_TO_THINK_VF_PAGE);
        }
        if(url == WHY_PAGE) {
            return new PageReference(WHY_VF_PAGE);
        }
        if(url == THANKYOU_PAGE) {
            return new PageReference(THANKYOU_VF_PAGE);
        }
        if(url == REGISTER_PAGE) {
            return new PageReference(REGISTER_VF_PAGE);
        }
        if(url == ABOUT_PAGE) {
            return new PageReference(ABOUT_VF_PAGE);
        }
        if(url == FORM_RATEMYPMS_PAGE) {
            return new PageReference(FORM_RATEMYPMS_VF_PAGE);
        }
        if(url == FORM_HOTELINDUSTRYSURVEY_PAGE) {
            return new PageReference(FORM_HOTELINDUSTRYSURVEY_VF_PAGE);
        }
        if(url == FORM_COVID19_PAGE) {
            return new PageReference(FORM_COVID19_VF_PAGE);
        }
        if(url == FORM_GENHOSPITALITYSURVEY_PAGE) {
            return new PageReference(FORM_GENHOSPITALITYSURVEY_VF_PAGE);
        }
        if(url == CAREER_PAGE) {
            return new PageReference(CAREER_VF_PAGE);
        }
        if(url == CAREER_APPLICATION_PAGE) {
            return new PageReference(CAREER_APPLICATION_VF_PAGE);
        }
        if(url == PMS_PAGE) {
            return new PageReference(PMS_VF_PAGE);
        }
        if(url == CONSULTATION_PAGE) {
            return new PageReference(CONSULTATION_VF_PAGE);
        }
        if(url == CONSULTATION_FORM_PAGE) {
            return new PageReference(CONSULTATION_FORM_VF_PAGE);
        }
        if(url == CALENDLY_PAGE) {
            return new PageReference(CALENDLY_VF_PAGE);
        }
        if(url == CUSTOMER_STORIES_PAGE) {
            return new PageReference(CUSTOMER_STORIES_VF_PAGE);
        }
        if(url == CUSTOMER_STORIES_HFTP_PAGE) {
            return new PageReference(CUSTOMER_STORIES_HFTP_VF_PAGE);
        }
        if(url == CUSTOMER_STORIES_CTY_PAGE) {
            return new PageReference(CUSTOMER_STORIES_CTY_VF_PAGE);
        }
        if(url == CUSTOMER_STORIES_INDUSTRIOUS_PAGE) {
            return new PageReference(CUSTOMER_STORIES_INDUSTRIOUS_VF_PAGE);
        }
        if(url == CUSTOMER_STORIES_WDS_PAGE) {
            return new PageReference(CUSTOMER_STORIES_WDS_VF_PAGE);
        }
        if(url == CLUB_LANDING_PAGE) {
            return new PageReference(CLUB_LANDING_VF_PAGE);
        }
        if(url == COWORKING_LANDING_PAGE) {
            return new PageReference(COWORKING_LANDING_VF_PAGE);
        }
        if(url == HOSTEL_LANDING_PAGE) {
            return new PageReference(HOSTEL_LANDING_VF_PAGE);
        }
        if(url == STORAGE_LANDING_PAGE) {
            return new PageReference(STORAGE_LANDING_VF_PAGE);
        }
        if(url == STUDENTHOUSING_LANDING_PAGE) {
            return new PageReference(STUDENTHOUSING_LANDING_VF_PAGE);
        }
        if(url == RESTAURANT_LANDING_PAGE) {
            return new PageReference(RESTAURANT_LANDING_VF_PAGE);
        }
        if(url == HOTEL_LANDING_PAGE) {
            return new PageReference(HOTEL_LANDING_VF_PAGE);
        }
        if(url == PROPERTY_LANDING_PAGE) {
            return new PageReference(PROPERTY_LANDING_VF_PAGE);
        }
        if(url == PARKING_LANDING_PAGE) {
            return new PageReference(PARKING_LANDING_VF_PAGE);
        }
        if(url == EVENT_LANDING_PAGE) {
            return new PageReference(EVENT_LANDING_VF_PAGE);
        }
        if(url == SENIOR_LANDING_PAGE) {
            return new PageReference(SENIOR_LANDING_VF_PAGE);
        }
        if(url == VACATION_LANDING_PAGE) {
            return new PageReference(VACATION_LANDING_VF_PAGE);
        }
        if(url == VILLA_LANDING_PAGE) {
            return new PageReference(VILLA_LANDING_VF_PAGE);
        }
        if(url == GOVERNMENT_LANDING_PAGE) {
            return new PageReference(GOVERNMENT_LANDING_VF_PAGE);
        }
        if(url == NONPROFIT_LANDING_PAGE) {
            return new PageReference(NONPROFIT_LANDING_VF_PAGE);
        }
        if(url == COMPETITIVE_MATRIX_PAGE) {
            return new PageReference(COMPETITIVE_MATRIX_VF_PAGE);
        }
        if(url == GLANCE_PAGE) {
            return new PageReference(GLANCE_VF_PAGE);
        }
        if(url == CAREER_THANKYOU_PAGE) {
            return new PageReference(CAREER_THANKYOU_VF_PAGE);
        }
        if(url == CONFERENCE_PAGE) {
            return new PageReference(CONFERENCE_VF_PAGE);
        }
        if(url == TOUR_PAGE) {
            return new PageReference(TOUR_VF_PAGE);
        }
        if(url == TOUR_AVAILABILITY_PAGE) {
            return new PageReference(TOUR_AVAILABILITY_VF_PAGE);
        }
        if(url == TOUR_BE_PAGE) {
            return new PageReference(TOUR_BE_VF_PAGE);
        }
        if(url == TOUR_CM_PAGE) {
            return new PageReference(TOUR_CM_VF_PAGE);
        }
        if(url == TOUR_EA_PAGE) {
            return new PageReference(TOUR_EA_VF_PAGE);
        }
        if(url == TOUR_ESIGN_PAGE) {
            return new PageReference(TOUR_ESIGN_VF_PAGE);
        }
        if(url == TOUR_MOBILE_PAGE) {
            return new PageReference(TOUR_MOBILE_VF_PAGE);
        }
        if(url == TOUR_PAYMENT_PAGE) {
            return new PageReference(TOUR_PAYMENT_VF_PAGE);
        }
        if(url == TOUR_POS_PAGE) {
            return new PageReference(TOUR_POS_VF_PAGE);
        }
        if(url == TOUR_REPORT_PAGE) {
            return new PageReference(TOUR_REPORT_VF_PAGE);
        }
        if(url == TOUR_RRC_PAGE) {
            return new PageReference(TOUR_RRC_VF_PAGE);
        }
        if(url == TOUR_TICKET_PAGE) {
            return new PageReference(TOUR_TICKET_VF_PAGE);
        }
        if(url == TOUR_TWILIO_PAGE) {
            return new PageReference(TOUR_TWILIO_VF_PAGE);
        }
        if(url == TOUR_ACCESSCONTROL_PAGE) {
            return new PageReference(TOUR_ACCESSCONTROL_VF_PAGE);
        }
        if(url == TOUR_APPEXCHANGE_PAGE) {
            return new PageReference(TOUR_APPEXCHANGE_VF_PAGE);
        }
        if(url == CAREER_SALESFORCEADMIN_PAGE) {
            return new PageReference(CAREER_SALESFORCEADMIN_VF_PAGE);
        }
        if(url == CAREER_SALESFORCEDEVELOPER_PAGE) {
            return new PageReference(CAREER_SALESFORCEDEVELOPER_VF_PAGE);
        }
        if(url == CAREER_FRONTENDDEVELOPER_PAGE) {
            return new PageReference(CAREER_FRONTENDDEVELOPER_VF_PAGE);
        }
        if(url == CAREER_CONTENTWRITER_PAGE) {
            return new PageReference(CAREER_CONTENTWRITER_VF_PAGE);
        }
        if(url == CAREER_SCRIPTWRITER_PAGE) {
            return new PageReference(CAREER_SCRIPTWRITER_VF_PAGE);
        }
        if(url == CAREER_DESIGNER_PAGE) {
            return new PageReference(CAREER_DESIGNER_VF_PAGE);
        }
        if(url == CAREER_GROWTHHACKER_PAGE) {
            return new PageReference(CAREER_GROWTHHACKER_VF_PAGE);
        }
        if(url == CAREER_PROJECTMANAGER_PAGE) {
            return new PageReference(CAREER_PROJECTMANAGER_VF_PAGE);
        }
        if(url == CAREER_ACCOUNTEXECUTIVE_PAGE) {
            return new PageReference(CAREER_ACCOUNTEXECUTIVE_VF_PAGE);
        }
        if(url == CAREER_MOBILEDEVELOPER_PAGE) {
            return new PageReference(CAREER_MOBILEDEVELOPER_VF_PAGE);
        }
        if(url == CAREER_CSR_PAGE) {
            return new PageReference(CAREER_CSR_VF_PAGE);
        }
        if(url == CAREER_SOCIALMEDIANINJA_PAGE) {
            return new PageReference(CAREER_SOCIALMEDIANINJA_VF_PAGE);
        }
        if(url == CAREER_SEONINJA_PAGE) {
            return new PageReference(CAREER_SEONINJA_VF_PAGE);
        }
        if(url == BEST_HOTEL_PMS_PAGE) {
            return new PageReference(BEST_HOTEL_PMS_VF_PAGE);
        }
        if(url == INTEREST_PAGE) {
            return new PageReference(INTEREST_VF_PAGE);
        }
        if(url == INTEREST_THANKYOU_PAGE) {
            return new PageReference(INTEREST_THANKYOU_VF_PAGE);
        }
        if(url == WAITLIST_PAGE) {
            return new PageReference(WAITLIST_VF_PAGE);
        }
        if(url == PMS_SALESFORCE_PAGE) {
            return new PageReference(PMS_SALESFORCE_VF_PAGE);
        }
        if(url == PREACTIVATIONFORM_PAGE) {
            return new PageReference(PREACTIVATIONFORM_VF_PAGE);
        }
        if(url == CHANNEL_LISTING_PAGE) {
            return new PageReference(CHANNEL_LISTING_VF_PAGE);
        }
        if(url == REVIEWS_PAGE) {
            return new PageReference(REVIEWS_VF_PAGE);
        }
        if(url == COVID19_PAGE) {
            return new PageReference(COVID19_VF_PAGE);
        }
        if(url == CONTACT_PAGE) {
            return new PageReference(CONTACT_VF_PAGE);
        }
        if(url == PARTNER_PAGE) {
            return new PageReference(PARTNER_VF_PAGE);
        }
        if(url == PARTNER_SALESFORCE_PAGE) {
            return new PageReference(PARTNER_SALESFORCE_VF_PAGE);
        }
        if(url == PARTNER_HFTP_PAGE) {
            return new PageReference(PARTNER_HFTP_VF_PAGE);
        }
        if(url == PARTNER_TWILIO_PAGE) {
            return new PageReference(PARTNER_TWILIO_VF_PAGE);
        }
        if(url == PARTNER_CHANNELRUSH_PAGE) {
            return new PageReference(PARTNER_CHANNELRUSH_VF_PAGE);
        }
        if(url == PARTNER_YIELD_PAGE) {
            return new PageReference(PARTNER_YIELD_VF_PAGE);
        }
        if(url == PARTNER_ESIGN_PAGE) {
            return new PageReference(PARTNER_ESIGN_VF_PAGE);
        }
        if(url == PARTNER_LATINO_PAGE) {
            return new PageReference(PARTNER_LATINO_VF_PAGE);
        }
        if(url == PARTNER_NABHOOD_PAGE) {
            return new PageReference(PARTNER_NABHOOD_VF_PAGE);
        }
        if(url == SURVEYS_PAGE) {
            return new PageReference(SURVEYS_VF_PAGE);
        }
        if(url == WEBINARS_PAGE) {
            return new PageReference(WEBINARS_VF_PAGE);
        }
        if(url == GUEST_POST_SUBMISSION_PAGE) {
            return new PageReference(GUEST_POST_SUBMISSION_VF_PAGE);
        }
        if(url == SUBMISSION_THANKYOU_PAGE) {
            return new PageReference(SUBMISSION_THANKYOU_VF_PAGE);
        }
        if(url == CHECKOUT_PAGE) {
            return new PageReference(CHECKOUT_VF_PAGE);
        }
        if(url == POS_CHECKOUT_PAGE) {
            return new PageReference(POS_CHECKOUT_VF_PAGE);
        }
        if(url == REFERRAL_PROGRAM_PAGE) {
            return new PageReference(REFERRAL_PROGRAM_VF_PAGE);
        }
        if(url == SITEMAP_PAGE) {
            return new PageReference(SITEMAP_VF_PAGE);
        }
        
        //portal
        if(url == PORTAL_HOME_PAGE || url == '/login?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_HOME_VF_PAGE);
        }
        if(url == PORTAL_FORGOTPASSWORD_PAGE || url == '/forgot-password?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_FORGOTPASSWORD_VF_PAGE);
        }
        if(url == PORTAL_ACCOUNT_PAGE || url == '/portal?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_ACCOUNT_VF_PAGE);
        }
        if(url == PORTAL_PAYMENT_PAGE || url == '/portal/payments?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_PAYMENT_VF_PAGE);
        }
        if(url == PORTAL_CARD_PAGE || url == '/portal/cards?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_CARD_VF_PAGE);
        }
        if(url == PORTAL_USER_PAGE || url == '/portal/users?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_USER_VF_PAGE);
        }
        if(url == PORTAL_SERVICE_PAGE || url == '/portal/services?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_SERVICE_VF_PAGE);
        }
        if(url == PORTAL_CLIENTV2MOM_PAGE || url == '/portal/v2mom?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_CLIENTV2MOM_VF_PAGE);
        }
        if(url == PORTAL_VIDEOS_PAGE || url == '/portal/videos?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_VIDEOS_VF_PAGE);
        }
        
        return null;
    }
            
    global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls) {
        //A list of pages to return after all the links have been evaluated
        List<PageReference> myFriendlyUrls = new List<PageReference>();
        
        // loop through all the urls once, finding all the valid ids
        for(PageReference mySalesforceUrl : mySalesforceUrls) {
            //Get the URL of the page
            String url = mySalesforceUrl.getUrl();
            
            if(url.startsWith(ARTICLE_VF_PAGE)) {
                String id = url.substring(ARTICLE_VF_PAGE.length(), url.length());
                if(url.startsWith(ARTICLE_VF_PAGE + id)) {
                    String slugUrl = [SELECT Article_Link__c FROM Article__c WHERE Id = :id].Article_Link__c;
                    List<String> slugList = slugUrl.split(ARTICLE_PAGE);
                    String slug = slugList.get(slugList.size() - 1);
                    
                    myFriendlyUrls.add(new PageReference(ARTICLE_PAGE + slug));
                }
            }
            else if(url.startsWith(WEBINAR_VF_PAGE)) {
                String id = url.substring(WEBINAR_VF_PAGE.length(), url.length());
                if(url.startsWith(WEBINAR_VF_PAGE + id)) {
                    String name = [SELECT Name FROM Webinar__c WHERE Id = :id].Name;
                    String urlName = name.replaceAll(' ', '-').toLowerCase();
                    
                    myFriendlyUrls.add(new PageReference(WEBINAR_PAGE + urlName));
                }
            }
            else if(url.startsWith(PORTAL_RESETPASSWORD_VF_PAGE)) {
                String userId = url.substring(PORTAL_RESETPASSWORD_VF_PAGE.length(), url.length());
                if(url.startsWith(PORTAL_RESETPASSWORD_VF_PAGE + userId)) {
                    myFriendlyUrls.add(new PageReference(PORTAL_RESETPASSWORD_PAGE + userId));
                }
            }
            else if(url == ADVANTAGES_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(ADVANTAGES_PAGE));
            }
            else if(url == ARTIFICIAL_INTELLIGENCE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(ARTIFICIAL_INTELLIGENCE_PAGE));
            }
            else if(url.startsWith(AUTHOR_VF_PAGE)) {
                String contactId = url.substring(AUTHOR_VF_PAGE.length(), url.length());
                myFriendlyUrls.add(new PageReference(AUTHOR_PAGE + contactId));
            }
            else if(url == BLOG_VF_PAGE || url.startsWith(BLOG_VF_PAGE.toLowerCase() + '?')) {
                if (url.startsWith(BLOG_VF_PAGE.toLowerCase() + '?')) {
                    String querySearch = url.substring(BLOG_VF_PAGE.length() + 1, url.length());
                    myFriendlyUrls.add(new PageReference(BLOG_PAGE + querySearch));
                } else {
                    myFriendlyUrls.add(new PageReference(BLOG_PAGE));
                }
            }
            else if(url == CORE_VALUES_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CORE_VALUES_PAGE));
            }
            else if(url == DATA_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(DATA_PAGE));
            }
            else if(url == EINSTEIN_FORM_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(EINSTEIN_FORM_PAGE));
            }
            else if(url == FAQS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FAQS_PAGE));
            }
            else if(url == GALLERY_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(GALLERY_PAGE));
            }
            else if(url == GDPR_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(GDPR_PAGE));
            }
            else if(url == IMPLEMENTATION_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(IMPLEMENTATION_PAGE));
            }
            else if(url == INDUSTRIAL_REVOLUTION_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(INDUSTRIAL_REVOLUTION_PAGE));
            }
            else if(url == INTEGRATIONS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(INTEGRATIONS_PAGE));
            }
            else if(url == MYTHS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(MYTHS_PAGE));
            }
            else if(url == PROCESS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PROCESS_PAGE));
            }
            else if(url == PRICING_PT_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PRICING_PT_PAGE));
            }
            else if(url == PRICING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PRICING_PAGE));
            }
            else if(url == RESOURCES_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(RESOURCES_PAGE));
            }
            else if(url == SOLUTIONS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(SOLUTIONS_PAGE));
            }
            else if(url == TIME_TO_THINK_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TIME_TO_THINK_PAGE));
            }
            else if(url == WHY_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(WHY_PAGE));
            }
            else if(url == REGISTER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(REGISTER_PAGE));
            }
            else if(url == THANKYOU_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(THANKYOU_PAGE));
            }
            else if(url == ABOUT_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(ABOUT_PAGE));
            }
            else if(url == FORM_RATEMYPMS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FORM_RATEMYPMS_PAGE));
            }
            else if(url == FORM_HOTELINDUSTRYSURVEY_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FORM_HOTELINDUSTRYSURVEY_PAGE));
            }
            else if(url == FORM_COVID19_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FORM_COVID19_PAGE));
            }
            else if(url == FORM_GENHOSPITALITYSURVEY_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FORM_GENHOSPITALITYSURVEY_PAGE));
            }
            else if(url == CAREER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_PAGE));
            }
            else if(url == CAREER_APPLICATION_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_APPLICATION_PAGE));
            }
            else if(url == PMS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PMS_PAGE));
            }
            else if(url == CONSULTATION_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CONSULTATION_PAGE));
            }
            else if(url == CONSULTATION_FORM_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CONSULTATION_FORM_PAGE));
            }
            else if(url == CALENDLY_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CALENDLY_PAGE));
            }
            else if(url == CLUB_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CLUB_LANDING_PAGE));
            }
            else if(url == COWORKING_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(COWORKING_LANDING_PAGE));
            }
            else if(url == HOSTEL_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(HOSTEL_LANDING_PAGE));
            }
            else if(url == STORAGE_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(STORAGE_LANDING_PAGE));
            }
            else if(url == STUDENTHOUSING_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(STUDENTHOUSING_LANDING_PAGE));
            }
            else if(url == RESTAURANT_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(RESTAURANT_LANDING_PAGE));
            }
            else if(url == PARKING_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PARKING_LANDING_PAGE));
            }
            else if(url == HOTEL_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(HOTEL_LANDING_PAGE));
            }
            else if(url == PROPERTY_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PROPERTY_LANDING_PAGE));
            }
            else if(url == EVENT_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(EVENT_LANDING_PAGE));
            }
            else if(url == SENIOR_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(SENIOR_LANDING_PAGE));
            }
            else if(url == VACATION_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(VACATION_LANDING_PAGE));
            }
            else if(url == VILLA_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(VILLA_LANDING_PAGE));
            }
            else if(url == GOVERNMENT_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(GOVERNMENT_LANDING_PAGE));
            }
            else if(url == NONPROFIT_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(NONPROFIT_LANDING_PAGE));
            }
            else if(url == COMPETITIVE_MATRIX_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(COMPETITIVE_MATRIX_PAGE));
            }
            else if(url == GLANCE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(GLANCE_PAGE));
            }
            else if(url == CUSTOMER_STORIES_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CUSTOMER_STORIES_PAGE));
            }
            else if(url == CUSTOMER_STORIES_HFTP_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CUSTOMER_STORIES_HFTP_PAGE));
            }
            else if(url == CUSTOMER_STORIES_CTY_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CUSTOMER_STORIES_CTY_PAGE));
            }
            else if(url == CUSTOMER_STORIES_INDUSTRIOUS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CUSTOMER_STORIES_INDUSTRIOUS_PAGE));
            }
            else if(url == CUSTOMER_STORIES_WDS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CUSTOMER_STORIES_WDS_PAGE));
            }
            else if(url == CAREER_THANKYOU_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_THANKYOU_PAGE));
            }
            else if(url == CONFERENCE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CONFERENCE_PAGE));
            }
            else if(url == TOUR_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_PAGE));
            }
            else if(url == TOUR_AVAILABILITY_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_AVAILABILITY_PAGE));
            }
            else if(url == TOUR_BE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_BE_PAGE));
            }
            else if(url == TOUR_CM_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_CM_PAGE));
            }
            else if(url == TOUR_EA_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_EA_PAGE));
            }
            else if(url == TOUR_ESIGN_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_ESIGN_PAGE));
            }
            else if(url == TOUR_MOBILE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_MOBILE_PAGE));
            }
            else if(url == TOUR_PAYMENT_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_PAYMENT_PAGE));
            }
            else if(url == TOUR_POS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_POS_PAGE));
            }
            else if(url == TOUR_REPORT_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_REPORT_PAGE));
            }
            else if(url == TOUR_RRC_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_RRC_PAGE));
            }
            else if(url == TOUR_TICKET_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_TICKET_PAGE));
            }
            else if(url == TOUR_TWILIO_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_TWILIO_PAGE));
            }
            else if(url == TOUR_ACCESSCONTROL_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_ACCESSCONTROL_PAGE));
            }
            else if(url == TOUR_APPEXCHANGE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TOUR_APPEXCHANGE_PAGE));
            }
            else if(url == CAREER_SALESFORCEADMIN_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_SALESFORCEADMIN_PAGE));
            }
            else if(url == CAREER_SALESFORCEDEVELOPER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_SALESFORCEDEVELOPER_PAGE));
            }
            else if(url == CAREER_FRONTENDDEVELOPER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_FRONTENDDEVELOPER_PAGE));
            }
            else if(url == CAREER_SCRIPTWRITER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_SCRIPTWRITER_PAGE));
            }
            else if(url == CAREER_CONTENTWRITER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_CONTENTWRITER_PAGE));
            }
            else if(url == CAREER_DESIGNER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_DESIGNER_PAGE));
            }
            else if(url == CAREER_GROWTHHACKER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_GROWTHHACKER_PAGE));
            }
            else if(url == CAREER_PROJECTMANAGER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_PROJECTMANAGER_PAGE));
            }
            else if(url == CAREER_ACCOUNTEXECUTIVE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_ACCOUNTEXECUTIVE_PAGE));
            }
            else if(url == CAREER_MOBILEDEVELOPER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_MOBILEDEVELOPER_PAGE));
            }
            else if(url == CAREER_CSR_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_CSR_PAGE));
            }
            else if(url == CAREER_SOCIALMEDIANINJA_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_SOCIALMEDIANINJA_PAGE));
            }
            else if(url == CAREER_SEONINJA_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CAREER_SEONINJA_PAGE));
            }
            else if(url == BEST_HOTEL_PMS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(BEST_HOTEL_PMS_PAGE));
            }
            else if(url == INTEREST_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(INTEREST_PAGE));
            }
            else if(url == INTEREST_THANKYOU_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(INTEREST_THANKYOU_PAGE));
            }
            else if(url == WAITLIST_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(WAITLIST_PAGE));
            }
            else if(url == PMS_SALESFORCE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PMS_SALESFORCE_PAGE));
            }
            else if(url == PREACTIVATIONFORM_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PREACTIVATIONFORM_PAGE));
            }
            else if(url == CHANNEL_LISTING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CHANNEL_LISTING_PAGE));
            }
            else if(url == REVIEWS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(REVIEWS_PAGE));
            }
            else if(url == COVID19_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(COVID19_PAGE));
            }
            else if(url == CONTACT_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CONTACT_PAGE));
            }
            else if(url == PARTNER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PARTNER_PAGE));
            }
            else if(url == PARTNER_SALESFORCE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PARTNER_SALESFORCE_PAGE));
            }
            else if(url == PARTNER_HFTP_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PARTNER_HFTP_PAGE));
            }
            else if(url == PARTNER_TWILIO_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PARTNER_TWILIO_PAGE));
            }
            else if(url == PARTNER_CHANNELRUSH_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PARTNER_CHANNELRUSH_PAGE));
            }
            else if(url == PARTNER_YIELD_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PARTNER_YIELD_PAGE));
            }
            else if(url == PARTNER_ESIGN_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PARTNER_ESIGN_PAGE));
            }
            else if(url == PARTNER_LATINO_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PARTNER_LATINO_PAGE));
            }
            else if(url == PARTNER_NABHOOD_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PARTNER_NABHOOD_PAGE));
            }
            else if(url == SURVEYS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(SURVEYS_PAGE));
            }
            else if(url == WEBINARS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(WEBINARS_PAGE));
            }
            else if(url == GUEST_POST_SUBMISSION_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(GUEST_POST_SUBMISSION_PAGE));
            }
            else if(url == SUBMISSION_THANKYOU_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(SUBMISSION_THANKYOU_PAGE));
            }
            else if(url == CHECKOUT_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(CHECKOUT_PAGE));
            }
            else if(url == POS_CHECKOUT_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(POS_CHECKOUT_PAGE));
            }
            else if(url == REFERRAL_PROGRAM_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(REFERRAL_PROGRAM_PAGE));
            }
            else if(url == SITEMAP_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(SITEMAP_PAGE));
            }
            // portal
            else if(url == PORTAL_HOME_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PORTAL_HOME_PAGE));
            }
            else if(url == PORTAL_FORGOTPASSWORD_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PORTAL_FORGOTPASSWORD_PAGE));
            }
            else if(url == PORTAL_ACCOUNT_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PORTAL_ACCOUNT_PAGE));
            }
            else if(url == PORTAL_PAYMENT_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PORTAL_PAYMENT_PAGE));
            }
            else if(url == PORTAL_CARD_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PORTAL_CARD_PAGE));
            }
            else if(url == PORTAL_USER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PORTAL_USER_PAGE));
            }
            else if(url == PORTAL_SERVICE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PORTAL_SERVICE_PAGE));
            }
            else if(url == PORTAL_CLIENTV2MOM_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PORTAL_CLIENTV2MOM_PAGE));
            }
            else if(url == PORTAL_VIDEOS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PORTAL_VIDEOS_PAGE));
            }
            else {
                myFriendlyUrls.add(mySalesforceUrl);
            }
        }
    
        //Return the full list of pages
        return myFriendlyUrls;
    }

}