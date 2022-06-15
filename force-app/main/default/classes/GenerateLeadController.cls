public with sharing class GenerateLeadController {
    
    public Lead lead { get; set; }
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String email { get; set; }
    public String phone { get; set; }
    public String company { get; set; }
    public String position { get; set; }
    public Boolean isSuccess { get; set; }
    public Boolean isFailed { get; set; }
    public String responseMessage { get; set; }
    
    public GenerateLeadController() {
        firstName = '';
        lastName = '';
        email = '';
        phone = '';
        company = '';
        position = '';
        isSuccess = false;
        isFailed = false;
        responseMessage = '';
    }
    
    public void Save() {
        if(checkExistingLead(email)) {
            isSuccess = false;
            isFailed = true;
            responseMessage = 'Email exists on our records! Please provide new one.';
        }
        else {
            lead = new Lead();
            lead.FirstName = firstName;
            lead.LastName = lastName;
            lead.Email = email;
            lead.Phone = phone;
            lead.Company = company;
            lead.Title = position;
            insert lead;
            
            isSuccess = true;
            isFailed = false;
            responseMessage = 'Thank you for your interest!';
        }
    }
    
    private boolean checkExistingLead(String email) {
        List<Lead> leads = [SELECT Id FROM Lead WHERE Email = :email];
        return leads.size() > 0 ? true : false;
    }
}