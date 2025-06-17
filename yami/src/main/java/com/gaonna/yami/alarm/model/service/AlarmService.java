package com.gaonna.yami.alarm.model.service;

import java.util.List;
import com.gaonna.yami.alarm.model.vo.Alarm;

public interface AlarmService {
    int insertAlarm(Alarm alarm);
    List<Alarm> selectAlarmList(int userNo);
    int updateAllAlarmRead(int userNo);
    int deleteAlarm(int alarmNo);
    int deleteAllAlarm(int userNo);
    int selectUnreadAlarmCount(int userNo);
    int deleteChatAlarmsByRoom(int userNo, int roomNo);
    int markAsRead(int alarmNo);

    int markReplyAlarmsAsRead(int userNo, int productNo);             
    int deleteReplyAlarmsByProduct(int userNo, int productNo);
}
