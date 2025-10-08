/**
 * @description Per-transaction cached decorator for ISelector_ContactSkill.
 *              Uses TxnContext.cache (L1); policy chosen by factory.
 * @since 1.0.0
 * @group Selectors
 * @see ISelector_ContactSkill
 * @see TxnContext
 */
public with sharing class Selector_ContactSkill_Cached implements ISelector_ContactSkill {
    private final ISelector_ContactSkill innerClass;
    private final TxnContext ctx;

    public Selector_ContactSkill_Cached(TxnContext ctx, ISelector_ContactSkill innerClass) {
        this.ctx = ctx;
        this.innerClass = innerClass;
    }

    public Map<Id, DTO_ContactSkill.RowCore> byIds(Set<Id> ids) {
        String key = ctx.key(new List<String>{'CS.byIds', idsKey(ids)});
        if (ctx.cache.containsKey(key))
            return (Map<Id, DTO_ContactSkill.RowCore>) ctx.cache.get(key);

        Map<Id, DTO_ContactSkill.RowCore> out = innerClass.byIds(ids);
        ctx.cache.put(key, out);
        return out;
    }

    public Map<Id, List<DTO_ContactSkill.RowCore>> forContacts(Set<Id> contactIds) {
        String key = ctx.key(new List<String>{'CS.forContacts', idsKey(contactIds)});
        if (ctx.cache.containsKey(key))
            return (Map<Id, List<DTO_ContactSkill.RowCore>>) ctx.cache.get(key);

        Map<Id, List<DTO_ContactSkill.RowCore>> out = innerClass.forContacts(contactIds);
        ctx.cache.put(key, out);
        return out;
    }

    public Map<Id, List<DTO_ContactSkill.RowCore>> forSkills(Set<Id> skillIds) {
        String key = ctx.key(new List<String>{'CS.forSkills', idsKey(skillIds)});
        if (ctx.cache.containsKey(key))
            return (Map<Id, List<DTO_ContactSkill.RowCore>>) ctx.cache.get(key);

        Map<Id, List<DTO_ContactSkill.RowCore>> out = innerClass.forSkills(skillIds);
        ctx.cache.put(key, out);
        return out;
    }

    public List<DTO_ContactSkill.RowAudit> recentlyModifiedSince(Datetime since, Integer limitSize) {
        String key = ctx.key(new List<String>{
            'CS.recent', (since == null ? 'epoch' : String.valueOf(since.getTime())), String.valueOf(limitSize)
        });
        if (ctx.cache.containsKey(key))
            return (List<DTO_ContactSkill.RowAudit>) ctx.cache.get(key);

        List<DTO_ContactSkill.RowAudit> out = innerClass.recentlyModifiedSince(since, limitSize);
        ctx.cache.put(key, out);
        return out;
    }

    public Map<Id, List<DTO_ContactSkill.RowDetail>> forContactsDetailed(Set<Id> contactIds) {
        String key = ctx.key(new List<String>{'CS.forContactsDetailed', idsKey(contactIds)});
        if (ctx.cache.containsKey(key))
            return (Map<Id, List<DTO_ContactSkill.RowDetail>>) ctx.cache.get(key);

        Map<Id, List<DTO_ContactSkill.RowDetail>> out = innerClass.forContactsDetailed(contactIds);
        ctx.cache.put(key, out);
        return out;
    }

    private static String idsKey(Set<Id> ids) {
        if (ids == null || ids.isEmpty()) {
            return '';
        }

        List<String> s = new List<String>();
        List<Id> iterableIds = new List<Id>(ids);
        iterableIds.sort();
        for (Id i : iterableIds) {
            s.add((String)i);
        }

        return String.join(s, ',');
    }
}