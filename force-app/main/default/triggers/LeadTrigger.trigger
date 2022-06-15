trigger LeadTrigger on Lead ( before insert, before update, after insert, after update ) {
    
    Set<Id> objectIds = new Set<Id>();
    for(Lead l : Trigger.new) {
        objectIds.add(l.Id);
    }
    List<Lead> leads = [SELECT Id, Country, Continent__c, Status__c, Call_Flow__c, Call_Request_Date__c, Rating_Lead__c, Linkedin_Activity__c, LinkedIn_Requested_Date__c, LinkedIn_Sent_Accepted_Date__c FROM Lead WHERE Id IN :objectIds];
    
    List<Lead> leads_to_update = new List<Lead>();
    
    if( Trigger.isBefore ) {
        Set<String> asia = new Set<String>{'Afghanistan','Armenia','Azerbaijan','Bahrain','Bangladesh','Bhutan','Brunei','Cambodia','China','East Timor','Timor Leste','Georgia','India','Indonesia','Iran','Iraq','Israel','Palestine','Japan','Jordan','Kazakhstan','Kuwait','Kyrgyzstan','Laos','Lebanon','Malaysia','Maldives','Mongolia','Myanmar','Nepal','North Korea','Oman','Pakistan','Philippines','Qatar','Russua','Saudi Arabia','Singapore','South Korea','Sri Lanka','Syria','Taiwan','Tajikistan','Thailand','Turkey','Turkmenistan','United Arab Emirates','Uzbekistan','Vietnam','Yemen'};
        Set<String> africa = new Set<String>{'Algeria','Angola','Benin','Botswana','Burikina Faso','Burundi','Cameroon','Cape Verde','Central African Republic','Chad','Comoros','Republic of Congo','Democratic Republic of Congo','Djibouti','Egypt','Equatorial Guinea','Eritra','Ethiopia','Gabon','The Gambia','Ghana','Guinea','Guinea-Bissau','Kenya','Lesotho','Liberia','Libya','Madagascar','Malawi','Mali','Mauritania','Namibia','Niger','Nigeria','Rwanda','São Tomé and Príncipe','Senegal','Seychelles','Sierra Leone','South Africa','South Sudan','Sudan','Swaziland','Tanzania','Togo','Tunisia','Uganda','Western Sahara','Zambia','Zimababwe'};
        Set<String> australia = new Set<String>{'Australia','Federated States of Micronesia','Fiji','Kiribati','Marshall Islands','Nauru','New Zealand','Palau','Papua New Guinea','Samoa','Solomon Islands','Tonga','Tuvalu','Vanuatu'};
        Set<String> europe = new Set<String>{'Albania','Andorra','Austria','Belarus','Belgium','Bosnia and Herzegovina','Bulgaria','Croatia','Cyprus','Czech Republic','Denmark','Estonia','Finland','France','Germany','Greece','Hungary','Iceland','Republic of Ireland','Itlay','Kosovo','Latvia','Liechtenstein','Lithuania','Luxembourg','Macedonia','Malta','Moldova','Monaco','Montenegro','Netherlands','Norway','Poland','Portugal','Romania','Russia','San Marino','Serbia','Slovakia','Slovenia','Spain','Sweden','Switzerland','Ukraine','United Kingdom','Vatican City'};
        Set<String> southamerica = new Set<String>{'Argentina','Bolivia','Brazil','Chile','Colombia','Ecuador','French Guiana','Guyana','Paraguay','Peru','Suriname','Uruguay','Venezuela'};
        
        for( lead lead : Trigger.new ) {
        
           // trigger based on contact's status
           if( lead.Status__c == 'Mapping Call' ) {
                lead.Call_Flow__c = '';
                lead.Call_Request_Date__c = null;
                lead.Rating_Lead__c = 'Email Not Found';
            }
           else if( lead.Status__c == 'Cold' ) {
                lead.Call_Flow__c = 'Priority Call List 3';
                lead.Call_Request_Date__c = DateTime.Now();
                lead.Linkedin_Activity__c = '';
                lead.LinkedIn_Requested_Date__c = null;
                lead.Rating_Lead__c = '';
            }
            else if( lead.Status__c == 'Warm' || lead.Status__c == 'Super Warms' ) {
                lead.Call_Flow__c = 'Priority Call List 2';
                lead.Call_Request_Date__c = DateTime.Now();
                if ( lead.Linkedin_Activity__c == null ) {
                    lead.Linkedin_Activity__c = 'Send Request';
                    lead.LinkedIn_Requested_Date__c = Date.Today();
                }
                lead.Rating_Lead__c = '';
            }
            else if( lead.Status__c == 'Hot' || lead.Status__c == 'Active Conversation' ) {
                lead.Call_Flow__c = 'Priority Call List 1';
                lead.Call_Request_Date__c = DateTime.Now();
                if ( lead.Linkedin_Activity__c == null ) {
                    lead.Linkedin_Activity__c = 'Send Request';
                    lead.LinkedIn_Requested_Date__c = Date.Today();
                }
                lead.Rating_Lead__c = '';
            }
            else if( lead.Status__c == 'Dead' || lead.Status__c == 'Bad Fit' || lead.Status__c == 'Check back Quarterly' ) {
                lead.Call_Flow__c = '';
                lead.Call_Request_Date__c = null;
                lead.Rating_Lead__c = '';
            }
            else if( lead.Status__c == '' || lead.Status__c == null ) {
                lead.Call_Flow__c = '';
                lead.Call_Request_Date__c = null;
                lead.Rating_Lead__c = '';
                lead.Linkedin_Activity__c = '';
                lead.LinkedIn_Requested_Date__c = null;
                lead.LinkedIn_Sent_Accepted_Date__c = null;
            }
            
            // trigger based on linkedin activity
            if( lead.Linkedin_Activity__c == 'Sent' || lead.Linkedin_Activity__c == 'Accepted' ) {
                if( lead.LinkedIn_Sent_Accepted_Date__c == null ) {
                    lead.LinkedIn_Sent_Accepted_Date__c = Date.Today();
                }   
            }
            
            // trigger to set continent value based on Mailing country
            if(String.isNotEmpty(lead.Country)) {
                if( JSON.serialize(asia).contains(lead.Country) ) {
                    lead.Continent__c = 'Asia';
                }
                else if( JSON.serialize(africa).contains(lead.Country) ) {
                    lead.Continent__c = 'Africa';
                }
                else if( JSON.serialize(australia).contains(lead.Country) ) {
                    lead.Continent__c = 'Australia & Oceania';
                }
                else if( JSON.serialize(europe).contains(lead.Country) ) {
                    lead.Continent__c = 'Europe';
                }
                else if( JSON.serialize(southamerica).contains(lead.Country) ) {
                    lead.Continent__c = 'South America';
                }
            }
            else {
                //lead.Continent__c = '';
                continue;
            }
        }
    }
}