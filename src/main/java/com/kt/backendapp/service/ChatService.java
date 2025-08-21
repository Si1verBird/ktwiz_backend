package com.kt.backendapp.service;

import com.kt.backendapp.entity.Chat;
import com.kt.backendapp.entity.User;
import com.kt.backendapp.enums.ChatRole;
import com.kt.backendapp.repository.ChatRepository;
import com.kt.backendapp.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class ChatService {
    
    private final ChatRepository chatRepository;
    private final UserRepository userRepository;
    
    /**
     * 새로운 세션 ID 생성 (24시간 단위)
     */
    public UUID generateSessionId() {
        return UUID.randomUUID();
    }
    
    /**
     * 사용자 메시지 저장
     */
    public Chat saveUserMessage(UUID sessionId, UUID userId, String message) {
        log.info("사용자 메시지 저장: sessionId={}, userId={}", sessionId, userId);
        
        User user = null;
        if (userId != null) {
            user = userRepository.findById(userId).orElse(null);
        }
        
        Chat chat = new Chat();
        chat.setId(UUID.randomUUID());
        chat.setSessionId(sessionId);
        chat.setUser(user);
        chat.setRole(ChatRole.USER);
        chat.setMessage(message);
        chat.setCreatedAt(LocalDateTime.now());
        
        return chatRepository.save(chat);
    }
    
    /**
     * 봇 응답 저장
     */
    public Chat saveBotMessage(UUID sessionId, String message) {
        log.info("봇 응답 저장: sessionId={}", sessionId);
        
        Chat chat = new Chat();
        chat.setId(UUID.randomUUID());
        chat.setSessionId(sessionId);
        chat.setUser(null);  // 봇은 user가 null
        chat.setRole(ChatRole.ASSISTANT);
        chat.setMessage(message);
        chat.setCreatedAt(LocalDateTime.now());
        
        return chatRepository.save(chat);
    }
    
    /**
     * 세션별 채팅 내역 조회
     */
    @Transactional(readOnly = true)
    public List<Chat> getChatHistory(UUID sessionId) {
        log.info("채팅 내역 조회: sessionId={}", sessionId);
        return chatRepository.findBySessionIdOrderByCreatedAtAsc(sessionId);
    }
    
    /**
     * 24시간 지난 채팅 정리 (스케줄러에서 호출)
     */
    public void cleanupOldChats() {
        log.info("오래된 채팅 정리 시작");
        
        LocalDateTime cutoffTime = LocalDateTime.now().minusHours(24);
        List<Chat> oldChats = chatRepository.findByCreatedAtBefore(cutoffTime);
        
        if (!oldChats.isEmpty()) {
            chatRepository.deleteAll(oldChats);
            log.info("{}개의 오래된 채팅 삭제됨", oldChats.size());
        }
    }
    
    /**
     * 간단한 봇 응답 생성 (향후 AI 연동 가능)
     */
    public String generateBotResponse(String userMessage) {
        String message = userMessage.toLowerCase();
        
        if (message.contains("안녕") || message.contains("하이") || message.contains("hello")) {
            return "안녕하세요! 빅또리 비서입니다. 어떻게 도와드릴까요?";
        } else if (message.contains("경기") || message.contains("일정")) {
            return "KT wiz 경기 일정은 스케줄 메뉴에서 확인하실 수 있습니다. 다른 궁금한 점이 있으시면 언제든 말씀해주세요!";
        } else if (message.contains("티켓") || message.contains("예매")) {
            return "티켓 예매는 티켓예매 메뉴에서 진행하실 수 있습니다. 도움이 필요하시면 말씀해주세요!";
        } else if (message.contains("감사") || message.contains("고마워")) {
            return "천만에요! 더 궁금한 것이 있으시면 언제든 말씀해주세요.";
        } else {
            return "네, 무엇을 도와드릴까요? KT wiz 관련 정보, 티켓 예매, 경기 일정 등 궁금한 것이 있으시면 언제든 말씀해주세요!";
        }
    }
}
