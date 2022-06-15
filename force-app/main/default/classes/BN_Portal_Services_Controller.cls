public class BN_Portal_Services_Controller extends BN_Portal_Template_Controller {
    
    public Contact contact {get; set;}
    
    public List<Service__c> services {get; set;}
    
    public Service__c service {get; set;}
    public String serviceRequest {get; set;}
    public String description {get; set;}
    public decimal price {get; set;}
    public decimal quantity {get; set;}
    
    public string productId {get; set;}
    
    public BN_Portal_Services_Controller() {
        
        String bnUserId = BN_Portal_UserUtils.getCurrBNUserId();
        
        contact = BN_Portal_UserUtils.getContactByBNUserId(bnUserId);
        
        services = getServicesByContactId(contact.Id);
        
        serviceRequest = '';
        description = '';
        price = 0;
        quantity = 1;
    }
    
    private List<Service__c> getServicesByContactId(string conId)
    {
        return [SELECT Id, Name, Service_Request__c, Description__c, Price__c, Quantity__c, CreatedDate FROM Service__c WHERE Contact__c = :conId ORDER BY CreatedDate DESC];
    }
    
    public List<SelectOption> getProductsAndServices()
    {
        List<SelectOption> servicesList = new List<SelectOption>();
        servicesList.add(new SelectOption('', 'Select product/service'));
        
        List<Product2> products = [SELECT Id, Name, Description FROM Product2 WHERE IsActive  = true];
        for(Product2 product : products)
        {
             servicesList.add(new SelectOption(product.Id, product.Name));
        }
        
        return servicesList;
    }
    
    public void getProduct()
    {
        //Product2 product = [SELECT Id, Name, Description, (SELECT Id, ProductCode, UnitPrice FROM PriceBookEntry) FROM Product2 WHERE Id = :productId];
        PriceBookEntry pbe =  [SELECT Id, ProductCode, UnitPrice, Product2.Id, Product2.Name, Product2.Description FROM PriceBookEntry WHERE Product2Id = :productId];
        if(pbe != null)
        {
            serviceRequest = pbe.Product2.Name;
            description = pbe.Product2.Description;
            price = pbe.UnitPrice;
        }
        else
        {
            serviceRequest = '';
            description = '';
            price = 0;
        }
    }
    
    public PageReference addServiceRequest()
    {
        try {
            service = new Service__c();
            service.Service_Request__c = serviceRequest;
            service.Description__c = description;
            service.Price__c = price;
            service.Quantity__c = quantity;
            service.Contact__c = contact.Id;
            insert service;
            
            // send email
            sendEmailNotif(service.Id);
            
            PageReference pageRef = new PageReference('/portal/services');
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
            return null;
        }
    }
    
    private void sendEmailNotif(String id)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'david@bookingninjas.com' };
        message.optOutPolicy = 'FILTER';
        message.subject = 'You have new client\'s service request';
        message.setHtmlBody('See record <a href="https://bookingninjas.my.salesforce.com/' + id + '">here</a>. <br/><br/> Best regards, <br/> David M. Harroch <br/> Founder and CEO <br/> Booking Ninjas');
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}