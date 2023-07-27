public with sharing class cargaArchivoCtr {

    @AuraEnabled(continuation=true)
    public static String cargaArchivo(Id id, String fileData) {
        oObjfileData file = (oObjfileData)JSON.deserializeStrict(fileData,oObjfileData.class);
        String code;
        boolean val;
	    String filetype;	   
	    String filename;
        String thumbnailLink;
	    String fid;
	    String clink;
        String key = '1092463917067-rt7palq4eojp006eb1nanthppl07sovo.apps.googleusercontent.com';
        String secret = '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';
        String redirect_uri = 'https://great-einstein-467969-dev-ed--c.visualforce.com/apex/cargaArchivo';
        String accesstoken;
        Integer expiresIn;
        String tokentype;
        Id ContactId = id;
        Drive_Token__mdt gd = [Select RefreshToken__c  from Drive_Token__mdt where DeveloperName ='R_Token'];
        String refreshtoken = gd.RefreshToken__c;
        try {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint('https://www.googleapis.com/oauth2/v4/token');
            req.setHeader('content-type', 'application/x-www-form-urlencoded');
            String messageBody = 'client_id=' + key + '&client_secret=' + secret + '&refresh_token='+refreshtoken+'&redirect_uri=' + redirect_uri + '&grant_type=refresh_token';
            req.setHeader('Content-length', String.valueOf(messageBody.length()));
            req.setBody(messageBody);
            req.setTimeout(60 * 1000);
            String resp;
            HttpResponse res = h.send(req);
            resp = res.getBody();
            JSONParser parser = JSON.createParser(resp);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                    String fieldName = parser.getText();
                    parser.nextToken();
                    if (fieldName == 'access_token') {
                    accesstoken = parser.getText();
                    } else if (fieldName == 'expires_in') {
                    expiresIn = parser.getIntegerValue();
                    } else if (fieldname == 'token_type') {
                    tokentype = parser.getText();
                    }
                } 
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Call exception ' + e.getMessage());
        }

        String boundary = '----------9889464542212';
		String delimiter = '\r\n--' + boundary + '\r\n';
		String close_delim = '\r\n--' + boundary + '--';
        if(file!=null)
		{
            String bodyEncoded = file.base64;
		    String FolderId='15TWaafcNRG_ZS5l6qQ_sHaPJI-eeR1Qr';
		    String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "' + file.filename + '",' + ' "mimeType" : "' + file.filetype + '",' + '"parents":[{"id":"'+ FolderId +'"}]}' + delimiter + 'Content-Type: ' + file.filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
            try {
                Http http = new Http();
                HttpRequest req1 = new HttpRequest();
                req1.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart&withLink=true');
                req1.setHeader('Authorization', 'Bearer ' + accesstoken);
                req1.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
                req1.setHeader('Content-length', String.valueOf(body.length()));
                req1.setBody(body);
                req1.setMethod('POST');
                req1.setTimeout(60 * 1000);
                HttpResponse resp1 = http.send(req1);
                Map<String, Object> p = (Map<String, Object>) JSON.deserializeUntyped(resp1.getBody());
                thumbnailLink= (String) p.get('thumbnailLink');
                fid=(String) p.get('id');
                clink='https://drive.google.com/uc?export=view&id='+fid; 
            } catch (Exception e) {
                System.debug(LoggingLevel.ERROR, 'Call exception ' + e.getMessage());
            }
            String body1 = '{"role":"reader","type":"anyone"}';
            try{
                http h1 = new Http();
                HttpRequest req2 = new HttpRequest();
                req2.setEndpoint('https://www.googleapis.com/drive/v2/files/'+fid+'/permissions');
                req2.setHeader('Authorization', 'Bearer ' + accesstoken);
                req2.setHeader('Content-Type', 'application/json');
                req2.setHeader('Content-length', String.valueOf(body1.length()));
                req2.setBody(body1);
                req2.setMethod('POST');
                req2.setTimeout(60 * 1000);
                HttpResponse resp2 = h1.send(req2);
            } catch (Exception e) {
                System.debug(LoggingLevel.ERROR, 'Call exception ' + e.getMessage());
            }  
            if(ContactId != null) {
                Contact c = [Select Id, Drive_URL__c from Contact where Id =: ContactId];
                c.Drive_URL__c = clink;
                update c;
            }
        }
        
        return clink;
	}

    public class oObjfileData{
        public String filename  {get;set;}
        public String base64 {get;set;}
        public String filetype  {get;set;}
        public String recordId {get;set;}
    }
}