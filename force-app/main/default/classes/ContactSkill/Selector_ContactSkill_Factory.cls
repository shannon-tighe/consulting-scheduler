/**
 * @description Factory for ISelector_ContactSkill implementations.
 *              Central place to choose policy (user/system mode, caching, etc.).
 * @since 1.0.0
 * @group Selectors
 */
public inherited sharing class Selector_ContactSkill_Factory {
    /**
     * @description Returns the default selector with per-transaction caching.
     * @param ctx Transaction context (cache, flags).
     * @return ISelector_ContactSkill implementation.
     */
    public static ISelector_ContactSkill get(TxnContext ctx) {
        ISelector_ContactSkill base = new Selector_ContactSkill_Usr();
        // Future: if (Feature__mdt.Use_System_Mode__c) base = new Selector_ContactSkill_Sys();
        return new Selector_ContactSkill_Cached(ctx, base);
    }
}