trigger Account_tgr on Account (after insert, after update) {
    /* Inicializa lista de oportidades a cerrar */
    List<Opportunity> oppLst = new List<Opportunity>();
    /* Inicializa lista de contactos a ser convertidos a Ex-Clientes */
    List<Contact> exCLst = new List<Contact>();
    /* Optiene oportunidades relacionadas a la(s) cuentas en el Trigger */
    Map<Id,Account> accAndOpp = new Map<Id,Account>([SELECT Id,(SELECT Id, StageName, Description FROM Opportunities WHERE StageName != 'Closed Won' AND StageName != 'Closed Lost') FROM Account WHERE Id IN :Trigger.New]);
    /* Optiene Contactos relacionadas a la(s) cuentas en el Trigger */
    List<Contact> contLst = [SELECT Id, Rol__c, AccountId FROM Contact WHERE Rol__c = 'Influyente' AND AccountId IN :Trigger.New];
    /* Inicializa uow con tipos de objetos a crear, actualizar y/o relacionar */
    fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] {Account.SObjectType, Ex_Cliente__c.SObjectType,Opportunity.SObjectType});
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Account acc : Trigger.new){
            if(acc.Activa__c.containsIgnoreCase('NO')){
                if(accAndOpp.get(acc.Id).Opportunities.size() > 0){
                    oppLst.addAll(accAndOpp.get(acc.Id).Opportunities);
                }
                if(contLst.size() > 0){
                    for(Contact cont : contLst){
                        if(cont.AccountId == acc.Id){
                            exCLst.add(cont);
                        }
                    }
                }
            }
        }
        if(oppLst.size() > 0 || exCLst.size() > 0){
            /* Actualiza Opp abiertas a Cerrada perdida con descripción */
            if(oppLst.size() > 0){
                for(Opportunity opp : oppLst){
                    opp.StageName = 'Closed Lost';
                    opp.Description = 'Cerrada por Cuenta Inactiva';
                    uow.registerDirty(opp);
                }
            }
            /* Crea ex-cuentas con información del contacto */
            if(exCLst.size() > 0){
                for(Contact contExC : exCLst){
                    Ex_Cliente__c exC = new Ex_Cliente__c(Generado_automaticamente__c = true);
                    uow.registerNew(exC, Ex_Cliente__c.Contact__c, contExC);
                }
            }
            uow.commitWork();
        }
    }
}