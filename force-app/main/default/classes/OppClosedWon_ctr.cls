public with sharing class OppClosedWon_ctr {
    public List<Opportunity> oppLst {get;set;}
    public boolean isExport {get; set;}
    public String recordId {get;set;}
    Public Opportunity objOpp {get;set;}

    public OppClosedWon_ctr(){
        /* Optiene oportunidades cerradas ganadas */
        if(oppLst == null) oppLst = [SELECT Id, Name, Account.Name, Amount, CloseDate, StageName, Type FROM Opportunity WHERE StageName = 'Closed Won'];
        /* Obtiene Id de la oportunidad que se visualizara en PDF */
        recordId = Apexpages.currentPage().getParameters().containsKey('oppId') ? Apexpages.currentPage().getParameters().get( 'oppId' ) : '';
        if(recordId != ''){
            for(Opportunity opp : oppLst){
                if(opp.Id == recordId){
                    objOpp =  opp;
                }
            }
        }
    }

    /* Descarga información en .xls */
    public pagereference Dowload(){
        isExport= true;
        return null;
    }
}
