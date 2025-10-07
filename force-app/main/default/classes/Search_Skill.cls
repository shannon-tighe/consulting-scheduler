/**
 * @description Dynamic search for Skill__c with keyset pagination, returning DTO pages.
 *              Use this for UI/API search endpoints with optional filters.
 * @since 1.0.0
 * @group Queries
 * @see DTO_Skill
 */
public with sharing class Search_Skill {

    /**
     * @description Allowed sort orders for search results.
     * @since 1.0.0
     */
    public enum SkillSort { NAME_ASC, MODIFIED_DESC }

    /**
     * @description Optional filters for searching Skills. Extend as needs grow.
     * @since 1.0.0
     */
    public class SkillCriteria {
        /** @description Case-insensitive contains match against Name. */
        public String nameLike;

        /** @description Normalizes inputs early. */
        public void validate() {
            if (nameLike != null) nameLike = nameLike.trim();
        }
    }

    /**
     * @description Paging request (keyset/cursor pagination preferred over OFFSET).
     * @since 1.0.0
     */
    public class PageRequest {
        /** @description Page size; clamped to [1..200]. */
        public Integer size = 50;
        /** @description Cursor token from previous page; format depends on sort order. */
        public String afterKey;
    }

    /**
     * @description Page of RowCore DTOs and a next cursor.
     * @since 1.0.0
     */
    public class PageCore {
        /** @description Current page items. */
        public List<DTO_Skill.RowCore> items;
        /** @description Cursor for next page; null if no more results. */
        public String nextKey;
    }

    /**
     * @description Executes a Skill search using the given criteria and page request.
     * @param criteria Optional filters (trimmed/validated).
     * @param page Page request (size clamped).
     * @param sortOrder Sort order (NAME_ASC or MODIFIED_DESC).
     * @return PageCore containing items and nextKey.
     * @since 1.0.0
     */
    public static PageCore searchCore(SkillCriteria criteria, PageRequest page, SkillSort sortOrder) {
        // 1) Validate inputs and clamp page size
        SkillCriteria c = (criteria == null) ? new SkillCriteria() : criteria; c.validate();
        PageRequest p = (page == null) ? new PageRequest() : page;
        p.size = (p.size == null) ? 50 : Math.max(1, Math.min(200, p.size));

        // 2) Build base SELECT/WHERE
        String soql = 'SELECT Id, Name, LastModifiedDate FROM Skill__c WHERE 1=1';

        // Pre-bind LIKE term (avoid injecting expressions into query text)
        if (!String.isBlank(c.nameLike)) {
            String likeTerm = '%' + c.nameLike + '%';
            soql += ' AND Name LIKE :likeTerm';
        }

        // Enforce FLS/CRUD at query-time
        soql += ' WITH SECURITY_ENFORCED';

        // 3) Apply keyset cursor and ORDER BY
        Id lastId;
        if (sortOrder == SkillSort.NAME_ASC) {
            String lastName;
            if (!String.isBlank(p.afterKey)) {
                List<String> parts = p.afterKey.split('\\|');
                lastName = parts[0];
                if (parts.size() > 1) lastId = Id.valueOf(parts[1]);
                soql += ' AND (Name > :lastName OR (Name = :lastName AND Id > :lastId))';
            }
            soql += ' ORDER BY Name ASC, Id ASC';
        } else {
            Datetime lastMod;
            if (!String.isBlank(p.afterKey)) {
                List<String> parts = p.afterKey.split('\\|');
                lastMod = Datetime.valueOf(parts[0]);
                if (parts.size() > 1) lastId = Id.valueOf(parts[1]);
                soql += ' AND (LastModifiedDate < :lastMod OR (LastModifiedDate = :lastMod AND Id > :lastId))';
            }
            soql += ' ORDER BY LastModifiedDate DESC, Id ASC';
        }

        // 4) LIMIT and execute
        soql += ' LIMIT :p.size';
        List<Skill__c> rows = Database.query(soql);

        // 5) Map to DTOs and compute nextKey (only if a full page was returned)
        PageCore pageOut = new PageCore();
        pageOut.items = new List<DTO_Skill.RowCore>();
        for (Skill__c s : rows) {
            pageOut.items.add(new DTO_Skill.RowCore(s.Id, s.Name));
        }
        if (rows.size() == p.size) {
            Skill__c tail = rows[rows.size() - 1];
            pageOut.nextKey = (sortOrder == SkillSort.NAME_ASC)
                ? (tail.Name + '|' + (String)tail.Id)
                : (String.valueOf(tail.LastModifiedDate) + '|' + (String)tail.Id);
        }
        return pageOut;
    }
}