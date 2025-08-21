package com.kt.backendapp.service;

import com.kt.backendapp.dto.TeamStandingResponse;
import com.kt.backendapp.entity.Team;

import java.util.List;

/**
 * 팀 순위 서비스 인터페이스
 */
public interface TeamStandingServiceInterface {

    /**
     * 모든 팀의 순위표를 조회
     */
    List<TeamStandingResponse> getAllTeamStandings();

    /**
     * 특정 팀의 순위 정보 조회
     */
    TeamStandingResponse getTeamStandingByName(String teamName);

    /**
     * 특정 팀의 통계 업데이트
     */
    void updateTeamStanding(Team team);

    /**
     * 모든 팀의 통계 업데이트
     */
    void updateAllTeamStandings();

    /**
     * 간단한 초기화 (테스트용)
     */
    void initializeTeamStandings();

    /**
     * 순위 재계산
     */
    void updateRankings();
}
