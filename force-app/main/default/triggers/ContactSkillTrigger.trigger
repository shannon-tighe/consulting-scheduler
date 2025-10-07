/**
 * @description Trigger for ContactSkill__c delegating all operations to Orchestrator_ContactSkill.
 *              Keep this file thin; no business logic or SOQL/DML here.
 * @since 1.0.0
 * @see Orchestrator_ContactSkill
 */
trigger ContactSkillTrigger on ContactSkill__c (
    before insert, before update,
    after insert,  after update,
    before delete, after delete,
    after undelete
) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) Orchestrator_ContactSkill.beforeInsert(Trigger.new);
        if (Trigger.isUpdate) Orchestrator_ContactSkill.beforeUpdate(Trigger.new, Trigger.oldMap);
        if (Trigger.isDelete) Orchestrator_ContactSkill.beforeDelete(Trigger.old);
    } else {
        if (Trigger.isInsert)   Orchestrator_ContactSkill.afterInsert(Trigger.new);
        if (Trigger.isUpdate)   Orchestrator_ContactSkill.afterUpdate(Trigger.new, Trigger.oldMap);
        if (Trigger.isDelete)   Orchestrator_ContactSkill.afterDelete(Trigger.old);
        if (Trigger.isUndelete) Orchestrator_ContactSkill.afterUndelete(Trigger.new);
    }
}