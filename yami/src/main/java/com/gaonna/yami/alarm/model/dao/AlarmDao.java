package com.gaonna.yami.alarm.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.alarm.model.vo.Alarm;

@Repository
public class AlarmDao {

    @Autowired
    private SqlSession sqlSession;

    public int insertAlarm(Alarm alarm) {
        return sqlSession.insert("alarmMapper.insertAlarm", alarm);
    }

    public List<Alarm> selectAlarmList(int userNo) {
        return sqlSession.selectList("alarmMapper.selectAlarmList", userNo);
    }

    public int updateAllAlarmRead(int userNo) {
        return sqlSession.update("alarmMapper.updateAllAlarmRead", userNo);
    }

    public int deleteAlarm(int alarmNo) {
        return sqlSession.delete("alarmMapper.deleteAlarm", alarmNo);
    }

    public int deleteAllAlarm(int userNo) {
        return sqlSession.delete("alarmMapper.deleteAllAlarm", userNo);
    }
    
    public int selectUnreadAlarmCount(int userNo) {
        return sqlSession.selectOne("alarmMapper.selectUnreadAlarmCount", userNo);
    }
    
    public int deleteChatAlarmsByRoom(int userNo, int roomNo) {
        return sqlSession.delete("alarmMapper.deleteChatAlarmsByRoom", Map.of("userNo", userNo, "roomNo", roomNo));
    }

    public int markAsRead(int alarmNo) {
        return sqlSession.update("alarmMapper.markAsRead", alarmNo);
    }
    
    public int markReplyAlarmsAsRead(int userNo, int productNo) {
        return sqlSession.update(
            "alarmMapper.markReplyAlarmsAsRead",
            Map.of("userNo", userNo, "productNo", productNo)
        );
    }

    public int deleteReplyAlarmsByProduct(int userNo, int productNo) {
        return sqlSession.delete("alarmMapper.deleteReplyAlarmsByProduct",
             Map.of("userNo", userNo, "productNo", productNo));
    }
    
    
    

    
    
}
