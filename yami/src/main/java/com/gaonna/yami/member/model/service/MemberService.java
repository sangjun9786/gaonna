package com.gaonna.yami.member.model.service;

import com.gaonna.yami.member.model.vo.Member;

public interface MemberService {

	//회원가입
	int insertMember(Member m);

	//회원가입 성공
	int confirmEmailInsert(int tokenNo);
	
	//아이디 중복확인
	int checkUserId(String id);

	//유저 식별번호로 아이디 검색
	String selectUserId(int userNo);

	//로그인
	Member loginMember(String userId, String domain, String userPwd);

	
}
