@isTest
private class webServiceHandler_tst {
    @isTest static void invokeServiceTst() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockResponse');
        mock.setStatus('OK');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        String res = webServiceHandler.invokeService('{"opportunityName": "OppDummy"}','https://test.com/test/test');
        System.assertEquals('200',res);
    }
}
