import { LightningElement, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class RecordTypeSelectorHost extends LightningElement {
  @api objectApiName;
  @api includeMasterRt = false;

  selectedRecordTypeId;
  recordTypeOptions = [];
  hasObjectInfo = false;

  _title;


  @api
  set title(value) {
    this._title = value;
  }

  get title() {
    if(this._title) return this._title;
    return `Select a Record Type${' for ' + this.objectApiName || ''}`;
  }

  @wire(getObjectInfo, { objectApiName: '$objectApiName' })
  wiredInfo({ data, error }) {
    if (data) {
      this.hasObjectInfo = true;

      console.log('Rt Infos:\n', JSON.stringify(data, null, 2));

      // Build list of available record types
      const infos = Object.values(data.recordTypeInfos || {});
      let opts = infos
        .filter(rt => rt.available)                // only those the user can use
        .filter(rt => !rt.master)
        .map(rt => ({ label: rt.name, value: rt.recordTypeId }));

      // Sort for nice UX
      opts.sort((a, b) => a.label.localeCompare(b.label));

      // If none left after filtering (edge case), just bail
      this.recordTypeOptions = opts;

      // Auto-select default RT (falls back to first option)
      this.selectedRecordTypeId = data.defaultRecordTypeId || (opts[0]?.value ?? null);
    } else if (error) {
      this.hasObjectInfo = false;
      console.error(error);
    }
  }

  handleRtChange(e) {
    this.selectedRecordTypeId = e.detail.value;
  }

  handleAfterSave(evt) {
    // evt.detail.recordId available if you need
    // e.g., show a toast / close a modal / navigate
  }

  handleCancel() {
    // e.g., close modal or navigate back
    history.back();
  }
}