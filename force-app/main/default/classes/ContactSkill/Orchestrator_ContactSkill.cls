/**
 * @description Orchestrator for ContactSkill__c trigger operations.
 *              Wires dependencies, guards recursion, and routes to domain methods.
 *              Owns no business rules.
 * @since 1.0.0
 * @group Orchestrators
 * @see Domain_ContactSkill
 */
public inherited sharing class Orchestrator_ContactSkill {

    // ---- Helper(s) ---------------------------------------------------------

    /**
     * @description Builds a fresh Domain_ContactSkill with a new TxnContext and default selector policy.
     * @return Initialized Domain_ContactSkill instance (with cached, user-mode selectors).
     */
    private static Domain_ContactSkill initDomain_ContactSkill() {
        TxnContext ctx = new TxnContext();
        ISelector_Skill selSkill = Selector_Skill_Factory.get(ctx);
        ISelector_ContactSkill selCS = Selector_ContactSkill_Factory.get(ctx);
        return new Domain_ContactSkill(ctx, selSkill, selCS);
    }

    /**
     * @description Test seam to inject fakes or alternative policies (e.g., system-mode).
     */
    @TestVisible
    private static Domain_ContactSkill initDomain_ContactSkill(
        TxnContext ctx,
        ISelector_Skill selSkill,
        ISelector_ContactSkill selCS
    ) {
        return new Domain_ContactSkill(ctx, selSkill, selCS);
    }

    // ---- Trigger entry points ---------------------------------------------

    /** @description Routes BEFORE INSERT with recursion guard. */
    public static void beforeInsert(List<ContactSkill__c> newList) {
        RecursionGuard.Token g = RecursionGuard.acquire('ContactSkill:beforeInsert'); // no Ids yet
        if (!g.allowed) return;

        try {
            initDomain_ContactSkill().beforeInsert(newList);
        } finally {
            g.release();
        }
    }

    /** @description Routes BEFORE UPDATE with recursion guard. */
    public static void beforeUpdate(
        List<ContactSkill__c> newList,
        Map<Id, ContactSkill__c> oldMap,
        Map<Id, ContactSkill__c> newMap
    ) {
        RecursionGuard.Token g = RecursionGuard.acquire('ContactSkill:beforeUpdate', (newMap == null ? null : newMap.keySet()));
        if (!g.allowed) return;

        try {
            initDomain_ContactSkill().beforeUpdate(newList, oldMap, newMap);
        } finally {
            g.release();
        }
    }

    /** @description Routes AFTER INSERT with recursion guard. */
    public static void afterInsert(List<ContactSkill__c> newList, Map<Id, ContactSkill__c> newMap) {
        RecursionGuard.Token g = RecursionGuard.acquire('ContactSkill:afterInsert', (newMap == null ? null : newMap.keySet()));
        if (!g.allowed) return;

        try {
            initDomain_ContactSkill().afterInsert(newList, newMap);
        } finally {
            g.release();
        }
    }

    /** @description Routes AFTER UPDATE with recursion guard. */
    public static void afterUpdate(
        List<ContactSkill__c> newList,
        Map<Id, ContactSkill__c> oldMap,
        Map<Id, ContactSkill__c> newMap
    ) {
        RecursionGuard.Token g = RecursionGuard.acquire('ContactSkill:afterUpdate', (newMap == null ? null : newMap.keySet()));
        if (!g.allowed) return;

        try {
            initDomain_ContactSkill().afterUpdate(newList, oldMap, newMap);
        } finally {
            g.release();
        }
    }

    /** @description Routes BEFORE DELETE with recursion guard. */
    public static void beforeDelete(List<ContactSkill__c> oldList, Map<Id, ContactSkill__c> oldMap) {
        RecursionGuard.Token g = RecursionGuard.acquire('ContactSkill:beforeDelete', (oldMap == null ? null : oldMap.keySet()));
        if (!g.allowed) return;

        try {
            initDomain_ContactSkill().beforeDelete(oldList, oldMap);
        } finally {
            g.release();
        }
    }

    /** @description Routes AFTER DELETE with recursion guard. */
    public static void afterDelete(List<ContactSkill__c> oldList, Map<Id, ContactSkill__c> oldMap) {
        RecursionGuard.Token g = RecursionGuard.acquire('ContactSkill:afterDelete', (oldMap == null ? null : oldMap.keySet()));
        if (!g.allowed) return;

        try {
            initDomain_ContactSkill().afterDelete(oldList, oldMap);
        } finally {
            g.release();
        }
    }

    /** @description Routes AFTER UNDELETE with recursion guard. */
    public static void afterUndelete(List<ContactSkill__c> newList, Map<Id, ContactSkill__c> newMap) {
        RecursionGuard.Token g = RecursionGuard.acquire('ContactSkill:afterUndelete', (newMap == null ? null : newMap.keySet()));
        if (!g.allowed) return;

        try {
            initDomain_ContactSkill().afterUndelete(newList, newMap);
        } finally {
            g.release();
        }
    }
}