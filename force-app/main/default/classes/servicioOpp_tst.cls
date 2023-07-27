@isTest
public with sharing class servicioOpp_tst {
    static testMethod void bchTst201() {
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
        Test.startTest();
        servicioOpp_bch bch = new servicioOpp_bch();
        bch.statusCode = '201';
        Id bchId = Database.executeBatch(bch);
        Test.stopTest();
    }
    static testMethod void bchTst500() {
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
        Test.startTest();
        servicioOpp_bch bch = new servicioOpp_bch();
        bch.statusCode = '500';
        Id bchId = Database.executeBatch(bch);
        Test.stopTest();
    }
}
