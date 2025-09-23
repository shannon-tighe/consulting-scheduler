({
    // Parses "Name=Test%20Record,Phone=4155551212" -> { Name: "Test Record", Phone: "4155551212" }
    parseDefaultFieldValues : function(encoded) {
        const out = {};
        if (!encoded) return out;
        try {
            const decoded = decodeURIComponent(encoded);
            decoded.split(',').forEach(pair => {
                const i = pair.indexOf('=');
                if (i > 0) {
                    const key = pair.substring(0, i).trim();
                    const val = pair.substring(i + 1);
                    if (key) out[key] = val;
                }
            });
        } catch (e) {
            // swallow; return best-effort
        }
        return out;
    }
})