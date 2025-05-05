package com.example.waselne_backend.models;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ErrorDetails {
    private int errorCode;
    private String errorMessage;
    private String devErrorMessage;


    public void setTimestamp(long l) {
    }

    public void setErrorMessage(String localizedMessage) {
    }

    public void setDevErrorMessage(String description) {
    }

    public void setErrorCode(int value) {
    }
}
