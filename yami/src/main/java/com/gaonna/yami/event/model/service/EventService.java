package com.gaonna.yami.event.model.service;

import com.gaonna.yami.event.model.vo.Event;
import com.gaonna.yami.member.model.vo.Member;

public interface EventService {

	Event eventInfo(Member loginUser);

	int attendance(Event e);

	int resetCount(Event e);

	int point1000(Member loginUser);

	int point500(Member loginUser);

}
