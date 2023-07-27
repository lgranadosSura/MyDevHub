import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOppWonLost from '@salesforce/apexContinuation/lstOppWonLostHandler.getOppWonLost';

export default class LstOppWonLost extends NavigationMixin(LightningElement) {
    columns = [
        { label: 'Nombre', fieldName: 'Id', hideDefaultActions: true, type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'} },
        { label: 'Cuenta', fieldName: 'Account', hideDefaultActions: true },
        { label: 'Monto', fieldName: 'Amount', type: 'currency', cellAttributes: {alignment: 'center'}, typeAttributes: { minimumFractionDigits: 0, maximumFractionDigits: 0 }, sortable: false, hideDefaultActions: true, },
        { label: 'Fecha de cierre', fieldName: 'CloseDate', hideDefaultActions: true, type:'date', typeAttributes: {
                                                                                    day: 'numeric',
                                                                                    month: 'numeric',
                                                                                    year: 'numeric',
                                                                                    hour: '2-digit',
                                                                                    minute: '2-digit',
                                                                                    hour12: true
                                                                                 }},
        { label: 'Etapa', fieldName: 'StageName', hideDefaultActions: true },
        { label: 'Tipo', fieldName: 'Type', hideDefaultActions: true }
    ];

    @api recordId;
    @track data;

    @wire(getOppWonLost, {recordId: '$recordId'})
    wiredOpp({data, error}){
        if(data){
            this.flawData(data);
        }else{

        }
    }
    flawData(data){
        let currentData = [];
        data.forEach((row) => {
            let rowData = {};
            rowData.Id = '/' + row.Id;
            rowData.Name = row.Name;
            rowData.Account = row.Account.Name;
            rowData.Amount = row.Amount;
            rowData.CloseDate = row.CloseDate;
            rowData.StageName = row.StageName;
            rowData.Type = row.Type;
            currentData.push(rowData);
        });
        this.data = currentData;
    }
}