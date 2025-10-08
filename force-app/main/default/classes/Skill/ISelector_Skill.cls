/**
 * @description Interface for Skill selectors (DTO-based). Enables DI and decorators (e.g., caching).
 * @since 1.0.0
 * @group Selectors
 */
public interface ISelector_Skill {
    /** @description Bulk lookup by Ids → Map of Id to RowCore. */
    Map<Id, DTO_Skill.RowCore> byIds(Set<Id> ids);

    /** @description Typeahead search by Name with safe limit. */
    List<DTO_Skill.RowCore> namesLike(String term, Integer limitSize);

    /** @description Top N skills ordered by Name (ascending). */
    List<DTO_Skill.RowCore> topNByName(Integer limitSize);

    /** @description Recently modified skills (audit projection). */
    List<DTO_Skill.RowAudit> recentlyModifiedSince(Datetime since, Integer limitSize);
}