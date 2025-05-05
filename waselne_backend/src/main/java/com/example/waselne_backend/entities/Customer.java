package com.example.waselne_backend.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "customer")
public class Customer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long customerId;

    private String customerName;

    @Column(unique = true)
    private String mobile;

    @Column(unique = true)
    private String email;

    // Embed wallet balance directly
    @Column(nullable = false)
    private Double walletBalance = 0.0;

    // Default constructor
    public Customer() {
        this.walletBalance = 0.0;
    }

    // Constructor with fields
    public Customer(String customerName, String mobile, String email) {
        this.customerName = customerName;
        this.mobile = mobile;
        this.email = email;
        this.walletBalance = 0.0;
    }

    // Getters and Setters
    public Long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Double getWalletBalance() {
        return walletBalance;
    }

    public void setWalletBalance(Double walletBalance) {
        this.walletBalance = walletBalance;
    }
}