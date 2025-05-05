package com.example.waselne_backend.services;

import com.example.waselne_backend.entities.Reservation;

import java.util.List;

public interface ReservationService {
    Reservation addReservation(Reservation reservation);
    List<Reservation> getAllReservations();
    List<Reservation> getReservationsByScheduleAndDepartureDate(Long scheduleId, String departureDate);
    List<Reservation> getReservationsByMobile(String mobile);
    List<Reservation> getActiveReservationsByScheduleAndDepartureDate(Long scheduleId, String departureDate);

}
