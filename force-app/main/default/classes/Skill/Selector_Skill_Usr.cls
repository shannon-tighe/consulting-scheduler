/**
 * @description User-context implementation of ISelector_Skill (with sharing).
 *              Performs SOQL and maps to DTOs; no caching here.
 * @since 1.0.0
 * @group Selectors
 * @see ISelector_Skill
 */
public with sharing class Selector_Skill_Usr implements ISelector_Skill {

    public Map<Id, DTO_Skill.RowCore> byIds(Set<Id> ids) {
        Map<Id, DTO_Skill.RowCore> out = new Map<Id, DTO_Skill.RowCore>();
        if (ids == null || ids.isEmpty()) {
            return out;
        }

        for (Skill__c s : [
            SELECT Id, Name
            FROM Skill__c
            WHERE Id IN :ids
            WITH SECURITY_ENFORCED
        ]) {
            out.put(s.Id, new DTO_Skill.RowCore(s.Id, s.Name));
        }
        return out;
    }

    public List<DTO_Skill.RowCore> namesLike(String term, Integer limitSize) {
        String q = (term == null) ? '' : term.trim();
        if (q == '') return new List<DTO_Skill.RowCore>();
        Integer lim = (limitSize == null) ? 20 : Math.max(1, Math.min(200, limitSize));
        String likeTerm = '%' + q + '%';

        List<DTO_Skill.RowCore> rows = new List<DTO_Skill.RowCore>();
        for (Skill__c s : [
            SELECT Id, Name
            FROM Skill__c
            WHERE Name LIKE :likeTerm
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC, Id ASC
            LIMIT :lim
        ]) {
            rows.add(new DTO_Skill.RowCore(s.Id, s.Name));
        }
        return rows;
    }

    public List<DTO_Skill.RowCore> topNByName(Integer limitSize) {
        Integer lim = (limitSize == null) ? 50 : Math.max(1, Math.min(2000, limitSize));

        List<DTO_Skill.RowCore> rows = new List<DTO_Skill.RowCore>();
        for (Skill__c s : [
            SELECT Id, Name
            FROM Skill__c
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC, Id ASC
            LIMIT :lim
        ]) {
            rows.add(new DTO_Skill.RowCore(s.Id, s.Name));
        }
        return rows;
    }

    public List<DTO_Skill.RowAudit> recentlyModifiedSince(Datetime since, Integer limitSize) {
        Datetime cutoff = (since == null) ? Datetime.newInstance(1970,1,1) : since;
        Integer lim = (limitSize == null) ? 200 : Math.max(1, Math.min(2000, limitSize));

        List<DTO_Skill.RowAudit> rows = new List<DTO_Skill.RowAudit>();
        for (Skill__c s : [
            SELECT Id, Name, CreatedDate, LastModifiedDate
            FROM Skill__c
            WHERE LastModifiedDate >= :cutoff
            WITH SECURITY_ENFORCED
            ORDER BY LastModifiedDate DESC, Id ASC
            LIMIT :lim
        ]) {
            rows.add(new DTO_Skill.RowAudit(s.Id, s.Name, s.CreatedDate, s.LastModifiedDate));
        }
        return rows;
    }
}