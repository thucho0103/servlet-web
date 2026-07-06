package com.example.web.util;

import com.fasterxml.jackson.core.type.TypeReference;
import org.junit.jupiter.api.Test;

import java.util.LinkedHashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class JsonTest {

    @Test
    void roundTripsPrimitives() {
        Map<String, Object> in = new LinkedHashMap<>();
        in.put("a", 1);
        in.put("b", 2.5);
        in.put("c", "x");
        in.put("d", true);
        in.put("e", null);
        in.put("f", java.util.List.of(1, 2));

        String json = Json.toJson(in);
        Map<String, Object> out = Json.fromJson(json, new TypeReference<>() { });

        assertEquals(1,      ((Number) out.get("a")).intValue());
        assertEquals(2.5,    ((Number) out.get("b")).doubleValue(), 1e-9);
        assertEquals("x",    out.get("c"));
        assertEquals(Boolean.TRUE, out.get("d"));
        assertEquals(null,   out.get("e"));
        assertNotNull(out.get("f"));
        assertTrue(out.get("f") instanceof java.util.List<?>);
    }

    @Test
    void escapesStrings() {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("msg", "He said \"hi\"\nworld");
        String json = Json.toJson(m);
        assertTrue(json.contains("\\\"hi\\\""), "expected escaped quote in: " + json);
        assertTrue(json.contains("\\n"),          "expected escaped newline in: " + json);
    }
}
