public    class PreCallPlanningController {
     String recId;
     public Pre_Call_Planner__c precall {get; set;}
     public Account account {get; set;}
     
     public PreCallPlanningController(ApexPages.StandardController stdController){
         recId = ApexPages.currentPage().getParameters().get('Id');
         
         precall = [Select CreatedById, CreatedBy.Name, Id, Account__c, 
                         Date_of_Call__c, KARE_Designation__c, X30_Seconds_Commercial__c, Pain__c, Budget__c, Decision__c, Post_Sell__c, Goals_For_Call__c, Key_Questions_To_Ask__c,
                         Questions_The_Buyer_May_Ask_You__c, Your_Responses_To_These_Questions__c, Planned_Up_Front_Contract__c, Bonding_and_Rapport__c,
                         Client_Contact_1__c, Client_Contact_2__c, Client_Contact_3__c, Client_Contact_4__c,
                         Client_Contact_1__r.Name, Client_Contact_2__r.Name, Client_Contact_3__r.Name, Client_Contact_4__r.Name,
                         Role_1__c, Role_2__c, Role_3__c, Role_4__c,
                         Impact_On_This_Deal_1__c, Impact_On_This_Deal_2__c, Impact_On_This_Deal_3__c, Impact_On_This_Deal_4__c, 
                         Met_Before_1__c, Met_Before_2__c, Met_Before_3__c, Met_Before_4__c, 
                         LinkedIn_Connected_1__c, LinkedIn_Connected_2__c, LinkedIn_Connected_3__c, LinkedIn_Connected_4__c, 
                         DISC_Style_1__c, DISC_Style_2__c, DISC_Style_3__c, DISC_Style_4__c, 
                         Existing_Relationship_1__c, Existing_Relationship_2__c, Existing_Relationship_3__c, Existing_Relationship_4__c,
                         Selling_Team_Attendees__c, New_Information_Learned__c, Next_Steps_Planned__c, Red_Flags_Potential_Problems_Uncovered__c, Questions_Topics_For_Next_Contact__c,
                         Action_Steps_1__c, Who_1__c, Who_1__r.Name, When_1__c, Intended_Result_1__c, 
                         Action_Steps_2__c, Who_2__c, Who_2__r.Name, When_2__c, Intended_Result_2__c 
                    from Pre_Call_Planner__c where Id =: recId];
                    
         account = [Select Id, Name, FirstName, LastName from Account where Id =: precall.Account__c];
     }
     
     private Attachment Attach;
     private Blob body;
     
     public Pre_Call_Planner__c getPreCall() {
         return precall;
     }
     
     public Account getAccount() {
         return account;
     }
     
     public PageReference SavePreCallPlanningForm() {
         
         precall.Date_of_Call__c = precall.Date_of_Call__c;
         precall.KARE_Designation__c = precall.KARE_Designation__c;
         precall.Bonding_and_Rapport__c = precall.Bonding_and_Rapport__c;
         precall.X30_Seconds_Commercial__c = precall.X30_Seconds_Commercial__c;
         precall.Pain__c = precall.Pain__c;
         precall.Budget__c = precall.Budget__c;
         precall.Decision__c = precall.Decision__c;
         precall.Post_Sell__c = precall.Post_Sell__c;
         precall.Goals_For_Call__c = precall.Goals_For_Call__c;
         precall.Key_Questions_To_Ask__c = precall.Key_Questions_To_Ask__c;
         precall.Questions_The_Buyer_May_Ask_You__c = precall.Questions_The_Buyer_May_Ask_You__c;
         precall.Your_Responses_To_These_Questions__c = precall.Your_Responses_To_These_Questions__c;
         precall.Planned_Up_Front_Contract__c = precall.Planned_Up_Front_Contract__c;
         
         precall.Client_Contact_1__c = precall.Client_Contact_1__c;
         precall.Role_1__c = precall.Role_1__c;
         precall.Impact_On_This_Deal_1__c = precall.Impact_On_This_Deal_1__c;
         precall.Met_Before_1__c = precall.Met_Before_1__c;
         precall.LinkedIn_Connected_1__c = precall.LinkedIn_Connected_1__c;
         precall.DISC_Style_1__c = precall.DISC_Style_1__c;
         precall.Existing_Relationship_1__c = precall.Existing_Relationship_1__c;
         
         precall.Client_Contact_2__c = precall.Client_Contact_2__c;
         precall.Role_2__c = precall.Role_2__c;
         precall.Impact_On_This_Deal_2__c = precall.Impact_On_This_Deal_2__c;
         precall.Met_Before_2__c = precall.Met_Before_2__c;
         precall.LinkedIn_Connected_2__c = precall.LinkedIn_Connected_2__c;
         precall.DISC_Style_2__c = precall.DISC_Style_2__c;
         precall.Existing_Relationship_2__c = precall.Existing_Relationship_2__c;
         
         precall.Client_Contact_3__c = precall.Client_Contact_3__c;
         precall.Role_3__c = precall.Role_3__c;
         precall.Impact_On_This_Deal_3__c = precall.Impact_On_This_Deal_3__c;
         precall.Met_Before_3__c = precall.Met_Before_3__c;
         precall.LinkedIn_Connected_3__c = precall.LinkedIn_Connected_3__c;
         precall.DISC_Style_3__c = precall.DISC_Style_3__c;
         precall.Existing_Relationship_3__c = precall.Existing_Relationship_3__c;
         
         precall.Client_Contact_4__c = precall.Client_Contact_4__c;
         precall.Role_4__c = precall.Role_4__c;
         precall.Impact_On_This_Deal_4__c = precall.Impact_On_This_Deal_4__c;
         precall.Met_Before_4__c = precall.Met_Before_4__c;
         precall.LinkedIn_Connected_4__c = precall.LinkedIn_Connected_4__c;
         precall.DISC_Style_4__c = precall.DISC_Style_4__c;
         precall.Existing_Relationship_4__c = precall.Existing_Relationship_4__c;
         
         update precall;
         
         PageReference p = new Pagereference('/' + recId);
         p.setRedirect(true);
         return p;
     }
     
