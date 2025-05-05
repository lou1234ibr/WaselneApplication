package com.example.waselne_backend.controller;

import com.example.waselne_backend.entities.Reservation;
import com.example.waselne_backend.models.ResponseModel;
import com.example.waselne_backend.repos.ReservationRepository;
import com.example.waselne_backend.services.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/reservation")
public class ReservationController {

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private ReservationService reservationService;

    @PostMapping("/add")
    public ResponseModel<Reservation> createReservation(@RequestBody Reservation reservation) {
        reservation.setReservationStatus("PENDING");

        Reservation savedReservation = reservationService.addReservation(reservation);

        return new ResponseModel<>(HttpStatus.OK.value(), "Reservation created in pending status", savedReservation);
    }


    @GetMapping("/all")
    public ResponseEntity<List<Reservation>> getAllReservations() {
        return ResponseEntity.ok(reservationService.getAllReservations());
    }

    @GetMapping("/query")
    public ResponseEntity<List<Reservation>> getReservationsByScheduleAndDepartureDate(
            @RequestParam Long scheduleId,
            @RequestParam String departureDate
    ) {
        return ResponseEntity.ok(reservationService.getReservationsByScheduleAndDepartureDate(scheduleId, departureDate));
    }

    @GetMapping("/all/{mobile}")
    public ResponseEntity<List<Reservation>> getReservationsByMobile(
            @PathVariable(name = "mobile") String mobile
    ) {
        return ResponseEntity.ok(reservationService.getReservationsByMobile(mobile));
    }


    @PutMapping("/{id}/cancel")
    public ResponseEntity<?> cancelReservation(@PathVariable Long id) {
        Optional<Reservation> reservationOpt = reservationRepository.findById(id);
        if (reservationOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Reservation reservation = reservationOpt.get();


        if ("cancelled".equalsIgnoreCase(reservation.getReservationStatus())) {
            return ResponseEntity.badRequest().body("Reservation already cancelled.");
        }


        try {
            String departureDate = reservation.getDepartureDate(); // e.g. 04/05/2025
            String departureTime = reservation.getBusSchedule().getDepartureTime(); // e.g. 14:00
            String dateTimeStr = departureDate + "T" + departureTime;

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy'T'HH:mm");
            LocalDateTime departureDateTime = LocalDateTime.parse(dateTimeStr, formatter);
            LocalDateTime now = LocalDateTime.now();

            // Check if less than 2 hours before departure
            if (departureDateTime.isBefore(now.plusHours(2))) {
                return ResponseEntity.badRequest().body("Cannot cancel reservation less than 2 hours before departure.");
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Invalid departure date/time format.");
        }

        // Set status to cancelled and save
        reservation.setReservationStatus("cancelled");
        reservationRepository.save(reservation);

        return ResponseEntity.ok().body("Reservation cancelled successfully.");
    }
}
