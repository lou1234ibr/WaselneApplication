package com.example.waselne_backend.models;


public class ResponseModel<T> {
    private int statusCode;
    private String message;
    private T response;

    // No-args constructor
    public ResponseModel() {
    }

    // All-args constructor
    public ResponseModel(int statusCode, String message, T response) {
        this.statusCode = statusCode;
        this.message = message;
        this.response = response;
    }

    // Getters and setters
    public int getStatusCode() {
        return statusCode;
    }

    public String getMessage() {
        return message;
    }

    public T getResponse() {
        return response;
    }


    public void setStatusCode(int statusCode) {
        this.statusCode = statusCode;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setResponse(T response) {
        this.response = response;
    }
}
