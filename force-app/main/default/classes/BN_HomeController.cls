public with sharing class BN_HomeController {
    
    // demo lead form
    public Lead lead {get; set;}
    public String industry {get; set;}
    public String name {get; set;}
    public String email {get; set;}
    public String phone {get; set;}
    public String companySize {get; set;}
    public String hqContinent {get; set;}    
    public boolean isVideoShown {get; set;}
    
    // calendly
    public String calendlyLink {get; set;}
    public String continent {get; set;}
    public String meetingType {get; set;}
    public String calendlyName {get; set;}

    // Package information
    public String pricingInfo {get; set;}
    
    public BN_HomeController() {
        
        industry = '';
        name = '';
        email = '';
        phone = '';
        companySize = '';
        hqContinent = '';
        isVideoShown = false;
        
        calendlyLink = '';
        continent = '';
        meetingType = '';
        calendlyName = '';

        List<Product2> starterPacks = [SELECT QuantityUnitOfMeasure FROM Product2 WHERE Name = 'Starter Pack' AND IsActive = true AND Expose_on_site__c = true LIMIT 1];
        Product2 starterPack = starterPacks.size() > 0 ? starterPacks[0] : null;
        this.pricingInfo = String.isNotBlank(starterPack?.QuantityUnitOfMeasure) ? starterPack.QuantityUnitOfMeasure : '/ room / per month';
    }

    public void sendDemoLead()
    {
        
        if(!checkExistingEmail(email))
        {
            try {
                lead = new Lead();
                lead.LastName = name;
                lead.Industry = industry;
                lead.Email = email;
                lead.Phone = phone;
                lead.LeadSource = 'Demo Lead';
                lead.Continent__c = hqContinent;
                insert lead;
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Successfully submitted! You can now watch the demo video.'));
                
                isVideoShown = true;
            }
            catch(Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                
                isVideoShown = false;
            }
        }
        isVideoShown = true;
    }
    
    public List<SelectOption> getIndustryList()
    {       
        List<SelectOption> industryList = new List<SelectOption>();
        industryList.add(new SelectOption('', 'Select Industry'));
        industryList.add(new SelectOption('Hospitality', 'Hospitality'));
        industryList.add(new SelectOption('Self Storage', 'Self Storage'));
        industryList.add(new SelectOption('Co-Working', 'Co-Working'));
        industryList.add(new SelectOption('Property Management', 'Property Management'));
        industryList.add(new SelectOption('Hostel', 'Hostel'));
        industryList.add(new SelectOption('Parking', 'Parking'));
        industryList.add(new SelectOption('Non Profit', 'Non Profit'));
        industryList.add(new SelectOption('Events', 'Events'));
        industryList.add(new SelectOption('Multi Use Cases', 'Multi Use Cases'));
        return industryList;
    }
    
    public List<SelectOption> getCompanySizeList()
    {       
        List<SelectOption> companySizeList = new List<SelectOption>();
        companySizeList.add(new SelectOption('', 'Select Company Size'));
        companySizeList.add(new SelectOption('1-10', '1-10'));
        companySizeList.add(new SelectOption('11-50', '11-50'));
        companySizeList.add(new SelectOption('51-100', '51-100'));
        companySizeList.add(new SelectOption('101-500', '101-500'));
        companySizeList.add(new SelectOption('501+', '501+'));
        return companySizeList;
    }
    
    public List<SelectOption> getHqContinentList()
    {       
        List<SelectOption> hqContinent = new List<SelectOption>();
        hqContinent.add(new SelectOption('', 'Select Headquarters Continent'));
        hqContinent.add(new SelectOption('North America', 'North America'));
        hqContinent.add(new SelectOption('South America', 'South America'));
        hqContinent.add(new SelectOption('Europe', 'Europe'));
        hqContinent.add(new SelectOption('Asia', 'Asia'));
        hqContinent.add(new SelectOption('Africa', 'Africa'));
        hqContinent.add(new SelectOption('Australia', 'Australia'));
        return hqContinent;
    }
    
    public List<SelectOption> getCalendlyContinents()
    {       
        List<SelectOption> continents = new List<SelectOption>();
        continents.add(new SelectOption('', 'Select Continent'));
        continents.add(new SelectOption('USA', 'USA'));
        continents.add(new SelectOption('Europe', 'Europe'));
        continents.add(new SelectOption('Asia & Australia', 'Asia & Australia'));
        return continents;
    }
    
    public List<SelectOption> getCalendlyMeetingTypeList()
    {       
        List<SelectOption> meetingTypes = new List<SelectOption>();
        meetingTypes.add(new SelectOption('', 'Select Meeting Type'));
        meetingTypes.add(new SelectOption('Introduction', 'Introduction (15 mins)'));
        meetingTypes.add(new SelectOption('Employee Inquiry', 'Employee Inquiry (15 mins)'));
        meetingTypes.add(new SelectOption('Interview', 'Interview (30 mins)'));
        meetingTypes.add(new SelectOption('General Meeting', 'General Meeting (30 mins)'));
        meetingTypes.add(new SelectOption('Check In Call', 'Check In Call (30 mins)'));
        meetingTypes.add(new SelectOption('Handoff Meeting', 'Handoff Meeting (30 mins)'));
        meetingTypes.add(new SelectOption('Demo', 'Demo (45 mins)'));
        return meetingTypes;
    }
    
    public void changeContinent()
    {
        if(continent == 'USA')
        {
            calendlyLink = 'https://calendly.com/bookingninjas_meetings/booking-ninjas-us-30-minute-meeting';
            calendlyName = 'Booking Ninjas USA';
        }
        else if(continent == 'Europe')
        {
            calendlyLink = 'https://calendly.com/bookingninjas_meetings/booking-ninjas-europe-30-minute-meeting';
            calendlyName = 'Booking Ninjas Europe';
        }
        else if(continent == 'Asia & Australia')
        {
            calendlyLink = 'https://calendly.com/bookingninjas_meetings/booking-ninjas-australia-asia-30-minute-meeting';
            calendlyName = 'Booking Ninjas Asia & Australia';
        }
        else {
            calendlyLink = '';
            calendlyName = '';
        }
    }
    
    public void changeMeetingType()
    {  
        if(meetingType == 'Introduction')
        {
            calendlyLink = 'https://calendly.com/bookingninjas_meetings/introduction';
            calendlyName = 'Introduction (15 mins, One-on-One)';
            System.Debug('Clicked: ' + calendlyLink);
        }
        else if(meetingType == 'Interview')
        {
            calendlyLink = 'https://calendly.com/bookingninjas_meetings/personal-call';
            calendlyName = 'Interview (30 mins, One-on-One)';
        }
        else if(meetingType == 'General Meeting')
        {
            calendlyLink = 'https://calendly.com/bookingninjas_meetings/booking-ninjas-general-meeting';
            calendlyName = 'General Meeting (30 mins, One-on-One)';
        }
        else if(meetingType == 'Check In Call')
        {
            calendlyLink = 'https://calendly.com/bookingninjas_meetings/booking-ninjas-check-in-call';
            calendlyName = 'Check In Call (30 mins, One-on-One)';
        }
        else if(meetingType == 'Handoff Meeting')
        {
            calendlyLink = 'https://calendly.com/bookingninjas_meetings/booking-ninjas-handoff';
            calendlyName = 'Handoff Meeting (30 mins, One-on-One)';
        }
        else if(meetingType  == 'Demo')
        {
            calendlyLink = 'https://calendly.com/bookingninjas_meetings/booking-ninjas-demo';
            calendlyName = 'Demo (45 mins, One-on-One)';
        }
        else if(meetingType  == 'Employee Inquiry')
        {
            calendlyLink = 'https://calendly.com/bookingninjas_meetings/booking-ninjas-employee-inquiry';
            calendlyName = 'Employee Inquiry (15 mins, One-on-One)';
        }
        else {
            calendlyLink = '';
            calendlyName = '';
        }
    }
    
    private boolean checkExistingEmail(string email)
    {
        List<Lead> leads = [SELECT Id, Email FROM Lead WHERE Email = :email];
        return leads.size() > 0 ? true : false;
    }
    
}