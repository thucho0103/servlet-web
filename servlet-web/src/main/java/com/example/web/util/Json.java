package com.example.web.util;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Thin Jackson facade. Centralises the shared {@link ObjectMapper} so that
 * servlets and JSP backing code use identical serialisation settings.
 */
public final class Json {

    private static final ObjectMapper MAPPER = newMapper();

    private static ObjectMapper newMapper() {
        ObjectMapper m = new ObjectMapper();
        m.registerModule(new JavaTimeModule());
        m.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        m.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
        return m;
    }

    private Json() { }

    public static ObjectMapper mapper() { return MAPPER; }

    /** Serialise any value to a JSON string. */
    public static String toJson(Object value) {
        try {
            return MAPPER.writeValueAsString(value);
        } catch (IOException e) {
            throw new IllegalStateException("Failed to serialise JSON", e);
        }
    }

    /** Deserialise a JSON string into the given type. */
    public static <T> T fromJson(String body, Class<T> type) {
        try {
            return MAPPER.readValue(body, type);
        } catch (IOException e) {
            throw new IllegalArgumentException("Failed to parse JSON", e);
        }
    }

    /** Deserialise a JSON string into a generic type (lists, maps). */
    public static <T> T fromJson(String body, TypeReference<T> ref) {
        try {
            return MAPPER.readValue(body, ref);
        } catch (IOException e) {
            throw new IllegalArgumentException("Failed to parse JSON", e);
        }
    }

    /**
     * Reads either an {@code application/json} body or an
     * {@code application/x-www-form-urlencoded} body and returns the
     * parameters as a flat string map (first value wins on duplicates).
     */
    public static Map<String, String> readFormOrJson(HttpServletRequest req) throws IOException {
        String ctype = req.getContentType();
        if (ctype != null && ctype.toLowerCase().contains("application/json")) {
            String body = req.getReader().lines()
                    .reduce("", (a, b) -> a + b);
            if (body.isBlank()) return Collections.emptyMap();

            TypeReference<Map<String, Object>> ref = new TypeReference<>() { };
            Map<String, Object> parsed = fromJson(body, ref);
            Map<String, String> out = new LinkedHashMap<>();
            parsed.forEach((k, v) -> out.put(k, v == null ? null : String.valueOf(v)));
            return out;
        }

        Map<String, String[]> raw = req.getParameterMap();
        Map<String, String> out = new LinkedHashMap<>();
        raw.forEach((k, vs) -> out.put(k, vs == null || vs.length == 0 ? null : vs[0]));
        return out;
    }

    /** Snapshot of all request headers, name → value. */
    public static Map<String, String> headersOf(HttpServletRequest req) {
        Map<String, String> out = new LinkedHashMap<>();
        List<String> names = Collections.list(req.getHeaderNames());
        for (String n : names) out.put(n, req.getHeader(n));
        return out;
    }
}
