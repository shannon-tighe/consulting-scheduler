/**
 * @description Transaction-scoped context passed into orchestrators/domains/factories.
 *              Holds per-transaction cache, correlation id, and future UoW/feature flags.
 * @since 1.0.0
 * @group Infrastructure
 */
public inherited sharing class TxnContext {
    /** @description Correlation Id for logging/telemetry across layers. */
    public final String correlationId;
    /** @description Per-transaction L1 cache (string-keyed). */
    public final Map<String, Object> cache;

    /**
     * @description Constructs a new transaction context with a fresh correlation id and cache.
     */
    public TxnContext() {
        this.correlationId = generateCorrelationId();
        this.cache = new Map<String, Object>();
    }

    /**
     * @description Builds a stable cache key from parts.
     * @param parts Heterogeneous parts to join.
     * @return Deterministic cache key.
     */
    public String key(List<String> parts) {
        List<String> safe = new List<String>();
        for (String p : parts) safe.add(p == null ? '' : p);
        return String.join(safe, '|');
    }

    private static String generateCorrelationId() {
        return String.valueOf(Crypto.getRandomLong()) + '-' + Datetime.now().getTime();
    }
}