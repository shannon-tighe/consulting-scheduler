import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecordCreateDefaults } from 'lightning/uiRecordApi';
import { CurrentPageReference } from 'lightning/navigation';
import {
  IsConsoleNavigation,
  getFocusedTabInfo,
  openTab,
  closeTab
} from 'lightning/platformWorkspaceApi';

export default class NewRecordForm extends NavigationMixin(LightningElement) {
    
    @api objectApiName;
    @api recordTypeId;

    defaults = {};

    @track fields = [];
    ready = false;
    retrievalErrorMsg;

    get title() {
        return 'New ' + this.objectApiName;
    }

    @wire(CurrentPageReference)
    getUrlParameters(pageRef) {
        if (!pageRef) return;

        // Extract Record Type Id from the URL
        this.recordTypeId = pageRef.state.recordTypeId;
    }   

    @wire(getRecordCreateDefaults, { objectApiName: '$objectApiName', recordTypeId: '$recordTypeId' })
    wiredDefaults({ data, error }) {
        if (data) {
            // Extract editable field API names from the appropriate page layout
            const fieldData = [];
            // Page layout section
            (data?.layout?.sections || []).forEach(section => {
                // Page layout row
                (section.layoutRows || []).forEach(row => {
                    // Individual field
                    (row.layoutItems || []).forEach(item => {
                        // Nested field data
                        (item.layoutComponents || []).forEach(comp => {
                            if (comp.apiName && item.editableForNew) {
                                fieldData.push({
                                    apiName: comp.apiName,
                                    isRequired: item.required ?? false
                                });
                            }
                        });
                    });
                });
            });

            // De-duplicate and only show edit form if there are editable fields
            this.fields = Array.from(new Set(fieldData));
            if(this.fields) {
                this.ready = true;
            } else {
                this.retrievalErrorMsg = 'There are no editable fields for this form. Please contact your admin for assistance.';
            }
        } else if (error) {
            // Surface error message if layout fetch fails
            console.warn('getRecordCreateDefaults error', error);
            this.retrievalErrorMsg = 'There was an error retrieving the editable fields for this form. Please contact your admin for assistance.';
        }
    }

    handleSubmit(evt) {
        // Inject default values (from override URL) for fields not touched by the user yet
        const fields = evt.detail.fields;
        Object.keys(this.defaults || {}).forEach(api => {
            if (fields[api] === undefined || fields[api] === null || fields[api] === '') {
                fields[api] = this.defaults[api];
            }
        });
        // Allow submit to proceed with merged fields
    }

    async handleSuccess(evt) {
        const recId = evt.detail.id;
        
        // Navigate to the new record and close the form
        try {
            if (await IsConsoleNavigation) {
                // 1) Get the currently focused (form) tab
                const focused = await getFocusedTabInfo();
                const currentTabId = focused.tabId;

                // 2) Open the new record and focus it
                await openTab({ recordId: recId, focus: true });

                // 3) Close the old form tab
                await closeTab(currentTabId);
            } else {
                // Standard app (not console): just navigate
                this.navToNewRecord(recId);
            }
        } catch (e) {
            // Fallback: at least navigate to the record
            // Surface error in console
            console.warn('Error closing new record form via LWC Workspace API. Attempting fallback...\n', e);
            this.navToNewRecord(recId);
        }
    }

    navToNewRecord(recId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                actionName: 'view'
            }
        });
    }

    handleError(evt) {
        // Surface full error detail in the conole
        // Error automatically surfaced in the UI via lightning-messages
        console.error('Save error', evt.detail);
    }

    async handleCancel() {
        // Get the currently focused (form) tab
        const focused = await getFocusedTabInfo();
        const currentTabId = focused.tabId;

        // Go back to the object’s list view
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.objectApiName,
                actionName: 'list'
            },
            state: { filterName: 'Recent' }
        });

        // Close the "New" record form
        await closeTab(currentTabId);
    }
}