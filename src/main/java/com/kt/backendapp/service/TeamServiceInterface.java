package com.kt.backendapp.service;

import com.kt.backendapp.dto.TeamResponse;

import java.util.List;
import java.util.UUID;

/**
 * 팀 서비스 인터페이스
 */
public interface TeamServiceInterface {

    /**
     * 모든 팀 조회
     */
    List<TeamResponse> getAllTeams();

    /**
     * 특정 팀 조회
     */
    TeamResponse getTeamById(UUID id);
}
