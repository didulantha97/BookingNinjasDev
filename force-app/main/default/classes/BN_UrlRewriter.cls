global class BN_UrlRewriter implements Site.UrlRewriter {

    String regEx = '[^a-zA-Z0-9]';

    // Variables to represent the user-friendly URLs
    String PORTUGESE_INDEX = '/ep';
    String SPANISH_INDEX = '/es';
    String ABOUT_PAGE = '/about-us';
    String ADVANTAGES_PAGE = '/advantages-of-our-property-management-system';
    String ARTICLE_PAGE = '/blog/';
    String ARTIFICIAL_INTELLIGENCE_PAGE = '/einstein-analytics-integration';
    String AUTHOR_PAGE = '/author/';
    String BEST_HOTEL_PMS_PAGE = '/one-platform-for-all-property-operations';
    String BLOG_PAGE = '/blog';
    String CALENDLY_PAGE = '/schedule-an-appointment';
    String CAREER_ACCOUNTEXECUTIVE_PAGE = '/careers/account-executives';
    String CAREER_APPLICATION_PAGE = '/career-application';
    String CAREER_CONTENTWRITER_PAGE = '/careers/content-writers';
    String CAREER_CSR_PAGE = '/careers/customer-service-representatives';
    String CAREER_DESIGNER_PAGE = '/careers/designers';
    String CAREER_FRONTENDDEVELOPER_PAGE = '/careers/front-end-developers';
    String CAREER_GROWTHHACKER_PAGE = '/careers/growth-hackers';
    String CAREER_MOBILEDEVELOPER_PAGE = '/careers/mobile-developers';
    String CAREER_PAGE = '/booking-ninjas-careers';
    String CAREER_DETAILS_PAGE = '/career/details';
    String CAREER_PROJECTMANAGER_PAGE = '/careers/project-managers';
    String CAREER_SALESFORCEADMIN_PAGE = '/careers/salesforce-admins';
    String CAREER_SALESFORCEDEVELOPER_PAGE = '/careers/salesforce-developers';
    String CAREER_SCRIPTWRITER_PAGE = '/careers/script-writers';
    String CAREER_SEONINJA_PAGE = '/careers/seo-ninjas';
    String CAREER_SOCIALMEDIANINJA_PAGE = '/careers/social-media-ninjas';
    String CAREER_THANKYOU_PAGE = '/thank-you-for-your-interest';
    String CHANNEL_LISTING_PAGE = '/third-party-hotel-booking-sites-integration';
    String CHECKOUT_PAGE = '/checkout';
    String CHECKOUT_SUCCEED_PAGE = '/order-successful?id=';
    String CLUB_LANDING_PAGE = '/club-management-software';
    String COMPETITIVE_MATRIX_PAGE = '/compare-property-management-software';
    String CONFERENCE_PAGE = '/conference';
    String CONSULTATION_FORM_PAGE = '/salesforce-consulting-services-form';
    String CONSULTATION_PAGE = '/salesforce-consulting-services';
    String CONTACT_PAGE = '/contact-us';
    String CORE_VALUES_PAGE = '/core-values-of-booking-ninjas-product';
    String COVID19_PAGE = '/covid-19';
    String COWORKING_LANDING_PAGE = '/coworking-space-management-software';
    String CUSTOMER_STORIES_CTY_PAGE = '/customer-story/cty-books';
    String CUSTOMER_STORIES_HFTP_PAGE = '/customer-story/hftp-south-florida';
    String CUSTOMER_STORIES_INDUSTRIOUS_PAGE = '/customer-story/industrious-office';
    String CUSTOMER_STORIES_PAGE = '/customer-stories';
    String CUSTOMER_STORIES_DETAIL_PAGE = '/customer-story/';
    String CUSTOMER_STORIES_WDS_PAGE = '/customer-story/worldwide-properties';
    String DATA_PAGE = '/automatic-data-processing-system';
    String EINSTEIN_FORM_PAGE = '/einstein-form';
    String EVENT_LANDING_PAGE = '/event-management-software';
    String FAQS_PAGE = '/faqs';
    String FORM_COVID19_PAGE = '/surveys/covid-19';
    String FORM_GENHOSPITALITYSURVEY_PAGE = '/surveys/general-hospitality';
    String FORM_HOTELINDUSTRYSURVEY_PAGE = '/surveys/hotel-industry';
    String FORM_RATEMYPMS_PAGE = '/surveys/rate-my-pms';
    String GALLERY_PAGE = '/booking-ninjas-pms-case-studies';
    String GDPR_PAGE = '/gdpr-compliance';
    String GLANCE_PAGE = '/capabilities-of-booking-ninjas-product';
    String GOVERNMENT_LANDING_PAGE = '/government-property-management-software';
    String GUEST_POST_SUBMISSION_PAGE = '/guest-post-submission';
    String HOSTEL_LANDING_PAGE = '/hostel-management-system';
    String HOTEL_LANDING_PAGE = '/hotel-management-software';
    String HOTEL_TRIAL_LANDING_PAGE = '/hotel-property-management-software-free-trial';
    String IMPLEMENTATION_PAGE = '/pms-implementation';
    String INDUSTRIAL_REVOLUTION_PAGE = '/industrial-revolution';
    String INTEGRATIONS_PAGE = '/pms-integration';
    String INTEREST_PAGE = '/expression-of-interest';
    String INTEREST_THANKYOU_PAGE = '/thank-you-for-expressing-your-interest';
    String LP_TRIAL_PAGE = '/14-day-free-trial-ppc';
    String MYTHS_PAGE = '/myths';
    String NONPROFIT_LANDING_PAGE = '/non-profit-property-management-software';
    String PARKING_LANDING_PAGE = '/parking-management-system';
    String PARTNER_CHANNELRUSH_PAGE = '/partners/channelrush';
    String PARTNER_ESIGN_PAGE = '/partners/esign-genie';
    String PARTNER_HFTP_PAGE = '/partners/hftp';
    String PARTNER_LATINO_PAGE = '/partners/latino-hotel-association';
    String PARTNER_NABHOOD_PAGE = '/partners/nabhood';
    String PARTNER_PAGE = '/partners';
    String PARTNER_SALESFORCE_PAGE = '/partners/salesforce';
    String PARTNER_TWILIO_PAGE = '/partners/twilio';
    String PARTNER_YIELD_PAGE = '/partners/yieldplanet';
    String PMS_PAGE = '/pms-software';
    String PMS_SALESFORCE_PAGE = '/integration-with-salesforce-platform';
    String POS_CHECKOUT_PAGE = '/pos-checkout';
    String PREACTIVATIONFORM_PAGE = '/pre-activation-form';
    String PRICING_PAGE = '/pricing';
    String PRICING_PT_PAGE = '/pt/pricing';
    String PRIVACY_PAGE = '/privacy-policy';
    String PROCESS_PAGE = '/buying-process';
    String PROPERTY_LANDING_PAGE = '/software-for-property-managers';
    String REFERRAL_PROGRAM_PAGE = '/referral-program';
    String REGISTER_PAGE = '/14-day-free-trial';
    String RESOURCES_PAGE = '/resources';
    String RESTAURANT_LANDING_PAGE = '/restaurant-management-system';
    String REVIEWS_PAGE = '/leave-your-feedback';
    String SENIOR_LANDING_PAGE = '/senior-assisted-living-software';
    String SITEMAP_PAGE = '/sitemap.xml';
    String SOLUTIONS_PAGE = '/solutions-for-property-management';
    String STORAGE_LANDING_PAGE = '/self-storage-management-software';
    String STUDENTHOUSING_LANDING_PAGE = '/student-housing-property-management-software';
    String SUBMISSION_THANKYOU_PAGE = '/thank-you-for-your-submission';
    String SURVEYS_PAGE = '/surveys';
    String TERMS_PAGE = '/terms-and-conditions';
    String THANKYOU_PAGE = '/thank-you?id=';
    String TIME_TO_THINK_PAGE = '/time-to-think';
    String FEATURE_ACCESSCONTROL_PAGE = '/features/hotel-door-access-control-system';
    String FEATURE_AMS_DETAILS_PAGE = '/features/accounting-management-system-details';
    String FEATURE_AMS_PAGE = '/features/accounting-management-system';
    String FEATURE_APPEXCHANGE_PAGE = '/features/salesforce-appexchange-integration';
    String FEATURE_AVAILABILITY_DETAILS_PAGE = '/features/reservation-management-system-details';
    String FEATURE_AVAILABILITY_PAGE = '/features/reservation-management-system';
    String FEATURE_BE_DETAILS_PAGE = '/features/hotel-booking-engine-details';
    String FEATURE_BE_PAGE = '/features/hotel-booking-engine';
    String FEATURE_CM_PAGE = '/features/hotel-channel-manager';
    String FEATURE_CS_DETAILS_PAGE = '/features/communication-services-details';
    String FEATURE_CS_PAGE = '/features/communication-services';
    String FEATURE_EA_PAGE = '/features/einstein-analytics';
    String FEATURE_ESIGN_PAGE = '/features/electronic-signature-software';
    String FEATURE_MOBILE_PAGE = '/features/pms-mobile-apps';
    String FEATURE_PAGE = '/features';
    String FEATURE_CORE_PAGE = '/features/core';
    String FEATURE_PAYMENT_PAGE = '/features/advance-payment-features';
    String FEATURE_PI_DETAILS_PAGE = '/features/payment-integrations-details';
    String FEATURE_PI_PAGE = '/features/payment-integrations';
    String FEATURE_POS_PAGE = '/features/point-of-sales-software';
    String FEATURE_REPORT_PAGE = '/features/custom-reporting-software';
    String FEATURE_RRC_DETAILS_PAGE = '/features/room-booking-software-details';
    String FEATURE_RRC_PAGE = '/features/room-booking-software';
    String FEATURE_TICKET_PAGE = '/features/event-ticketing-system';
    String FEATURE_TWILIO_PAGE = '/features/twilio-flex-integrations';
    String TRIAL_SUCCEED_PAGE = '/trial-request-successful?id=';
    String VACATION_LANDING_PAGE = '/vacation-rental-software';
    String VILLA_LANDING_PAGE = '/villas-management-software';
    String WAITLIST_PAGE = '/wait-list';
    String WEBINAR_PAGE = '/webinar/';
    String WEBINARS_PAGE = '/booking-ninjas-webinars';
    String WHY_PAGE = '/why-booking-ninjas';
    String UKPMS_PAGE = '/uk/property-management-software';
    String CALENDLY_NEW_PAGE = '/demo';
    String INVOICE_ACTIVATION_PAGE = '/activation?id=';
    String CALENDLY_THANK_YOU_PAGE = '/thank-you';
    
    // portal
    String PORTAL_ACCOUNT_PAGE = '/portal';
    String PORTAL_CARD_PAGE = '/portal/cards';
    String PORTAL_CLIENTV2MOM_PAGE = '/portal/v2mom';
    String PORTAL_FORGOTPASSWORD_PAGE = '/forgot-password';
    String PORTAL_HOME_PAGE = '/login';
    String PORTAL_PAYMENT_PAGE = '/portal/payments';
    String PORTAL_RESETPASSWORD_PAGE = '/reset-password?id=';
    String PORTAL_SERVICE_PAGE = '/portal/services';
    String PORTAL_USER_PAGE = '/portal/users';
    String PORTAL_VIDEOS_PAGE = '/portal/videos';
    
    
    //Variables to represent my custom Visualforce pages
    String SPANISH_VF_INDEX = '/BNES_Index';
    String PORTUGESE_VF_INDEX = '/BNEP_Index';
    String ABOUT_VF_PAGE = '/BN_About';
    String ADVANTAGES_VF_PAGE = '/BN_Advantages';
    String ARTICLE_VF_PAGE = '/BN_Article?id=';
    String ARTIFICIAL_INTELLIGENCE_VF_PAGE = '/BN_ArtificialIntelligence';
    String AUTHOR_VF_PAGE = '/BN_Author?id=';
    String BEST_HOTEL_PMS_VF_PAGE = '/BN_HotelPMS';
    String BLOG_VF_PAGE = '/BN_Blog';
    String CALENDLY_VF_PAGE = '/BNCalendly';
    String CAREER_ACCOUNTEXECUTIVE_VF_PAGE = '/BN_Career_AccountExecutive';
    String CAREER_APPLICATION_VF_PAGE = '/BN_CareerLeadForm';
    String CAREER_CONTENTWRITER_VF_PAGE = '/BN_Career_ContentWriter';
    String CAREER_CSR_VF_PAGE = '/BN_Career_CSR';
    String CAREER_DESIGNER_VF_PAGE = '/BN_Career_Designer';
    String CAREER_FRONTENDDEVELOPER_VF_PAGE = '/BN_Career_FrontEndDeveloper';
    String CAREER_GROWTHHACKER_VF_PAGE = '/BN_Career_GrowthHacker';
    String CAREER_MOBILEDEVELOPER_VF_PAGE = '/BN_Career_MobileDeveloper';
    String CAREER_PROJECTMANAGER_VF_PAGE = '/BN_Career_ProjectManager';
    String CAREER_SALESFORCEADMIN_VF_PAGE = '/BN_Career_SalesforceAdmin';
    String CAREER_SALESFORCEDEVELOPER_VF_PAGE = '/BN_Career_SalesforceDeveloper';
    String CAREER_SCRIPTWRITER_VF_PAGE = '/BN_Career_ScriptWriter';
    String CAREER_SEONINJA_VF_PAGE = '/BN_Career_SEONinja';
    String CAREER_SOCIALMEDIANINJA_VF_PAGE = '/BN_Career_SocialMediaNinja';
    String CAREER_THANKYOU_VF_PAGE = '/BN_ThankYou2';
    String CAREER_VF_PAGE = '/BN_Career';
    String CAREER_DETAILS_VF_PAGE = '/BN_Career_Detail?id=';
    String CHANNEL_LISTING_VF_PAGE = '/BN_ChannelListing';
    String CHECKOUT_SUCCEED_VF_PAGE = '/BN_CheckoutSucceed?id=';
    String CHECKOUT_VF_PAGE = '/BN_CheckOut';
    String CLUB_LANDING_VF_PAGE = '/BN_LP_Club';
    String COMPETITIVE_MATRIX_VF_PAGE = '/BN_Matrix';
    String CONFERENCE_VF_PAGE = '/BN_Conference';
    String CONSULTATION_FORM_VF_PAGE = '/BN_ConsultingForm';
    String CONSULTATION_VF_PAGE = '/BN_Consulting';
    String CONTACT_VF_PAGE = '/BN_Contact';
    String CORE_VALUES_VF_PAGE = '/BN_CoreValues';
    String COVID19_VF_PAGE = '/BN_Covid19';
    String COWORKING_LANDING_VF_PAGE = '/BN_LP_CoWorking';
    String CUSTOMER_STORIES_CTY_VF_PAGE = '/BN_CustomerStories_CTY';
    String CUSTOMER_STORIES_HFTP_VF_PAGE = '/BN_CustomerStories_HFTP';
    String CUSTOMER_STORIES_INDUSTRIOUS_VF_PAGE = '/BN_CustomerStories_Industrious';
    String CUSTOMER_STORIES_VF_PAGE = '/BN_CustomerStories';
    String CUSTOMER_STORIES_DETAIL_VF_PAGE = '/BN_CustomerStories_Detail?id=';
    String CUSTOMER_STORIES_WDS_VF_PAGE = '/BN_CustomerStories_WDS';
    String DATA_VF_PAGE = '/BN_Data';
    String EINSTEIN_FORM_VF_PAGE = '/BN_EinsteinForm';
    String EVENT_LANDING_VF_PAGE = '/BN_LP_Event';
    String FAQS_VF_PAGE = '/BN_FAQs';
    String FORM_COVID19_VF_PAGE = '/BN_Form_Covid19';
    String FORM_GENHOSPITALITYSURVEY_VF_PAGE = '/BN_Form_GeneralHospitalitySurvey';
    String FORM_HOTELINDUSTRYSURVEY_VF_PAGE = '/BN_Form_HotelIndustrySurvey';
    String FORM_RATEMYPMS_VF_PAGE = '/BN_Form_RateMyPMS';
    String GALLERY_VF_PAGE = '/BN_Gallery';
    String GDPR_VF_PAGE = '/BN_Gdpr';
    String GLANCE_VF_PAGE = '/BN_Glance';
    String GOVERNMENT_LANDING_VF_PAGE = '/BN_LP_Government';
    String GUEST_POST_SUBMISSION_VF_PAGE = '/BN_GuestPost';
    String HOSTEL_LANDING_VF_PAGE = '/BN_LP_Hostels';
    String HOTEL_LANDING_VF_PAGE = '/BN_LP_Hotels';
    String HOTEL_TRIAL_LANDING_VF_PAGE = '/BN_LP_HotelsTrial';
    String IMPLEMENTATION_VF_PAGE = '/BN_Implementation';
    String INDUSTRIAL_REVOLUTION_VF_PAGE = '/BN_IndustrialRevolution';
    String INTEGRATIONS_VF_PAGE = '/BN_Integrations';
    String INTEREST_THANKYOU_VF_PAGE = '/BN_ThankYou3';
    String INTEREST_VF_PAGE = '/BN_Interest';
    String LP_TRIAL_VF_PAGE = '/BN_LP_Trial';
    String MYTHS_VF_PAGE = '/BN_Myths';
    String NONPROFIT_LANDING_VF_PAGE = '/BN_LP_NonProfit';
    String PARKING_LANDING_VF_PAGE = '/BN_LP_Parking';
    String PARTNER_CHANNELRUSH_VF_PAGE = '/BN_Partners_ChannelRush';
    String PARTNER_ESIGN_VF_PAGE = '/BN_Partners_ESign';
    String PARTNER_HFTP_VF_PAGE = '/BN_Partners_HFTP';
    String PARTNER_LATINO_VF_PAGE = '/BN_Partners_Latino';
    String PARTNER_NABHOOD_VF_PAGE = '/BN_Partners_Nabhood';
    String PARTNER_SALESFORCE_VF_PAGE = '/BN_Partners_Salesforce';
    String PARTNER_TWILIO_VF_PAGE = '/BN_Partners_Twilio';
    String PARTNER_VF_PAGE = '/BN_Partners';
    String PARTNER_YIELD_VF_PAGE = '/BN_Partners_YieldPlanet';
    String PMS_SALESFORCE_VF_PAGE = '/BN_PMS_Salesforce';
    String PMS_VF_PAGE = '/BN_PMS';
    String POS_CHECKOUT_VF_PAGE = '/BN_POS';
    String PREACTIVATIONFORM_VF_PAGE = '/BN_ActivationForm';
    String PRICING_PT_VF_PAGE = '/BN_Pricing_PT';
    String PRICING_VF_PAGE = '/BN_Pricing';
    String PRIVACY_VF_PAGE = '/BN_PrivacyPolicy';
    String PROCESS_VF_PAGE = '/BN_Process';
    String PROPERTY_LANDING_VF_PAGE = '/BN_LP_PropertyManagers';
    String REFERRAL_PROGRAM_VF_PAGE = '/BN_ReferralProgram';
    String REGISTER_VF_PAGE = '/BN_Register';
    String RESOURCES_VF_PAGE = '/BN_Resources';
    String RESTAURANT_LANDING_VF_PAGE = '/BN_LP_Restaurant';
    String REVIEWS_VF_PAGE = '/BN_Reviews';
    String SENIOR_LANDING_VF_PAGE = '/BN_LP_Senior';
    String SITEMAP_VF_PAGE = '/sitemap.xml';
    String SOLUTIONS_VF_PAGE = '/BN_Solutions';
    String STORAGE_LANDING_VF_PAGE = '/BN_LP_Storage';
    String STUDENTHOUSING_LANDING_VF_PAGE = '/BN_LP_StudentHousing';
    String SUBMISSION_THANKYOU_VF_PAGE = '/BN_GuestPost_TY';
    String SURVEYS_VF_PAGE = '/BN_Survey';
    String TERMS_VF_PAGE = '/BN_TermsAndConditions';
    String THANKYOU_VF_PAGE = '/BN_ThankYou?id=';
    String TIME_TO_THINK_VF_PAGE = '/BN_TimeToThink';
    String FEATURE_ACCESSCONTROL_VF_PAGE = '/BN_FeatureSpotlight_AccessControl';
    String FEATURE_AMS_DETAILS_VF_PAGE = '/BN_FeatureSpotlight_AMS_Details';
    String FEATURE_AMS_VF_PAGE = '/BN_FeatureSpotlight_AMS';
    String FEATURE_APPEXCHANGE_VF_PAGE = '/BN_FeatureSpotlight_Appexchange';
    String FEATURE_AVAILABILITY_DETAILS_VF_PAGE = '/BN_FeatureSpotlight_AvailabilityGrid_Det';
    String FEATURE_AVAILABILITY_VF_PAGE = '/BN_FeatureSpotlight_AvailabilityGrid';
    String FEATURE_BE_DETAILS_VF_PAGE = '/BN_FeatureSpotlight_BE_Details';
    String FEATURE_BE_VF_PAGE = '/BN_FeatureSpotlight_BE';
    String FEATURE_CM_VF_PAGE = '/BN_FeatureSpotlight_Channel';
    String FEATURE_CS_DETAILS_VF_PAGE = '/BN_FeatureSpotlight_CS_Details';
    String FEATURE_CS_VF_PAGE = '/BN_FeatureSpotlight_CS';
    String FEATURE_EA_VF_PAGE = '/BN_FeatureSpotlight_Einstein';
    String FEATURE_ESIGN_VF_PAGE = '/BN_FeatureSpotlight_ESign';
    String FEATURE_MOBILE_VF_PAGE = '/BN_FeatureSpotlight_Mobile';
    String FEATURE_PAYMENT_VF_PAGE = '/BN_FeatureSpotlight_Payment';
    String FEATURE_CORE_VF_PAGE = '/BN_FeatureSpotlight_Core';
    String FEATURE_PI_DETAILS_VF_PAGE = '/BN_FeatureSpotlight_PI_Details';
    String FEATURE_PI_VF_PAGE = '/BN_FeatureSpotlight_PI';
    String FEATURE_POS_VF_PAGE = '/BN_FeatureSpotlight_POS';
    String FEATURE_REPORT_VF_PAGE = '/BN_FeatureSpotlight_Report';
    String FEATURE_RRC_DETAILS_VF_PAGE = '/BN_FeatureSpotlight_RRC_Details';
    String FEATURE_RRC_VF_PAGE = '/BN_FeatureSpotlight_RRC';
    String FEATURE_TICKET_VF_PAGE = '/BN_FeatureSpotlight_Ticket';
    String FEATURE_TWILIO_VF_PAGE = '/BN_FeatureSpotlight_Twilio';
    String FEATURE_VF_PAGE = '/BN_FeatureSpotlights';
    String TRIAL_SUCCEED_VF_PAGE = '/BN_TrialSucceed?id=';
    String VACATION_LANDING_VF_PAGE = '/BN_LP_Vacation';
    String VILLA_LANDING_VF_PAGE = '/BN_LP_Villa';
    String WAITLIST_VF_PAGE = '/BN_WaitList';
    String WEBINAR_VF_PAGE = '/BN_WebinarSingle?id=';
    String WEBINARS_VF_PAGE = '/BN_Webinars';
    String WHY_VF_PAGE = '/BN_Why';
    String UKPMS_VF_PAGE = '/BN_UK_PMS';
    String INVOICE_ACTIVATION_VF_PAGE = '/BN_Invoice_Activation?id=';
    String CALENDLY_NEW_VF_PAGE = '/BN_Demo';
    String CALENDLY_THANK_YOU_VF_PAGE = '/BN_CalendlyThankYou';
    
    // portal
    String PORTAL_ACCOUNT_VF_PAGE = '/BN_Portal_Account';
    String PORTAL_CARD_VF_PAGE = '/BN_Portal_Cards';
    String PORTAL_CLIENTV2MOM_VF_PAGE = '/BN_Portal_ClientV2MOM';
    String PORTAL_FORGOTPASSWORD_VF_PAGE = '/BN_Portal_ForgotPassword';
    String PORTAL_HOME_VF_PAGE = '/BN_Portal_Home';
    String PORTAL_PAYMENT_VF_PAGE = '/BN_Portal_PaymentHistory';
    String PORTAL_RESETPASSWORD_VF_PAGE = '/BN_Portal_ResetPassword?id=';
    String PORTAL_SERVICE_VF_PAGE = '/BN_Portal_Services';
    String PORTAL_USER_VF_PAGE = '/BN_Portal_Users';
    String PORTAL_VIDEOS_VF_PAGE = '/BN_Portal_Videos';
    
    
    global PageReference mapRequestUrl(PageReference myFriendlyUrl) {
        String url = myFriendlyUrl.getUrl();
        System.debug('url:' + url);
        
        if(url.startsWithIgnoreCase(ARTICLE_PAGE)) {
            String slug = url.substring(ARTICLE_PAGE.length(), url.length());

            if(slug.contains('/') || slug.contains('?')){
                Integer endIndex = slug.indexOf('/');
                if(endIndex == -1) endIndex = slug.indexOf('?');

                slug = slug.substring(0, endIndex);
            }

            String slugSearch = '%'+slug;
            Article__c article = [SELECT Id FROM Article__c WHERE Article_Link__c like :slugSearch LIMIT 1];
            if(article != null) {
                return new PageReference(ARTICLE_VF_PAGE + article.Id);
            }
        }
        if(url.startsWithIgnoreCase(WEBINAR_PAGE)) {
            String slug = url.substring(WEBINAR_PAGE.length(), url.length());

            if(slug.contains('/') || slug.contains('?')){
                Integer endIndex = slug.indexOf('/');
                if(endIndex == -1) endIndex = slug.indexOf('?');

                slug = slug.substring(0, endIndex);
            }

            String slugSearch = '%' + slug;
            List<Webinar__c> webinars = [SELECT Id FROM Webinar__c WHERE WebinarLink__c LIKE :slugSearch LIMIT 1];
            if(webinars.size() > 0) {
                return new PageReference(WEBINAR_VF_PAGE + webinars[0].Id);
            }
        }
        if(url.startsWithIgnoreCase(PORTAL_RESETPASSWORD_PAGE)) {
            String userId = url.substring(PORTAL_RESETPASSWORD_PAGE.length(), url.length());
            if(url.startsWith(PORTAL_RESETPASSWORD_PAGE + userId)) {
                return new PageReference(PORTAL_RESETPASSWORD_VF_PAGE + userId);
            }
        }
       
        if(url.startsWithIgnoreCase(ADVANTAGES_PAGE)) {
            return new PageReference(ADVANTAGES_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(ARTIFICIAL_INTELLIGENCE_PAGE)) {
            return new PageReference(ARTIFICIAL_INTELLIGENCE_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(AUTHOR_PAGE)) {
            String slug = url.substring(AUTHOR_PAGE.length(), url.length());
            if(slug.contains('/') || slug.contains('?')){
                Integer endIndex = slug.indexOf('/');
                if(endIndex == -1) endIndex = slug.indexOf('?');

                slug = slug.substring(0, endIndex);
            }
            
            String slugSearch = '%' + slug;
            List<Contact> contacts = [SELECT Id FROM Contact WHERE Username__c LIKE :slugSearch LIMIT 1];
            if(contacts.size() > 0) {
                return new PageReference(AUTHOR_VF_PAGE + contacts[0].Id);
            }
        }
        if(url.startsWithIgnoreCase(BLOG_PAGE)) {
            if (url.startsWith(BLOG_PAGE + '?')){
                String querySearch = url.substring(BLOG_PAGE.length(), url.length());
                return new PageReference(BLOG_VF_PAGE + querySearch);
            } else {
                return new PageReference(BLOG_VF_PAGE);
            }
        }
        if(url.startsWithIgnoreCase(CORE_VALUES_PAGE)) {
            return new PageReference(CORE_VALUES_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(DATA_PAGE)) {
            return new PageReference(DATA_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(EINSTEIN_FORM_PAGE)) {
            return new PageReference(EINSTEIN_FORM_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FAQS_PAGE)) {
            return new PageReference(FAQS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(GALLERY_PAGE)) {
            return new PageReference(GALLERY_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(GDPR_PAGE)) {
            return new PageReference(GDPR_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(IMPLEMENTATION_PAGE)) {
            return new PageReference(IMPLEMENTATION_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(INDUSTRIAL_REVOLUTION_PAGE)) {
            return new PageReference(INDUSTRIAL_REVOLUTION_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(INTEGRATIONS_PAGE)) {
            return new PageReference(INTEGRATIONS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(MYTHS_PAGE)) {
            return new PageReference(MYTHS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PROCESS_PAGE)) {
            return new PageReference(PROCESS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PRICING_PAGE)) {
            return new PageReference(PRICING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PRICING_PT_PAGE)) {
            return new PageReference(PRICING_PT_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PRIVACY_PAGE)) {
            return new PageReference(PRIVACY_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(RESOURCES_PAGE)) {
            return new PageReference(RESOURCES_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(SOLUTIONS_PAGE)) {
            return new PageReference(SOLUTIONS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(TERMS_PAGE)) {
            return new PageReference(TERMS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(TIME_TO_THINK_PAGE)) {
            return new PageReference(TIME_TO_THINK_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(WHY_PAGE)) {
            return new PageReference(WHY_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(THANKYOU_PAGE)) {
            String objectId = url.substring(THANKYOU_PAGE.length(), url.length());
            return new PageReference(THANKYOU_VF_PAGE + objectId);
        }
        if(url.startsWithIgnoreCase(TRIAL_SUCCEED_PAGE)) {
            String customerId = url.substring(TRIAL_SUCCEED_PAGE.length(), url.length());
            return new PageReference(TRIAL_SUCCEED_VF_PAGE + customerId);
        }
        if(url.startsWithIgnoreCase(CHECKOUT_SUCCEED_PAGE)) {
            String customerId = url.substring(CHECKOUT_SUCCEED_PAGE.length(), url.length());
            return new PageReference(CHECKOUT_SUCCEED_VF_PAGE + customerId);
        }
        if(url.startsWithIgnoreCase(REGISTER_PAGE)) {
            return new PageReference(REGISTER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(LP_TRIAL_PAGE)) {
            return new PageReference(LP_TRIAL_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(ABOUT_PAGE)) {
            return new PageReference(ABOUT_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FORM_RATEMYPMS_PAGE)) {
            return new PageReference(FORM_RATEMYPMS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FORM_HOTELINDUSTRYSURVEY_PAGE)) {
            return new PageReference(FORM_HOTELINDUSTRYSURVEY_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FORM_COVID19_PAGE)) {
            return new PageReference(FORM_COVID19_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FORM_GENHOSPITALITYSURVEY_PAGE)) {
            return new PageReference(FORM_GENHOSPITALITYSURVEY_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_PAGE)) {
            return new PageReference(CAREER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_DETAILS_PAGE)) {
            String vacancyId = url.substring(CAREER_DETAILS_PAGE.length(), url.length());
            return new PageReference(CAREER_DETAILS_VF_PAGE + vacancyId);
        }
        if(url.startsWithIgnoreCase(CAREER_APPLICATION_PAGE)) {
            return new PageReference(CAREER_APPLICATION_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PMS_PAGE)) {
            return new PageReference(PMS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CONSULTATION_PAGE)) {
            return new PageReference(CONSULTATION_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CONSULTATION_FORM_PAGE)) {
            return new PageReference(CONSULTATION_FORM_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CALENDLY_PAGE)) {
            return new PageReference(CALENDLY_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CUSTOMER_STORIES_PAGE)) {
            return new PageReference(CUSTOMER_STORIES_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CUSTOMER_STORIES_DETAIL_PAGE)) {
            String slug = url.substring(CUSTOMER_STORIES_DETAIL_PAGE.length(), url.length());
    
            if(slug.contains('/') || slug.contains('?')){
                Integer endIndex = slug.indexOf('/');
                if(endIndex == -1) endIndex = slug.indexOf('?');

                slug = slug.substring(0, endIndex);
            }

            String slugSearch = '%' + slug;
            List<CustomerStories__c> stories = [SELECT Id FROM CustomerStories__c WHERE StoryLink__c LIKE :slugSearch LIMIT 1];
            if(stories.size() > 0) {
                return new PageReference(CUSTOMER_STORIES_DETAIL_VF_PAGE + stories[0].Id);
            }
        }
        if(url.startsWithIgnoreCase(CUSTOMER_STORIES_HFTP_PAGE)) {
            return new PageReference(CUSTOMER_STORIES_HFTP_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CUSTOMER_STORIES_CTY_PAGE)) {
            return new PageReference(CUSTOMER_STORIES_CTY_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CUSTOMER_STORIES_INDUSTRIOUS_PAGE)) {
            return new PageReference(CUSTOMER_STORIES_INDUSTRIOUS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CUSTOMER_STORIES_WDS_PAGE)) {
            return new PageReference(CUSTOMER_STORIES_WDS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CLUB_LANDING_PAGE)) {
            return new PageReference(CLUB_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(COWORKING_LANDING_PAGE)) {
            return new PageReference(COWORKING_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(HOSTEL_LANDING_PAGE)) {
            return new PageReference(HOSTEL_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(STORAGE_LANDING_PAGE)) {
            return new PageReference(STORAGE_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(STUDENTHOUSING_LANDING_PAGE)) {
            return new PageReference(STUDENTHOUSING_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(RESTAURANT_LANDING_PAGE)) {
            return new PageReference(RESTAURANT_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(HOTEL_LANDING_PAGE)) {
            return new PageReference(HOTEL_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(HOTEL_TRIAL_LANDING_PAGE)) {
            return new PageReference(HOTEL_TRIAL_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PROPERTY_LANDING_PAGE)) {
            return new PageReference(PROPERTY_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PARKING_LANDING_PAGE)) {
            return new PageReference(PARKING_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(EVENT_LANDING_PAGE)) {
            return new PageReference(EVENT_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(SENIOR_LANDING_PAGE)) {
            return new PageReference(SENIOR_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(VACATION_LANDING_PAGE)) {
            return new PageReference(VACATION_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(VILLA_LANDING_PAGE)) {
            return new PageReference(VILLA_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(GOVERNMENT_LANDING_PAGE)) {
            return new PageReference(GOVERNMENT_LANDING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(NONPROFIT_LANDING_PAGE)) {
            return new PageReference(NONPROFIT_LANDING_VF_PAGE);
        }
        if(url .startsWithIgnoreCase(COMPETITIVE_MATRIX_PAGE)) {
            return new PageReference(COMPETITIVE_MATRIX_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(GLANCE_PAGE)) {
            return new PageReference(GLANCE_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_THANKYOU_PAGE)) {
            return new PageReference(CAREER_THANKYOU_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CONFERENCE_PAGE)) {
            return new PageReference(CONFERENCE_VF_PAGE);
        }
        if(url.equalsIgnoreCase(FEATURE_PAGE)) {
            return new PageReference(FEATURE_VF_PAGE);
        }
        if(url.equalsIgnoreCase(FEATURE_AVAILABILITY_PAGE)) {
            return new PageReference(FEATURE_AVAILABILITY_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_AVAILABILITY_DETAILS_PAGE)) {
            return new PageReference(FEATURE_AVAILABILITY_DETAILS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_AMS_PAGE)) {
            return new PageReference(FEATURE_AMS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_AMS_DETAILS_PAGE)) {
            return new PageReference(FEATURE_AMS_DETAILS_VF_PAGE);
        }
        if(url.equalsIgnoreCase(FEATURE_BE_PAGE)) {
            return new PageReference(FEATURE_BE_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_BE_DETAILS_PAGE)) {
            return new PageReference(FEATURE_BE_DETAILS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_CS_PAGE)) {
            return new PageReference(FEATURE_CS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_CS_DETAILS_PAGE)) {
            return new PageReference(FEATURE_CS_DETAILS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_PI_PAGE)) {
            return new PageReference(FEATURE_PI_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_PI_DETAILS_PAGE)) {
            return new PageReference(FEATURE_PI_DETAILS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_CM_PAGE)) {
            return new PageReference(FEATURE_CM_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_EA_PAGE)) {
            return new PageReference(FEATURE_EA_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_ESIGN_PAGE)) {
            return new PageReference(FEATURE_ESIGN_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_MOBILE_PAGE)) {
            return new PageReference(FEATURE_MOBILE_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_PAYMENT_PAGE)) {
            return new PageReference(FEATURE_PAYMENT_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_CORE_PAGE)) {
            return new PageReference(FEATURE_CORE_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_POS_PAGE)) {
            return new PageReference(FEATURE_POS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_REPORT_PAGE)) {
            return new PageReference(FEATURE_REPORT_VF_PAGE);
        }
        if(url.equalsIgnoreCase(FEATURE_RRC_PAGE)) {
            return new PageReference(FEATURE_RRC_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_RRC_DETAILS_PAGE)) {
            return new PageReference(FEATURE_RRC_DETAILS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_TICKET_PAGE)) {
            return new PageReference(FEATURE_TICKET_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_TWILIO_PAGE)) {
            return new PageReference(FEATURE_TWILIO_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_ACCESSCONTROL_PAGE)) {
            return new PageReference(FEATURE_ACCESSCONTROL_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(FEATURE_APPEXCHANGE_PAGE)) {
            return new PageReference(FEATURE_APPEXCHANGE_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_SALESFORCEADMIN_PAGE)) {
            return new PageReference(CAREER_SALESFORCEADMIN_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_SALESFORCEDEVELOPER_PAGE)) {
            return new PageReference(CAREER_SALESFORCEDEVELOPER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_FRONTENDDEVELOPER_PAGE)) {
            return new PageReference(CAREER_FRONTENDDEVELOPER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_CONTENTWRITER_PAGE)) {
            return new PageReference(CAREER_CONTENTWRITER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_SCRIPTWRITER_PAGE)) {
            return new PageReference(CAREER_SCRIPTWRITER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_DESIGNER_PAGE)) {
            return new PageReference(CAREER_DESIGNER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_GROWTHHACKER_PAGE)) {
            return new PageReference(CAREER_GROWTHHACKER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_PROJECTMANAGER_PAGE)) {
            return new PageReference(CAREER_PROJECTMANAGER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_ACCOUNTEXECUTIVE_PAGE)) {
            return new PageReference(CAREER_ACCOUNTEXECUTIVE_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_MOBILEDEVELOPER_PAGE)) {
            return new PageReference(CAREER_MOBILEDEVELOPER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_CSR_PAGE)) {
            return new PageReference(CAREER_CSR_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_SOCIALMEDIANINJA_PAGE)) {
            return new PageReference(CAREER_SOCIALMEDIANINJA_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CAREER_SEONINJA_PAGE)) {
            return new PageReference(CAREER_SEONINJA_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(BEST_HOTEL_PMS_PAGE)) {
            return new PageReference(BEST_HOTEL_PMS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(INTEREST_PAGE)) {
            return new PageReference(INTEREST_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(INTEREST_THANKYOU_PAGE)) {
            return new PageReference(INTEREST_THANKYOU_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(WAITLIST_PAGE)) {
            return new PageReference(WAITLIST_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PMS_SALESFORCE_PAGE)) {
            return new PageReference(PMS_SALESFORCE_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PREACTIVATIONFORM_PAGE)) {
            return new PageReference(PREACTIVATIONFORM_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CHANNEL_LISTING_PAGE)) {
            return new PageReference(CHANNEL_LISTING_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(REVIEWS_PAGE)) {
            return new PageReference(REVIEWS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(COVID19_PAGE)) {
            return new PageReference(COVID19_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CONTACT_PAGE)) {
            return new PageReference(CONTACT_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PARTNER_PAGE)) {
            return new PageReference(PARTNER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PARTNER_SALESFORCE_PAGE)) {
            return new PageReference(PARTNER_SALESFORCE_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PARTNER_HFTP_PAGE)) {
            return new PageReference(PARTNER_HFTP_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PARTNER_TWILIO_PAGE)) {
            return new PageReference(PARTNER_TWILIO_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PARTNER_CHANNELRUSH_PAGE)) {
            return new PageReference(PARTNER_CHANNELRUSH_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PARTNER_YIELD_PAGE)) {
            return new PageReference(PARTNER_YIELD_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PARTNER_ESIGN_PAGE)) {
            return new PageReference(PARTNER_ESIGN_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PARTNER_LATINO_PAGE)) {
            return new PageReference(PARTNER_LATINO_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PARTNER_NABHOOD_PAGE)) {
            return new PageReference(PARTNER_NABHOOD_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(SURVEYS_PAGE)) {
            return new PageReference(SURVEYS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(WEBINARS_PAGE)) {
            return new PageReference(WEBINARS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(GUEST_POST_SUBMISSION_PAGE)) {
            return new PageReference(GUEST_POST_SUBMISSION_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(SUBMISSION_THANKYOU_PAGE)) {
            return new PageReference(SUBMISSION_THANKYOU_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CHECKOUT_PAGE)) {
            return new PageReference(CHECKOUT_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(POS_CHECKOUT_PAGE)) {
            return new PageReference(POS_CHECKOUT_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(REFERRAL_PROGRAM_PAGE)) {
            return new PageReference(REFERRAL_PROGRAM_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(SITEMAP_PAGE)) {
            return new PageReference(SITEMAP_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(UKPMS_PAGE)) {
            return new PageReference(UKPMS_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(INVOICE_ACTIVATION_PAGE)) {
            String quoteId = url.substring(INVOICE_ACTIVATION_PAGE.length(), url.length());
            return new PageReference(INVOICE_ACTIVATION_VF_PAGE + quoteId);
        }
        if(url.startsWithIgnoreCase(CALENDLY_NEW_PAGE)) {
            return new PageReference(CALENDLY_NEW_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(CALENDLY_THANK_YOU_PAGE)) {
            return new PageReference(CALENDLY_THANK_YOU_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(SPANISH_INDEX)) {
            return new PageReference(SPANISH_VF_INDEX);
        }
        if(url.startsWithIgnoreCase(PORTUGESE_INDEX)) {
            return new PageReference(PORTUGESE_VF_INDEX);
        }

        //portal
        if(url.startsWithIgnoreCase(PORTAL_HOME_PAGE) || url == '/login?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_HOME_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PORTAL_FORGOTPASSWORD_PAGE) || url == '/forgot-password?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_FORGOTPASSWORD_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PORTAL_ACCOUNT_PAGE) || url == '/portal?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_ACCOUNT_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PORTAL_PAYMENT_PAGE) || url == '/portal/payments?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_PAYMENT_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PORTAL_CARD_PAGE) || url == '/portal/cards?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_CARD_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PORTAL_USER_PAGE) || url == '/portal/users?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_USER_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PORTAL_SERVICE_PAGE) || url == '/portal/services?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_SERVICE_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PORTAL_CLIENTV2MOM_PAGE) || url == '/portal/v2mom?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_CLIENTV2MOM_VF_PAGE);
        }
        if(url.startsWithIgnoreCase(PORTAL_VIDEOS_PAGE) || url == '/portal/videos?sfdcIFrameOrigin=null') {
            return new PageReference(PORTAL_VIDEOS_VF_PAGE);
        }
        
        return null;
    }

    private static Map<Id, Contact> authorMap;
    private static Map<Id, Contact> getAuthorMap(){
        if(authorMap == null) authorMap = new Map<Id, Contact>([SELECT Id, Username__c FROM Contact WHERE Username__c != null]);
        
        return authorMap;
    }

    private static Map<Id, Article__c> articleMap;
    private static Map<Id, Article__c> getArticleMap(){
        if(articleMap == null) articleMap = new Map<Id, Article__c>([SELECT Id, Article_Link__c FROM Article__c WHERE Article_Link__c != null]);
        
        return articleMap;
    }

    private static Map<Id, Webinar__c> webinarMap;
    private static Map<Id, Webinar__c> getWebinarMap(){
        if(webinarMap == null) webinarMap = new Map<Id, Webinar__c>([SELECT Id, Name FROM Webinar__c WHERE Name != null]);
        
        return webinarMap;
    }

    private static Map<Id, CustomerStories__c> customerStoryMap;
    private static Map<Id, CustomerStories__c> getCustomerStoryMap(){
        if(customerStoryMap == null) customerStoryMap = new Map<Id, CustomerStories__c>([SELECT Id, StoryLink__c FROM CustomerStories__c WHERE StoryLink__c != null]);

        return customerStoryMap;
    }

    global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls) {
        //A list of pages to return after all the links have been evaluated
        List<PageReference> myFriendlyUrls = new List<PageReference>();
        String regExp = '[^\\w\\s]';

        // loop through all the urls once, finding all the valid ids
        for(PageReference mySalesforceUrl : mySalesforceUrls) {
            //Get the URL of the page
            String url = mySalesforceUrl.getUrl();
            System.debug('url:' + url);
            
            if(url.startsWith(ARTICLE_VF_PAGE)) {
                Integer endIndex = url.contains('&') ? url.indexOf('&') : url.length();
                String id = url.substring(ARTICLE_VF_PAGE.length(), endIndex);
                if(url.startsWith(ARTICLE_VF_PAGE + id)) {
                    String slugUrl = getArticleMap().get(id)?.Article_Link__c;
                    List<String> slugList = slugUrl.split(ARTICLE_PAGE);
                    String slug = slugList.get(slugList.size() - 1);
                    
                    myFriendlyUrls.add(new PageReference(ARTICLE_PAGE + slug));
                }
            }
            else if(url.startsWith(WEBINAR_VF_PAGE)) {
                Integer endIndex = url.contains('&') ? url.indexOf('&') : url.length();
                String id = url.substring(WEBINAR_VF_PAGE.length(), endIndex);
                if(url.startsWith(WEBINAR_VF_PAGE + id)) {
                    String name = getWebinarMap().get(id)?.Name;
                    String urlName = name?.replaceAll(regExp , '').replaceAll(' ', '-')?.toLowerCase();
                    
                    myFriendlyUrls.add(new PageReference(WEBINAR_PAGE + urlName));
                }
            }
            else if(url.startsWith(PORTAL_RESETPASSWORD_VF_PAGE)) {
                Integer endIndex = url.contains('&') ? url.indexOf('&') : url.length();
                String userId = url.substring(PORTAL_RESETPASSWORD_VF_PAGE.length(), endIndex);
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
                Integer endIndex = url.contains('&') ? url.indexOf('&') : url.length();
                String id = url.substring(AUTHOR_VF_PAGE.length(), endIndex);
                if(url.startsWith(AUTHOR_VF_PAGE + id) && id != 'admin') {
                    String slugUrl = getAuthorMap().get(id)?.Username__c;
                    if(String.isBlank(slugUrl)) {
                        myFriendlyUrls.add(new PageReference(AUTHOR_PAGE + 'admin'));
                    }
                    else {
                        List<String> slugList = slugUrl.split(AUTHOR_PAGE);
                        String slug = slugList.get(slugList.size() - 1);
                        
                        myFriendlyUrls.add(new PageReference(AUTHOR_PAGE + slug));
                    }
                }
            }
            else if(url == BLOG_VF_PAGE || url.startsWith(BLOG_VF_PAGE.toLowerCase() + '?')) {
                if (url.startsWith(BLOG_VF_PAGE.toLowerCase() + '?')) {
                    Integer endIndex = url.contains('&') ? url.indexOf('&') : url.length();
                    String querySearch = url.substring(BLOG_VF_PAGE.length() + 1, endIndex);
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
            else if(url == PRIVACY_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(PRIVACY_PAGE));
            }
            else if(url == RESOURCES_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(RESOURCES_PAGE));
            }
            else if(url == SOLUTIONS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(SOLUTIONS_PAGE));
            }
            else if(url == TERMS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TERMS_PAGE));
            }
            else if(url == TIME_TO_THINK_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(TIME_TO_THINK_PAGE));
            }
            else if(url == WHY_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(WHY_PAGE));
            }
            else if(url == UKPMS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(UKPMS_PAGE)); 
            }
            else if(url == REGISTER_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(REGISTER_PAGE));
            }
            else if(url == THANKYOU_VF_PAGE) {
                String objectId = url.substring(THANKYOU_VF_PAGE.length(), url.length());
                myFriendlyUrls.add(new PageReference(THANKYOU_PAGE + objectId));
            }
            else if(url.startsWith(TRIAL_SUCCEED_VF_PAGE)) {
                Integer endIndex = url.contains('&') ? url.indexOf('&') : url.length();
                String customerId = url.substring(TRIAL_SUCCEED_VF_PAGE.length(), endIndex);
                myFriendlyUrls.add(new PageReference(TRIAL_SUCCEED_PAGE + customerId));
            }
            else if(url.startsWith(CHECKOUT_SUCCEED_VF_PAGE)) {
                Integer endIndex = url.contains('&') ? url.indexOf('&') : url.length();
                String customerId = url.substring(CHECKOUT_SUCCEED_VF_PAGE.length(), endIndex);
                myFriendlyUrls.add(new PageReference(CHECKOUT_SUCCEED_PAGE + customerId));
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
            else if(url.startsWith(CAREER_DETAILS_VF_PAGE)) {
                Integer endIndex = url.contains('&') ? url.indexOf('&') : url.length();
                String vacancyId = url.substring(CAREER_DETAILS_VF_PAGE.length(), endIndex);
                myFriendlyUrls.add(new PageReference(CAREER_DETAILS_PAGE + vacancyId));
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
            else if(url == HOTEL_TRIAL_LANDING_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(HOTEL_TRIAL_LANDING_PAGE));
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
            else if(url.startsWith(CUSTOMER_STORIES_DETAIL_VF_PAGE)) {
                Integer endIndex = url.contains('&') ? url.indexOf('&') : url.length();
                String id = url.substring(CUSTOMER_STORIES_DETAIL_VF_PAGE.length(), endIndex);
                if(url.startsWith(CUSTOMER_STORIES_DETAIL_VF_PAGE + id)) {
                    String slug = getCustomerStoryMap().get(id)?.StoryLink__c;
                    myFriendlyUrls.add(new PageReference(CUSTOMER_STORIES_DETAIL_PAGE + slug));
                }
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
            else if(url == FEATURE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_PAGE));
            }
            else if(url == FEATURE_AVAILABILITY_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_AVAILABILITY_PAGE));
            }
            else if(url == FEATURE_AVAILABILITY_DETAILS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_AVAILABILITY_DETAILS_PAGE));
            }
            else if(url == FEATURE_BE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_BE_PAGE));
            }
            else if(url == FEATURE_BE_DETAILS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_BE_DETAILS_PAGE));
            }
            else if(url == FEATURE_CS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_CS_PAGE));
            }
            else if(url == FEATURE_CS_DETAILS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_CS_DETAILS_PAGE));
            }
            else if(url == FEATURE_PI_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_PI_PAGE));
            }
            else if(url == FEATURE_PI_DETAILS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_PI_DETAILS_PAGE));
            }
            else if(url == FEATURE_CM_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_CM_PAGE));
            }
            else if(url == FEATURE_EA_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_EA_PAGE));
            }
            else if(url == FEATURE_ESIGN_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_ESIGN_PAGE));
            }
            else if(url == FEATURE_MOBILE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_MOBILE_PAGE));
            }
            else if(url == FEATURE_RRC_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_RRC_PAGE));
            }
            else if(url == FEATURE_RRC_DETAILS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_RRC_DETAILS_PAGE));
            }
            else if(url == FEATURE_PAYMENT_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_PAYMENT_PAGE));
            }
            else if(url == FEATURE_CORE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_CORE_PAGE));
            }
            else if(url == FEATURE_POS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_POS_PAGE));
            }
            else if(url == FEATURE_REPORT_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_REPORT_PAGE));
            }
            else if(url == FEATURE_TICKET_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_TICKET_PAGE));
            }
            else if(url == FEATURE_TWILIO_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_TWILIO_PAGE));
            }
            else if(url == FEATURE_ACCESSCONTROL_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_ACCESSCONTROL_PAGE));
            }
            else if(url == FEATURE_APPEXCHANGE_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_APPEXCHANGE_PAGE));
            }
            else if(url == FEATURE_AMS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_AMS_PAGE));
            }
            else if(url == FEATURE_AMS_DETAILS_VF_PAGE) {
                myFriendlyUrls.add(new PageReference(FEATURE_AMS_DETAILS_PAGE));
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
            else if(url.startsWith(INVOICE_ACTIVATION_VF_PAGE)) {
                String quoteId = url.substring(INVOICE_ACTIVATION_VF_PAGE.length(), url.length());
                myFriendlyUrls.add(new PageReference(INVOICE_ACTIVATION_PAGE + quoteId));
            }
            else if(url.startsWith(CALENDLY_NEW_VF_PAGE)) {
                myFriendlyUrls.add(new PageReference(CALENDLY_NEW_PAGE));
            }
            else if(url.startsWith(CALENDLY_THANK_YOU_VF_PAGE)) {
                myFriendlyUrls.add(new PageReference(CALENDLY_THANK_YOU_PAGE));
            }
            else if(url.startsWith(SPANISH_VF_INDEX)) {
                myFriendlyUrls.add(new PageReference(SPANISH_INDEX));
            }
            else if(url.startsWith(PORTUGESE_VF_INDEX)) {
                myFriendlyUrls.add(new PageReference(PORTUGESE_INDEX));
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