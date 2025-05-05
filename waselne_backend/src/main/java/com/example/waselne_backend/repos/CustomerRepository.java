package com.example.waselne_backend.repos;

import com.example.waselne_backend.entities.Customer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CustomerRepository extends JpaRepository<Customer, Long> {
    Optional<Customer> findByMobileOrEmail(String mobile, String email);
    Optional<Customer> findByMobile(String mobile);

    Boolean existsByMobileOrEmail(String mobile, String email);
}
