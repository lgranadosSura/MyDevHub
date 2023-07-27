public class controllerCargaArchivo {
	private String code;
	public boolean val {get;set;}
	public blob file {get;set;}
	public String filetype {get;set;}	   
	public String filename {get;set;}

	public Id ContactId = ApexPages.currentPage().getParameters().get('Id');
	private string key = '1092463917067-rt7palq4eojp006eb1nanthppl07sovo.apps.googleusercontent.com';
    private string secret = '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';
	private string redirect_uri = 'https://great-einstein-467969-dev-ed--c.visualforce.com/apex/cargaArchivo';
	private String accesstoken;
	private String refreshtoken;
	private String thumbnailLink;
	private String fid;
	private String clink;
	private Integer expiresIn;
	private String tokentype;
	Drive_Token__mdt gd = [Select RefreshToken__c  from Drive_Token__mdt where DeveloperName ='R_Token'];
 

	public controllerCargaArchivo() {
	}
    
    public PageReference UploadFile() {
		refreshtoken = gd.RefreshToken__c;
		try{
		//Getting access token from google
		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		req.setEndpoint('https://www.googleapis.com/oauth2/v4/token');
		req.setHeader('content-type', 'application/x-www-form-urlencoded');
		String messageBody = 'client_id=' + key + '&client_secret=' + secret + '&refresh_token='+refreshtoken+'&redirect_uri=' + redirect_uri + '&grant_type=refresh_token';
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
		  } catch
		(Exception e) {
			System.debug(LoggingLevel.ERROR,
		'Call exception ' + e.getMessage());
		  } 
		 
		 
		 System.debug(ContactId);
		String boundary = '----------9889464542212';
		String delimiter = '\r\n--' + boundary + '\r\n';
		String close_delim = '\r\n--' + boundary + '--';
		if(file!=null)
		{
		String bodyEncoded = EncodingUtil.base64Encode(file);
		System.debug('bodyEncoded '+ bodyEncoded);
		System.debug('FileType '+ filetype);
		System.debug('FileName '+ filename);
		String FolderId='15TWaafcNRG_ZS5l6qQ_sHaPJI-eeR1Qr';
		String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "' + filename + '",' + ' "mimeType" : "' + filetype + '",' + '"parents":[{"id":"'+ FolderId +'"}]}' + delimiter + 'Content-Type: ' + filetype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
		try{
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
		System.debug(resp1.getBody());

		Map<String, Object> p = (Map<String, Object>) JSON.deserializeUntyped(resp1.getBody());
		thumbnailLink= (String) p.get('thumbnailLink');
		fid=(String) p.get('id');
		 System.debug(fid);
		 clink='https://drive.google.com/uc?export=view&id='+fid;

		//Changing file permission to public viewable using link
		   } catch
		(Exception e) {
			System.debug(LoggingLevel.ERROR,
		'Call exception ' + e.getMessage());
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
            System.debug(resp2.getBody());
		} catch (Exception e) {
            System.debug(LoggingLevel.ERROR,
            'Call exception ' + e.getMessage());
		 }  
		 if(ContactId!=null) {
             Contact c = [Select Id, Drive_URL__c from Contact where Id =: ContactId];
              c.Drive_URL__c =clink;
              update c;
		  }

		}
		PageReference returnPage = new PageReference('/lightning/r/Contact/'+ContactId+'/view?0.source=alohaHeader');  

		return returnPage;
    }
    
    
}