public without sharing class BN_CareerController {

    public Career__c career {get; set;}
    
    public String name {get; set;}
    public String phone {get; set;}
    public String email {get; set;}
    public String linkedin {get; set;}
    public String position {get; set;}
    
    public BN_CareerController()
    {
        name = '';
        phone = '';
        email = '';
        linkedin = '';
        position = '';
    }
    
    public PageReference register() 
    {
        career = new Career__c();
        career.Name__c = name;
        career.Email__c = email;
        career.Phone__c = phone;
        career.Linkedin__c = linkedin;
        career.Position__c = position;
        insert career;
        
        // send email notification
        sendEmail(email);
        
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
        message.subject = 'Thank you for your interest!';
        message.setHtmlBody('This letter is confirmation that we have received your application! We appreciate your interest in joining our team. We will be reviewing applications over the next couple weeks. If you are selected for an interview, you can expect a call from a member of our staff shortly. <br/> Thank you again for applying to join the Booking Ninjas team. We look forward to reviewing your application! <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
    
    public List<SelectOption> getPositionList()
    {       
        List<SelectOption> positionList = new List<SelectOption>();
        AggregateResult[] positions = [SELECT Name, COUNT(Id) FROM Vacancy__c GROUP BY Name];
        for(AggregateResult position: positions){
            String name = position.get('Name').toString();
            positionList.add(new SelectOption(name, name));
        }

        return positionList;
    }
    
    
}