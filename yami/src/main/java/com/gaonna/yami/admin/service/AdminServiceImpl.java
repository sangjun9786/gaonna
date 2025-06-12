package com.gaonna.yami.admin.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gaonna.yami.admin.dao.AdminDao;
import com.gaonna.yami.composite.vo.BoardCo;
import com.gaonna.yami.composite.vo.ReplyCo;
import com.gaonna.yami.composite.vo.SearchForm;
import com.gaonna.yami.location.vo.BakeryComment;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;

@Service
public class AdminServiceImpl implements AdminService{
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private AdminDao dao;
	@Autowired
	private BCryptPasswordEncoder bcrypt;
	
	@Override
	public Member consoleLogin(String userId) {
		return dao.consoleLogin(sqlSession,userId);
	}
	
	@Override
	public String selectRoleType(Member loginUser) {
		return dao.selectRoleType(sqlSession,loginUser);
	}
	
	//ajax 관리자 조회
	@Override
	public List<Member> searchAdmin(String select) {
		List<Member> result = dao.searchAdmin(sqlSession, select);
		new Member().memberSDF(result);
		return result;
	}
	
	//관리자 데이터 수정
	@Override
	@Transactional
	public int updateAdmin(Member m) {
		//비밀번호 암호화
		m.setUserPwd(bcrypt.encode(m.getUserPwd()));
		
		int result = 1;
		//관리자 정보 수정
		result *= dao.updateAdmin(sqlSession,m);
		
		//관리자 권한 수정
		if(m.getRoleType().equals("non")) {
			//non이면 관리자 권한 삭제
			result *= dao.deleteAdminRole(sqlSession,m);
		}else {
			result *= dao.updateAdminRole(sqlSession,m);
		}
		
		return result;
	}
	
	//관리자 추가
	@Override
	public int insertAdmin(Member m) {
		int result=1;
		
		//비밀번호 암호화
		m.setUserPwd(bcrypt.encode(m.getUserPwd()));
		
		//member테이블에 추가
		result *=dao.insertAdmin(sqlSession, m);
		
		//role테이블에 추가
		result *=dao.insertAdminRole(sqlSession,m);
		
		return result;
	}
	
	@Override
	public List<Member> searchMember(String searchType, String searchKeyword, int searchCount, int page) {
		
		/*
			시작 번호 : searchCount*(page-1) +1
			끝 번호 : searchCount*page
		 */	
		String startRow = String.valueOf(searchCount*(page-1) +1);
		String endRow = String.valueOf(searchCount*page);
		
		Map<String, String> mapping = new HashMap<>();
		mapping.put("searchType", searchType);
		mapping.put("searchKeyword", searchKeyword);
		mapping.put("startRow", startRow);
		mapping.put("endRow", endRow);
				
		List<Member> result = new ArrayList<>();
		
		if(searchType.equals("all")) {
			result = dao.searchMemberAll(sqlSession,mapping);
		}else {
			result = dao.searchMember(sqlSession,mapping);
		}
		new Member().memberSDF(result);
		
		return result;
	}
	
	@Override
	public String countMember(String searchType, String searchKeyword) {
		
		Map<String, String> mapping = new HashMap<>();
		mapping.put("searchType", searchType);
		mapping.put("searchKeyword", searchKeyword);
		
		return dao.countMember(sqlSession,mapping);
	}
	
	@Override
	public int updateUser(Member m) {
		return dao.updateUser(sqlSession,m);
	}
	
	@Override
	public List<Coord> userDongne(int userNo) {
		return dao.userDongne(sqlSession, userNo);
	}
	@Override
	public List<Location> userLocation(int userNo) {
		return dao.userLocation(sqlSession, userNo);
	}

	//ajax - 게시글 조회
	@Override
	public Map<String, Object> searchBoard(SearchForm searchForm) {
		//resultCount(게시글 수) 구하기
		searchForm.setResultCount(dao.countBoard(sqlSession,searchForm));
		
		//searchForm 정상화
		searchForm.normalize();
		
		//게시글 구하기
		List<BoardCo> result = dao.searchBoard(sqlSession,searchForm);
		
		//sdf
		new BoardCo().boardSDF(result);
		
		return Map.of("result", result, "totalCount", searchForm.getResultCount());
	}
	
	//ajax - 판매게시판 댓글 조회
	@Override
	public Map<String, Object> searchReply(SearchForm searchForm) {
		//resultCount(댓글 수) 구하기
		searchForm.setResultCount(dao.countReply(sqlSession, searchForm));
		
		//searchForm 정상화
		searchForm.normalize();
		
		//댓글 구하기
		List<ReplyCo> result = dao.searchReply(sqlSession,searchForm);
		
		//바로 날짜형식 정상화
		new ReplyCo().replySDF(result);
		
		return Map.of("result", result, "totalCount", searchForm.getResultCount());
	}
	
	//ajax - 우리동네빵집 댓글 조회
	@Override
	public Map<String, Object> searchReplyDongne(SearchForm searchForm) {
		//resultCount(댓글 수) 구하기
		searchForm.setResultCount(dao.countReplyDongne(sqlSession, searchForm));
		
		//searchForm 정상화
		searchForm.normalize();
		
		//댓글 구하기
		List<BakeryComment> result = dao.searchReplyDongne(sqlSession,searchForm);
		
		//바로 날짜형식 정상화
		new BakeryComment().bakeryCommentSDF(result);
		
		return Map.of("result", result, "totalCount", searchForm.getResultCount());
	}
	
}
