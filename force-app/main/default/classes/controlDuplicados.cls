global class controlDuplicados implements Database.Batchable<sObject>, Database.Stateful {

    global Boolean Query {get;set;}

    global controlDuplicados(Boolean query) {
        this.Query = query;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(Query){
            return Database.getQueryLocator([SELECT id, MasterDuplicate__c FROM Contact WHERE MasterDuplicate__c != null]);
        } else{
            return Database.getQueryLocator([SELECT id, MasterDuplicate__c FROM Lead WHERE MasterDuplicate__c != null]);
        }
    }

    global void execute(Database.BatchableContext bc, sObject[] records){ 
        if(Query){
            for(sObject record : records){
                Contact contact = (Contact) record;
                try {
                    Database.merge(new Contact(Id=contact.MasterDuplicate__c), contact.Id);
                } catch (Exception e) {
                    System.debug('Error in Merge '+ e.getMessage());
                }
            }
        } else {
            for(sObject record : records){
                Lead lead = (Lead) record;
                try {
                    Database.merge(new Lead(Id=lead.MasterDuplicate__c), lead.Id);
                } catch (Exception e) {
                    System.debug('Error in Merge '+ e.getMessage());
                }
            }
        }
    }

    global void finish(Database.BatchableContext bc){
    }    
    
}