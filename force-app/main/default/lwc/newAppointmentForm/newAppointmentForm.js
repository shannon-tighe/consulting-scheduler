import { LightningElement,wire,api,track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getContactSkills from '@salesforce/apex/NewAppointmentFormController.getContactSkills';
import { getRecordIdFromUrl } from 'c/utils';
import { CurrentPageReference } from 'lightning/navigation';
import updateContactSkills from '@salesforce/apex/NewAppointmentFormController.updateContactSkills'

export default class NewAppointmentForm extends LightningElement {
    @api recordId;

    contactId;
    recordTypeId;

    @track draftValues = [];

    @track contactSkills = [];
    wiredContactSkills;
    contactSkillCols = [
        { label: 'Skill Name', fieldName: 'name', type: 'text', editable: true},
        { label: 'Skill Level', fieldName: 'skillLevel', type: 'number', editable: true},
        { label: 'Value Ranking', fieldName: 'valueRanking', type: 'text'}
    ];

    get contactDisplayInfo() {
        return {
            primaryField: 'Name',
            additionalFields: [ 'Title' ]
        }
    }

    get contactIsSelected() {
        return this.contactId != null;
    }

    get showFooter() {
        return this.draftValues && this.draftValues.length > 0;
    }

    @wire(CurrentPageReference)
    getContactId(pageRef) {
        if(this.recordId) {
            this.contactId = this.recordId;
        } else if(pageRef) {
            this.contactId = getRecordIdFromUrl(pageRef.state.ws, 'Contact');
        }
    }

    @wire(getContactSkills, { contactId: '$contactId' })
    wiredGetContactSkills(result) {
        this.wiredContactSkills = result;
        if(result.data) {
            console.log('Data ==> ', JSON.stringify( result.data ));
            this.contactSkills = result.data;
        } else if(result.error) {
            console.warn('Error Retrieving Contact Skills.\nError:\n', result.error);
        }
    }

    handleContactChange(event) {
        this.contactId = this.template.querySelector('.contact-lookup').value;
        if(this.contactId == null || this.contactId == '') {
            this.contactSkills = [];
        }
    }

    handleRowSelection(event) {
        console.log('Handling Row Selection:\n', event);
    }

    handleCellChange(event) {
        const incomingDrafts = event.detail.draftValues;

        const draftMap = new Map(
            this.draftValues.map((draft) => [draft.Id, {...draft }])
        );

        incomingDrafts.forEach((draft) => {
            const existing = draftMap.get(draft.Id) || {};
            draftMap.set(draft.Id, {...existing, ...draft});
        });

        this.draftValues = Array.from(draftMap.values());
        console.log('Saved Draft Values:\n', JSON.stringify(this.draftValues));
    }

    async handleSave() {
        console.log('handling save. Draft values:\n', JSON.stringify(this.draftValues));
        await updateContactSkills({ skillz: this.draftValues });
        this.draftValues = [];
        await refreshApex(this.wiredContactSkills);
    }

    handleCancel() {
        console.log('handling cancel');
        this.draftValues = [];
    }
}