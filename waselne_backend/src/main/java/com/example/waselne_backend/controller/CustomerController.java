package com.example.waselne_backend.controller;

import com.example.waselne_backend.repos.AppUserRepository;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/customer")
public class CustomerController {

    @Autowired
    private AppUserRepository appUsersRepository;

    @GetMapping("/by-username/{userName}")
    public ResponseEntity<?> getCustomerByUserName(@PathVariable String userName) {
        return appUsersRepository.findByUserName(userName)
                .map(appUser -> {
                    if (appUser.getCustomer() != null) {
                        return ResponseEntity.ok(appUser.getCustomer());
                    } else {
                        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                                .body("No customer linked to this user");
                    }
                })
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body("User not found with username: " + userName));
    }
}
