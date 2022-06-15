/*****************************************************************************************
 * @Purpose      :  Controller for SendTwilio Visualforce page which handles
 *                  user operations to send twilio SMS/WhatsApp
 * @Created Date :  30 August 2017
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/ 
public with sharing class SendTwilioController {

    public String Ids { get; set; }
    
    public SendTwilioController() {
    
        Ids = apexpages.currentpage().getparameters().get('id');
        
        //System.debug('main : ' + cont.MobilePhone);
    }
}