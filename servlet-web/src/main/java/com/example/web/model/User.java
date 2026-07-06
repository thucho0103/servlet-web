package com.example.web.model;

import java.time.Instant;

/**
 * Mutable POJO representing a user. Getters/setters follow JavaBean
 * conventions so JSP EL and JSON serialisation work cleanly.
 */
public class User {

    private String id;
    private String username;
    private String email;
    private String displayName;
    private Instant createdAt = Instant.now();

    public User() { }

    public User(String id, String username, String email, String displayName) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.displayName = displayName;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "User{id='" + id + "', username='" + username + "', email='" + email + "'}";
    }
}
