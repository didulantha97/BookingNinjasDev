trigger TaskTrigger on Task ( after insert, after update ) {

    String contact_prefix = Schema.SObjectType.Contact.getKeyPrefix();
    String lead_prefix = Schema.SObjectType.Lead.getKeyPrefix();
    
    Set<Id> objectIds = new Set<Id>();
    Set<Id> contactIds = new Set<Id>();
    Set<Id> leadIds = new Set<Id>();
    for( Task t : Trigger.new ) {
        objectIds.add(t.Id);
        
        if(String.valueOf(t.WhoId).startsWith(contact_prefix)) {
            contactIds.add(t.WhoId);
        }
        else if(String.valueOf(t.WhoId).startsWith(lead_prefix)) {
            leadIds.add(t.WhoId);
        }
    }
    List<Task> tasks = [SELECT Id, WhoId, Subject, cirrusadv__Num_of_Replies__c, cirrusadv__Num_of_Opens__c, cirrusadv__Email_Opened__c FROM Task WHERE WhoId IN :objectIds];

    
    Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, Name, X1st_email__c, Follow_Up_email_2nd_engage__c, X3rd_follow_up_breakup__c, Status__c FROM Contact WHERE Id IN :contactIds]);
    Map<Id, Contact> contacts_to_update = new Map<Id, Contact>();
    Map<Id, Lead> leads = new Map<Id, Lead>([SELECT Id, Name, X1st_email__c, Follow_Up_email_2nd_engage__c, X3rd_follow_up_breakup__c, Status__c FROM Lead WHERE Id IN :leadIds]);
    Map<Id, Lead> leads_to_update = new Map<Id, Lead>();
    
    for( Task t : tasks ) {
        if( t.WhoId != null || t.WhoId != '' ) {
            if( String.valueOf(t.WhoId).startsWith(contact_prefix) ) {
                Contact c = contacts.get(t.whoId);
                if( trigger.IsInsert ) {
                    // update date field based on email sent
                        if( c.X1st_email__c == null ) {
                            c.X1st_email__c = DateTime.Now();
                        }
                        if( c.Follow_Up_email_2nd_engage__c == null && (t.Subject == 'Email: Important Follow -Up From Booking Ninjas PMS' || t.Subject == '→ Email: Important Follow -Up From Booking Ninjas PMS' || t.Subject == '← Email: Important Follow -Up From Booking Ninjas PMS') ) {
                            c.Follow_Up_email_2nd_engage__c = DateTime.Now();
                        }
                        if( c.X3rd_follow_up_breakup__c == null && (t.Subject == 'Email: Let Us Talk | Booking Ninjas' || t.Subject == '→ Email: Let Us Talk | Booking Ninjas' || t.Subject == '← Email: Let Us Talk | Booking Ninjas') ) {
                            c.X3rd_follow_up_breakup__c = DateTime.Now();
                        }
                        
                        //trigger for unsubscribe emails
                        if( t.Subject == 'Unsubscribe Me' || t.Subject == '→ Email: Unsubscribe Me' || t.Subject == '← Email: Unsubscribe Me' ) {
                            c.HasOptedOutOfEmail = true;
                        }
                                       
                        //trigger for drip emails
                        if( t.Subject == 'Email: Get your dream solution now!' || t.Subject == '→ Email: Get your dream solution now!' || t.Subject == '← Email: Get your dream solution now!' ) {
                            c.Drip_Email_1__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Booking Ninjas Advantages' || t.Subject == '→ Email: Booking Ninjas Advantages' || t.Subject == '← Email: Booking Ninjas Advantages' ) {
                            c.Drip_Email_2__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Get your dream solution now!' || t.Subject == '→ Email: Get your dream solution now!' || t.Subject == '← Email: Get your dream solution now!' ) {
                            c.Drip_Email_3__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Unmatched Benefits with Booking Ninjas!' || t.Subject == '→ Email: Unmatched Benefits with Booking Ninjas!' || t.Subject == '← Email: Unmatched Benefits with Booking Ninjas!' ) {
                            c.Drip_Email_4__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: We are entering 4th Industrial Revolution today! - Booking Ninjas' || t.Subject == '→ Email: We are entering 4th Industrial Revolution today! - Booking Ninjas' || t.Subject == '← Email: We are entering 4th Industrial Revolution today! - Booking Ninjas' ) {
                            c.Drip_Email_5__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Why Booking Ninjas?' || t.Subject == '→ Email: Why Booking Ninjas?' || t.Subject == '→ Email: Why Booking Ninjas?' ) {
                            c.Drip_Email_6__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Ask yourself. What are my capabilities today?' || t.Subject == '→ Email: Ask yourself. What are my capabilities today?' || t.Subject == '← Email: Ask yourself. What are my capabilities today?' ) {
                            c.Drip_Email_7__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Booking Ninjas | Upgrade Your System' || t.Subject == '→ Email: Booking Ninjas | Upgrade Your System' || t.Subject == '← Email: Booking Ninjas | Upgrade Your System' ) {
                            c.Drip_Email_8__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Are you suffering from Cognitive Dissonance? | Booking Ninjas' || t.Subject == '→ Email: Are you suffering from Cognitive Dissonance? | Booking Ninjas' || t.Subject == '← Email: Are you suffering from Cognitive Dissonance? | Booking Ninjas' ) {
                            c.Drip_Email_9__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: The ultimate solution to all your problems | Booking Ninjas' || t.Subject == '→ Email: The ultimate solution to all your problems | Booking Ninjas' || t.Subject == '← Email: The ultimate solution to all your problems | Booking Ninjas' ) {
                            c.Drip_Email_10__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Step Into The Brighter Future With Booking Ninjas!' || t.Subject == '→ Email: Step Into The Brighter Future With Booking Ninjas!' || t.Subject == '← Email: Step Into The Brighter Future With Booking Ninjas!' ) {
                            c.Drip_Email_11__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: You Can Always Get More Cash, But You Can Never Get More Time' || t.Subject == '→ Email: You Can Always Get More Cash, But You Can Never Get More Time' || t.Subject == '← Email: You Can Always Get More Cash, But You Can Never Get More Time' ) {
                            c.Drip_Email_12__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Evaluate Your Return On Investment (ROI) | Booking Ninjas' || t.Subject == '→ Email: Evaluate Your Return On Investment (ROI) | Booking Ninjas' || t.Subject == '← Email: Evaluate Your Return On Investment (ROI) | Booking Ninjas' ) {
                            c.Drip_Email_13__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: A Life Without Risk Is A Life Without Growth | Booking Ninjas' || t.Subject == '→ Email: A Life Without Risk Is A Life Without Growth | Booking Ninjas' || t.Subject == '← Email: A Life Without Risk Is A Life Without Growth | Booking Ninjas' ) {
                            c.Drip_Email_14__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: How Do You Plan To Move Your Company Forward? | Booking Ninjas' || t.Subject == '→ Email: How Do You Plan To Move Your Company Forward? | Booking Ninjas' || t.Subject == '← Email: How Do You Plan To Move Your Company Forward? | Booking Ninjas' ) {
                            c.Drip_Email_15__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Life is Better Together with Booking Ninjas' || t.Subject == '→ Email: Life is Better Together with Booking Ninjas' || t.Subject == '← Email: Life is Better Together with Booking Ninjas' ) {
                            c.Drip_Email_16__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Old Way vs New Way is Booking Ninjas' || t.Subject == '→ Email: Old Way vs New Way is Booking Ninjas' || t.Subject == '← Email: Old Way vs New Way is Booking Ninjas' ) {
                            c.Drip_Email_17__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Why are you putting yourself through this? | Booking Ninjas' || t.Subject == '→ Email: Why are you putting yourself through this? | Booking Ninjas' || t.Subject == '← Email: Why are you putting yourself through this? | Booking Ninjas' ) {
                            c.Drip_Email_18__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Myths About Changing Your System | Booking Ninjas' || t.Subject == '→ Email: Myths About Changing Your System | Booking Ninjas' || t.Subject == '← Email: Myths About Changing Your System | Booking Ninjas' ) {
                            c.Drip_Email_19__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: We Are Blazing A New Trail | Booking Ninjas' || t.Subject == '→ Email: We Are Blazing A New Trail | Booking Ninjas' || t.Subject == '← Email: We Are Blazing A New Trail | Booking Ninjas' ) {
                            c.Drip_Email_20__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Is Your PMS That Smart? | Booking Ninjas' || t.Subject == '→ Email: Is Your PMS That Smart? | Booking Ninjas' || t.Subject == '← Email: Is Your PMS That Smart? | Booking Ninjas' ) {
                            c.Drip_Email_21__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: General Data Protection Regulation | Booking Ninjas' || t.Subject == '→ Email: General Data Protection Regulation | Booking Ninjas' || t.Subject == '← Email: General Data Protection Regulation | Booking Ninjas' ) {
                            c.Drip_Email_22__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Invest Yourself in a Greater Reason! | Booking Ninjas' || t.Subject == '→ Email: Invest Yourself in a Greater Reason! | Booking Ninjas' || t.Subject == '← Email: Invest Yourself in a Greater Reason! | Booking Ninjas' ) {
                            c.Drip_Email_23__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Einstein AI is here embedded in your PMS | Booking Ninjas' || t.Subject == '→ Email: Einstein AI is here embedded in your PMS | Booking Ninjas' || t.Subject == '← Email: Einstein AI is here embedded in your PMS | Booking Ninjas' ) {
                            c.Drip_Email_24__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Einstein AI For Your Business | Booking Ninjas' || t.Subject == '→ Email: Einstein AI For Your Business | Booking Ninjas' || t.Subject == '← Email: Einstein AI For Your Business | Booking Ninjas' ) {
                            c.Drip_Email_25__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Brace yourselves, GDPR is coming! | Booking Ninjas' || t.Subject == '→ Email: Brace yourselves, GDPR is coming! | Booking Ninjas' || t.Subject == '← Email: Brace yourselves, GDPR is coming! | Booking Ninjas' ) {
                            c.Drip_Email_26__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Booking Ninjas is the new revolution of hotel industry!' || t.Subject == '→ Email: Booking Ninjas is the new revolution of hotel industry!' || t.Subject == '← Email: Booking Ninjas is the new revolution of hotel industry!' ) {
                            c.Drip_Email_27__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Enjoy benefits like no other with Booking Ninjas PMS!' || t.Subject == '→ Email: Enjoy benefits like no other with Booking Ninjas PMS!' || t.Subject == '← Email: Enjoy benefits like no other with Booking Ninjas PMS!' ) {
                            c.Drip_Email_28__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: How has Data become an important part of your business?' || t.Subject == '→ Email: How has Data become an important part of your business?' || t.Subject == '← Email: How has Data become an important part of your business?' ) {
                            c.Drip_Email_29__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Time for questions are over, it is time for an answer!' || t.Subject == '→ Email: Time for questions are over, it is time for an answer!' || t.Subject == '← Email: Time for questions are over, it is time for an answer!' ) {
                            c.Drip_Email_30__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Our Core Values | Booking Ninjas' || t.Subject == '→ Email: Our Core Values | Booking Ninjas' || t.Subject == '← Email: Our Core Values | Booking Ninjas' ) {
                            c.Drip_Email_31__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Fourth The Great | Booking Ninjas' || t.Subject == '→ Email: Fourth The Great | Booking Ninjas' || t.Subject == '← Email: Fourth The Great | Booking Ninjas' ) {
                            c.Drip_Email_32__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: See how the Booking Ninjas system improved Sarah&#x27;s business' || t.Subject == '→ Email: See how the Booking Ninjas system improved Sarah&#x27;s business' || t.Subject == '← Email: See how the Booking Ninjas system improved Sarah&#x27;s business' ) {
                            c.Drip_Email_33__c = DateTime.Now();
                        }
                        else if( t.Subject == 'Email: Zach&#x27;s experience greatly improved by the Booking Ninjas application' || t.Subject == '→ Email: Zach&#x27;s experience greatly improved by the Booking Ninjas application' || t.Subject == '← Email: Zach&#x27;s experience greatly improved by the Booking Ninjas application' ) {
                            c.Drip_Email_34__c = DateTime.Now();
                        }
                }
                if( trigger.IsUpdate ) {
                    // update status based on # of opens / clicks
                    if( t.cirrusadv__Num_of_Replies__c > 0 ) {
                        c.Status__c = 'Active Conversation';
                    }
                    else {
                        if( (t.cirrusadv__Num_of_Opens__c == null || t.cirrusadv__Num_of_Opens__c <= 0) && t.cirrusadv__Email_Opened__c == false ) {
                            if( (c.Status__c == '' || c.Status__c == null ||c.Status__c == 'Mapping Call') && (c.Status__c != 'Cold' || c.Status__c != 'Warm' || c.Status__c != 'Super Warms' || c.Status__c != 'Hot' || c.Status__c == null) ) {
                                c.Status__c = 'Mapping Call';
                            }
                        }
                        else if( t.cirrusadv__Num_of_Opens__c >= 1 && t.cirrusadv__Num_of_Opens__c <= 2 ) {
                            if( (c.Status__c == '' || c.Status__c == null || c.Status__c == 'Mapping Call' || c.Status__c == 'Cold')  && (c.Status__c != 'Warm' || c.Status__c != 'Super Warms' || c.Status__c != 'Hot') ) {
                                c.Status__c = 'Cold';
                            }
                        }
                        else if( t.cirrusadv__Num_of_Opens__c >= 3 && t.cirrusadv__Num_of_Opens__c <= 5 ) {
                            if( (c.Status__c == '' || c.Status__c == null || c.Status__c == 'Mapping Call' || c.Status__c == 'Cold'  || c.Status__c == 'Warm') && (c.Status__c != 'Super Warms' || c.Status__c != 'Hot') ) {
                                c.Status__c = 'Warm';
                            }
                        }
                        else if( t.cirrusadv__Num_of_Opens__c >= 6 && t.cirrusadv__Num_of_Opens__c <= 9 ) {
                            if( (c.Status__c == '' || c.Status__c == null || c.Status__c == 'Mapping Call' || c.Status__c == 'Cold'  || c.Status__c == 'Warm' || c.Status__c == 'Super Warms') && c.Status__c != 'Hot' ) {
                                c.Status__c = 'Super Warms';
                            } 
                        }
                        else if( t.cirrusadv__Num_of_Opens__c > 9 ) {
                            if( c.Status__c == '' || c.Status__c == null || c.Status__c == 'Mapping Call' || c.Status__c == 'Cold'  || c.Status__c == 'Warm' || c.Status__c == 'Super Warms' || c.Status__c == 'Hot' ) {
                                c.Status__c = 'Hot';
                            }
                        }
                    }
                }
                //add contacts to update on list
                contacts_to_update.put(c.Id, c);                   
            }
            else if ( String.valueOf(t.WhoId).startsWith(lead_prefix) ) {
                Lead l = leads.get(t.whoId);
                if( trigger.IsInsert ) { 
                    // update date field based on email sent
                    if( l.X1st_email__c == null ) {
                        l.X1st_email__c = DateTime.Now();
                    }
                    if( l.Follow_Up_email_2nd_engage__c == null && (t.Subject == 'Email: Important Follow -Up From Booking Ninjas PMS' || t.Subject == '→ Email: Important Follow -Up From Booking Ninjas PMS' || t.Subject == '← Email: Important Follow -Up From Booking Ninjas PMS') ) {
                        l.Follow_Up_email_2nd_engage__c = DateTime.Now();
                    }
                    if( l.X3rd_follow_up_breakup__c == null && (t.Subject == 'Email: Let Us Talk | Booking Ninjas' || t.Subject == '→ Email: Let Us Talk | Booking Ninjas' || t.Subject == '← Email: Let Us Talk | Booking Ninjas') ) {
                        l.X3rd_follow_up_breakup__c = DateTime.Now();
                    }
                    
                    //trigger for unsubscribe emails
                    if( t.Subject == 'Unsubscribe Me' || t.Subject == '→ Email: Unsubscribe Me' || t.Subject == '← Email: Unsubscribe Me' ) {
                        l.HasOptedOutOfEmail = true;
                    }
                                   
                    //trigger for drip emails
                    if( t.Subject == 'Email: Get your dream solution now!' || t.Subject == '→ Email: Get your dream solution now!' || t.Subject == '← Email: Get your dream solution now!' ) {
                        l.Drip_Email_1__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Booking Ninjas Advantages' || t.Subject == '→ Email: Booking Ninjas Advantages' || t.Subject == '← Email: Booking Ninjas Advantages' ) {
                        l.Drip_Email_2__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Get your dream solution now!' || t.Subject == '→ Email: Get your dream solution now!' || t.Subject == '← Email: Get your dream solution now!' ) {
                        l.Drip_Email_3__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Unmatched Benefits with Booking Ninjas!' || t.Subject == '→ Email: Unmatched Benefits with Booking Ninjas!' || t.Subject == '← Email: Unmatched Benefits with Booking Ninjas!' ) {
                        l.Drip_Email_4__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: We are entering 4th Industrial Revolution today! - Booking Ninjas' || t.Subject == '→ Email: We are entering 4th Industrial Revolution today! - Booking Ninjas' || t.Subject == '← Email: We are entering 4th Industrial Revolution today! - Booking Ninjas' ) {
                        l.Drip_Email_5__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Why Booking Ninjas?' || t.Subject == '→ Email: Why Booking Ninjas?' || t.Subject == '→ Email: Why Booking Ninjas?' ) {
                        l.Drip_Email_6__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Ask yourself. What are my capabilities today?' || t.Subject == '→ Email: Ask yourself. What are my capabilities today?' || t.Subject == '← Email: Ask yourself. What are my capabilities today?' ) {
                        l.Drip_Email_7__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Booking Ninjas | Upgrade Your System' || t.Subject == '→ Email: Booking Ninjas | Upgrade Your System' || t.Subject == '← Email: Booking Ninjas | Upgrade Your System' ) {
                        l.Drip_Email_8__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Are you suffering from Cognitive Dissonance? | Booking Ninjas' || t.Subject == '→ Email: Are you suffering from Cognitive Dissonance? | Booking Ninjas' || t.Subject == '← Email: Are you suffering from Cognitive Dissonance? | Booking Ninjas' ) {
                        l.Drip_Email_9__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: The ultimate solution to all your problems | Booking Ninjas' || t.Subject == '→ Email: The ultimate solution to all your problems | Booking Ninjas' || t.Subject == '← Email: The ultimate solution to all your problems | Booking Ninjas' ) {
                        l.Drip_Email_10__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Step Into The Brighter Future With Booking Ninjas!' || t.Subject == '→ Email: Step Into The Brighter Future With Booking Ninjas!' || t.Subject == '← Email: Step Into The Brighter Future With Booking Ninjas!' ) {
                        l.Drip_Email_11__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: You Can Always Get More Cash, But You Can Never Get More Time' || t.Subject == '→ Email: You Can Always Get More Cash, But You Can Never Get More Time' || t.Subject == '← Email: You Can Always Get More Cash, But You Can Never Get More Time' ) {
                        l.Drip_Email_12__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Evaluate Your Return On Investment (ROI) | Booking Ninjas' || t.Subject == '→ Email: Evaluate Your Return On Investment (ROI) | Booking Ninjas' || t.Subject == '← Email: Evaluate Your Return On Investment (ROI) | Booking Ninjas' ) {
                        l.Drip_Email_13__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: A Life Without Risk Is A Life Without Growth | Booking Ninjas' || t.Subject == '→ Email: A Life Without Risk Is A Life Without Growth | Booking Ninjas' || t.Subject == '← Email: A Life Without Risk Is A Life Without Growth | Booking Ninjas' ) {
                        l.Drip_Email_14__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: How Do You Plan To Move Your Company Forward? | Booking Ninjas' || t.Subject == '→ Email: How Do You Plan To Move Your Company Forward? | Booking Ninjas' || t.Subject == '← Email: How Do You Plan To Move Your Company Forward? | Booking Ninjas' ) {
                        l.Drip_Email_15__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Life is Better Together with Booking Ninjas' || t.Subject == '→ Email: Life is Better Together with Booking Ninjas' || t.Subject == '← Email: Life is Better Together with Booking Ninjas' ) {
                        l.Drip_Email_16__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Old Way vs New Way is Booking Ninjas' || t.Subject == '→ Email: Old Way vs New Way is Booking Ninjas' || t.Subject == '← Email: Old Way vs New Way is Booking Ninjas' ) {
                        l.Drip_Email_17__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Why are you putting yourself through this? | Booking Ninjas' || t.Subject == '→ Email: Why are you putting yourself through this? | Booking Ninjas' || t.Subject == '← Email: Why are you putting yourself through this? | Booking Ninjas' ) {
                        l.Drip_Email_18__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Myths About Changing Your System | Booking Ninjas' || t.Subject == '→ Email: Myths About Changing Your System | Booking Ninjas' || t.Subject == '← Email: Myths About Changing Your System | Booking Ninjas' ) {
                        l.Drip_Email_19__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: We Are Blazing A New Trail | Booking Ninjas' || t.Subject == '→ Email: We Are Blazing A New Trail | Booking Ninjas' || t.Subject == '← Email: We Are Blazing A New Trail | Booking Ninjas' ) {
                        l.Drip_Email_20__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Is Your PMS That Smart? | Booking Ninjas' || t.Subject == '→ Email: Is Your PMS That Smart? | Booking Ninjas' || t.Subject == '← Email: Is Your PMS That Smart? | Booking Ninjas' ) {
                        l.Drip_Email_21__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: General Data Protection Regulation | Booking Ninjas' || t.Subject == '→ Email: General Data Protection Regulation | Booking Ninjas' || t.Subject == '← Email: General Data Protection Regulation | Booking Ninjas' ) {
                        l.Drip_Email_22__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Invest Yourself in a Greater Reason! | Booking Ninjas' || t.Subject == '→ Email: Invest Yourself in a Greater Reason! | Booking Ninjas' || t.Subject == '← Email: Invest Yourself in a Greater Reason! | Booking Ninjas' ) {
                        l.Drip_Email_23__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Einstein AI is here embedded in your PMS | Booking Ninjas' || t.Subject == '→ Email: Einstein AI is here embedded in your PMS | Booking Ninjas' || t.Subject == '← Email: Einstein AI is here embedded in your PMS | Booking Ninjas' ) {
                        l.Drip_Email_24__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Einstein AI For Your Business | Booking Ninjas' || t.Subject == '→ Email: Einstein AI For Your Business | Booking Ninjas' || t.Subject == '← Email: Einstein AI For Your Business | Booking Ninjas' ) {
                        l.Drip_Email_25__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Brace yourselves, GDPR is coming! | Booking Ninjas' || t.Subject == '→ Email: Brace yourselves, GDPR is coming! | Booking Ninjas' || t.Subject == '← Email: Brace yourselves, GDPR is coming! | Booking Ninjas' ) {
                        l.Drip_Email_26__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Booking Ninjas is the new revolution of hotel industry!' || t.Subject == '→ Email: Booking Ninjas is the new revolution of hotel industry!' || t.Subject == '← Email: Booking Ninjas is the new revolution of hotel industry!' ) {
                        l.Drip_Email_27__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Enjoy benefits like no other with Booking Ninjas PMS!' || t.Subject == '→ Email: Enjoy benefits like no other with Booking Ninjas PMS!' || t.Subject == '← Email: Enjoy benefits like no other with Booking Ninjas PMS!' ) {
                        l.Drip_Email_28__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: How has Data become an important part of your business?' || t.Subject == '→ Email: How has Data become an important part of your business?' || t.Subject == '← Email: How has Data become an important part of your business?' ) {
                        l.Drip_Email_29__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Time for questions are over, it is time for an answer!' || t.Subject == '→ Email: Time for questions are over, it is time for an answer!' || t.Subject == '← Email: Time for questions are over, it is time for an answer!' ) {
                        l.Drip_Email_30__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Our Core Values | Booking Ninjas' || t.Subject == '→ Email: Our Core Values | Booking Ninjas' || t.Subject == '← Email: Our Core Values | Booking Ninjas' ) {
                        l.Drip_Email_31__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Fourth The Great | Booking Ninjas' || t.Subject == '→ Email: Fourth The Great | Booking Ninjas' || t.Subject == '← Email: Fourth The Great | Booking Ninjas' ) {
                        l.Drip_Email_32__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: See how the Booking Ninjas system improved Sarah&#x27;s business' || t.Subject == '→ Email: See how the Booking Ninjas system improved Sarah&#x27;s business' || t.Subject == '← Email: See how the Booking Ninjas system improved Sarah&#x27;s business' ) {
                        l.Drip_Email_33__c = DateTime.Now();
                    }
                    else if( t.Subject == 'Email: Zach&#x27;s experience greatly improved by the Booking Ninjas application' || t.Subject == '→ Email: Zach&#x27;s experience greatly improved by the Booking Ninjas application' || t.Subject == '← Email: Zach&#x27;s experience greatly improved by the Booking Ninjas application' ) {
                        l.Drip_Email_34__c = DateTime.Now();
                    }
                }  
                if( trigger.IsUpdate ) {
                    // update status based on # of opens / clicks
                    if( t.cirrusadv__Num_of_Replies__c > 0 ) {
                        l.Status__c = 'Active Conversation';
                    }
                    else {
                        if( (t.cirrusadv__Num_of_Opens__c == null || t.cirrusadv__Num_of_Opens__c <= 0) && t.cirrusadv__Email_Opened__c == false ) {
                            if( (l.Status__c == '' || l.Status__c == null || l.Status__c == 'Mapping Call') && (l.Status__c != 'Cold' || l.Status__c != 'Warm' || l.Status__c != 'Super Warms' || l.Status__c != 'Hot' || l.Status__c == null) ) {
                                l.Status__c = 'Mapping Call';
                            }
                        }
                        else if( t.cirrusadv__Num_of_Opens__c >= 1 && t.cirrusadv__Num_of_Opens__c <= 2 ) {
                            if( (l.Status__c == '' || l.Status__c == null || l.Status__c == 'Mapping Call' || l.Status__c == 'Cold')  && (l.Status__c != 'Warm' || l.Status__c != 'Super Warms' || l.Status__c != 'Hot') ) {
                                l.Status__c = 'Cold';
                            }
                        }
                        else if( t.cirrusadv__Num_of_Opens__c >= 3 && t.cirrusadv__Num_of_Opens__c <= 5 ) {
                            if( (l.Status__c == '' || l.Status__c == null || l.Status__c == 'Mapping Call' || l.Status__c == 'Cold'  || l.Status__c == 'Warm') && (l.Status__c != 'Super Warms' || l.Status__c != 'Hot') ) {
                                l.Status__c = 'Warm';
                            }
                        }
                        else if( t.cirrusadv__Num_of_Opens__c >= 6 && t.cirrusadv__Num_of_Opens__c <= 9 ) {
                            if( (l.Status__c == '' || l.Status__c == null || l.Status__c == 'Mapping Call' || l.Status__c == 'Cold'  || l.Status__c == 'Warm' || l.Status__c == 'Super Warms') && l.Status__c != 'Hot' ) {
                                l.Status__c = 'Super Warms';
                            } 
                        }
                        else if( t.cirrusadv__Num_of_Opens__c > 9 ) {
                            if( l.Status__c == '' || l.Status__c == null || l.Status__c == 'Mapping Call' || l.Status__c == 'Cold'  || l.Status__c == 'Warm' || l.Status__c == 'Super Warms' || l.Status__c == 'Hot' ) {
                                l.Status__c = 'Hot';
                            }
                        }
                    }
                }
                //add leads to update on list
                leads_to_update.put(l.Id, l);                   
            }
        }
        continue;
    }
    
    try {
        update contacts_to_update.values();
        
        update leads_to_update.values();
    }
    catch(DMLException e) {
        system.debug('Records were not all properly updated.  Error: '+ e);
    }
}