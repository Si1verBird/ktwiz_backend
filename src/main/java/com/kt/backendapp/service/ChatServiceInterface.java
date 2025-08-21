package com.kt.backendapp.service;

import com.kt.backendapp.dto.ChatResponse;

import java.util.List;
import java.util.UUID;

/**
 * 채팅 서비스 인터페이스
 */
public interface ChatServiceInterface {

    /**
     * 새로운 세션 ID 생성 (24시간 단위)
     */
    UUID generateSessionId();

    /**
     * 사용자 메시지 저장
     */
    ChatResponse saveUserMessage(UUID sessionId, UUID userId, String message);

    /**
     * 봇 응답 저장
     */
    ChatResponse saveBotMessage(UUID sessionId, String message);

    /**
     * 관리자 응답 저장
     */
    ChatResponse saveAdminMessage(UUID sessionId, UUID adminId, String message);

    /**
     * 세션별 채팅 내역 조회 (DTO 반환)
     */
    List<ChatResponse> getChatHistory(UUID sessionId);

    /**
     * 24시간 지난 채팅 정리 (스케줄러에서 호출)
     */
    void cleanupOldChats();

    /**
     * 간단한 봇 응답 생성 (관리자가 응답하기 전까지 기본 응답)
     */
    String generateBotResponse(String userMessage);
}
