/**
 * @description Factory for ISelector_Skill implementations.
 *              Central place to choose policy (user/system mode, caching, etc.).
 * @since 1.0.0
 * @group Selectors
 */
public inherited sharing class Selector_Skill_Factory {
    /**
     * @description Returns the default selector with per-transaction caching.
     * @param ctx Transaction context (cache, flags).
     * @return ISelector_Skill implementation.
     */
    public static ISelector_Skill get(TxnContext ctx) {
        ISelector_Skill base = new Selector_Skill_Usr();
        // Future: if (Feature__mdt.Use_System_Mode__c) base = new Selector_Skill_Sys();
        return new Selector_Skill_Cached(ctx, base);
    }
}