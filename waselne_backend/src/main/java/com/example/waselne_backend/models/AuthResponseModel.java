package com.example.waselne_backend.models;

public class AuthResponseModel {
    private int statusCode;
    private String message;
    private String accessToken;
    private Long loginTime;
    private Long expirationDuration;
    private String role;
    // No-args constructor
    public AuthResponseModel(int value, String sucessfullyLoggedIn, String token, long l, Long expiration) {
    }




    // All-args constructor
    public AuthResponseModel(int statusCode, String message, String accessToken, Long loginTime, Long expirationDuration, String role) {
        this.statusCode = statusCode;
        this.message = message;
        this.accessToken = accessToken;
        this.loginTime = loginTime;
        this.expirationDuration = expirationDuration;
        this.role=role;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // Getters
    public int getStatusCode() {
        return statusCode;
    }

    public String getMessage() {
        return message;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public Long getLoginTime() {
        return loginTime;
    }

    public Long getExpirationDuration() {
        return expirationDuration;
    }

    // Setters
    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public void setLoginTime(Long loginTime) {
        this.loginTime = loginTime;
    }

    public void setExpirationDuration(Long expirationDuration) {
        this.expirationDuration = expirationDuration;
    }
}
