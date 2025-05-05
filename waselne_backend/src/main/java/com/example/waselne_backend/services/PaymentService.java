package com.example.waselne_backend.services;

import com.example.waselne_backend.dto.PaymentDTO;
import com.example.waselne_backend.entities.Customer;
import com.example.waselne_backend.entities.Payment;
import com.example.waselne_backend.entities.Reservation;
import com.example.waselne_backend.repos.CustomerRepository;
import com.example.waselne_backend.repos.PaymentRepository;
import com.example.waselne_backend.repos.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private CustomerRepository customerRepository;

    public Payment processPayment(PaymentDTO dto) throws Exception {
        System.out.println(" Starting payment processing...");
        System.out.println("Customer ID: " + dto.getCustomerId());
        System.out.println(" Reservation ID: " + dto.getReservationId());
        System.out.println(" Amount: " + dto.getAmount());
        System.out.println(" Method: " + dto.getPaymentMethod());



        Optional<Customer> customerOpt = customerRepository.findById(dto.getCustomerId());
        Optional<Reservation> reservationOpt = reservationRepository.findById(dto.getReservationId());

        if (customerOpt.isEmpty()) throw new Exception("Customer not found");
        if (reservationOpt.isEmpty()) throw new Exception("Reservation not found");

        Customer customer = customerOpt.get();
        Reservation reservation = reservationOpt.get();

        // Check if already paid
        if ("PAID".equalsIgnoreCase(reservation.getReservationStatus())) {
            throw new Exception("Reservation already paid");
        }

        // Check wallet balance
        if (customer.getWalletBalance() < dto.getAmount()) {
            throw new Exception("Insufficient balance in wallet");
        }

        // Deduct from wallet
        customer.setWalletBalance(customer.getWalletBalance() - dto.getAmount());
        customerRepository.save(customer);
        System.out.println(" Wallet updated: " + customer.getWalletBalance());
        // Create and save payment
        Payment payment = new Payment();
        payment.setAmount(dto.getAmount());
        payment.setTimestamp(new Date());
        payment.setCustomer(customer);
        payment.setReservation(reservation);
        payment.setPaymentMethod(dto.getPaymentMethod());
        payment.setStatus("PAID");


        paymentRepository.save(payment);
        System.out.println(" Payment saved");

        // Update reservation status
        reservation.setReservationStatus("PAID");
        reservationRepository.save(reservation);
        System.out.println("Reservation status updated to PAID");

        return payment;
    }




        public List<Payment> getAllPayments() {
            return paymentRepository.findAll();
        }

        public List<Payment> getPaymentsByCustomerId(Long customerId) {
            return paymentRepository.findAll()
                    .stream()
                    .filter(p -> p.getCustomer().getCustomerId().equals(customerId))
                    .collect(Collectors.toList());
        }


}
