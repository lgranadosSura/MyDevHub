@isTest
public with sharing class OppClosedWon_tst {
    static testMethod void controllerTst(){
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
        /* Test Controller */
        Test.startTest();
        OppClosedWon_ctr ctr = new OppClosedWon_ctr();
        ctr.recordId = opp.Id;
        ctr.objOpp = opp;
        ctr.oppLst.add(opp);
        PageReference pageRef = ctr.Dowload();
        Test.stopTest();
    }

    static testMethod void controllerTst1(){
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
        /* Test Controller */
        Test.startTest();
        Pagereference pr = Page.viewOppPdf_pag;
        pr.getParameters().put('oppId', String.valueOf(opp.Id));
        Test.setCurrentPage(pr);
        OppClosedWon_ctr ctr = new OppClosedWon_ctr();
        ctr.oppLst.add(opp);
        ctr.objOpp = opp;
        Test.stopTest();
    }
}
