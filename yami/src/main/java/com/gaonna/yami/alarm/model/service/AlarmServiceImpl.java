package com.gaonna.yami.alarm.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.alarm.model.dao.AlarmDao;
import com.gaonna.yami.alarm.model.vo.Alarm;

@Service
public class AlarmServiceImpl implements AlarmService {

    @Autowired
    private AlarmDao alarmDao;

    @Override
    public int insertAlarm(Alarm alarm) {
        return alarmDao.insertAlarm(alarm);
    }

    @Override
    public List<Alarm> selectAlarmList(int userNo) {
        return alarmDao.selectAlarmList(userNo);
    }

    @Override
    public int updateAllAlarmRead(int userNo) {
        return alarmDao.updateAllAlarmRead(userNo);
    }

    @Override
    public int deleteAlarm(int alarmNo) {
        return alarmDao.deleteAlarm(alarmNo);
    }

    @Override
    public int deleteAllAlarm(int userNo) {
        return alarmDao.deleteAllAlarm(userNo);
    }
    
    @Override
    public int selectUnreadAlarmCount(int userNo) {
        return alarmDao.selectUnreadAlarmCount(userNo);
    }
    
    @Override
    public int deleteChatAlarmsByRoom(int userNo, int roomNo) {
        return alarmDao.deleteChatAlarmsByRoom(userNo, roomNo);
    }
    
    @Override
    public int markAsRead(int alarmNo) {
        return alarmDao.markAsRead(alarmNo);
    }
    
    @Override
    public int markReplyAlarmsAsRead(int userNo, int productNo) {
        return alarmDao.markReplyAlarmsAsRead(userNo, productNo);
    }

    
    @Override
    public int deleteReplyAlarmsByProduct(int userNo, int productNo) {
        return alarmDao.deleteReplyAlarmsByProduct(userNo, productNo);
    }

}
