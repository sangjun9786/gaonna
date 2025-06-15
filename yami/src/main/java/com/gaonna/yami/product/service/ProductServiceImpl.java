package com.gaonna.yami.product.service;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.dao.ProductDao;
import com.gaonna.yami.product.model.ProductDTO;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.product.vo.Order;
import com.gaonna.yami.product.vo.Product;

@Service
public class ProductServiceImpl implements ProductService {

//    @Autowired
//    private SqlSession sqlSession;
    
    @Autowired
    private SqlSessionTemplate sqlSession;
    
    @Autowired
    private ProductDao dao;
    
    //게시글 리스트 카운트
    @Override
    public int getListCount() {
        return dao.getListCount(sqlSession);
    }

//    @Override
//    public List<ProductDTO> selectProductList(PageInfo pi) {
//        return sqlSession.selectList("productMapper.selectProductList", pi);
//    }
//    
    //조회수 증가
    @Override
	public int increaseCount(int productNo) {
		// TODO Auto-generated method stub
		return dao.increaseCount(sqlSession,productNo);
	}
    
    //상세보기
	@Override
	public Product selectProductDetail(int productNo) {
		// TODO Auto-generated method stub
		return dao.selectProductDetail(sqlSession,productNo);
	}
	
	//상품 게시물 등록
	@Transactional
	@Override
	public int insertProduct(Product p, ArrayList<Attachment> atList) {
			
		int productNo = dao.selectProductNo(sqlSession);
		
		if(productNo> 0) {
			p.setProductNo(productNo);
		}else {
			return productNo;
		}
		
		int result = dao.insertAtProduct(sqlSession,p);
			
		int result2 = 1; //첨부파일 등록 반환값 담을 변수
			
		if(result>0) {
			for(Attachment at : atList) {
				at.setProductBno(productNo); //참조게시글번호 추가
				result2 *= dao.insertAttachment(sqlSession,at);
			}
			return result * result2;
			
		}else{
			return result; 
		}
			
	}
	
	@Override
	public ArrayList<Product> selectProductList(PageInfo pi) {
		// TODO Auto-generated method stub
		return dao.selectProductList(sqlSession,pi);
	}
	
	@Override
	public ArrayList<Attachment> selectProductAttachments(int productNo) {
		// TODO Auto-generated method stub
		return dao.selectProductAttachments(sqlSession,productNo);
	}
    
	//카테고리 목록
	@Override
	public ArrayList<Category> selectCategoryList() {
		// TODO Auto-generated method stub
		return dao.selectCategoryList(sqlSession);
	}
	
	//삭제
	@Override
	public int deleteProduct(int productNo) {
		// TODO Auto-generated method stub
		
		
		return dao.deleteProduct(sqlSession,productNo);
	}
	
	//수정
	@Override
	public int productUpdate(Product p) {
		// TODO Auto-generated method stub
		return dao.productUpdate(sqlSession,p);
	}
	
	//주문 등록 및 포인트 차감
	@Transactional
	@Override
	public int productOrder(Order o, Member m) {
		// TODO Auto-generated method stub
		// 1. 주문 등록 (Order insert)
	    int result = dao.insertOrder(sqlSession, o);
	    
	    // 2. 포인트 차감 (Member update)
	    int result2 = 1;
	    if (result > 0 && o.getUsedPoint() > 0) {
	        // 차감할 포인트가 있으면
	        m.setPoint(m.getPoint() - o.getUsedPoint());
	        result2 = dao.updatePoint(sqlSession, m);
	    }
	    
	    // 3. 상품 상태 'T'로 변경
	    int result3 = dao.updateProductStatus(sqlSession, o);

//	    // 4. 판매자 알림 전송 (알림 테이블 insert)
//	    int result4 = dao.insertSellerNotification(sqlSession, o);
	    
	    return result * result2 * result3 ;  // 셋 다 성공해야 1 반환
	}
	


}

//@Override
//public int getListCount() {
//	return dao.selectOne("productMapper.getListCount");
//}