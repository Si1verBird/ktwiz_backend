package com.kt.backendapp.service;

import com.kt.backendapp.dto.PostResponse;

import java.util.List;

/**
 * 게시물 서비스 인터페이스
 */
public interface PostServiceInterface {

    /**
     * 최근 관리자 게시물 조회
     */
    List<PostResponse> getRecentAdminPosts(int limit);

    /**
     * 최근 게시물 조회
     */
    List<PostResponse> getRecentPosts(int limit);

    /**
     * 모든 게시물 조회
     */
    List<PostResponse> getAllPosts();
}
