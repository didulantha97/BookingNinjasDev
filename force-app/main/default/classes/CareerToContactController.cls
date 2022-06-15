/*
CHANGE LOG:
-  Edited by Bohdan Dosiak 26.12.2020
-  Edited by Bohdan Dosiak 27.12.2020


*/


public with sharing class CareerToContactController {
    
    public Id careerId {get; set;}
    public Career__c career {get; set;}
    public Contact contact {get; set;}
    public Main_Accounts__c devAcc {get; set;}
    
    public CareerToContactController(ApexPages.StandardController controller) 
    {
        careerId = (Id)controller.getRecord().get('id');
        career = getCareer(careerId);
        devAcc =  getDevAcc();
    }
    
    private Career__c getCareer(Id cId) {
        return [SELECT Id, Name__c, Email__c, Phone__c, Position__c, Linkedin__c FROM Career__c WHERE Id = :cId LIMIT 1];
    }
    private Main_Accounts__c getDevAcc(){
        if(System.Test.isRunningTest()){
         return [SELECT Id, Name, Account_Id__c FROM Main_Accounts__c WHERE Name = 'Booking Ninjas Devs_Test'];       
        }else{
         return [SELECT Id, Name, Account_Id__c FROM Main_Accounts__c WHERE Name = 'Booking Ninjas Devs'];    
        }
       
    }
    
    public PageReference convertToContact()
    {
        String pageReferenceUrl;
        // validates record
        if(getContactByEmail(career.Email__c).size() > 0)
        {
            // fetch contact and do update
            contact = getContactByEmail(career.Email__c)[0];
            contact.LastName = nameSeperator(career.Name__c)[0]; //assign last name
            contact.FirstName = nameSeperator(career.Name__c)[1]; //assign first name
            contact.Email = career.Email__c;
            contact.Phone = career.Phone__c;
            contact.Title = career.Position__c;
            contact.LinkedIN__c = career.Linkedin__c;
            update contact;
            pageReferenceUrl = '/apex/eSignGenieApp__sendContactDetails?objId={!' +
                + updateOpportunities(contact.Id)
                + '}&prntObjName=Opportunity';
           
        }
        else 
        {
            // create new contact
            contact = new Contact();
            contact.LastName = nameSeperator(career.Name__c)[0]; //assign last name
            contact.FirstName = nameSeperator(career.Name__c)[1]; //assign first name
            contact.Email = career.Email__c;
            contact.Phone = career.Phone__c;
            contact.LinkedIN__c = career.Linkedin__c;
            contact.Title = career.Position__c;
            contact.AccountId = devAcc.Account_Id__c;
            insert contact;
            pageReferenceUrl = '/apex/eSignGenieApp__sendContactDetails?objId={!' +
            + createNewOpportunity(contact.Id)
            + '}&prntObjName=Opportunity';
        }
        
        // delete career
        delete career;
        
        // redirect to new contact
        if(String.isNotEmpty(pageReferenceUrl)){
            if(System.Test.IsRunningTest()){
                pageReferenceUrl = '/'+contact.Id;
            }
            PageReference pageRef = new PageReference(pageReferenceUrl);
            pageRef.setRedirect(true);
            return pageRef;
        }else
        {
            return null;
        }

    }
    
    private List<Contact> getContactByEmail(String email) {
        return [SELECT Id, FirstName, LastName, Email, Phone, AccountId, Account.Name FROM Contact WHERE Email = :email];
    }
    
    public String updateOpportunities(String primContId){
        List<Opportunity> oppList = new List <Opportunity>([
            SELECT Id, 
            AccountId,
            Primary_Contact__c,
            CloseDate,
            StageName
            FROM Opportunity
            WHERE Primary_Contact__c =: primContId
            AND AccountId =: devAcc.Account_Id__c
        ]);
        if(!oppList.isEmpty()){
            for(Opportunity o : oppList){
                o.StageName = 'Onboarding';
                o.CloseDate = Date.valueOf(System.now().addHours(40)); //40 hours hardcoded
            }
            update oppList;
            //need workaround with ret of collections
            return oppList[0].Id;
        }else{
            createNewOpportunity(primContId);
        }
        return null;
    }
    public String createNewOpportunity(String primContId){
        if(devAcc != null){
            Opportunity newOpp = new Opportunity();
            newOpp.Name = 'Onboarding ' + Date.valueOf(System.now().addHours(40));
            newOpp.AccountId = devAcc.Account_Id__c;
            newOpp.StageName = 'Onboarding';
            newOpp.CloseDate = Date.valueOf(System.now().addHours(40)); //40 hours hardcoded
            newOpp.Primary_Contact__c = primContId;
            newOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Developer').getRecordTypeId();
            insert newOpp;
            return newOpp.Id;
        }else{
            return null;
        }
        
    }
    //not verry good point =(
    //but works as expected
    public List<String> nameSeperator(String toSeperate){
    List<String> returnResult = new List<String>();
    List<String> res = toSeperate.split(' ', 2);
    if(res.size() > 1){
        returnResult.add(res[1]); //last name
        returnResult.add(res[0]); //first name
    }else{
        returnResult.add(res[0]); //last name
        returnResult.add(''); //first name
    }
  
    return returnResult;
    }
}