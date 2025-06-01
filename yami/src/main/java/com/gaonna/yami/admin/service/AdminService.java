package com.gaonna.yami.admin.service;

import java.util.List;

import com.gaonna.yami.member.model.vo.Member;

public interface AdminService {

	//콘솔 명령 - 관리자 로그인
	Member consoleLogin(String userId);

	//관리자 권한 조회
	String selectRoleType(Member loginUser);

	//ajax 관리자 조회
	List<Member> searchAdmin(String select);
	
}
