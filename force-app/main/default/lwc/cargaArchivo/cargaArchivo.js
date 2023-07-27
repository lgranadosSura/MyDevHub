import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cargaArchivo from '@salesforce/apexContinuation/cargaArchivoCtr.cargaArchivo';

export default class CargaArchivo extends NavigationMixin(LightningElement) {
    @api recordId;

    error
    fileData
    IsSpinner = true;
    
    openfileUpload(event) {
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'filetype': file.type,
                'recordId': this.recordId
            }
        }
        reader.readAsDataURL(file)
    }

    handleClick (){
        this.IsSpinner = false;
        cargaArchivo({id: this.recordId, fileData: JSON.stringify(this.fileData)})
        .then(result => {
            this.notifica('success', result);
        })
        .catch(error => {
            console.log("*** Error LWC: " + JSON.stringify(error));
            this.notifica('error', error.message);
        });
    }

    notifica(mode, msm){
        if(mode === 'success'){
            this.showNotification( this.fileData.filename, 'Cargado con exito, url: ' + msm, mode);
        } else{
            this.showNotification( this.fileData.filename, msm, mode);
        }
        this.IsSpinner = true;
    }

    showNotification(tittle, message, variant,mode) {
        if (mode === null)
            mode = 'dismissible';
        const evt = new ShowToastEvent({
            title: tittle,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }
}