package com.example.web;

import com.example.web.model.User;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

class AppInfoTest {

    @Test
    void userBeanRoundTrips() {
        User u = new User("u1", "alice", "alice@example.com", "Alice");
        u.setDisplayName("Alicia");
        assertEquals("u1",                 u.getId());
        assertEquals("alice",              u.getUsername());
        assertEquals("alice@example.com",  u.getEmail());
        assertEquals("Alicia",             u.getDisplayName());
        assertNotNull(u.getCreatedAt());
    }
}
