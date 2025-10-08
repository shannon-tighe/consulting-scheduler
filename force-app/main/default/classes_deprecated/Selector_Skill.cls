/**
 * @description Read-only selector for Skill__c. Returns DTOs (DTO_Skill).
 *              Centralizes SOQL, sharing/FLS enforcement, and stable projections.
 * @since 1.0.0
 * @group Selectors
 * @see DTO_Skill
 */
public with sharing class Selector_Skill {

    /**
     * @description Bulk lookup by Ids → Map of Id to RowCore.
     * @param ids Set of Skill Ids to retrieve.
     * @return Map<Id, DTO_Skill.RowCore> lookups.
     * @since 1.0.0
     */
    public static Map<Id, DTO_Skill.RowCore> byIds(Set<Id> ids) {
        Map<Id, DTO_Skill.RowCore> out = new Map<Id, DTO_Skill.RowCore>();
        if (ids == null || ids.isEmpty()) return out;

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

    /**
     * @description Returns the first N Skills ordered by Name.
     * @param limitSize Maximum number of rows to return (clamped to [1..2000], default 50).
     * @return List of RowCore DTOs.
     * @since 1.0.0
     */
    public static List<DTO_Skill.RowCore> topNByName(Integer limitSize) {
        Integer lim = (limitSize == null) ? 50 : Math.max(1, Math.min(2000, limitSize));
        List<DTO_Skill.RowCore> rows = new List<DTO_Skill.RowCore>();

        for (Skill__c s : [
            SELECT Id, Name
            FROM Skill__c
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC
            LIMIT :lim
        ]) {
            rows.add(new DTO_Skill.RowCore(s.Id, s.Name));
        }
        return rows;
    }

    /**
     * @description Case-insensitive typeahead on Name using LIKE '%term%'.
     * @param term Search fragment (trimmed). Empty/blank returns empty list.
     * @param limitSize Max rows (clamped to [1..200], default 20).
     * @return List of RowCore DTOs.
     * @since 1.0.0
     */
    public static List<DTO_Skill.RowCore> namesLike(String term, Integer limitSize) {
        String q = (term == null) ? '' : term.trim();
        if (q == '') return new List<DTO_Skill.RowCore>();
        Integer lim = (limitSize == null) ? 20 : Math.max(1, Math.min(200, limitSize));

        // Pre-bind variable for safe dynamic query usage
        String likeTerm = '%' + q + '%';

        List<DTO_Skill.RowCore> rows = new List<DTO_Skill.RowCore>();
        for (Skill__c s : [
            SELECT Id, Name
            FROM Skill__c
            WHERE Name LIKE :likeTerm
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC
            LIMIT :lim
        ]) {
            rows.add(new DTO_Skill.RowCore(s.Id, s.Name));
        }
        return rows;
    }

    /**
     * @description Returns Skills modified at or after the provided timestamp (audit projection).
     * @param since Datetime cutoff (null → 1970-01-01).
     * @param limitSize Max rows (clamped to [1..2000], default 200).
     * @return List of RowAudit DTOs.
     * @since 1.0.0
     */
    public static List<DTO_Skill.RowAudit> recentlyModifiedSince(Datetime since, Integer limitSize) {
        Datetime cutoff = (since == null) ? Datetime.newInstance(1970, 1, 1) : since;
        Integer lim = (limitSize == null) ? 200 : Math.max(1, Math.min(2000, limitSize));
        List<DTO_Skill.RowAudit> rows = new List<DTO_Skill.RowAudit>();

        for (Skill__c s : [
            SELECT Id, Name, CreatedDate, LastModifiedDate
            FROM Skill__c
            WHERE LastModifiedDate >= :cutoff
            WITH SECURITY_ENFORCED
            ORDER BY LastModifiedDate DESC
            LIMIT :lim
        ]) {
            rows.add(new DTO_Skill.RowAudit(s.Id, s.Name, s.CreatedDate, s.LastModifiedDate));
        }
        return rows;
    }
}