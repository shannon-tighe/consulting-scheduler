import { LightningElement, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecordIdFromUrl } from 'c/utils';
import {
  IsConsoleNavigation,
  getFocusedTabInfo,
  closeTab,
  refreshTab
} from 'lightning/platformWorkspaceApi';

export default class NewContactSkillForm extends LightningElement {

    recordTypeId;
    contactId;

    @wire(IsConsoleNavigation) isConsoleNavigation;

    @wire(CurrentPageReference)
    getUrlParameters(pageRef) {
        if (!pageRef) return;

        // Extract Contact and Rt Ids from URL
        this.recordTypeId = pageRef.state.recordTypeId;
        this.contactId = getRecordIdFromUrl(pageRef.state.ws, 'Contact');
    }

    handleSubmit(evt) {
        // Prevent auto-submitting the form
        evt.preventDefault();

        // Add default values for required fields
        const fields = evt.detail.fields;
        fields.Contact__c = this.contactId;
        fields.Name = 'New Contact Skill';

        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(evt) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Created',
            message: `Contact Skill Successfully Added.`,
            variant: 'success'
        }));

        //this.notifyParent();

        this.closeCurrentTab();
    }

    handleCancel() {
        this.closeCurrentTab();
    }

    async closeCurrentTab() {
        // Only attempt to close tab in console
        if(!this.isConsoleNavigation) return;

        const focused = await getFocusedTabInfo();
        const currentTabId = focused.tabId;
        const parentTabId = focused.parentTabId;

        if(parentTabId) {
            await refreshTab( parentTabId, {includeAllSubtabs: false} );
        }

        if(currentTabId) {
            history.back();

            await closeTab(currentTabId);
        }
    }
}