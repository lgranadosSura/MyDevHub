public class GoogleDriveController {
    private String code;
    public boolean val {get;set;}    
    public blob file {get;set;}    
    public String filetype {get;set;}       
    public String filename {get;set;}
    private string key = '1092463917067-rt7palq4eojp006eb1nanthppl07sovo.apps.googleusercontent.com';
    private string secret = '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';
    private string redirect_uri = 'https://great-einstein-467969-dev-ed--c.visualforce.com/apex/cargaArchivoVF';
    private String accesstoken;
    private Integer expiresIn;
    private String tokentype;
    public GoogleDriveController() {
        code = ApexPages.currentPage().getParameters().get('code');
        //Get the access token once we have code
        if (code != '' && code != null) {
        	AccessToken();
        }
    }
    
    public PageReference DriveAuth() {
    //Authenticating
    PageReference pg = new PageReference(GoogleDriveAuthUri(key, redirect_uri));
    return pg;
    }

    public String GoogleDriveAuthUri(String Clientkey, String redirect_uri) {
    String key = EncodingUtil.urlEncode(Clientkey, 'UTF-8');
    String uri = EncodingUtil.urlEncode(redirect_uri, 'UTF-8');
    String authuri = '';
    authuri = 'https://accounts.google.com/o/oauth2/auth?' +
          'client_id=' + key +
          '&response_type=code' +
          '&scope=https://www.googleapis.com/auth/drive' +
          '&redirect_uri=' + uri +
          '&state=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' +
           +
          'access_type=offline';
           return authuri;
    }
    
    public void UploadFile() {
        String boundary = '----------9889464542212';
        String delimiter = '\r\n--' + boundary + '\r\n';
        String close_delim = '\r\n--' + boundary + '--';
        String bodyEncoded = EncodingUtil.base64Encode(file);
        String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "' + filename + '",' + ' "mimeType" : "' + filetype + '" }' + delimiter + 'Content-Type: ' + filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
        req.setHeader('Content-length', String.valueOf(body.length()));
        req.setBody(body);
        req.setMethod('POST');
        req.setTimeout(60 * 1000);
        HttpResponse resp = http.send(req);
        file = null;
        filetype = '';
        filename = '';
    }
    
    public void AccessToken() {
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code=' + code + '&client_id=' + key + '&client_secret=' + secret + '&redirect_uri=' + redirect_uri + '&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60 * 1000);
        Http h = new Http();
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
         } }
         System.debug(' You can parse the response to get the access token ::: ' + resp);
       }
}