package com.example.waselne_backend.services;

import com.example.waselne_backend.entities.Bus;

import java.util.List;

public interface BusService {
    Bus addBus(Bus bus);
    List<Bus> getAllBus();
}
