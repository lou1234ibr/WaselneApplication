package com.example.waselne_backend.controller;

import com.example.waselne_backend.dto.PaymentDTO;
import com.example.waselne_backend.entities.Payment;
import com.example.waselne_backend.models.ResponseModel;
import com.example.waselne_backend.repos.PaymentRepository;
import com.example.waselne_backend.services.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private PaymentRepository paymentRepository;

    @PostMapping("/payments")
    public ResponseModel<Payment> makePayment(@RequestBody PaymentDTO paymentDTO) {
        try {
            Payment payment = paymentService.processPayment(paymentDTO);
            return new ResponseModel<>(HttpStatus.OK.value(), "Payment successful", payment);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseModel<>(HttpStatus.BAD_REQUEST.value(), e.getMessage(), null);
        }
    }

  /*  @GetMapping("/payments/all")
    public ResponseEntity<ResponseModel<List<Payment>>> getAllPayments() {
        List<Payment> payments = paymentRepository.findAll();
        return ResponseEntity.ok(new ResponseModel<>(ResponseStatus.SUCCESS, 200, "Fetched", payments));
    }*/

   /* @GetMapping("/customer/{customerId}")
    public ResponseEntity<ResponseModel<List<Payment>>> getPaymentsByCustomerId(@PathVariable Long customerId) {
        List<Payment> payments = paymentService.getPaymentsByCustomerId(customerId);
        return ResponseEntity.ok(new ResponseModel<>(ResponseStatus.SUCCESS, 200, "Fetched by customer", payments));
    }*/
}
