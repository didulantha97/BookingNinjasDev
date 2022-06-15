/*****************************************************************************************
 * @Purpose      :  Hold all the API calls to FullContact end
 * @Created Date :  30 April 2018
 * @Author       :  Madhura Priyadarshana 
 *****************************************************************************************/ 
global with sharing class FullContactService {
    
    String baseURL;
    String API_KEY;
    List<FullContact_Login__mdt> fullContactLogin = [SELECT Id, API_Key__c, Endpoint__c, Recipients__c FROM FullContact_Login__mdt WHERE MasterLabel = 'Primary'];
    
    public FullContactService() {
        
    }
    
    //	common functionality to update a given contact according to the response recieved from Lunch
    webservice static String updateContact(String contId) {
        
        String strStatus = '';
        // Initializing service
        FullContactService service = new FullContactService();
        
        if(service.fullContactLogin.isEmpty())
            return 'FullContact is not setup in this org';
        
        try {
            Contact cont = [SELECT Email, MobilePhone, Name FROM Contact WHERE Id =: contId LIMIT 1];
            PersonResponse pr = new PersonResponse();
            pr.email = cont.Email;    //	send at least one fields from Queryable list as described in FullContact doc
            pr.Phone = cont.MobilePhone;
            pr.fullName = cont.Name;                        
            
            HttpResponse res = service.getPersonProfile(pr);
            System.debug('raw res : \n' + res.getBody());
            if(res.getStatusCode() == 200) {
                String formattedRes = res.getBody().replace('end :', 'endEducation :');
                System.debug('formattedRes : \n' + formattedRes);
                PersonResponse retPR = (PersonResponse)System.JSON.deserialize(res.getBody(), PersonResponse.class);
                System.debug('resp : ' + retPR);
                
                Contact c = new Contact();
                c.Id = cont.Id;
                c.Sync_with_FullContact__c = false;	//	resetting sync flag to false
                //c.Email = retPR.Email;
                c.LinkedIN__c = retPR.linkedin;
                c.Description = retPR.bio;
                c.Twitter__c = retPR.twitter;
                c.Age_Range__c = retPR.ageRange;
                c.Location__c = retPR.location;
                
                PersonResponse.Details details = retPR.details;
                System.debug('details : ' + details);
                if(details.emails != null && details.emails.isEmpty() != true) {
                    c.Email = details.emails.get(0).value;
                }
                
                c.Phone = retPR.phone;
                
                String tempName = retPR.fullName;
                if(String.isNotBlank(tempName) && tempName.split(' ').size() > 0) {
                    c.FirstName = tempName.split(' ').get(0);
                    c.LastName = tempName.split(' ').get(1);
                }
                
                upsert c; 
                strStatus = 'Updated';
            } else if(res.getStatusCode() == 404) {	//	if the given profile is not found in FullContact
                System.debug('Profile not found for : ' + cont);
                strStatus = 'Profile not found';
            } else
                strStatus = res.getStatus() + '. Check for required email field before calling back';
        } catch(Exception e) {
            strStatus = e.getMessage();
        }
        
        return strStatus;
    }
    
    //	Call FullContact endpoint and get person information
    public HttpResponse getPersonProfile(PersonResponse pr) {
        this.baseURL = fullContactLogin.get(0).Endpoint__c;
        this.API_KEY = fullContactLogin.get(0).API_KEY__c;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.baseURL + 'v3/person.enrich');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + this.API_KEY);
        req.setBody(System.JSON.serialize(pr));
        
        HttpResponse res = h.send(req);
        
        return res;        
    }

}