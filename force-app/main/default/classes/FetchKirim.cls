public class FetchKirim {
    
    public static List<Map<Integer, String>> fetchActivity() {
        List<Map<Integer, String>> activity = new List<Map<Integer, String>>();
        
        for (Integer i = 1; i < 20; i++) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://kirim.qaisha.com/activities/?format=json&page=' + i);
            request.setMethod('GET');
            
            Http http = new Http();

            try {
                HttpResponse httpResponse = http.send(request);
                // getting report data
                if (httpResponse.getStatusCode() == 200 ) {  
                    Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());
                    String detail = (String)response.get('detail');
                    if (detail != null && detail.equals('Invalid page.')) {
                        break;   
                    }
                    
                    List<Object> campaigns = (List<Object>)response.get('results'); // get data
                    for (Object campaign: campaigns) {
                        Map<Integer, String> raw_data = new Map<Integer, String>();
                        Map<String, Object> resp = (Map<String, Object>)campaign;
                        String campaign_title = (String)resp.get('campaign_title');
                        String campaign_date = (String)resp.get('campaign_date');
                        String email = (String)resp.get('email');
                        String open_total = String.valueOf(resp.get('open_total'));
                        String open_date = String.valueOf(resp.get('open_date'));
                        String click_total = String.valueOf(resp.get('click_total'));
                        String unsub = String.valueOf(resp.get('unsub'));
                        String unsub_date = (String)resp.get('unsub_date');
                        String unsub_reason = (String)resp.get('unsub_reason');
                        raw_data.put(1, campaign_title);
                        raw_data.put(2, campaign_date);
                        raw_data.put(3, email);
                        raw_data.put(4, open_total);
                        raw_data.put(5, click_total);
                        raw_data.put(6, unsub);
                        raw_data.put(7, unsub_date);
                        raw_data.put(8, unsub_reason);
                        raw_data.put(9, open_date);
                        activity.add(raw_data);
                    }
                }
            } catch(System.CalloutException e) {
                continue;
            }
                 
        }

        return activity;
    }
    
    public static List<Map<Integer, String>> fetchGeo() {
        List<Map<Integer, String>> geo = new List<Map<Integer, String>>();
        
        for (Integer i = 1; i < 20; i++) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://kirim.qaisha.com/geoloc/?format=json&page=' + i);
            request.setMethod('GET');
            
            Http http = new Http();

            try {
                HttpResponse httpResponse = http.send(request);
                // getting report data
                if (httpResponse.getStatusCode() == 200 ) {  
                    Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());
                    String detail = (String)response.get('detail');
                    if (detail != null && detail.equals('Invalid page.')) {
                        break;   
                    }
                    
                    List<Object> campaigns = (List<Object>)response.get('results'); // get data
                    for (Object campaign: campaigns) {
                        Map<Integer, String> raw_data = new Map<Integer, String>();
                        Map<String, Object> resp = (Map<String, Object>)campaign;
                        String email = (String)resp.get('email');
                        String ip_address = (String)resp.get('ip_address');
                        String country = (String)resp.get('country');
                        String timezone = (String)resp.get('timezone');
                        raw_data.put(1, email);
                        raw_data.put(2, ip_address);
                        raw_data.put(3, country);
                        raw_data.put(4, timezone);
                        geo.add(raw_data);
                    }
                }
            } catch(System.CalloutException e) {
                continue;
            }
                     
        }

        return geo;
    }
    
    public static List<Map<Integer, String>> fetchBounce() {
        List<Map<Integer, String>> bounce = new List<Map<Integer, String>>();
        
        for (Integer i = 1; i < 20; i++) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://kirim.qaisha.com/bounces/?format=json&page=' + i);
            request.setMethod('GET');
            
            Http http = new Http();

            try {
                HttpResponse httpResponse = http.send(request);
                // getting report data
                if (httpResponse.getStatusCode() == 200 ) {  
                    Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());
                    String detail = (String)response.get('detail');
                    if (detail != null && detail.equals('Invalid page.')) {
                        break;   
                    }
                    
                    List<Object> campaigns = (List<Object>)response.get('results'); // get data
                    for (Object campaign: campaigns) {
                        Map<Integer, String> raw_data = new Map<Integer, String>();
                        Map<String, Object> resp = (Map<String, Object>)campaign;
                        String email = (String)resp.get('email');
                        String bounce_type = (String)resp.get('bounce_type');
                        raw_data.put(1, email);
                        raw_data.put(2, bounce_type);
                        bounce.add(raw_data);
                    }
                }
            } catch(System.CalloutException e) {
                continue;
            }
                        
        }

        return bounce;
    }

    public static List<Map<Integer, String>> fetchUnopen() {
        List<Map<Integer, String>> unopen = new List<Map<Integer, String>>();
        
        for (Integer i = 1; i < 20; i++) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://kirim.qaisha.com/unopened/?format=json&page=' + i);
            request.setMethod('GET');
            
            Http http = new Http();

            try {
                HttpResponse httpResponse = http.send(request);
                // getting report data
                if (httpResponse.getStatusCode() == 200 ) {  
                    Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());
                    String detail = (String)response.get('detail');
                    if (detail != null && detail.equals('Invalid page.')) {
                        break;   
                    }
                    
                    List<Object> campaigns = (List<Object>)response.get('results'); // get data
                    for (Object campaign: campaigns) {
                        Map<Integer, String> raw_data = new Map<Integer, String>();
                        Map<String, Object> resp = (Map<String, Object>)campaign;
                        String email = (String)resp.get('email');
                        raw_data.put(1, email);
                        unopen.add(raw_data);
                    }
                }
            } catch(System.CalloutException e) {
                continue;
            }
                        
        }

        return unopen;
    }

    public static List<Map<Integer, String>> fetchDead() {
        List<Map<Integer, String>> dead = new List<Map<Integer, String>>();
        
        for (Integer i = 1; i < 20; i++) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://kirim.qaisha.com/dead/?format=json&page=' + i);
            request.setMethod('GET');
            
            Http http = new Http();

            try {
                HttpResponse httpResponse = http.send(request);
                // getting report data
                if (httpResponse.getStatusCode() == 200 ) {  
                    Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());
                    String detail = (String)response.get('detail');
                    if (detail != null && detail.equals('Invalid page.')) {
                        break;   
                    }
                    
                    List<Object> campaigns = (List<Object>)response.get('results'); // get data
                    for (Object campaign: campaigns) {
                        Map<Integer, String> raw_data = new Map<Integer, String>();
                        Map<String, Object> resp = (Map<String, Object>)campaign;
                        String email = (String)resp.get('email');
                        String total = String.valueOf(resp.get('total'));
                        raw_data.put(1, email);
                        raw_data.put(2, total);
                        dead.add(raw_data);
                    }
                }
            } catch(System.CalloutException e) {
                continue;
            }

        }

        return dead;
    }

}