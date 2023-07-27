public class  servicioOpp_bch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    public String Query;
    public String retService;
    public String statusCode;
 
    public Database.QueryLocator start(Database.BatchableContext BC){
        Query = 'SELECT Id, Name, CloseDate, Amount, AccountId FROM Opportunity WHERE StageName IN (\'Closed Won\', \'Reenviar\')';
        return Database.getQueryLocator(query);
    }
 
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        Set<Id> ids = new Set<Id>();
        List<Opportunity> oppUpdate = new List<Opportunity>();
        if (scope != null && !scope.isEmpty()){
            List<Opportunity> oppLst = (List<Opportunity>) scope;
            for(Opportunity o : oppLst){
                ids.add(o.AccountId);
            }
            List<Account> accLst = [select Id,Name from Account WHERE Id IN: ids];
            Map<Id,Account> mapAcc = new Map<Id,Account>(accLst);
            for(Opportunity opp : oppLst){
                String body = '{"opportunityName": "' + opp.Name + '",';
                body += '"opportunityId": "' + opp.Id + '",';
                body += '"closeDate": "' + opp.CloseDate + '",';
                body += '"amount": ' + opp.Amount + ',';
                body += '"accountName": "' + mapAcc.get(opp.AccountId).Name + '"}';
                retService = !Test.isRunningTest() ? webServiceHandler.invokeService(body,'http://www.apexdevnet.com/test/prueba/') : statusCode;
                if(retService == '201'){
                    opp.StageName = 'Enviado';
                    oppUpdate.add(opp);
                } else{
                    opp.StageName = 'Reenviar';
                    oppUpdate.add(opp);
                }
            }
            update oppUpdate;
        }
    }
 
    public void finish(Database.BatchableContext BC){
 
    }
 
 }
