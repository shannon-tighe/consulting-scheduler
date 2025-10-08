/**
 * @description Simple recursion guard to prevent re-entrancy and repeated processing.
 *              Provides depth control and "already processed ID" protection per logical key.
 * @since 1.0.0
 * @group Infrastructure
 *
 * Usage:
 *   RecursionGuard.Token g = RecursionGuard.acquire('ContactSkill:beforeInsert', ids, 1);
 *   if (!g.allowed) return;
 *   try {
 *       // do work
 *   } finally {
 *       g.release();
 *   }
 */
public inherited sharing class RecursionGuard {
    /** @description Default max depth per key if not specified. */
    private static final Integer DEFAULT_MAX_DEPTH = 1;

    /** @description Current depth per key for this transaction. */
    private static Map<String, Integer> depthByKey = new Map<String, Integer>();
    /** @description IDs already processed per key for this transaction. */
    private static Map<String, Set<Id>> processedIdsByKey = new Map<String, Set<Id>>();

    /**
     * @description RAII-like token representing a successful guard acquisition.
     *              Always call release() in a finally block if allowed==true.
     */
    public class Token {
        /** @description Logical key for this guarded section. */
        public final String key;
        /** @description Whether the guarded section is allowed to proceed. */
        public final Boolean allowed;

        private Token(String key, Boolean allowed) {
            this.key = key;
            this.allowed = allowed;
        }

        /** @description Releases one depth for the key; cleans up when depth reaches zero. */
        public void release() {
            RecursionGuard.exit(key);
        }
    }

    /**
     * @description Attempts to enter a guarded section for key with default depth.
     * @param key Logical key identifying the guarded code path (e.g., 'ContactSkill:beforeInsert').
     * @return Token with allowed==true if enter succeeded; otherwise allowed==false.
     */
    public static Token acquire(String key) {
        return acquire(key, null, DEFAULT_MAX_DEPTH);
    }

    public static Token acquire(String key, Integer maxDepth) {
        return acquire(key, null, maxDepth);
    }

    public static Token acquire(String key, Set<Id> ids) {
        return acquire(key, ids, DEFAULT_MAX_DEPTH);
    }

    /**
     * @description Attempts to enter a guarded section for key, with optional ID set and max depth.
     *              If any of the given IDs were already processed under this key, acquisition is denied.
     * @param key Logical key for the guarded section.
     * @param ids Optional set of record Ids to mark as processed; pass null for depth-only guard.
     * @param maxDepth Maximum allowed re-entrancy depth for this key in the current transaction.
     * @return Token with allowed==true if enter succeeded; otherwise allowed==false.
     */
    public static Token acquire(String key, Set<Id> ids, Integer maxDepth) {
        Integer d = depthByKey.containsKey(key) ? depthByKey.get(key) : 0;
        if (d >= ((maxDepth == null) ? DEFAULT_MAX_DEPTH : maxDepth)) {
            return new Token(key, false);
        }
        depthByKey.put(key, d + 1);

        if (ids != null && !ids.isEmpty()) {
            Set<Id> seen = processedIdsByKey.get(key);
            if (seen == null) {
                seen = new Set<Id>();
                processedIdsByKey.put(key, seen);
            }
            // If any overlap, deny and roll back depth
            Set<Id> overlap = new Set<Id>(ids);
            overlap.retainAll(seen);
            if (!overlap.isEmpty()) {
                exit(key);
                return new Token(key, false);
            }
            // Mark these ids as seen for this key
            seen.addAll(ids);
        }
        return new Token(key, true);
    }

    /** @description Decrements depth for key; clears processed IDs when depth reaches zero. */
    private static void exit(String key) {
        Integer d = depthByKey.get(key);
        if (d == null) return;
        if (d <= 1) {
            depthByKey.remove(key);
            processedIdsByKey.remove(key);
        } else {
            depthByKey.put(key, d - 1);
        }
    }
}