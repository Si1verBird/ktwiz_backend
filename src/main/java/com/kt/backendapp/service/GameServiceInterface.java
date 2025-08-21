package com.kt.backendapp.service;

import com.kt.backendapp.dto.GameRequest;
import com.kt.backendapp.dto.GameResponse;
import com.kt.backendapp.enums.GameStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * 경기 서비스 인터페이스
 */
public interface GameServiceInterface {

    /**
     * 모든 경기 조회
     */
    List<GameResponse> getAllGames();

    /**
     * 특정 경기 조회
     */
    GameResponse getGameById(UUID gameId);

    /**
     * 상태별 경기 조회
     */
    List<GameResponse> getGamesByStatus(GameStatus status);

    /**
     * 기간별 경기 조회
     */
    List<GameResponse> getGamesByDateRange(LocalDateTime start, LocalDateTime end);

    /**
     * 경기 생성
     */
    GameResponse createGame(GameRequest request);

    /**
     * 경기 수정
     */
    GameResponse updateGame(UUID gameId, GameRequest request);

    /**
     * 경기 삭제
     */
    void deleteGame(UUID gameId);

    /**
     * 가장 가까운 경기 조회 (현재 시간 이후의 첫 번째 경기)
     */
    GameResponse getNextGame();

    /**
     * KT Wiz의 최근 종료된 경기 조회
     */
    GameResponse getKtWizLatestEndedGame();

    /**
     * 팀과 상태로 경기 필터링
     */
    List<GameResponse> getGamesByTeamsAndStatuses(List<UUID> teamIds, List<GameStatus> statuses);
}
