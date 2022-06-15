global without sharing class ESignEmbedService {

    /**
     * Fetches eSign_Embed_Config__c custom settings value
     */
    public eSign_Embed_Config__c apiSettings {
        get {
            if(apiSettings == null) {
                apiSettings = eSign_Embed_Config__c.getInstance(UserInfo.getUserId());
                if (apiSettings == null) {
                    throw new EmbedServiceException('eSign Genie Config is missing!');
                }
            }
            return apiSettings;
        }
        set {
            apiSettings = value;
        }
    }

    /** API endpoints for the HTTP request */
    @TestVisible protected String endpoint = 'https://www.esigngenie.com/esign/api';
    @TestVisible protected String oauthEndpoint = '/oauth2/access_token';
    @TestVisible protected String createFolderEndpoint = '/templates/createFolder';
    @TestVisible protected String downloadFolderEndpoint = '/folders/document/download';
    @TestVisible protected String folderDetailEndPoint = '/folders/myfolder?folderId=';

    /** Template Id from eSign Genie */
    @TestVisible protected String templateId = '79905';

    @TestVisible protected String accessToken;
    @TestVisible protected String embeddedSessionURL;

    @TestVisible
    void setAccessToken() {
        String urlParams = '?grant_type=client_credentials&client_id='+
            this.apiSettings.API_Key__c+'&client_secret=' + this.apiSettings.API_Secret__c +
            '&scope=read-write';
        
        try {
            HttpResponse response = 
                this.doCallout('POST', 'application/x-www-form-URLencoded', this.endpoint + this.oauthEndpoint + urlParams, null );
            OAuthResponse oauthResponse= (OAuthResponse)JSON.deserialize(response.getBody(), OAuthResponse.class);
            this.accessToken = oauthResponse.access_token;
        }
        catch(Exception ex) {
            throw new EmbedServiceException('EsignEmbedService -- Callout exception in setting access token!');
        }
    }

    /**
     * Invokes createFolder request and updated related opportunity record with created folder Id
     * @param recordId current opportunity Id from controller class
     * @return embedded session URL of created folder for signing
     */
    public String invokeCreateFolderRequest(Id recordId) {
        Opportunity opp = getOpportunity(recordId);

        if(String.isBlank(opp.Primary_Contact__c)) throw new EmbedServiceException('There is no contact data to send document!');
        

        this.setAccessToken();

        if(!String.isBlank(String.valueOf(opp.ESignGenie_FolderId__c))) {
            throw new EmbedServiceException('Seems like the document is already signed!');
        } else {
            String body = JSON.serialize(
                new Map<String, Object> {
                    'templateIds' => new List<Object> { this.templateId },
                    'parties' => new List<Object> { new Map<String, Object> { 
                        'firstName' =>  opp.Primary_Contact__r.FirstName,
                        'lastName' => opp.Primary_Contact__r.LastName,
                        'emailId' => opp.Primary_Contact__r.Email,
                        'permission' => 'FILL_FIELDS_AND_SIGN',
                        'sequence' => 1
                    }},
                    'sendNow' => true,
                    'createEmbeddedSigningSession' => true,
                    'embeddedSignersEmailIds' => new List<Object> { opp.Primary_Contact__r.Email }
                }
            );

            HttpResponse response =
                this.doCallOut('POST', 'application/json', this.endpoint + this.createFolderEndpoint, body);
            
            CreateFolderResponse createFolderResponse = (CreateFolderResponse) JSON.deserialize(response.getBody(), CreateFolderResponse.class);

            if(createFolderResponse.result == 'success') {
                this.embeddedSessionURL = createFolderResponse.embeddedSigningSessions[0].embeddedSessionURL;
            }

            opp.ESignGenie_FolderId__c = createFolderResponse.folder.folderId;
            upsert opp;
    }
        return this.embeddedSessionURL;
    }

    /**
     * Attachs signed document to related opportunity and contact
     * @param oppId related opportunity Id 
     * @param contId related contact Id
     * @param folderId related folderId from the Esign Genie
     * @param docNumber document array sequence (generally 1)
     */
    void attachDocument(Id oppId, Id contId, Integer folderId, Integer docNumber) {
        try {
            HttpResponse response = 
                this.doCallOut('GET', 'application/json', this.endpoint + this.downloadFolderEndpoint+'?folderId='+folderId+'&docNumber='+docNumber, null);
    
            Blob responseAsBlob = response.getBodyAsBlob();
            insert new List<Attachment>{
                new Attachment(Name='E-signed file'+docNumber, ParentId=oppId, ContentType='application/pdf', Body = responseAsBlob ),
                new Attachment(Name='E-signed file'+docNumber, ParentId=contId, ContentType='application/pdf', Body = responseAsBlob )
            };
        }
        catch(Exception ex) {
            throw new EmbedServiceException(ex.getMessage());
        }
    }

    /**
     * Checks if the document signed
     * @param oppId related opportunity Id 
     * @param contId related contact Id
     * @param folderId related folderId from the Esign Genie
     */

    public void checkDocSign(Id oppId, Id contId, Integer folderId) {
        this.setAccessToken();
        HttpResponse response =
            this.doCallOut('GET', 'application/json', this.endpoint + this.folderDetailEndPoint + folderId, null);

        FolderDetail folderDetail = (FolderDetail) JSON.deserialize(response.getBody(), FolderDetail.class);

        if(folderDetail.folder.folderStatus.equalsIgnoreCase('signed') || folderDetail.folder.folderStatus.equalsIgnoreCase('executed')) {
            attachDocument(oppId, contId, folderId, 1);
            CardService.createCardRecord(folderDetail.allFieldsNameValue, contId);
        } else {
            throw new EmbedServiceException('Document is not signed!');
        }
    }

    /**
     * Generic function that makes call-out
     */
    private HttpResponse doCallOut(String method, String contentType, String endPoint, String body){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(endPoint);
        if(this.accessToken != null) request.setHeader('Authorization','Bearer ' + this.accessToken);
        request.setHeader('Content-Type', contentType);
        if (body != null) request.setBody(body);

        try {
            HttpResponse response = http.send(request);
            if(response.getStatusCode() != 200 || (method=='POST' && String.isBlank(response.getBody()))) return null;
            return response;
        }
        catch(Exception ex) {
            throw new EmbedServiceException(ex.getMessage());
        }
    }

    public static Opportunity getOpportunity(Id oppId){
        return [
            SELECT Id, Primary_Contact__c, Primary_Contact__r.FirstName, Primary_Contact__r.LastName, Primary_Contact__r.Email, ESignGenie_FolderId__c
            FROM Opportunity 
            WHERE Id= :oppId
        ];
    }

    public class OAuthResponse {
        public String  access_token {get; set;}
    }

    public class CreateFolderResponse {
        public String result {get; set;}
        public List<EmbeddedSigningSessions> embeddedSigningSessions {get; set;}
        public Folder folder {get; set;}
    }

    public class EmbeddedSigningSessions {
        public String embeddedSessionURL {get; set;}
    }

    public class FolderDetail {
        public Folder folder {get; set;}
        public List<FieldValue> allFieldsNameValue {get; set;}
    }

    public class Folder {
        public Integer folderId {get; set;}
        public string folderStatus {get; set;}
    }

    public class FieldValue {
        public String fieldType {get; set;}
        public String name {get; set;}
        public String value {get; set;}

        public FieldValue(String fieldType, String name, String value) {
            this.fieldType = fieldType;
            this.name = name;
            this.value = value;
        }

    }

    public class EmbedServiceException extends Exception {
        public EmbedServiceException(Exception ex, String uiMessage) {
            this.setMessage(uiMessage);
        }
    }
}