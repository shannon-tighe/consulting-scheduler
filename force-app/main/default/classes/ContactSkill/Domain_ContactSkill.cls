/**
 * @description Domain rules for ContactSkill__c.
 *              Encapsulates invariants and lifecycle behaviors for the junction object.
 * @since 1.0.0
 * @group Domain
 * @see ISelector_Skill
 * @see ISelector_ContactSkill
 */
public inherited sharing class Domain_ContactSkill {
    private final TxnContext ctx;
    private final ISelector_Skill selSkill;
    private final ISelector_ContactSkill selContactSkill;

    /**
     * @description Constructs a ContactSkill domain with injected dependencies.
     * @param ctx Transaction context (cache, corrId).
     * @param selSkill Skill selector (DTO-based).
     * @param selContactSkill ContactSkill selector (DTO-based).
     */
    public Domain_ContactSkill(TxnContext ctx, ISelector_Skill selSkill, ISelector_ContactSkill selContactSkill) {
        this.ctx = ctx;
        this.selSkill = selSkill;
        this.selContactSkill = selContactSkill;
    }

    /**
     * @description BEFORE INSERT: If Name is blank or a placeholder, stamp it from related Skill.Name.
     *              Bulk-safe; no DML is performed in before context (field assignments only).
     * @param newList Records from Trigger.new.
     * @since 1.0.0
     */
    public void beforeInsert(List<ContactSkill__c> newList) {
        if (newList == null || newList.isEmpty()) {
            return;
        }

        List<ContactSkill__c> toStamp = new List<ContactSkill__c>();
        Set<Id> skillIds = new Set<Id>();

        for (ContactSkill__c cs : newList) {

            // Collect ContactSkill__c records that need a new name
            Boolean needsName = String.isBlank(cs.Name) || cs.Name == 'New Contact Skill';
            if (needsName) {
                toStamp.add(cs);
                skillIds.add(cs.Skill__c);
            }
        }

        if (toStamp.isEmpty()) {
            return;
        }

        // Query Skill names
        Map<Id, DTO_Skill.RowCore> skillsById = selSkill.byIds(skillIds);

        // Stamp updated Name pre-insert
        for (ContactSkill__c cs : toStamp) {
            DTO_Skill.RowCore sk = skillsById.get(cs.Skill__c);
            if (sk != null && !String.isBlank(sk.name)) cs.Name = sk.name;
        }
    }

    /** @description BEFORE UPDATE hook (reserved for future rules). */
    public void beforeUpdate(List<ContactSkill__c> newList, Map<Id, ContactSkill__c> oldMap, Map<Id, ContactSkill__c> newMap) { /* no-op */ }

    /** @description AFTER INSERT hook (reserved). */
    public void afterInsert(List<ContactSkill__c> newList, Map<Id, ContactSkill__c> newMap) { /* no-op */ }

    /** @description AFTER UPDATE hook (reserved). */
    public void afterUpdate(List<ContactSkill__c> newList, Map<Id, ContactSkill__c> oldMap, Map<Id, ContactSkill__c> newMap) { /* no-op */ }

    /** @description BEFORE DELETE hook (reserved). */
    public void beforeDelete(List<ContactSkill__c> oldList, Map<Id, ContactSkill__c> oldMap) { /* no-op */ }

    /** @description AFTER DELETE hook (reserved). */
    public void afterDelete(List<ContactSkill__c> oldList, Map<Id, ContactSkill__c> oldMap) { /* no-op */ }

    /** @description AFTER UNDELETE hook (reserved). */
    public void afterUndelete(List<ContactSkill__c> newList, Map<Id, ContactSkill__c> newMap) { /* no-op */ }
}