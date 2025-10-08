/**
 * @description Read-only selector for ContactSkill__c (junction). Returns DTOs (DTO_ContactSkill).
 *              Centralizes SOQL and ensures consistent sharing/FLS enforcement.
 * @since 1.0.0
 * @group Selectors
 * @see DTO_ContactSkill
 * @see SkillDTO
 */
public with sharing class Selector_ContactSkill {

    /**
     * @description Bulk lookup of junction rows by Id.
     * @param ids Set of ContactSkill__c Ids.
     * @return Map<Id, DTO_ContactSkill.RowCore> lookups.
     * @since 1.0.0
     */
    public static Map<Id, DTO_ContactSkill.RowCore> byIds(Set<Id> ids) {
        Map<Id, DTO_ContactSkill.RowCore> out = new Map<Id, DTO_ContactSkill.RowCore>();
        if (ids == null || ids.isEmpty()) return out;

        for (ContactSkill__c cs : [
            SELECT Id, Name, Contact__c, Skill__c
            FROM ContactSkill__c
            WHERE Id IN :ids
            WITH SECURITY_ENFORCED
        ]) {
            out.put(
                cs.Id,
                new DTO_ContactSkill.RowCore(cs.Id, cs.Contact__c, cs.Skill__c, cs.Name)
            );
        }
        return out;
    }

    /**
     * @description Retrieves junction rows for the provided Contacts.
     * @param contactIds Set of Contact Ids.
     * @return Map<ContactId, List<RowCore>>; keys prefilled with empty lists.
     * @since 1.0.0
     */
    public static Map<Id, List<DTO_ContactSkill.RowCore>> forContacts(Set<Id> contactIds) {
        Map<Id, List<DTO_ContactSkill.RowCore>> out = new Map<Id, List<DTO_ContactSkill.RowCore>>();
        if (contactIds == null || contactIds.isEmpty()) return out;
        for (Id cId : contactIds) out.put(cId, new List<DTO_ContactSkill.RowCore>());

        for (ContactSkill__c cs : [
            SELECT Id, Name, Contact__c, Skill__c
            FROM ContactSkill__c
            WHERE Contact__c IN :contactIds
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC, Id ASC
        ]) {
            out.get(cs.Contact__c).add(
                new DTO_ContactSkill.RowCore(cs.Id, cs.Contact__c, cs.Skill__c, cs.Name)
            );
        }
        return out;
    }

    /**
     * @description Retrieves junction rows for the provided Skills.
     * @param skillIds Set of Skill Ids.
     * @return Map<SkillId, List<RowCore>>; keys prefilled with empty lists.
     * @since 1.0.0
     */
    public static Map<Id, List<DTO_ContactSkill.RowCore>> forSkills(Set<Id> skillIds) {
        Map<Id, List<DTO_ContactSkill.RowCore>> out = new Map<Id, List<DTO_ContactSkill.RowCore>>();
        if (skillIds == null || skillIds.isEmpty()) return out;
        for (Id sId : skillIds) out.put(sId, new List<DTO_ContactSkill.RowCore>());

        for (ContactSkill__c cs : [
            SELECT Id, Name, Contact__c, Skill__c
            FROM ContactSkill__c
            WHERE Skill__c IN :skillIds
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC, Id ASC
        ]) {
            out.get(cs.Skill__c).add(
                new DTO_ContactSkill.RowCore(cs.Id, cs.Contact__c, cs.Skill__c, cs.Name)
            );
        }
        return out;
    }

    /**
     * @description Returns ContactSkill audit rows modified at/after a timestamp.
     * @param since Datetime cutoff (null → epoch start).
     * @param limitSize Max rows (clamped to [1..2000], default 200).
     * @return List<DTO_ContactSkill.RowAudit>
     * @since 1.0.0
     */
    public static List<DTO_ContactSkill.RowAudit> recentlyModifiedSince(Datetime since, Integer limitSize) {
        Datetime cutoff = (since == null) ? Datetime.newInstance(1970,1,1) : since;
        Integer lim = (limitSize == null) ? 200 : Math.max(1, Math.min(2000, limitSize));
        List<DTO_ContactSkill.RowAudit> out = new List<DTO_ContactSkill.RowAudit>();

        for (ContactSkill__c cs : [
            SELECT Id, Name, Contact__c, Skill__c, CreatedDate, LastModifiedDate
            FROM ContactSkill__c
            WHERE LastModifiedDate >= :cutoff
            WITH SECURITY_ENFORCED
            ORDER BY LastModifiedDate DESC, Id ASC
            LIMIT :lim
        ]) {
            out.add(new DTO_ContactSkill.RowAudit(
                cs.Id, cs.Contact__c, cs.Skill__c, cs.Name, cs.CreatedDate, cs.LastModifiedDate
            ));
        }
        return out;
    }

    /**
     * @description Retrieves detailed junction rows for the provided Contacts, including Skill (Id/Name).
     * @param contactIds Set of Contact Ids.
     * @return Map<ContactId, List<DTO_ContactSkill.RowDetail>>; keys prefilled with empty lists.
     * @since 1.0.0
     */
    public static Map<Id, List<DTO_ContactSkill.RowDetail>> forContactsDetailed(Set<Id> contactIds) {
        Map<Id, List<DTO_ContactSkill.RowDetail>> out = new Map<Id, List<DTO_ContactSkill.RowDetail>>();
        if (contactIds == null || contactIds.isEmpty()) return out;
        for (Id cId : contactIds) out.put(cId, new List<DTO_ContactSkill.RowDetail>());

        for (ContactSkill__c cs : [
            SELECT Id, Name, Contact__c, Skill__c,
                   Skill__r.Id, Skill__r.Name
            FROM ContactSkill__c
            WHERE Contact__c IN :contactIds
            WITH SECURITY_ENFORCED
            ORDER BY Skill__r.Name ASC, Id ASC
        ]) {
            out.get(cs.Contact__c).add(
                new DTO_ContactSkill.RowDetail(
                    cs.Id, cs.Contact__c, cs.Skill__c, cs.Name,
                    new DTO_Skill.RowCore(cs.Skill__r.Id, cs.Skill__r.Name)
                )
            );
        }
        return out;
    }
}