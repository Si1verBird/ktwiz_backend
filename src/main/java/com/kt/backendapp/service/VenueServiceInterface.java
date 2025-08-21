package com.kt.backendapp.service;

import com.kt.backendapp.dto.VenueResponse;

import java.util.List;
import java.util.UUID;

/**
 * 경기장 서비스 인터페이스
 */
public interface VenueServiceInterface {

    /**
     * 모든 경기장 조회
     */
    List<VenueResponse> getAllVenues();

    /**
     * 특정 경기장 조회
     */
    VenueResponse getVenueById(UUID id);
}
