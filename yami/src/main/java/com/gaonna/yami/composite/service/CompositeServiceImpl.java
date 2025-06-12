package com.gaonna.yami.composite.service;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.composite.dao.CompositeDao;
import com.gaonna.yami.composite.vo.BoardCo;
import com.gaonna.yami.composite.vo.Category;
import com.gaonna.yami.composite.vo.ReplyCo;
import com.gaonna.yami.composite.vo.SearchForm;
import com.gaonna.yami.location.vo.BakeryComment;

@Service
public class CompositeServiceImpl implements CompositeService{
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private CompositeDao dao;

	//ajax - 카테고리 조회
	@Override
	public List<Category> selectCategory() {
		return dao.selectCategory(sqlSession);
	}
	
	//ajax - 게시글 조회
	@Override
	public Map<String, Object> searchMyBoard(SearchForm searchForm) {
		//resultCount(게시글 수) 구하기
		searchForm.setResultCount(dao.countMyBoard(sqlSession, searchForm));
		
		//searchForm 정상화
		searchForm.normalize();
		
		//게시글 구하기
		List<BoardCo> result = dao.searchMyBoard(sqlSession,searchForm);
		
		//sdf
		new BoardCo().boardSDF(result);
		
		return Map.of("result", result, "totalCount", searchForm.getResultCount());
	}
	
	//ajax - 판매게시판 댓글 조회
	@Override
	public Map<String, Object> searchMyReply(SearchForm searchForm) {
		//resultCount(댓글 수) 구하기
		searchForm.setResultCount(dao.countMyReply(sqlSession, searchForm));
		
		//searchForm 정상화
		searchForm.normalize();
		
		//댓글 구하기
		List<ReplyCo> result = dao.searchMyReply(sqlSession,searchForm);
		
		//바로 날짜형식 정상화
		new ReplyCo().replySDF(result);
		
		return Map.of("result", result, "totalCount", searchForm.getResultCount());
	}
	
	//ajax - 우리동네빵집 댓글 조회
	@Override
	public Map<String, Object> searchMyReplyDongne(SearchForm searchForm) {
		//resultCount(댓글 수) 구하기
		searchForm.setResultCount(dao.countMyReplyDongne(sqlSession, searchForm));
		
		//searchForm 정상화
		searchForm.normalize();
		
		//댓글 구하기
		List<BakeryComment> result = dao.searchMyReplyDongne(sqlSession,searchForm);
		
		//바로 날짜형식 정상화
		new BakeryComment().bakeryCommentSDF(result);
		
		return Map.of("result", result, "totalCount", searchForm.getResultCount());
	}
	
	//ajax - 찜 조회
	@Override
	public Map<String, Object> searchMyWishlist(SearchForm searchForm) {
		//resultCount(댓글 수) 구하기
		searchForm.setResultCount(dao.countMyWishlist(sqlSession, searchForm));
		
		//searchForm 정상화
		searchForm.normalize();
		
		//찜 게시글 구하기
		List<BoardCo> result = dao.searchMyWishlist(sqlSession,searchForm);
		
		//sdf
		new BoardCo().boardSDF(result);
		
		return Map.of("result", result, "totalCount", searchForm.getResultCount());
	}
	
}
