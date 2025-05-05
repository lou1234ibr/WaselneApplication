package com.example.waselne_backend.services;

import com.example.waselne_backend.entities.AppUsers;
import com.example.waselne_backend.repos.AppUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private AppUserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public AppUsers registerUser(AppUsers user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole("USER"); // Only allow USER role on signup
        return userRepository.save(user);
    }
}
