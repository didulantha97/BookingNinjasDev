/**
* The BNEmailFetch class for fetching raw data of the last month's
* campaign activities from the https://bookingninjas.email website
*
* @author  Prayoga Teguh <teguh@bookingninjas.com>
* @version 1.0
* @since   2020-09-23
*/
public with sharing class BNEmailFetch {

    public String username = 'teguh@bookingninjas.com';
    public String password = 'theguh22';
    public String crediential = EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));


    public List<Map<Integer, String>> fetchActivity() {
        List<Map<Integer, String>> activity = new List<Map<Integer, String>>();

        Integer totalPages = getTotalPages();

        if (totalPages > 0) {
            for (Integer i = 1; i <= totalPages; i++) {
                HttpRequest request = new HttpRequest();
                request.setEndpoint('https://bookingninjas.email/reports/api/campaign-activity/?format=json&page=' + i);
                request.setHeader('Authorization', 'Basic '+crediential);
                request.setMethod('GET');
                
                Http http = new Http();

                try {
                    HttpResponse httpResponse = http.send(request);
                    // getting report data
                    if (httpResponse.getStatusCode() == 200 ) {  
                        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());
                        
                        List<Object> campaigns = (List<Object>)response.get('results'); // get data
                        for (Object campaign: campaigns) {
                            Map<Integer, String> rawData = new Map<Integer, String>();
                            Map<String, Object> resp = (Map<String, Object>)campaign;
                            String campaignTitle = (String)resp.get('name');
                            String campaignDate = (String)resp.get('campaign_date');
                            String contactID = (String)resp.get('contact_id');
                            String contactQuality = (String)resp.get('contact_quality');
                            String conatctQualityDesc = (String)resp.get('quality_description');
                            String totalClick = String.valueOf(resp.get('total_click'));
                            String totalOpen = String.valueOf(resp.get('total_open'));
                            rawData.put(1, campaignTitle);
                            rawData.put(2, campaignDate);
                            rawData.put(3, contactID);
                            rawData.put(4, contactQuality);
                            rawData.put(5, conatctQualityDesc);
                            rawData.put(6, totalClick);
                            rawData.put(7, totalOpen);
                            activity.add(rawData);
                        }
                    }
                } catch(System.CalloutException e) {
                    continue;
                }
            }
        }

        return activity;
    }

    private Integer getTotalPages() {
        Integer totalPages = 0;

        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://bookingninjas.email/reports/api/campaign-activity/?format=json');
        request.setHeader('Authorization', 'Basic '+crediential);
        request.setMethod('GET');

        Http http = new Http();
        try {
            HttpResponse httpResponse = http.send(request);
            if (httpResponse.getStatusCode() == 200 ) {
                Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());
                Integer totalRecords = (Integer)response.get('count');
                if (totalRecords != null) {
                    if (totalRecords < 1000 || totalRecords <= 1000) {
                        totalPages = 1;
                    } else {
                        Decimal pages = totalRecords / 1000.0;
                        totalPages = (Integer)pages.round(System.RoundingMode.CEILING);
                    }
                }
            }
        } catch(System.CalloutException e) {}

        return totalPages;
    }
   
}