package com.kt.backendapp.service;

import com.kt.backendapp.dto.LoginResponse;

/**
 * 사용자 서비스 인터페이스
 */
public interface UserServiceInterface {

    /**
     * 사용자 로그인
     */
    LoginResponse login(String email, String password);
}
