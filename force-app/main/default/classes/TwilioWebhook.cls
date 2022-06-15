/***********************************************
 * @Purpose      : Webhook handler for Twilio
 * @Created Date : 27 October 2018
 * @Author       : Madhura Priyadarshana 
 ***********************************************/ 
@RestResource(urlMapping='/webhook/*')
global class TwilioWebhook {
    
    //	GET method
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        String action = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        //	if the request is coming from Twilio Record
        if('recording'.equals(action)) {
            Map<String, String> params = req.params;
            String callSid;
            String callDuration;
            String recordingUrl;
            for(String s : params.keySet()) {
                if('RecordingUrl'.equals(s) && params.get(s) != null) {
                    recordingUrl = params.get(s);
                } else if('DialCallDuration'.equals(s)  && params.get(s) != null) {
                    callDuration = params.get(s);
                } else if('CallSid'.equals(s) && params.get(s) != null) {
                    callSid = params.get(s);
                }
            }
                        
            String re = '<?xml version="1.0" encoding="UTF-8"?>' +
                '<Response />';
            RestResponse res = Restcontext.response;
            res.addHeader('Content-Type', 'application/xml');
            res.responseBody = Blob.valueOf(re);
            
            //	update task with call information
            TwilioWebhook.updateLog(callSid, callDuration, recordingUrl);
            
        } else {
            Map<String, String> params = req.params;
            String sender = '';
            String recipient = '';
            String message = '';
            
            //	collecting information to store under correct contact 
            for(String s : params.keySet()) {
                
                if('To'.equals(s)) {
                    recipient = params.get(s);
                    continue;
                } else if('From'.equals(s)) {
                    sender = params.get(s);
                    continue;
                } else if('Body'.equals(s)) {
                    message = params.get(s);
                    continue;
                }
            }
            
            //	generating response back to the sender
            String re = '<?xml version="1.0" encoding="UTF-8"?>' +
                '<Response>' +
                '<Message>Thank you for responding!\n' +
                '-Booking Ninjas-</Message>' +
                '</Response>';
            RestResponse res = Restcontext.response;
            res.addHeader('Content-Type', 'application/xml');
            res.responseBody = Blob.valueOf(re);
            
            String recordId = TwilioWebhook.getIdByPhone(sender);	//	get the id of the contact
            if(String.isNotBlank(recordId))
                TwilioWebhook.trackSMS(sender, recipient, message, recordId);
            
        }
    }
    
    //	passing to the message utility class to send the message
    private static void trackSMS(String sender, String recipient, String message, String recordId) {
        TwilioService service = new TwilioService();
        service.trackMessage(sender, recipient, message, 'Incoming', recordId);	//	store the sent message
    }

    //	util method to get the Contact record from the incoming messages's phone number
    private static String getIdByPhone(String phone) {
        String recordId;
        for(Contact con : [SELECT Id FROM Contact WHERE MobilePhone =: phone]) {
            recordId = con.Id;
            break;
        }
        
        if(String.isBlank(recordId)) {
            if(phone.startsWith('+')) {
                phone = phone.removeStart('+');
            } else {
                phone = '+' + phone;
            }
            
            for(Contact con : [SELECT Id FROM Contact WHERE MobilePhone =: phone]) {
                recordId = con.Id;
                break;
            }
        }
        
        return recordId;
    }
    
    //	update the existing task record which was created just after the call hangup, with recording url
    //	which is coming from twilio end
    private static void updateLog(String callSid, String callDuration, String recordingUrl) {
        System.debug('called update : ' + callSid);
        if(String.isNotBlank(callSid)) {
        	List<Call_Log__c> logs = [SELECT Id, Twilio_Call_Id__c, 
                               Call_Duration__c, Recording_URL__c, Call_Date__c
                          FROM Call_Log__c WHERE Twilio_Call_Id__c =: callSid LIMIT 1];
            System.debug('log : ' + logs);
            if(!logs.isEmpty()) {
                Call_Log__c log = logs.get(0);
                log.Recording_URL__c = recordingUrl;
                log.Call_Date__c = Date.today();
                log.Call_Duration__c = (String.isNotBlank(callDuration)) ? Integer.valueOf(callDuration)/60 : 0;
                update log;
            }
        }
    }
}