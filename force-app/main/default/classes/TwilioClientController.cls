/*****************************************************
 * @Purpose         : Controller for Twilio voice related pages : Dial, TwilioClick2Dial, LightningCtiAdapter
 * @Created Date    : 13 November 2018
 * @Author          : Madhura Priyadarshana 
 ****************************************************/ 
public class TwilioClientController {
       
    private TwilioCapability capability;
    private String callSid;
    
    /****   SMS fields  ****/
    public String uname { get; set; }
    public String message { get; set; }
    public Boolean isSMS { get; set; }
    public String selectedTemplate { get; set; }
    public List<Twilio_SMS__c> trackSmsList = new List<Twilio_SMS__c>();
    Twilio__mdt twilioMDT = new Twilio__mdt();
    String baseURL = 'https://api.twilio.com';
    String accountSid;
    String authToken;
    String sMSNumber;
    String whatsappNumber;
    public String parentRecordId { get; set; }
    
    public String recipientMobile { get; set; }
    
    public Boolean showError { get; set; }
    public Boolean showSuccess { get; set; }
    public String responseMessage { get; set; }
    /****   /SMS fields ****/
    
    //****** Initalizer - Set up Twilio Capability Token - requires ApplicationSid__c to be set
    public TwilioClientController() {
        capability = TwilioAPI.createCapability();
        capability.allowClientOutgoing(
            TwilioAPI.getTwilioConfig().ApplicationSid__c,null);
        uname = UserInfo.getUserName();
        capability.allowClientIncoming('salesforce_agent');
        
        //  SMS
        twilioMDT = [SELECT Id, Account_SID__c, Auth_Token__c, SMS_Number__c, Whatsapp_Number__c FROM Twilio__mdt WHERE MasterLabel = 'Twilio'];
    }
    
    //******* {!Token} method returns a string based capability token
    public String getToken() { return capability.generateToken(); }

    //******* Pass in a parameter PhoneNumber - and this will Dial the phone number
    public String getDial() {
        Cook_Book__c cb; // declare CB
        Contact con; // declare Contact
        String parentId = System.currentPageReference().getParameters().get('parentCBId');
        if(String.isNotBlank(parentId)) {
            String objectType = parentId.subString(0,3);
            if(parentId != null && objectType == 'a1V') {
                cb = [SELECT Id, Record_Call__c FROM Cook_Book__c WHERE Id =: parentId LIMIT 1];
            }
            else if( parentId != null && objectType == '003' ) {
                con = [SELECT Id, Record_Call__c FROM Contact WHERE Id =: parentId LIMIT 1];
            }
        }
        //callSid = ApexPages.currentPage().getParameters().get('CallSid');
        //System.debug('callSid : ' + callSid);
        //Call_Log__c cl = [SELECT Id, Cook_Book__r.Record_Call__c FROM Call_Log__c WHERE Twilio_Call_Id__c =: callSid LIMIT 1];
        //System.debug('record : ' + cl);
        String callerid = TwilioAPI.getTwilioConfig().CallerId__c;
        String recordingCallBack = TwilioAPI.getTwilioConfig().Record_Action_URL__c;
        //phone number will be passed as http query parameter
        String PhoneNumber = System.currentPageReference().getParameters().get('PhoneNumber');
        TwilioTwiML.Response res = new TwilioTwiML.Response();
        TwilioTwiML.Dial d;
        TwilioTwiML.Number_X n;
        String lowerCaseNumber = PhoneNumber.toLowerCase();
        
        if(lowerCaseNumber.contains('x')) {
            d = new TwilioTwiML.Dial();
            
            String baseNumber = lowerCaseNumber.split('x').get(0);
            String ext = lowerCaseNumber.split('x').get(1);
            n = new TwilioTwiML.Number_X(baseNumber);
            n.setSendDigits(ext);
            d.append(n);
        } else {                
            d = new TwilioTwiML.Dial(PhoneNumber);                
        }
        
        d.setCallerId(callerid);
        if(cb != NULL && cb.Record_Call__c != NULL && cb.Record_Call__c) {
            d.setRecord('record-from-answer-dual');
            d.setAction(recordingCallBack);
        }
        else if(con != NULL && con.Record_Call__c != NULL && con.Record_Call__c) {
            d.setRecord('record-from-answer-dual');
            d.setAction(recordingCallBack);
        }
        
        d.setMethod('GET');            
        res.append(d);
        System.debug('res : \n' + res.toXML().replace('_X', ''));
        return res.toXML().replace('_X', '');
    }
    
    /************** SMS Features    *********************** */
    
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
    public void trackMessage(String recipient, String sender, String message, String direction, String parentId) {
        String tempRecipient = recipient.remove('%2B').remove('+');
        String tempSender = sender.remove('%2B').remove('+');
        String objectType = parentId.subString(0,3);
        
        Twilio_SMS__c sms = new Twilio_SMS__c();
        sms.Direction__c = Direction;
        sms.From__c = tempSender;
        sms.To__c = tempRecipient;
        sms.Message__c = message;
        if(objectType == '003')
            sms.Contact__c = parentId;
        else if(objectType == 'a1V')
            sms.Cook_Book__c = parentId;
            
        System.debug('rec : ' + sms);
        trackSmsList.add(sms);
    }
    
    //  Reset the message text area with the selected template body
    public void onChangeTemplate() {
        if(String.isNotBlank(this.selectedTemplate)) {
            SMS_Template__c template = [SELECT Id, Template_Body__c FROM SMS_Template__c WHERE Id =: this.selectedTemplate
                                       AND Active__c = true LIMIT 1];
            this.message = template.Template_Body__c;
        }    
    }

    public void triggerMessage() {
        System.debug('number : ?' + this.recipientMobile);
        sendSMS(message, isSMS);
    }
    
    public void sendSMS(String message, Boolean isSMS) {
        if(twilioMDT == null) {
            showError = true;
            showSuccess = false;
            responseMessage = 'Twilio is not setup in this org.';
            return;
        }
        
        string sidtoken = twilioMDT.Account_SID__c + ':' + twilioMDT.Auth_Token__c;
        SmsNumber = twilioMDT.SMS_Number__c;
        WhatsappNumber = twilioMDT.Whatsapp_Number__c;
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Twilio_Access');
        req.setMethod('POST');
        
        Blob headerValue = Blob.valueOf(sidtoken);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        recipientMobile = recipientMobile.startsWith('\\+') ? recipientMobile.replaceFirst('\\+', '') : recipientMobile;
        recipientMobile = recipientMobile.replace('-', '');   // remove dash
        recipientMobile = recipientMobile.replace(' ', '');  // remove whitespace
            
        String body = '';
        
        if(isSMS) {
            body = 'From=' + smsNumber + '&To=%2B' + recipientMobile + '&Body=';
        }
        
        body += EncodingUtil.urlEncode(message, 'UTF-8');
        req.setBody(body);
        
        Http ht = new Http();
        
        try {            
            responseMessage = 'Message successfully sent to recipient(s)!';
            HttpResponse res = ht.send(req);
            System.debug('res : ' + res.getBody());
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
                trackMessage(recipientMobile, '13052502323', message, 'Outgoing', this.parentRecordId); //  store the sent message to a list
            }
        } catch(Exception ex) {
            showError = true;
            showSuccess = false;
            responseMessage = 'Error occurred : ' + ex.getMessage();
            System.debug('ERROR : ' + ex.getMessage());
        }
        
        // Insert new Twilio sms list
        if(trackSmsList.size() > 0 && String.isNotBlank(this.parentRecordId)) {
            insert trackSmsList;
        }
    }
        
    /************** /SMS Features   ************************/
}