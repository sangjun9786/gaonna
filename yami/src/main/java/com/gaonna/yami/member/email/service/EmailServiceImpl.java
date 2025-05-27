package com.gaonna.yami.member.email.service;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Properties;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.gaonna.yami.member.email.dao.EmailDao;
import com.gaonna.yami.member.email.vo.Email;
import com.gaonna.yami.member.email.vo.MemberToken;
import com.gaonna.yami.member.model.vo.Member;

/*
 * bean에서 의존성 추가하고 싶으면
 * @Service, @Autowired 제거 
 */
@Service
public class EmailServiceImpl implements EmailService{
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private EmailDao dao;
	
	//이메일 양식 저장소 연결
	private Properties prop = new Properties();
	private String insertMeContent;
	public EmailServiceImpl() {
		try {
			//제목 저장소 연결
			ClassPathResource resource = new ClassPathResource("emailTemplates/subject.xml");
			InputStream inputStream = resource.getInputStream();
			prop.loadFromXML(inputStream);
			inputStream.close();
			
			//본문 저장소 연결
			
			//회원가입
			ClassPathResource insertMe = new ClassPathResource("emailTemplates/insertMeContent.html");
			insertMeContent = new String(Files.readAllBytes(insertMe.getFile().toPath()), StandardCharsets.UTF_8);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Autowired
    private JavaMailSender mailSender;
	
    //단순 이메일 보내기
    @Override
    public void sendEmail(Email email){
    	try {
	    	MimeMessage mimeMessage = mailSender.createMimeMessage();
	    	MimeMessageHelper message = new MimeMessageHelper(mimeMessage, true, "UTF-8");
	    	
	        message.setTo(email.getToAddress());
	        message.setSubject(email.getSubject());
			message.setText(email.getContent(), true);
			mailSender.send(mimeMessage);
			
		} catch (MessagingException e) {
			e.printStackTrace();
		}
    }
    
    //토큰 삭제
    @Override
    public int deleteToken(Member m) {
    	return dao.deleteToken(sqlSession, m);
    }

    //회원가입
    @Override
    public int insertMemberEmail(Member m, String token) {
    	MemberToken mt = new MemberToken(m.getUserNo(),token);
    	String userId = m.getUserId();
    	
    	//토큰 데이터 저장
    	int result = insertMemberToken(mt);
    	
    	//데이터 저장 성공 및 추출 성공하면 메일 송신
    	if(result>0 && mt.getTokenNo()>0) {
    		return insertMemberSendEmail(userId,mt);
    	}else {
    		return 0;
    	}
    }

	@Override
	public int insertMemberToken(MemberToken memberToken) {
		return dao.insertMemberToken(sqlSession,memberToken);
	}
	

	//회원가입 이메일 송신
	@Override
	public int insertMemberSendEmail(String userId, MemberToken mt){
		try {
	    	MimeMessage mimeMessage = mailSender.createMimeMessage();
	    	MimeMessageHelper message = new MimeMessageHelper(mimeMessage, true, "UTF-8");
	    	
	        message.setTo(userId);
	        message.setSubject(prop.getProperty("insertMeSubject"));

	        String content = insertMeContent
	        	    .replace("{{TOKEN_NO}}", String.valueOf(mt.getTokenNo()))
	        	    .replace("{{TOKEN}}", mt.getToken());
	        
			message.setText(content, true);
			mailSender.send(mimeMessage);
			
			return 1; //정상 작동
		}catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	@Override
	public int confirmEmailInsert(MemberToken mt) {
		return dao.confirmEmailInsert(sqlSession,mt);
	}
	
	@Override
	public Member resendEmail(MemberToken mt) {
		return dao.resendEmail(sqlSession,mt);
	}
}
