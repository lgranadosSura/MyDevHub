public with sharing class lstOppWonLostHandler {
    @AuraEnabled(cacheable=true continuation=true)
	public static List<Opportunity> getOppWonLost(String recordId){
        List<Opportunity> ret = [SELECT Id, Name, Account.Name, Amount, CloseDate, StageName, Type 
                                    FROM Opportunity 
                                    WHERE StageName IN ('Closed Won', 'Closed Lost')
                                    AND AccountId =: recordId
                                    AND CloseDate = THIS_MONTH];
        return ret;
    }
}
