public class BN_TrialSucceedController {
    private String crediential {
        get {
            List<Stripe_Settings__c> st = [
                SELECT
                    Is_Live__c,
                    Stripe_Secret_Live_Key__c,
                    Stripe_Secret_Test_Key__c
                FROM Stripe_Settings__c
            ];
            if (st.size() > 0) {
                if (st[0].Is_Live__c) {
                    return st[0].Stripe_Secret_Live_Key__c;
                } else {
                    return st[0].Stripe_Secret_Test_Key__c;
                }
            }
            return '';
        }
    }
    private String paymentIntent;
    private Map<String, String> customer;
    public Boolean forbidden {get; set;}

    public BN_TrialSucceedController() {
        paymentIntent = ApexPages.currentPage().getParameters().get('id');
        paymentIntent = paymentIntent.split('_secret_')[0];
        if (paymentIntent == null) {
            forbidden = true;
        } else {
            forbidden = false;
        }

        customer = getCustomer();

        // set cookie
        Cookie visited = ApexPages.currentPage().getCookies().get('visited-'+paymentIntent);
        if (visited == null) {
            visited = new Cookie('visited-'+paymentIntent,'1',null,-1,true);
        } else {
            // If this isn't the first time the user is accessing the page
            // create a new cookie, incrementing the value of the original count by 1
            Integer count = Integer.valueOf(visited.getValue());
            visited = new Cookie('visited-'+paymentIntent, String.valueOf(count+1),null,-1,true);
        }
        ApexPages.currentPage().setCookies(new Cookie[]{visited});
    }

    public pageReference addSuccessActions() {
        Cookie visited = ApexPages.currentPage().getCookies().get('visited-'+paymentIntent);
        if (customer == null) {
            return null;
        } else if (!customer.isEmpty() && customer.containsKey('name') && visited.getValue() == '1' && forbidden == false) {
            // create contact
            createContact(customer);
            // create opp
            createOpportunity(customer);
            // send email confirmation to customer
            String emailConfirmationBody =  'Hello ' + customer.get('name') + ',<br/><br/>' +
                                'Your payment of $1 has been successfully processed. '+
                                'Your Booking Ninjas trial request is currently being set up, and you should receive your account information in less than 24 hours.<br/><br/>' +
                                'If you have any questions or need to make any change to your application, we can easily be reached by replying to this email or you can ' + 
                                'send an email to any Booking Ninjas representative you are currently having a conversation with.<br/><br/>' +
                                'Thank you for choosing Booking Ninjas.<br/><br/>' +
                                'Regards, <br/>Booking Ninjas<br/>';
            sendEmail(customer.get('email'), 'Your payment has been processed - Booking Ninjas', emailConfirmationBody);
            // send email confirmation to staff (dave & oliver)
            String emailNotificationBody =  customer.get('name') + ' from ' + customer.get('company') + ' ' +
                                            'has successfully pay $1 for Booking Ninjas trial.<br/><br/>';
            sendEmail('ceo@bookingninjas.com', 'Trial Request from ' + customer.get('email'), emailNotificationBody);
            sendEmail('oliver@bookingninjas.com', 'Trial Request from ' + customer.get('email'), emailNotificationBody);

            return null;
        } else {
            pageReference pg = new pageReference('/');
            return pg.setRedirect(true);
        }
    }

    private void createContact(Map<String, String> customerData) {
        List<String> customerName = getFirstLastName(customerData.get('name'));
        Contact contact = new Contact();
        contact.trialBusinessName__c = customerData.get('company');
        contact.firstName = customerName[0];
        contact.lastName = customerName[1];
        contact.Email = customerData.get('email');
        contact.Phone = customerData.get('phone');
        insert contact;
    }

    private void createOpportunity(Map<String, String> customerData) {
        Opportunity opportunity = new Opportunity();
        opportunity.Name = customerData.get('name');
        opportunity.trialEmail__c = customerData.get('email');
        opportunity.Type = 'New Business';
        opportunity.StageName = 'Trial';
        opportunity.Trial_Start_Date__c = Date.Today().addDays(1);
        opportunity.CloseDate = Date.Today().addDays(15);
        opportunity.Effective_Date__c = Date.Today().addDays(1);
        insert opportunity;
    }

    private String getCustomerId() {
        String endPoint = 'https://api.stripe.com/v1/payment_intents/' + paymentIntent;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + crediential);
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        HttpResponse res = http.send(request);

        Map<String, Object> respMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        
        Map<String, String> customer = new Map<String, String>();
        if(respMap.containsKey('id')) {
            return (String)respMap.get('customer');
        }
        return null;
    }

    private Map<String, String> getCustomer() {
        String customerId = getCustomerId();
        String endPoint = 'https://api.stripe.com/v1/customers/' + customerId;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + crediential);
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        HttpResponse res = http.send(request);

        Map<String, Object> respMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        Map<String, String> customer = new Map<String, String>();
        if(respMap.containsKey('id') && !respMap.containsKey('deleted')) {
            customer.put('name', (String)respMap.get('name'));
            customer.put('email', (String)respMap.get('email'));
            customer.put('phone', (String)respMap.get('phone'));
            Object metaObj = (Object)respMap.get('metadata');
            Map<String, Object> m = (Map<String, Object>) metaObj;
            customer.put('company', (String)m.get('company'));
            return customer;
        }
        return null;
    }

    private void sendEmail(String email, String emailSubject, String emailBody)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { email };
        message.setSenderDisplayName('Booking Ninjas');
        message.optOutPolicy = 'FILTER';
        message.subject = emailSubject;
        message.setHtmlBody(emailBody);
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }

    private List<String> getFirstLastName(String fullName) {
        List<String> name;
        try {
            name = fullName.split(' ');
        } catch (Exception e) {
            name = new List<String>{'First Name', 'Last Name'};
        }
        String firstName = '';
        String lastName = '';
        if (name.size() == 1) {
            lastName = name[0];
        } else if (name.size() == 2) {
            firstName = name[0];
            lastName = name[1];
        } else {
            firstName = name[0];
            Integer idx = 0;
            for (String n : name) {
                if (idx != 0) {
                    lastName += name[idx] + ' ';
                }
                idx++;
            }
        }
        return new List<String>{firstName, lastName};
    }
}