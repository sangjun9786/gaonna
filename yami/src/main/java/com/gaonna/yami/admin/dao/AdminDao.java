package com.gaonna.yami.admin.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.composite.vo.BoardCo;
import com.gaonna.yami.composite.vo.ReplyCo;
import com.gaonna.yami.composite.vo.SearchForm;
import com.gaonna.yami.location.vo.BakeryComment;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;

@Repository
public class AdminDao {

	public Member consoleLogin(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("adminMapper.consoleLogin",userId);
	}

	public String selectRoleType(SqlSessionTemplate sqlSession, Member loginUser) {
		return sqlSession.selectOne("adminMapper.selectRoleType",loginUser);
	}

	public List<Member> searchAdmin(SqlSessionTemplate sqlSession, String select) {
		return sqlSession.selectList("adminMapper.searchAdmin", select);
	}

	public int updateAdmin(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("adminMapper.updateAdmin", m);
	}

	public int updateAdminRole(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("adminMapper.updateAdminRole", m);
	}

	public int deleteAdminRole(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.delete("adminMapper.deleteAdminRole", m);
	}

	public int insertAdmin(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.insert("adminMapper.insertAdmin",m);
	}

	public int insertAdminRole(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.insert("adminMapper.insertAdminRole",m);
	}

	public List<Member> searchMemberAll(SqlSessionTemplate sqlSession, Map<String, String> mapping) {
		return sqlSession.selectList("adminMapper.searchMemberAll", mapping);
	}
	
	public List<Member> searchMember(SqlSessionTemplate sqlSession, Map<String, String> mapping) {
		return sqlSession.selectList("adminMapper.searchMember", mapping);
	}

	public String countMember(SqlSessionTemplate sqlSession, Map<String, String> mapping) {
		Integer count = sqlSession.selectOne("adminMapper.countMember", mapping);
		return count != null ? count.toString() : "0";
	}

	public int updateUser(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("adminMapper.updateUser", m);
	}

	public List<Coord> userDongne(SqlSessionTemplate sqlSession, int userNo) {
		return sqlSession.selectList("adminMapper.userDongne", userNo);
	}

	public List<Location> userLocation(SqlSessionTemplate sqlSession, int userNo) {
		return sqlSession.selectList("adminMapper.userLocation", userNo);
	}

	public int countBoard(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectOne("adminMapper.countBoard", searchForm);
	}

	public List<BoardCo> searchBoard(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("adminMapper.searchBoard",searchForm);
	}

	public int countReply(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectOne("adminMapper.countReply", searchForm);
	}

	public List<ReplyCo> searchReply(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("adminMapper.searchReply", searchForm);
	}

	public int countReplyDongne(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectOne("adminMapper.countReplyDongne", searchForm);
	}

	public List<BakeryComment> searchReplyDongne(SqlSessionTemplate sqlSession, SearchForm searchForm) {
		return sqlSession.selectList("adminMapper.searchReplyDongne", searchForm);
	}
}
