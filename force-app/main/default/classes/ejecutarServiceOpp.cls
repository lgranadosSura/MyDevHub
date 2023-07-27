global class ejecutarServiceOpp extends relax.BatchableSchedulableProcessStep implements Database.Stateful{
    global String parameters;
    public String query;
    public String condition;

    global override Database.QueryLocator start(Database.BatchableContext btx){
        if (parameters == null) parameters = params();
        if (parameters != null) {
            Map<String,Object> paramsObj;
            try {
                paramsObj = (Map<String,Object>) JSON.deserializeUntyped(parameters);
                condition = (String) paramsObj.get('condition');
                System.debug('***DATOS: '  + condition );
            } catch (Exception ex) {
                complete();
                throw ex;
            }
        }
        if (condition != null) {
            query = 'SELECT Id FROM Opportunity WHERE StageName IN ' + condition;
        }
        if (query != null) {
            return Database.getQueryLocator(query);
        } else{
            return Database.getQueryLocator([select Id FROM Opportunity limit 0]);
        }
    }

    global override void execute(Database.BatchableContext btx, List<SObject> scope) {
        System.debug('***ColaboracionClientes_bch.execute');
        if (scope != null && !scope.isEmpty()){
            System.debug('***ColaboracionClientes_bch. Se llama al método AccountUtils_cls.colaborarCuentaDePolizas');
        }
        
    }

    global override void finish(Database.BatchableContext btx) {
        complete();
    }

    global override void execute(SchedulableContext ctx) {
		system.debug('ejecutarServiceOpp: execute');
		Database.executeBatch(new ejecutarServiceOpp());
	}
}
