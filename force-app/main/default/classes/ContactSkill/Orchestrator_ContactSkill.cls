/**
 * @description Orchestrator for ContactSkill__c trigger operations.
 *              Routes per-operation to the domain layer; owns no business rules.
 * @since 1.0.0
 * @group Orchestrators
 * @see Domain_ContactSkill
 */
public inherited sharing class Orchestrator_ContactSkill {

    /** @description Routes BEFORE INSERT. @param newList Trigger.new. @since 1.0.0 */
    public static void beforeInsert(List<ContactSkill__c> newList) {
        Domain_ContactSkill.beforeInsert(newList);
    }

    /** @description Routes BEFORE UPDATE. @param newList Trigger.new. @param oldMap Trigger.oldMap. @since 1.0.0 */
    public static void beforeUpdate(List<ContactSkill__c> newList, Map<Id, ContactSkill__c> oldMap) {
        Domain_ContactSkill.beforeUpdate(newList, oldMap);
    }

    /** @description Routes AFTER INSERT. @param newList Trigger.new. @since 1.0.0 */
    public static void afterInsert(List<ContactSkill__c> newList) {
        Domain_ContactSkill.afterInsert(newList);
    }

    /** @description Routes AFTER UPDATE. @param newList Trigger.new. @param oldMap Trigger.oldMap. @since 1.0.0 */
    public static void afterUpdate(List<ContactSkill__c> newList, Map<Id, ContactSkill__c> oldMap) {
        Domain_ContactSkill.afterUpdate(newList, oldMap);
    }

    /** @description Routes BEFORE DELETE. @param oldList Trigger.old. @since 1.0.0 */
    public static void beforeDelete(List<ContactSkill__c> oldList) {
        Domain_ContactSkill.beforeDelete(oldList);
    }

    /** @description Routes AFTER DELETE. @param oldList Trigger.old. @since 1.0.0 */
    public static void afterDelete(List<ContactSkill__c> oldList) {
        Domain_ContactSkill.afterDelete(oldList);
    }

    /** @description Routes AFTER UNDELETE. @param newList Trigger.new. @since 1.0.0 */
    public static void afterUndelete(List<ContactSkill__c> newList) {
        Domain_ContactSkill.afterUndelete(newList);
    }
}