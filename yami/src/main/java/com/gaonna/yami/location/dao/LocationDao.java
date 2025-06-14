package com.gaonna.yami.location.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.location.vo.Bakery;
import com.gaonna.yami.location.vo.BakeryComment;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;

@Repository
public class LocationDao {

	public List<Coord> selectUserDongne(SqlSessionTemplate sqlSession, int userNo) {
		return sqlSession.selectList("locationMapper.selectUserDongne", userNo);
	}

	public int insertDongne(SqlSessionTemplate sqlSession, Coord currCoord) {
		return sqlSession.insert("locationMapper.insertDongne",currCoord);
	}

	public int insertMemberCoords(SqlSessionTemplate sqlSession, Map<String, Integer> memberCoords) {
		return sqlSession.insert("locationMapper.insertMemberCoords",memberCoords);
	}

	public int updateMainCoord(SqlSessionTemplate sqlSession, Member loginUser) {
		return sqlSession.update("memberMapper.updateMainCoord",loginUser);
	}

	public int deleteCoord(SqlSessionTemplate sqlSession, int coordNo) {
		return sqlSession.delete("locationMapper.deleteCoord",coordNo);
	}

	public List<Location> selectLocation(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.selectList("locationMapper.selectLocation", m);
	}

	public int deleteMainLocation(SqlSessionTemplate sqlSession,Member m) {
		return sqlSession.update("memberMapper.deleteMainLocation",m);
	}

	public int deleteLocation(SqlSessionTemplate sqlSession, int locationNo) {
		return sqlSession.update("locationMapper.deleteLocation",locationNo);
	}

	public int updateMainLocation(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("memberMapper.updateMainLocation",m);
	}

	public int insertLocationMe(SqlSessionTemplate sqlSession, Location lo) {
		return sqlSession.insert("locationMapper.insertLocationMe",lo);
	}

	public int insertMemberLocation(SqlSessionTemplate sqlSession, Map<String, Integer> memberLocation) {
		return sqlSession.insert("locationMapper.insertMemberLocation",memberLocation);
	}

	public List<Bakery> selectBakeries(SqlSessionTemplate sqlSession, Coord mainCoord) {
		return sqlSession.selectList("locationMapper.selectBakeries",mainCoord);
	}

	public List<BakeryComment> selectBakeryComment(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.selectList("locationMapper.selectBakeryComment",map);
	}
	
	public List<BakeryComment> selectBakeryRecomment(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.selectList("locationMapper.selectBakeryRecomment",map);
	}

	public int insertBakeryComment(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.insert("locationMapper.insertBakeryComment", map);
	}

	public int insertBakeryRecomment(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.insert("locationMapper.insertBakeryRecomment", map);
	}

	public int updateBakeryComment(SqlSessionTemplate sqlSession, Map<String, Object> map) {
		return sqlSession.update("locationMapper.updateBakeryComment", map);
	}
	
	public int deleteBakeryComment(SqlSessionTemplate sqlSession, int commentNo) {
		return sqlSession.update("locationMapper.deleteBakeryComment", commentNo);
	}

	public Bakery selectBakeryInfo(SqlSessionTemplate sqlSession, String bakeryNo) {
		return sqlSession.selectOne("locationMapper.selectBakeryInfo", bakeryNo);
	}

}
