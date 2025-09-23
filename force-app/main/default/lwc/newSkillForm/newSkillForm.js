import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecordCreateDefaults } from 'lightning/uiRecordApi';
import {
  IsConsoleNavigation,
  getFocusedTabInfo,
  openTab,
  closeTab
} from 'lightning/platformWorkspaceApi';

export default class NewRecordForm extends NavigationMixin(LightningElement) {
    
    @api objectApiName;

    recordTypeId;
    defaults = {};

    @track fields = [];
    ready = false;

    get title() {
        return 'New ' + this.objectApiName;
    }

    @wire(getRecordCreateDefaults, { objectApiName: '$objectApiName', recordTypeId: '$recordTypeId' })
    wiredDefaults({ data, error }) {
        console.log('Running wired method');
        if (data) {
            console.log('Data => ', JSON.stringify(data, null, 2));
            // Extract editable field API names from the layout
            const fieldData = [];
            (data?.layout?.sections || []).forEach(section => {
                (section.layoutRows || []).forEach(row => {
                    (row.layoutItems || []).forEach(item => {
                        // Exctract nested info from layout components
                        let apiName;
                        (item.layoutComponents || []).forEach(comp => {
                            if (comp.apiName && item.editableForNew) {
                                apiName = comp.apiName;
                            }
                        });

                        // Add field data to collection
                        if(apiName) {
                            fieldData.push({
                                apiName: apiName,
                                isRequired: item.required ?? false
                            });
                        }
                    });
                });
            });

            // De-duplicate and keep something sensible if layout is empty
            const uniq = Array.from(new Set(fieldData));
            this.fields = uniq.length ? uniq : ['Name']; // fallback
            console.log('Fields =>', JSON.stringify(this.fields));
            this.ready = true;
        } else if (error) {
            // If layout fetch fails, fall back to a minimal form
            // eslint-disable-next-line no-console
            console.warn('getRecordCreateDefaults error', error);
            this.fields = ['Name'];
            this.ready = true;
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