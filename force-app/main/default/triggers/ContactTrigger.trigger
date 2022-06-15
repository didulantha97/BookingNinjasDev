trigger ContactTrigger on Contact ( before insert, before update, after insert, after update ) {
    
    Set<Id> objectIds = new Set<Id>();
    Set<Id> accountIds = new Set<Id>();
    for( Contact con : Trigger.new ) {
        objectIds.add(con.Id);
        accountIds.add(con.AccountId);
    }
    List<Contact> contacts = [SELECT Id, Name, Phone, MobilePhone, X2nd_Phone_Number__c, AccountId, MailingCountry, Status__c, Call_Flow__c, Call_Request_Date__c, Rating_Contact__c, Linkedin_Activity__c, LinkedIn_Requested_Date__c, LinkedIn_Sent_Accepted_Date__c, X1st_Call__c, X1st_call_Notes__c, Continent__c FROM Contact WHERE Id IN :objectIds];
    
    //List<Contact> contacts_to_update = new List<Contact>();
    
    if( Trigger.isBefore ) {
        Set<String> asia = new Set<String>{'Afghanistan','Armenia','Azerbaijan','Bahrain','Bangladesh','Bhutan','Brunei','Cambodia','China','East Timor','Timor Leste','Georgia','India','Indonesia','Iran','Iraq','Israel','Palestine','Japan','Jordan','Kazakhstan','Kuwait','Kyrgyzstan','Laos','Lebanon','Malaysia','Maldives','Mongolia','Myanmar','Nepal','North Korea','Oman','Pakistan','Philippines','Qatar','Russua','Saudi Arabia','Singapore','South Korea','Sri Lanka','Syria','Taiwan','Tajikistan','Thailand','Turkey','Turkmenistan','United Arab Emirates','Uzbekistan','Vietnam','Yemen'};
        Set<String> africa = new Set<String>{'Algeria','Angola','Benin','Botswana','Burikina Faso','Burundi','Cameroon','Cape Verde','Central African Republic','Chad','Comoros','Republic of Congo','Democratic Republic of Congo','Djibouti','Egypt','Equatorial Guinea','Eritra','Ethiopia','Gabon','The Gambia','Ghana','Guinea','Guinea-Bissau','Kenya','Lesotho','Liberia','Libya','Madagascar','Malawi','Mali','Mauritania','Namibia','Niger','Nigeria','Rwanda','São Tomé and Príncipe','Senegal','Seychelles','Sierra Leone','South Africa','South Sudan','Sudan','Swaziland','Tanzania','Togo','Tunisia','Uganda','Western Sahara','Zambia','Zimababwe'};
        Set<String> australia = new Set<String>{'Australia','Federated States of Micronesia','Fiji','Kiribati','Marshall Islands','Nauru','New Zealand','Palau','Papua New Guinea','Samoa','Solomon Islands','Tonga','Tuvalu','Vanuatu'};
        Set<String> europe = new Set<String>{'Albania','Andorra','Austria','Belarus','Belgium','Bosnia and Herzegovina','Bulgaria','Croatia','Cyprus','Czech Republic','Denmark','Estonia','Finland','France','Germany','Greece','Hungary','Iceland','Republic of Ireland','Itlay','Kosovo','Latvia','Liechtenstein','Lithuania','Luxembourg','Macedonia','Malta','Moldova','Monaco','Montenegro','Netherlands','Norway','Poland','Portugal','Romania','Russia','San Marino','Serbia','Slovakia','Slovenia','Spain','Sweden','Switzerland','Ukraine','United Kingdom','Vatican City'};
        Set<String> southamerica = new Set<String>{'Argentina','Bolivia','Brazil','Chile','Colombia','Ecuador','French Guiana','Guyana','Paraguay','Peru','Suriname','Uruguay','Venezuela'};
        //g.s3 Add new continent
        Set<String> emea = new Set<String>{'Albania','Algeria','Andorra','Angola','Austria','Bahrain','Belarus','Belgium','Benin','Bosnia and Herzegovina','Botswana','Bulgaria','Burkina Faso','Burundi','Cameroon','Cape Verde','Central African Republic','Chad','Comoros','Croatia','Cyprus','Czech Republic','Democratic Republic of the Congo','Denmark','Djibouti','Egypt','Equatorial Guinea','Eritrea','Estonia','Ethiopia','Faroe Islands','Finland','France','Gabon','Gambia','Georgia','Germany','Ghana','Gibraltar','Greece','Guernsey','Guinea','Guinea-Bissau','Hungary','Iceland','Iran','Iraq','Ireland','Isle Of Man','Israel','Italy','Ivory Coast','Jersey','Jordan','Kenya','Kuwait','Latvia','Lebanon','Lesotho','Liberia','Libya','Liechtenstein','Lithuania','Luxembourg','Macedonia','Madagascar','Malawi','Mali','Malta','Mauritania','Mauritius','Moldova','Monaco','Montenegro','Morocco','Mozambique','Namibia','Netherlands','Niger','Nigeria','Norway','Oman','Palestine','Poland','Portugal','Qatar','Romania','Rwanda','San Marino','Sao Tome & Principe','Saudi Arabia','Senegal','Serbia','Slovakia','Slovenia','Somalia','South Africa','Spain','Sudan','Swaziland','Sweden','Switzerland','Syria','Tanzania','Togo','Tunisia','Turkey','Uganda','Ukraine','United Arab Emirates','United Kingdom','Vatican City','Western Sahara','Yemen','Zambia','Zimbabwe'};
        
            
        for( Contact con : contacts ) {        
           // trigger based on contact's status
           if( con.Status__c == 'Mapping Call' ) {
                con.Call_Flow__c = '';
                con.Call_Request_Date__c = null;
                con.Rating_Contact__c = 'Email Not Found';
            }
           else if( con.Status__c == 'Cold' ) {
                con.Call_Flow__c = 'Priority Call List 3';
                con.Call_Request_Date__c = DateTime.Now();
                con.Linkedin_Activity__c = '';
                con.LinkedIn_Requested_Date__c = null;
                con.Rating_Contact__c = '';
            }
            else if( con.Status__c == 'Warm' || con.Status__c == 'Super Warms' ) {
                con.Call_Flow__c = 'Priority Call List 2';
                con.Call_Request_Date__c = DateTime.Now();
                if ( con.Linkedin_Activity__c == null ) {
                    con.Linkedin_Activity__c = 'Send Request';
                    con.LinkedIn_Requested_Date__c = Date.Today();
                }
                con.Rating_Contact__c = '';
                con.X1st_Call__c = DateTime.Now().addDays(2);
                con.X1st_call_Notes__c = con.Status__c;
            }
            else if( con.Status__c == 'Hot' || con.Status__c == 'Active Conversation' ) {
                con.Call_Flow__c = 'Priority Call List 1';
                con.Call_Request_Date__c = DateTime.Now();
                if ( con.Linkedin_Activity__c == null ) {
                    con.Linkedin_Activity__c = 'Send Request';
                    con.LinkedIn_Requested_Date__c = Date.Today();
                }
                con.Rating_Contact__c = '';
                con.X1st_Call__c = DateTime.Now().addDays(2);
                con.X1st_call_Notes__c = con.Status__c;
            }
            else if( con.Status__c == 'Dead' || con.Status__c == 'Bad Fit' || con.Status__c == 'Check back Quarterly' ) {
                con.Call_Flow__c = '';
                con.Call_Request_Date__c = null;
                con.Rating_Contact__c = '';
            }
            
            // trigger based on linkedin activity
            if( con.Linkedin_Activity__c == 'Sent' || con.Linkedin_Activity__c == 'Accepted' ) {
                if( con.LinkedIn_Sent_Accepted_Date__c == null ) {
                    con.LinkedIn_Sent_Accepted_Date__c = Date.Today();
                }   
            }
            
            // trigger to set continent value based on Mailing country
            if(String.isNotEmpty(con.MailingCountry)) {
                if( JSON.serialize(asia).contains(con.MailingCountry) ) {
                    con.Continent__c = 'Asia';
                }
                else if( JSON.serialize(africa).contains(con.MailingCountry) ) {
                    con.Continent__c = 'Africa';
                }
                else if( JSON.serialize(australia).contains(con.MailingCountry) ) {
                    con.Continent__c = 'Australia & Oceania';
                }
                else if( JSON.serialize(europe).contains(con.MailingCountry) ) {
                    con.Continent__c = 'Europe';
                }
                else if( JSON.serialize(southamerica).contains(con.MailingCountry) ) {
                    con.Continent__c = 'South America';
                }
                //g.s3 add logic for EMEA countries
                else if( (JSON.serialize(emea).contains(con.MailingCountry) && JSON.serialize(africa).contains(con.MailingCountry)) || (JSON.serialize(emea).contains(con.MailingCountry) && JSON.serialize(australia).contains(con.MailingCountry)) || (JSON.serialize(emea).contains(con.MailingCountry) && JSON.serialize(europe).contains(con.MailingCountry)) ) {
                    con.Continent__c = 'EMEA';
                }
            }
            continue;
        }
    }
    
    if( Trigger.isAfter && Trigger.isUpdate ) {
        
        List<Cook_Book__c> cook_books = new List<Cook_Book__c>();
        
        List<Opportunity> opportunity_to_create = new List<Opportunity>();
        List<Opportunity> check_opp = [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN :accountIds];
        
        for( Contact con : contacts ) {
               
           // trigger to update all related cook book's mobile phone
           for(Cook_Book__c cb : con.Cook_Books__r) {
               cb.Mobile__c = con.MobilePhone;
               cb.Phone__c = con.Phone;
               cb.X2nd_Phone__c = con.X2nd_Phone_Number__c;
               cook_books.add(cb);
           }
           
           // trigger to create new opportunity
           if( con.Status__c == 'Hot' || con.Status__c == 'Super Warms' ) {
               if(check_opp.size() == 0) {
                    Opportunity opp = new Opportunity();
                    opp.Name = con.Name + '_Qualification_' + String.valueOf(Date.Today().addDays(7));
                    opp.AccountId = con.AccountId;
                    opp.Primary_Contact__c = con.Id;
                    opp.CloseDate = Date.Today().addDays(7);
                    opp.StageName = 'Qualification';
                    opp.Probability = 10;
                   
                    opportunity_to_create.add(opp);
                }
                continue;
            }
        }
        
        try {
            if( cook_books.size() > 0 ) {
                update cook_books;
            }
            
            if( opportunity_to_create.size() > 0 ) {
                insert opportunity_to_create;
            }
        }
        catch(DMLException e) {
            system.debug('Error: '+ e);
        }   
    }
    
    // used by trial/pilot form, author: teguh@bookingninjas.com
    // create contact with no duplicate account
    if (Trigger.isBefore && Trigger.isInsert) {
        // check old accounts
        List<String> accountsName = new List<String>();
        for (Contact contact : Trigger.New) {
            if (contact.trialBusinessName__c != null) {
                accountsName.add(contact.trialBusinessName__c);
            }
        }
        Map<String, Id> oldAcounts = new Map<String, Id>();
        for (Account acc : [SELECT Id, Name FROM Account WHERE Name IN :accountsName]){
        	oldAcounts.put(acc.Name, acc.Id);
        }
        for (Contact contact : Trigger.New) {
            if (contact.trialBusinessName__c != null) {
                Id accId = oldAcounts.get(contact.trialBusinessName__c);
                if (accId == null) {
                    Account account = new Account();
                    account.Name = contact.trialBusinessName__c;
                    insert account;
                    accId = account.Id;
                }
                Trigger.New[0].AccountId = accId;
            }
        }
    }
    
    // used by trial/pilot form, author: teguh@bookingninjas.com
    // remove if current record is duplicate contact
    if (Trigger.isAfter && Trigger.isInsert) {
        List<Id> accountId = new List<Id>();
        for (Contact contact : Trigger.New) {
            accountId.add(contact.AccountId);
        }
        for (Contact contact : Trigger.New) {
            if (contact.trialBusinessName__c != null) {
            	List<Contact> contacts = [SELECT Id FROM Contact WHERE Email = :contact.Email];
                if (contacts.size() > 1) {
                    delete [SELECT Id FROM Contact WHERE Id IN :Trigger.New];
                }   
            }
        }
    }

}