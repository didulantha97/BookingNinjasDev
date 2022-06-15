@IsTest
public class PersonResponse_Test {
    
    static testMethod void testParse() {
        String json = '{\"fullName\":\"Bart Lorang\",\"ageRange\":\"25-35\",\"gender\":\"Male\",\"location\":\"Boulder, Colorado, United States\",\"title\":\"Co-Founder and Chief Executive Officer\",\"organization\":\"FullContact\",\"twitter\":\"https://twitter.com/bartlorang\",\"linkedin\":\"https://www.linkedin.com/in/bartlorang\",\"facebook\":\"https://www.facebook.com/bart.lorang\",\"bio\":\"CEO & Co-Founder of @FullContact, Managing Director @v1vc. Tech Entrepreneur, Investor. Husband to @parkerbenson and Father to Greyson Lorang\",\"avatar\":\"https://d2ojpxxtu63wzl.cloudfront.net/static/a7e6a5aba590d4933e35eaadabd97fd2_44e00e968ac57725a15b32f9ca714827aff8e4818d290cb0c611f2e2585253b3\",\"website\":\"https://fullcontact.com/bart\",\"details\":{\"name\":null,\"age\":null,\"gender\":null,\"emails\":[{\"label\":\"provided\",\"value\":\"bart@fullcontact.com\"}],\"phones\":[],\"profiles\":{},\"locations\":[],\"employment\":[],\"photos\":[],\"education\":[],\"urls\":[],\"interests\":[],\"topics\":[]},\"dataAddOns\":[{\"id\":\"demographics\",\"name\":\"Demographics\",\"enabled\":false,\"applied\":false,\"description\":\"Name, age, gender, locations and education.\",\"docLink\":\"http://docs.fullcontact.com/api/#demographics\"},{\"id\":\"firmographics\",\"name\":\"Employment History\",\"enabled\":false,\"applied\":false,\"description\":\"Current and historical job title and position information, as well as approximate start and end dates.\",\"docLink\":\"http://docs.fullcontact.com/api/#firmographics\"},{\"id\":\"allsocial\",\"name\":\"All Social\",\"enabled\":false,\"applied\":false,\"description\":\"All social profile overviews (bio, followers, urls, and more) as well as photos and websites.\",\"docLink\":\"http://docs.fullcontact.com/api/#all-social\"},{\"id\":\"socialaffinities\",\"name\":\"Affinities\",\"enabled\":false,\"applied\":false,\"description\":\"Provides interest and brand association linkages alongside affinity scores (HIGH, MED, LOW).\",\"docLink\":\"http://docs.fullcontact.com/api/#affinities\"},{\"id\":\"emailhash\",\"name\":\"Email Hash\",\"enabled\":false,\"applied\":false,\"description\":\"When querying by email, we\'ll provide md5 and sha256 hashes of the emails associated with that profile.\",\"docLink\":\"http://docs.fullcontact.com/api/#email-hash\"},{\"id\":\"topics\",\"name\":\"Topics\",\"enabled\":false,\"applied\":false,\"description\":\"Topics and themes associated with this person, similar to interests but simpler and includes themes.\",\"docLink\":\"http://docs.fullcontact.com/api/#topics\"}],\"updated\":\"2018-05-07\"}';
        PersonResponse obj = PersonResponse.parse(json);
        System.assert(obj != null);
    }
}