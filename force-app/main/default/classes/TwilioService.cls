/*****************************************************************************************
 * @Purpose      : Handle Twilio operations via Twilio API
 * @Created Date : 30 August 2017
 * @Author       : Madhura Priyadarshana 
 *****************************************************************************************/ 

public class TwilioService {
    
    String baseURL = 'https://api.twilio.com';
    String AccountSid;
    String AuthToken;
    String SMSNumber;
    String WhatsappNumber;
    Twilio__mdt twilio = new Twilio__mdt();
    Set<String> objectIds = new Set<String>();
    List<Contact> contacts = new List<Contact>();
    public List<Twilio_SMS__c> trackSmsList = new List<Twilio_SMS__c>();
    public String recordId { get; set; }    // record Id where this SMS should associated
    
    public String message { get; set; }
    public String messageContent { get; set; }
    public Boolean isSMS { get; set; }
    public String recipient { get; set; }
    
    public Boolean showError { get; set; }
    public Boolean showSuccess { get; set; }
    public String responseMessage { get; set; }
    
    public String selectedTemplate { get; set; }
    
    public TwilioService() {
        showError = false;
        showSuccess = false;
        responseMessage = '';
        twilio = [SELECT Id, Account_SID__c, Auth_Token__c, SMS_Number__c, Whatsapp_Number__c FROM Twilio__mdt WHERE MasterLabel = 'Twilio'];
    }
    
    public void triggerMessage() {
        sendSMS(message, isSMS);
    }
    
    public void sendSMS(String message, Boolean isSMS) {
        
        if(twilio == null) {
            showError = true;
            showSuccess = false;
            responseMessage = 'Twilio is not setup in this org.';
        }
        
        string sidtoken = twilio.Account_SID__c + ':' + twilio.Auth_Token__c;
        SmsNumber = twilio.SMS_Number__c;
        WhatsappNumber = twilio.Whatsapp_Number__c;
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Twilio_Access');
        req.setMethod('POST');
        
        Blob headerValue = Blob.valueOf(sidtoken);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        
        // iterate contacts and send message one at a time
        List<String> contactIds = recordId.split(',');
        for(String contactId : contactIds) {
            objectIds.add(contactId);
        }
        contacts = [SELECT Id, Name, MobilePhone FROM Contact WHERE Id IN :objectIds];
        for(Contact con : contacts) {
            String tempRecipient = String.isnotBlank(con.MobilePhone) ? con.MobilePhone : '';
            if(String.isNotBlank(tempRecipient)) {
                tempRecipient = tempRecipient.startsWith('\\+') ? tempRecipient.replaceFirst('\\+', '') : tempRecipient;
                tempRecipient = tempRecipient.replace('-', '');   // remove dash
                tempRecipient = tempRecipient.replace(' ', '');  // remove whitespace
            }
            recipient = tempRecipient;
            
            String body = '';
            
            if(isSMS) {
                body = 'From=' + SmsNumber + '&To=%2B' + recipient + '&Body=';
            }
            else {
                body = 'From=whatsapp:' + WhatsappNumber + '&To=whatsapp:%2B94777709084&Body=';    
            }
            
            // replace variable to contact's first name     
            messageContent = message.replace('{{name}}', con.Name);
            
            body += EncodingUtil.urlEncode(messageContent, 'UTF-8');
            req.setBody(body);
            
            Http ht = new Http();
            try {            
                responseMessage = 'Message successfully sent to recipient(s)!';
                HttpResponse res = ht.send(req);
                
                // Deserialize the JSON to a map of key => value
                Map <String, Object> root = (Map <String, Object>) JSON.deserializeUntyped(res.getBody());
                Object statusCode = (Object)root.get('status');
                if(statusCode instanceof Integer) { // if status is type of Integer, message sending from Twilio is success
                    Integer intStatusCode = (Integer)statusCode;
                    if(intStatusCode != 200 && intStatusCode != 201) {
                        responseMessage = (String)root.get('message');
                        showError = true;
                        showSuccess = false;   
                    }
                } else if(statusCode instanceof String) {   // if status is type of String, message sending from Twilio is success
                    showError = false;
                    showSuccess = true;
                    trackMessage('13052502323', tempRecipient, messageContent, 'Outgoing', String.valueOf(con.Id)); //  store the sent message to a list
                }
            } catch(Exception ex) {
                showError = true;
                showSuccess = false;
                responseMessage = 'Error occurred : ' + ex.getMessage();
                System.debug('ERROR : ' + ex.getMessage());
            }
        }
        
        // Insert new Twilio sms list
        if(trackSmsList.size() > 0) {
             insert trackSmsList;
        }
    }
    
    //  Reset the message text area with the selected template body
    public void onChangeTemplate() {
        if(String.isNotBlank(this.selectedTemplate)) {
            SMS_Template__c template = [SELECT Id, Template_Body__c FROM SMS_Template__c WHERE Id =: this.selectedTemplate
                                       AND Active__c = true LIMIT 1];
            this.message = template.Template_Body__c;
        }    
    }
    
    //  Load all the active templates and setup a picklist to bind with UI
    public List<SelectOption> getTemplates() {
        List<SelectOption> templates = new List<SelectOption>();
        templates.add(new SelectOption('','--None--'));
        for(SMS_Template__c t : [SELECT Id, Name, Template_Body__c FROM SMS_Template__c WHERE Active__c = true]) {
            templates.add(new SelectOption(t.Id, t.Name));
        }
        
        return templates;
    }
    
    // Store Twilio sms record with the given information to track incoming/outgoing SMSes
    public void trackMessage(String recipient, String sender, String message, String direction, String recordId) {
        String tempRecipient = recipient.remove('%2B').remove('+');
        String tempSender = sender.remove('%2B').remove('+');
        
        Twilio_SMS__c sms = new Twilio_SMS__c(
            Direction__c = Direction,
            From__c = tempSender,
            To__c = tempRecipient,
            Message__c = message,
            Contact__c = recordId
        );
        
        trackSmsList.add(sms);
    }
}