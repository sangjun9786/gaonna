package com.gaonna.yami.member.model.service;

import javax.servlet.http.HttpSession;

import com.gaonna.yami.cookie.vo.CookieToken;
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

	//아이디 업데이트
	int updateId(Member m);

	//비번 업데이트
	int updatePwd(Member m);
	
	//이름 업데이트
	int updateName(Member m);
	
	//전화번호 업데이트
	int updatePhone(Member m);

	//좌표(동네) 업데이트
	int insertDongne(HttpSession session, String isMain) throws Exception;

	//유저 좌표 삭제
	int deleteCoord(HttpSession session, int coordNo);

	//대표 동네 바꾸기
	int updateMainCoord(Member m, int coordNo);

	//유저 아이디로 회원식별번호 알아내기
	int selectUserNo(Member m);

	//유저 번호로 비밀번호 조회
	String selectUserPwd(int userNo);

	//유저 아이디/비밀번호 확인
	int confirmIdPwd(Member m, String userId, String userPwd);

	//회원 탈퇴
	int deleteUser(Member m);
	
}
