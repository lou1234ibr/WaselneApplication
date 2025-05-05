package com.example.waselne_backend.controller;

import com.example.waselne_backend.dto.SignupRequest;
import com.example.waselne_backend.entities.AppUsers;
import com.example.waselne_backend.entities.Customer;
import com.example.waselne_backend.models.AuthResponseModel;
import com.example.waselne_backend.repos.AppUserRepository;
import com.example.waselne_backend.repos.CustomerRepository;
import com.example.waselne_backend.security.JwtTokenProvider;
import com.example.waselne_backend.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Value("${app-jwt-expiration-milliseconds}")
    private Long expiration;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;


    @Autowired
    private AppUserRepository appUserRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

 @PostMapping("/login")
 public ResponseEntity<AuthResponseModel> login(@RequestBody AppUsers user) {
     final Authentication authentication =
             authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(
                     user.getUserName(), user.getPassword()
             ));

     SecurityContextHolder.getContext().setAuthentication(authentication);
     String token = jwtTokenProvider.generateToken(authentication);

     // Extract role from authenticated user
     String role = authentication.getAuthorities().iterator().next().getAuthority(); // e.g., "ROLE_ADMIN"

     AuthResponseModel authResponseModel = new AuthResponseModel(
             HttpStatus.OK.value(),
             "Successfully logged in",
             token,
             System.currentTimeMillis(),
             expiration,
             role
     );

     return ResponseEntity.ok(authResponseModel);
 }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@RequestBody SignupRequest request) {
        if (appUserRepository.findByUserName(request.getUserName()).isPresent()) {
            return ResponseEntity.badRequest().body("Username already taken");
        }

        Customer customer = new Customer();
        customer.setCustomerName(request.getCustomerName());
        customer.setMobile(request.getMobile());
        customer.setEmail(request.getEmail());

        Customer savedCustomer = customerRepository.save(customer);

        AppUsers user = new AppUsers();
        user.setUserName(request.getUserName());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole("USER");
        user.setCustomer(savedCustomer);

        appUserRepository.save(user);

        return ResponseEntity.ok("User registered successfully");
    }
}
