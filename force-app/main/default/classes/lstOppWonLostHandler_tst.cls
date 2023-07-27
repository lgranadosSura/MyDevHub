@isTest
public with sharing class lstOppWonLostHandler_tst {
    static testMethod void getOppWonLostTst(){
        Account acc = new Account(
            Name = 'Account Dummy',
            Activa__c = 'Si',
            Phone = '3003003030'
        );
        insert acc;
        Opportunity opp = new Opportunity(
            Name = 'Opportunity Dummy',
            StageName = 'Closed Won',
            Amount = 120000,
            CloseDate = System.today(),
            AccountId = acc.Id
        );
        insert opp;
        List<Opportunity> lst = lstOppWonLostHandler.getOppWonLost(opp.Id);
        System.assertEquals(true, lst.size()>0);
    }
}
