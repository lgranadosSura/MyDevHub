public with sharing class webServiceHandler {
    
	public static String invokeService(String body, String endPoint){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(endPoint);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        HttpResponse response = http.send(request);
        return String.valueOf(response.getStatusCode());
    }
}
