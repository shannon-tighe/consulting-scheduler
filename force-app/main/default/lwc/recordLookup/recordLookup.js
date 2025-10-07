import { LightningElement, api } from 'lwc';

export default class StandaloneLookup extends LightningElement {
    /*** Public API ***/
    @api objectApiName;
    @api required = false;
    @api disabled = false;
    @api readOnly = false;
    @api variant = 'label-stacked';
    @api selectedRecordId;
    @api matchingInfo = { primaryField: { fieldPath: 'Name' } };
    @api displayInfo; // Ex: { primaryField: { fieldPath: 'Name' }, additionalFields: [{ fieldPath: 'Skill_Level__c' }] }
    @api filter;// = { criteria: [ { fieldPath: 'IsDeleted', operator: 'eq', value: false } ] };

    get label() {
        return this.objectApiName ? `${this.objectApiName} Search` : 'Lookup';
    }

    get placeholder() {
        if(!this.objectApiName) {
            return 'Select a Record...';
        }

        const firstChar = this.objectApiName.charAt(0);
        const startsWithVowel = ['a', 'e', 'i', 'o', 'u'].includes(firstChar.toLowerCase());
        const article = startsWithVowel ? 'an' : 'a';
        
        return `Select ${article} ${this.objectApiName}...`;
    }

    /*** Events ***/
    handleChange(e) {
        // recordId is the Id of the picked record (or null if cleared)
        const recordId = e.detail.recordId || null;
        this.selectedRecordId = recordId;

        // Bubble a simple event upward so parents can react
        this.dispatchEvent(new CustomEvent('select', { detail: { recordId } }));
    }

    /*** Public methods parents can call ***/
    @api clear() {
        this.selectedRecordId = undefined;
        const rp = this.template.querySelector('.lookup');
        rp?.setCustomValidity('');
        rp?.reportValidity();
        // Re-open recents after clearing
        setTimeout(() => rp?.focus(), 0);
    }

    @api setSelection(recordId) {
        this.selectedRecordId = recordId; // record-picker will render the pill for this Id if user has access
    }
}