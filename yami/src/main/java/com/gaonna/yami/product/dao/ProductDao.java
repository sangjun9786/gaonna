package com.gaonna.yami.product.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.product.vo.Order;
import com.gaonna.yami.product.vo.Product;

@Repository
public class ProductDao {
	
	//리스트 카운트
	public int getListCount(SqlSessionTemplate sqlSession) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("productMapper.getListCount");
	}
	//조회수 증가
	public int increaseCount(SqlSessionTemplate sqlSession, int productNo) {
		// TODO Auto-generated method stub
		return sqlSession.update("productMapper.increaseCount",productNo);
	}
	
	//리스트
	public ArrayList<Product> selectProductList(SqlSessionTemplate sqlSession, PageInfo pi) {
		// TODO Auto-generated method stub
		int limit = pi.getBoardLimit(); //몇개씩 보여줄건지 (조회개수)
		//몇개를 건너뛰고 조회할것인지
		//한페이지에서 5개씩 보여준다고 가정
		//1페이지에선 1-5 보여주고
		//2페이지에선 6-10 보여주고
		int offset = (pi.getCurrentPage()-1)*limit;
		
		
		RowBounds rowBounds = new RowBounds(offset,limit);
		
		//페이징처리를 위해 rowbounds 객체를 전달할때 두번째 매개변수 위치에 전달할 파라미터값이 없더라도
		//형식을 유지해야되기 때문에 null을 전달하고 rowbounds 객체는 3번째 매개변수로 전달해야한다.
		ArrayList<Product> list = (ArrayList)sqlSession.selectList("productMapper.selectProductList",null,rowBounds);
		
		return list;
	}
	
	//상품 번호
	public int selectProductNo(SqlSessionTemplate sqlSession) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("productMapper.selectProductNo");
	}
	
	//상품게시글
	public int insertAtProduct(SqlSessionTemplate sqlSession, Product p) {
		// TODO Auto-generated method stub
		return sqlSession.insert("productMapper.insertAtProduct",p);
	}
	
	//첨부파일 
	public int insertAttachment(SqlSessionTemplate sqlSession, Attachment at) {
		// TODO Auto-generated method stub
		try {
			return sqlSession.insert("productMapper.insertAttachment",at);

		}catch(Exception e){
			return 0;	
		}	
	}
	
	//상세
	public Product selectProductDetail(SqlSessionTemplate sqlSession, int productNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("productMapper.selectProductDetail",productNo);
		
	}
	
	//사진
	public ArrayList<Attachment> selectProductAttachments(SqlSessionTemplate sqlSession, int productNo) {
		// TODO Auto-generated method stub
		return (ArrayList)sqlSession.selectList("productMapper.selectProductAttachments",productNo);
	}
	
	//카테고리
	public ArrayList<Category> selectCategoryList(SqlSessionTemplate sqlSession) {
		// TODO Auto-generated method stub
		return (ArrayList)sqlSession.selectList("productMapper.selectCategoryList");
	}
	
	//거래 희망 장소
	
	public Location selectMainLocationByUserNo(SqlSessionTemplate sqlSession, int userNo) {
	    return sqlSession.selectOne("productMapper.selectMainLocationByUserNo", userNo);
	}


	//삭제
	public int deleteProduct(SqlSessionTemplate sqlSession, int productNo) {
		// TODO Auto-generated method stub
		return sqlSession.delete("productMapper.deleteProduct",productNo);
	}
	
	
	//첨부파일 삭제
	public int deleteAttachmentProduct(SqlSessionTemplate sqlSession, int productNo) {
		// TODO Auto-generated method stub
		return sqlSession.delete("productMapper.deleteAttachmentProduct", productNo);
	}
	
	//수정
	public int updateProduct(SqlSessionTemplate sqlSession, Product p) {
		// TODO Auto-generated method stub
		return sqlSession.update("productMapper.updateProduct", p);
	}
	
	
	//수정
	public int productUpdate(SqlSessionTemplate sqlSession, Product p) {
		// TODO Auto-generated method stub
		return sqlSession.update("productMapper.productUpdate",p);
	}
	
	//주문 등록
	public int insertOrder(SqlSessionTemplate sqlSession, Order o) {
		// TODO Auto-generated method stub
		return sqlSession.insert("productMapper.insertOrder", o);
	}
	
	//포인트 업데이트
	public int updatePoint(SqlSessionTemplate sqlSession, Member m) {
		// TODO Auto-generated method stub
		return sqlSession.update("productMapper.updatePoint", m);
	}
	
	//판매게시판 상태중 T로 바꾸기
	public int updateProductStatus(SqlSessionTemplate sqlSession, Order o) {
		// TODO Auto-generated method stub
		return sqlSession.update("productMapper.updateProductStatus",o);
	}
	
	

}