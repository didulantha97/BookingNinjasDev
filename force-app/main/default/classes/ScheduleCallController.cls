public with sharing class ScheduleCallController {
    
    public String Id {get;set;}
    
    //public ScheduleCallController(ApexPages.StandardController controller){
    public ScheduleCallController(){

        Id = apexpages.currentpage().getparameters().get('id');
    }
}