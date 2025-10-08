/**
 * @description Per-transaction cached decorator for ISelector_Skill.
 *              Uses TxnContext.cache (L1); policy chosen by factory.
 * @since 1.0.0
 * @group Selectors
 * @see ISelector_Skill
 * @see TxnContext
 */
public with sharing class Selector_Skill_Cached implements ISelector_Skill {
    private final ISelector_Skill innerClass;
    private final TxnContext ctx;

    /**
     * @description Wraps a selector with per-transaction caching.
     * @param ctx Transaction context holding cache.
     * @param innerClass Underlying selector implementation.
     */
    public Selector_Skill_Cached(TxnContext ctx, ISelector_Skill innerClass) {
        this.ctx = ctx;
        this.innerClass = innerClass;
    }

    public Map<Id, DTO_Skill.RowCore> byIds(Set<Id> ids) {
        // Check whether this query has already been performed in this transaction
        String key = ctx.key(new List<String>{'Skill.byIds', idsKey(ids)});
        if (ctx.cache.containsKey(key)) {
            return (Map<Id, DTO_Skill.RowCore>) ctx.cache.get(key);
        }

        Map<Id, DTO_Skill.RowCore> out = innerClass.byIds(ids);
        ctx.cache.put(key, out);
        return out;
    }

    public List<DTO_Skill.RowCore> namesLike(String term, Integer limitSize) {
        String key = ctx.key(new List<String>{'Skill.namesLike', term, String.valueOf(limitSize)});
        if (ctx.cache.containsKey(key))
            return (List<DTO_Skill.RowCore>) ctx.cache.get(key);

        List<DTO_Skill.RowCore> out = innerClass.namesLike(term, limitSize);
        ctx.cache.put(key, out);
        return out;
    }

    public List<DTO_Skill.RowCore> topNByName(Integer limitSize) {
        String key = ctx.key(new List<String>{'Skill.topN', String.valueOf(limitSize)});
        if (ctx.cache.containsKey(key))
            return (List<DTO_Skill.RowCore>) ctx.cache.get(key);

        List<DTO_Skill.RowCore> out = innerClass.topNByName(limitSize);
        ctx.cache.put(key, out);
        return out;
    }

    public List<DTO_Skill.RowAudit> recentlyModifiedSince(Datetime since, Integer limitSize) {
        String key = ctx.key(new List<String>{
            'Skill.recent', (since == null ? 'epoch' : String.valueOf(since.getTime())), String.valueOf(limitSize)
        });
        if (ctx.cache.containsKey(key))
            return (List<DTO_Skill.RowAudit>) ctx.cache.get(key);

        List<DTO_Skill.RowAudit> out = innerClass.recentlyModifiedSince(since, limitSize);
        ctx.cache.put(key, out);
        return out;
    }

    /** @description Deterministic key for a Set<Id>. */
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