package com.gaonna.yami.notice.model.service;

import java.util.List;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.notice.model.vo.Notice;

public interface NoticeService {

    List<Notice> selectNoticeList();

    Notice selectNotice(int noticeNo);

    int updateCount(int noticeNo);

    int insertNotice(Notice notice);

    int updateNotice(Notice notice);

    int deleteNotice(int noticeNo);
    
    int selectListCount(String keyword);
    
    List<Notice> selectList(PageInfo pi, String keyword);
}
