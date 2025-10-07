/**
 * @description Domain rules for ContactSkill__c.
 *              Encapsulates invariants and lifecycle behaviors for the junction object.
 * @since 1.0.0
 * @group Domain
 * @see Selector_Skill
 */
public inherited sharing class Domain_ContactSkill {

    /**
     * @description BEFORE INSERT: If Name is blank or a placeholder, stamp it from related Skill.Name.
     *              Bulk-safe; no DML is performed in before context (field assignments only).
     * @param newList Records from Trigger.new.
     * @since 1.0.0
     */
    public static void beforeInsert(List<ContactSkill__c> newList) {
        if (newList == null || newList.isEmpty()) return;

        // Gather records needing a stamp and collect Skill Ids
        List<ContactSkill__c> toStamp = new List<ContactSkill__c>();
        Set<Id> skillIds = new Set<Id>();

        for (ContactSkill__c cs : newList) {
            if (cs == null) continue;
            Boolean needsName = String.isBlank(cs.Name) || cs.Name == 'New Contact Skill';
            if (needsName && cs.Skill__c != null) {
                toStamp.add(cs);
                skillIds.add(cs.Skill__c);
            }
        }
        if (toStamp.isEmpty()) return;

        // Bulk query Skill names via selector (DTO)
        Map<Id, DTO_Skill.RowCore> skillsById = Selector_Skill.byIds(skillIds);

        // Stamp Name in-memory (before context)
        for (ContactSkill__c cs : toStamp) {
            DTO_Skill.RowCore sk = skillsById.get(cs.Skill__c);
            if (sk != null && !String.isBlank(sk.name)) {
                cs.Name = sk.name;
            }
        }
    }

    /**
     * @description BEFORE UPDATE hook (reserved for future rules).
     * @param newList Records from Trigger.new.
     * @param oldMap Map of Id to Trigger.old records.
     * @since 1.0.0
     */
    public static void beforeUpdate(List<ContactSkill__c> newList, Map<Id, ContactSkill__c> oldMap) { /* no-op */ }

    /** @description AFTER INSERT hook (reserved). @since 1.0.0 */
    public static void afterInsert(List<ContactSkill__c> newList) { /* no-op */ }

    /**
     * @description AFTER UPDATE hook (reserved).
     * @param newList Records from Trigger.new.
     * @param oldMap Map of Id to Trigger.old.
     * @since 1.0.0
     */
    public static void afterUpdate(List<ContactSkill__c> newList, Map<Id, ContactSkill__c> oldMap) { /* no-op */ }

    /** @description BEFORE DELETE hook (reserved). @since 1.0.0 */
    public static void beforeDelete(List<ContactSkill__c> oldList) { /* no-op */ }

    /** @description AFTER DELETE hook (reserved). @since 1.0.0 */
    public static void afterDelete(List<ContactSkill__c> oldList) { /* no-op */ }

    /** @description AFTER UNDELETE hook (reserved). @since 1.0.0 */
    public static void afterUndelete(List<ContactSkill__c> newList) { /* no-op */ }
}