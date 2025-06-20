package com.gaonna.yami.product.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.location.dao.LocationDao;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.dao.ProductDao;
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
    
    @Autowired
    private LocationDao locationDao;

    
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
	
	//리스트 조회
	@Override
	public ArrayList<Product> selectProductList(PageInfo pi) {
		// TODO Auto-generated method stub
		return dao.selectProductList(sqlSession,pi);
	}
	
	//카테고리 목록
	@Override
	public ArrayList<Category> selectCategoryList() {
		// TODO Auto-generated method stub
		return dao.selectCategoryList(sqlSession);
	}
		
	//거래장소
	@Override
	public Location selectMainLocationByUserNo(int userNo) {
		// TODO Auto-generated method stub
		return dao.selectMainLocationByUserNo(sqlSession, userNo);
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

	//상세보기
	@Override
	public Product selectProductDetail(int productNo) {
		// TODO Auto-generated method stub
		return dao.selectProductDetail(sqlSession,productNo);
	}
	
	//상세페이지 사진
	@Override
	public ArrayList<Attachment> selectProductAttachments(int productNo) {
		// TODO Auto-generated method stub
		return dao.selectProductAttachments(sqlSession,productNo);
	}
    
	//삭제
	@Override
	public int deleteProduct(int productNo) {
		// TODO Auto-generated method stub
		
		
		return dao.deleteProduct(sqlSession,productNo);
	}
	
	//수정
	@Transactional
	@Override
	public int productUpdate(Product p, ArrayList<Attachment> atList) {
		
	    // ✅ 1. 대표 이미지 유효성 검사 (기존 유지 OR 새로 업로드된 것 중 하나는 있어야 함)
	    boolean hasThumbnail =
	        atList.stream().anyMatch(at -> at.getFileLevel() == 1) ||
	        (p.getChangeName() != null && !p.getChangeName().isEmpty());

	    if (!hasThumbnail) {
	        throw new IllegalArgumentException("대표 이미지는 반드시 등록해야 합니다.");
	    }

	    // ✅ 2. 기존 첨부파일 삭제
	    dao.deleteAttachmentProduct(sqlSession, p.getProductNo());

	    // ✅ 3. 새로운 첨부파일 등록
	    int result2 = 1;
	    for (Attachment at : atList) {
	        at.setProductBno(p.getProductNo());
	        result2 *= dao.insertAttachment(sqlSession, at);
	    }

	    // ✅ 4. 게시글 본문 수정
	    int result1 = dao.updateProduct(sqlSession, p);

	    return result1 * result2;
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