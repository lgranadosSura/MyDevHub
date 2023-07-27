public class demoCase_bch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    public String Query;
    public static List<Case> lstUpdate = new List<Case>();
 
    public Database.QueryLocator start(Database.BatchableContext BC){
        Query = 'SELECT Id, Status, Origin, Priority, Type, Subject, Description FROM Case';
        return Database.getQueryLocator(query);
    }
 
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        lstUpdate.clear();
        Map<Id,Case> mapCases = new Map<Id,Case>((List<Case>) scope);
        Set<Id> caseIds = mapCases.keySet();
        lstUpdate = [SELECT  Id, Description FROM Case WHERE Id IN: caseIds];
        for(Case c : lstUpdate){
            c.Description = 'bch '+ System.today();
        }
        update lstUpdate;
    }
 
    public void finish(Database.BatchableContext BC){
 
    }
}
