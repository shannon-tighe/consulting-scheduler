/**
 * @description User-context implementation of ISelector_ContactSkill (with sharing).
 *              Performs SOQL and maps to DTOs; no caching here.
 * @since 1.0.0
 * @group Selectors
 * @see ISelector_ContactSkill
 */
public with sharing class Selector_ContactSkill_Usr implements ISelector_ContactSkill {

    public Map<Id, DTO_ContactSkill.RowCore> byIds(Set<Id> ids) {
        Map<Id, DTO_ContactSkill.RowCore> out = new Map<Id, DTO_ContactSkill.RowCore>();
        if (ids == null || ids.isEmpty()) return out;

        for (ContactSkill__c cs : [
            SELECT Id, Name, Contact__c, Skill__c
            FROM ContactSkill__c
            WHERE Id IN :ids
            WITH SECURITY_ENFORCED
        ]) {
            out.put(cs.Id, new DTO_ContactSkill.RowCore(cs.Id, cs.Contact__c, cs.Skill__c, cs.Name));
        }
        return out;
    }

    public Map<Id, List<DTO_ContactSkill.RowCore>> forContacts(Set<Id> contactIds) {
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
            out.get(cs.Contact__c).add(new DTO_ContactSkill.RowCore(cs.Id, cs.Contact__c, cs.Skill__c, cs.Name));
        }
        return out;
    }

    public Map<Id, List<DTO_ContactSkill.RowCore>> forSkills(Set<Id> skillIds) {
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
            out.get(cs.Skill__c).add(new DTO_ContactSkill.RowCore(cs.Id, cs.Contact__c, cs.Skill__c, cs.Name));
        }
        return out;
    }

    public List<DTO_ContactSkill.RowAudit> recentlyModifiedSince(Datetime since, Integer limitSize) {
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

    public Map<Id, List<DTO_ContactSkill.RowDetail>> forContactsDetailed(Set<Id> contactIds) {
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