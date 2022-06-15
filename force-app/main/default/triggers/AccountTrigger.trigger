trigger AccountTrigger on Account( before insert, before update, after insert, after update ) {
    
    Set<Id> objectIds = new Set<Id>();
    for(Account a : Trigger.new) {
        objectIds.add(a.Id);
    }
    
    List<Account> accounts = [SELECT Id, Name, Total_Contact_Records__c, BillingCountry, Continent__c FROM Account WHERE Id IN :objectIds];
    List<Contact> contacts = [SELECT Id, AccountId, Account.Continent__c, Name, Continent__c FROM Contact WHERE AccountId IN :objectIds];
    
    if( Trigger.isBefore ) {
    
        Set<String> asia = new Set<String>{'Afghanistan','Armenia','Azerbaijan','Bahrain','Bangladesh','Bhutan','Brunei','Cambodia','China','East Timor','Timor Leste','Georgia','India','Indonesia','Iran','Iraq','Israel','Palestine','Japan','Jordan','Kazakhstan','Kuwait','Kyrgyzstan','Laos','Lebanon','Malaysia','Maldives','Mongolia','Myanmar','Nepal','North Korea','Oman','Pakistan','Philippines','Qatar','Russua','Saudi Arabia','Singapore','South Korea','Sri Lanka','Syria','Taiwan','Tajikistan','Thailand','Turkey','Turkmenistan','United Arab Emirates','Uzbekistan','Vietnam','Yemen'};
        Set<String> africa = new Set<String>{'Algeria','Angola','Benin','Botswana','Burikina Faso','Burundi','Cameroon','Cape Verde','Central African Republic','Chad','Comoros','Republic of Congo','Democratic Republic of Congo','Djibouti','Egypt','Equatorial Guinea','Eritra','Ethiopia','Gabon','The Gambia','Ghana','Guinea','Guinea-Bissau','Kenya','Lesotho','Liberia','Libya','Madagascar','Malawi','Mali','Mauritania','Namibia','Niger','Nigeria','Rwanda','São Tomé and Príncipe','Senegal','Seychelles','Sierra Leone','South Africa','South Sudan','Sudan','Swaziland','Tanzania','Togo','Tunisia','Uganda','Western Sahara','Zambia','Zimababwe'};
        Set<String> australia = new Set<String>{'Australia','Federated States of Micronesia','Fiji','Kiribati','Marshall Islands','Nauru','New Zealand','Palau','Papua New Guinea','Samoa','Solomon Islands','Tonga','Tuvalu','Vanuatu'};
        Set<String> europe = new Set<String>{'Albania','Andorra','Austria','Belarus','Belgium','Bosnia and Herzegovina','Bulgaria','Croatia','Cyprus','Czech Republic','Denmark','Estonia','Finland','France','Germany','Greece','Hungary','Iceland','Republic of Ireland','Itlay','Kosovo','Latvia','Liechtenstein','Lithuania','Luxembourg','Macedonia','Malta','Moldova','Monaco','Montenegro','Netherlands','Norway','Poland','Portugal','Romania','Russia','San Marino','Serbia','Slovakia','Slovenia','Spain','Sweden','Switzerland','Ukraine','United Kingdom','Vatican City'};
        Set<String> southamerica = new Set<String>{'Argentina','Bolivia','Brazil','Chile','Colombia','Ecuador','French Guiana','Guyana','Paraguay','Peru','Suriname','Uruguay','Venezuela'};
        
        for( Account acc : Trigger.new ) {
            if(String.isNotEmpty(acc.BillingCountry)) {
                if( JSON.serialize(asia).contains(acc.BillingCountry) ) {
                    acc.Continent__c = 'Asia';
                }
                else if( JSON.serialize(africa).contains(acc.BillingCountry) ) {
                    acc.Continent__c = 'Africa';
                }
                else if( JSON.serialize(australia).contains(acc.BillingCountry) ) {
                    acc.Continent__c = 'Australia & Oceania';
                }
                else if( JSON.serialize(europe).contains(acc.BillingCountry) ) {
                    acc.Continent__c = 'Europe';
                }
                else if( JSON.serialize(southamerica).contains(acc.BillingCountry) ) {
                    acc.Continent__c = 'South America';
                }
            } 
        }
    }
        
    if( Trigger.isAfter) {
    
        List<Contact> contacts_to_update = new List<Contact>();
        for( Contact c : contacts) {
            c.Continent__c = c.Account.Continent__c;
            contacts_to_update.add(c);
        }
        
        try {
            if( contacts_to_update.size() > 0 ) {
                update contacts_to_update; 
            }
        }
        catch(DMLException e) {
            system.debug('Contacts were not all properly updated.  Error: '+ e);
        }
    }
}