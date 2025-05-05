package com.example.waselne_backend.services;



import com.example.waselne_backend.entities.Customer;
import com.example.waselne_backend.repos.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class CustomerService {

    @Autowired
    private CustomerRepository customerRepository;

    // Find a customer by their ID
    public Customer findById(int customerId) {
        Optional<Customer> customer = customerRepository.findById((long) customerId);
        if (customer.isPresent()) {
            return customer.get();
        } else {
            throw new RuntimeException("Customer not found with ID: " + customerId);
        }
    }

    // Save a customer
    public Customer save(Customer customer) {
        return customerRepository.save(customer);
    }
}

