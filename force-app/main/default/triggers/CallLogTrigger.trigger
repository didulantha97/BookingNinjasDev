trigger CallLogTrigger on Call_Log__c (after insert, after update) {
    
    Set<Id> objectIds = new Set<Id>();
    for(Call_Log__c cl : Trigger.new) {
        objectIds.add(cl.Id);
    }
    List<Call_Log__c> logs = [SELECT Id, Cook_Book__c, Call_Result__c FROM Call_Log__c WHERE Id IN: objectIds];
     
    if(Trigger.isAfter) {
    
        List<Cook_Book__c> cook_books_to_update = new List<Cook_Book__c>();
        
        for( Call_Log__c cl : logs ) {
            
            if(cl.Cook_Book__c != null) {
                Cook_Book__c cb = [SELECT Id, Call_Result__c FROM Cook_Book__c WHERE Id = :cl.Cook_Book__c];
                
                // map fields
                cb.Call_Result__c = cl.Call_Result__c;
                
                cook_books_to_update.add(cb);
            }
        }
        
        try 
        {
            if( cook_books_to_update.size() > 0 )
            {
                update cook_books_to_update;
            }
        }
        catch(DMLException e) {
            System.Debug('Error: '+ e);
            
        } 
    }  
}