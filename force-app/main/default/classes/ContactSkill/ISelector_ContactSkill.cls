/**
 * @description Interface for ContactSkill selectors (DTO-based). Enables DI and decorators.
 * @since 1.0.0
 * @group Selectors
 */
public interface ISelector_ContactSkill {
    /** @description By Ids. */
    Map<Id, DTO_ContactSkill.RowCore> byIds(Set<Id> ids);

    /** @description For provided Contacts → Map<ContactId, List<RowCore>>. */
    Map<Id, List<DTO_ContactSkill.RowCore>> forContacts(Set<Id> contactIds);

    /** @description For provided Skills → Map<SkillId, List<RowCore>>. */
    Map<Id, List<DTO_ContactSkill.RowCore>> forSkills(Set<Id> skillIds);

    /** @description Recent audit rows. */
    List<DTO_ContactSkill.RowAudit> recentlyModifiedSince(Datetime since, Integer limitSize);

    /** @description For Contacts with nested Skill (Id/Name). */
    Map<Id, List<DTO_ContactSkill.RowDetail>> forContactsDetailed(Set<Id> contactIds);
}