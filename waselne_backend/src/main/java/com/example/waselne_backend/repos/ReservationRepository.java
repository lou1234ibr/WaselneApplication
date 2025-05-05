package com.example.waselne_backend.repos;

import com.example.waselne_backend.entities.BusSchedule;
import com.example.waselne_backend.entities.Customer;
import com.example.waselne_backend.entities.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    Optional<List<Reservation>> findByCustomer(Customer customer);
    Optional<List<Reservation>> findByBusScheduleAndDepartureDate(BusSchedule busSchedule, String departureDate);


    List<Reservation> findByBusSchedule_ScheduleIdAndDepartureDateAndReservationStatusNot(
            Long scheduleId, String departureDate, String reservationStatus);
}
