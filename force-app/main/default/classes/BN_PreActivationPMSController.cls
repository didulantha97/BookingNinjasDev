public with sharing class BN_PreActivationPMSController {
    
    public PreActivation__c preActivation {get; set;}
    
    public String organizationName {get; set;}
    public String contact1Name {get; set;}
    public String contact1Email {get; set;}
    public String contact1Phone {get; set;}
    public String contact2Name {get; set;}
    public String contact2Email {get; set;}
    public String contact2Phone {get; set;}
    public String contact3Name {get; set;}
    public String contact3Email {get; set;}
    public String contact3Phone {get; set;}
    public Integer numberOfUnits {get; set;}
    public Integer numberOfusers {get; set;}
    public String propertyAddress {get; set;}
    public String propertyAddress2 {get; set;}
    public String propertyAddress3 {get; set;}
    public String pmsRequirements {get; set;}
    public String questionsAboutProduct {get; set;}

    public BN_PreActivationPMSController() {
        
        organizationName = '';
        contact1Name = '';
        contact1Email = '';
        contact1Phone = '';
        contact2Name = '';
        contact2Email = '';
        contact2Phone = '';
        contact3Name = '';
        contact3Email = '';
        contact3Phone = '';
        numberOfUnits = 0;
        numberOfusers = 0;
        propertyAddress = '';
        propertyAddress2 = '';
        propertyAddress3 = '';
        pmsRequirements = '';
        questionsAboutProduct = '';
    }
    
    public PageReference register() 
    {
        // add new preactivation record
        preActivation = new PreActivation__c();
        preActivation.Organization_Name__c = organizationName;
        preActivation.Contact1_Name__c = contact1Name;
        preActivation.Contact1_Email__c = contact1Email;
        preActivation.Contact1_Phone__c = contact1Phone;
        preActivation.Contact2_Name__c = contact2Name;
        preActivation.Contact2_Email__c = contact2Email;
        preActivation.Contact2_Phone__c = contact2Phone;
        preActivation.Contact3_Name__c = contact3Name;
        preActivation.Contact3_Email__c = contact3Email;
        preActivation.Contact3_Phone__c = contact3Phone;
        preActivation.Number_of_units__c = numberOfUnits;
        preActivation.Number_of_users__c = numberOfUsers;
        preActivation.Property_Address__c = propertyAddress;
        preActivation.Property_Address_2__c = propertyAddress2;
        preActivation.Property_Address_3__c = propertyAddress3;
        preActivation.PMS_Requirements__c = pmsRequirements;
        preActivation.Questions_about_product__c = questionsAboutProduct;
        insert preActivation;
        
         // send email notification
        sendEmail(contact1Email);
        
        // redirect to thank you  page
        PageReference pageRef = new PageReference('/thank-you-for-your-interest');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private void sendEmail(String email)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.setccAddresses(new String[] { 'david@bookingninjas.com' });
        message.optOutPolicy = 'FILTER';
        message.subject = 'Your Digital Transformation is on the Way! ';
        message.setHtmlBody('Thank you for filling out the pre-activation form for the Booking Ninjas property management software! You’re now one step closer to digitally transforming your property. <br/> Our team is processing your data now and will be in touch soon to discuss in detail what’d you like to accomplish with our pms. In the meantime, feel free to <a href="https://www.bookingninjas.com/advantages">browse our website</a> and get excited about the new features coming your way! <br/> Thank you for the interest in our property software and I look forward to working with you to create the best digital solution for your property!  <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}