     public void GeneratePreCallPdf() {
         
          PageReference pdf = Page.PreCallPlannerPdf;
          
          pdf.getParameters().put('Id',String.valueOf(precall.Id));
          try {
              body = pdf.getContent();
          }
          catch(VisualforceException e) {
              body = Blob.valueOf('Couldn\'t get the content of - ' + String.valueOf(precall.Id));
          }
          
          attach = new Attachment();
          attach.Name ='Pre-Call Planner - ' + account.Name + '.pdf';
          attach.Body = body;
          attach.IsPrivate = false;
          attach.ParentId = precall.Id;
          
          try {
              insert attach;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Pre-Call Planner -' + account.Name + '.pdf was created'));
          }
          catch(Exception e) 
          {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occurred. Please try again.'));
          }
     }
     
     public PageReference SaveCallDebriefingForm() {
         
         precall.Selling_Team_Attendees__c = precall.Selling_Team_Attendees__c;
         precall.New_Information_Learned__c = precall.New_Information_Learned__c;
         precall.Next_Steps_Planned__c = precall.Next_Steps_Planned__c;
         precall.Red_Flags_Potential_Problems_Uncovered__c = precall.Red_Flags_Potential_Problems_Uncovered__c;
         precall.Questions_Topics_For_Next_Contact__c = precall.Questions_Topics_For_Next_Contact__c;
         
         precall.Action_Steps_1__c = precall.Action_Steps_1__c;
         precall.Who_1__c = precall.Who_1__c;
         precall.When_1__c = precall.When_1__c;
         precall.Intended_Result_1__c = precall.Intended_Result_1__c;
         
         precall.Action_Steps_2__c = precall.Action_Steps_2__c;
         precall.Who_2__c = precall.Who_2__c;
         precall.When_2__c = precall.When_2__c;
         precall.Intended_Result_2__c = precall.Intended_Result_2__c;
         
         update precall;
         
         PageReference p = new Pagereference('/' + recId);
         p.setRedirect(true);
         return p;
     }
     
     public void GenerateCallDebriefingPdf() {
         
          PageReference pdf = Page.CallDebriefingPdf;
          
          pdf.getParameters().put('Id',String.valueOf(precall.Id));
          try {
              body = pdf.getContent();
          }
          catch(VisualforceException e) {
              body = Blob.valueOf('Couldn\'t get the content of - ' + String.valueOf(precall.Id));
          }
          
          attach = new Attachment();
          attach.Name ='Call Debriefing Tool - ' + account.Name+ '.pdf';
          attach.Body = body;
          attach.IsPrivate = false;
          attach.ParentId = precall.Id;
          
          try {
              insert attach;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Call Debriefing Tool -' + account.Name + '.pdf was created'));
          }
          catch(Exception e) 
          {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occurred. Please try again.'));
          }
     }
}