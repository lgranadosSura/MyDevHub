@isTest
public with sharing class Account_tgr_tst {
    static testMethod void updateAccontTst(){
        Account acc = new Account(
            Name = 'Account Dummy',
            Activa__c = 'Si',
            Phone = '3003003030'
        );
        insert acc;
        Opportunity opp = new Opportunity(
            Name = 'Opportunity Dummy',
            StageName = 'Prospecting',
            Amount = 120000,
            CloseDate = System.today(),
            AccountId = acc.Id
        );
        insert opp;
        Contact cont = new Contact(
            FirstName = 'Contact',
            LastName = 'Dummy',
            Rol__c = 'Influyente',
            AccountId = acc.Id
        );
        insert cont;
        /* Prueba Update */
        Account updateAcc = [SELECT Id, Activa__c FROM Account WHERE Id =: acc.Id];
        updateAcc.Activa__c = 'No';
        update updateAcc;
        Opportunity testOpp = [SELECT Id, Description FROM Opportunity WHERE Id =: opp.Id];
        System.assertEquals('Cerrada por Cuenta Inactiva', testOpp.Description);
        Ex_Cliente__c testExC = [SELECT Id, Generado_automaticamente__c FROM Ex_Cliente__c WHERE Contact__c =: cont.Id];
        System.assertEquals(true, testExC.Generado_automaticamente__c);
    }
}
