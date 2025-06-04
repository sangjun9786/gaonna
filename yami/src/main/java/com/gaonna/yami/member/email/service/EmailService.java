package com.gaonna.yami.member.email.service;

import com.gaonna.yami.member.email.vo.Email;
import com.gaonna.yami.member.email.vo.MemberToken;
import com.gaonna.yami.member.model.vo.Member;

public interface EmailService {

	//단순 이메일 보내기
	void sendEmail(Email email);
	
	//토큰 삭제
	int deleteToken(Member m);

	//회원가입 - 생성된 토큰 저장
	int insertToken(MemberToken memberToken);

	//회원가입 - 이메일 송출
	int insertMemberSendEmail(String userId, MemberToken memberToken);

	//회원가입
	int insertMemberEmail(Member m, String token);

	//회원가입 - 이메일 링크로 확인
	int confirmEmailInsert(MemberToken mt);

	//토큰 만료, 해당 토큰 주인 찾기
	Member resendEmail(MemberToken mt);

	//마이페이지 아이디 변경
	int updateEmailToken(Member m, String token);

	//비밀번호 찾기
	int findPwdToken(Member m, String token);


}
