----------------시스템계정--------------------
--DROP USER yami CASCADE;--계정 삭제
--
--create user yami identified by yami;
--grant resource, connect to yami;

exp yami/yami file=c:\yami.dmp owner=yami
----------------------------------------------

/*
    버그
    
    헤더 변경에 따른 alertMsg확인
    회원가입 작성 폼에서 뒤로가기 막기
    유저 우리동네, 배송지 페이지 비동기식으로 변경
    
    추가 필요
    로그인 정보 저장/자동 로그인
    아이디/비밀번호 찾기
*/


--시퀀스 시작 숫자가 테스트 과정에서 사람마다 달라질 수 있음

--회원 식별번호 시퀀스
CREATE SEQUENCE seq_me
START WITH 1
INCREMENT BY 1
NOCACHE;

--토큰번호 시퀀스
CREATE SEQUENCE seq_token
START WITH 1
INCREMENT BY 1
NOCACHE;

--위치번호 시퀀스
CREATE SEQUENCE seq_location
START WITH 1
INCREMENT BY 1
NOCACHE;

--좌표번호 시퀀스
CREATE SEQUENCE seq_coords
START WITH 1
INCREMENT BY 1
NOCACHE;

--member테이블
CREATE TABLE member (
    user_no    NUMBER,
    user_id    VARCHAR2(50),
    user_pwd   VARCHAR2(100),
    user_name  VARCHAR2(50),
    phone      VARCHAR2(20),
    point      NUMBER        DEFAULT 0,
    enrolldate DATE,
    modifydate DATE          DEFAULT SYSDATE,
    status     VARCHAR2(1)   DEFAULT 'U',
    MAIN_COORD NUMBER,
    MAIN_LOCATION NUMBER,
    
    CONSTRAINT USER_NO_PK    PRIMARY KEY (user_no),
    CONSTRAINT USER_ID_NN    CHECK (user_id IS NOT NULL),
    CONSTRAINT USER_ID_UQ    UNIQUE (user_id),
    CONSTRAINT USER_PWD_NN   CHECK (user_pwd IS NOT NULL),
    CONSTRAINT USER_NAME_NN  CHECK (user_name IS NOT NULL),
    CONSTRAINT STATUS_CK     CHECK (status IN ('Y', 'N', 'E', 'U'))
);
COMMENT ON TABLE member IS '회원정보';
COMMENT ON COLUMN member.user_no IS '식별번호';
COMMENT ON COLUMN member.user_id IS '아이디';
COMMENT ON COLUMN member.user_pwd IS '비밀번호';
COMMENT ON COLUMN member.user_name IS '이름';
COMMENT ON COLUMN member.phone IS '전화번호';
COMMENT ON COLUMN member.point IS '포인트';
COMMENT ON COLUMN member.enrolldate IS '가입일';
COMMENT ON COLUMN member.modifydate IS '수정일';
COMMENT ON COLUMN member.status IS '회원 상태 (Y:정상, N:탈퇴, E:휴면, U:이메일 미인증)';
COMMENT ON COLUMN member.MAIN_COORD IS '대표 좌표';
COMMENT ON COLUMN member.MAIN_LOCATION IS '대표 위치';

--member가 업데이트되면 작동하는 트리거
CREATE OR REPLACE TRIGGER TRG_MEMBER_MODIFY
BEFORE UPDATE ON member
FOR EACH ROW
BEGIN
    :NEW.MODIFYDATE := SYSDATE;
END;
/

--좌표
create table coords(
    coord_no NUMBER,
    LATITUDE VARCHAR2(20),
    LONGITUDE VARCHAR2(20),
    COORD_Address VARCHAR2(300),
    coord_date DATE default sysdate,
    
    CONSTRAINT coords_no_PK PRIMARY KEY (coord_no)
);
COMMENT ON TABLE coords IS '좌표';
COMMENT ON COLUMN coords.coord_no IS '좌표 식별번호';
COMMENT ON COLUMN coords.LATITUDE IS '위도';
COMMENT ON COLUMN coords.LONGITUDE IS '경도';
COMMENT ON COLUMN coords.COORD_Address IS '해당 좌표 주소';
COMMENT ON COLUMN coords.coord_date IS '추가/수정된 날짜';

--member-coords조인 테이블
CREATE TABLE MEMBER_COORDS (
    USER_NO NUMBER,
    COORD_NO NUMBER,
    CONSTRAINT MEMBER_COORDS_USER_NO_fk FOREIGN KEY (USER_NO) REFERENCES member(USER_NO) ON DELETE CASCADE,
    CONSTRAINT MEMBER_COORDS_COORD_NO_fk FOREIGN KEY (COORD_NO) REFERENCES coords(COORD_NO) ON DELETE CASCADE
);
COMMENT ON TABLE MEMBER_COORDS IS '유저-좌표';
COMMENT ON COLUMN MEMBER_COORDS.USER_NO IS '유저 식별번호';
COMMENT ON COLUMN MEMBER_COORDS.COORD_NO IS '좌표 식별번호';

--위치
CREATE TABLE LOCATION (
    LOCATION_NO NUMBER,
    location_date DATE default sysdate,
    road_Address VARCHAR2(300),
    jibun_Address VARCHAR2(300),
    detail_Address VARCHAR2(200),
    ZIP_CODE VARCHAR2(10),

    CONSTRAINT LOCATION_NO_PK PRIMARY KEY (LOCATION_NO)
);
COMMENT ON TABLE LOCATION IS '위치';
COMMENT ON COLUMN LOCATION.location_date IS '추가/수정된 날짜';
COMMENT ON COLUMN LOCATION.road_Address IS '도로명주소';
COMMENT ON COLUMN LOCATION.jibun_Address IS '지번주소';
COMMENT ON COLUMN LOCATION.detail_Address IS '세부주소';
COMMENT ON COLUMN LOCATION.ZIP_CODE IS '우편번호';

--member-location조인 테이블
CREATE TABLE MEMBER_LOCATION (
    USER_NO NUMBER,
    LOCATION_NO NUMBER,
    CONSTRAINT MEMBER_LOCATION_USER_NO_fk FOREIGN KEY (USER_NO) REFERENCES member(USER_NO) ON DELETE CASCADE,
    CONSTRAINT MEMBER_LOCATION_LOCATION_NO_fk FOREIGN KEY (LOCATION_NO) REFERENCES LOCATION(LOCATION_NO) ON DELETE CASCADE
);
COMMENT ON TABLE MEMBER_LOCATION IS '유저-위치';
COMMENT ON COLUMN MEMBER_LOCATION.USER_NO IS '유저 식별번호';
COMMENT ON COLUMN MEMBER_LOCATION.LOCATION_NO IS '위치 식별번호';

--이메일 인증용 토큰 저장소
CREATE TABLE token (
    token_no        NUMBER,
    user_no         NUMBER,
    token           VARCHAR2(50) CONSTRAINT token_nn NOT NULL,
    generated_time  DATE DEFAULT SYSDATE CONSTRAINT token_generated_time_nn NOT NULL,
    token_status    VARCHAR2(1) DEFAULT 'Y' CONSTRAINT token_status_check CHECK (token_status IN ('Y', 'N')),
    
    CONSTRAINT token_no_pk PRIMARY KEY (token_no),
    CONSTRAINT token_user_no_fk FOREIGN KEY (user_no) REFERENCES member(user_no) ON DELETE CASCADE
);
COMMENT ON TABLE token IS '토큰';
COMMENT ON COLUMN token.user_no IS '회원 식별번호';
COMMENT ON COLUMN token.token_no IS '토큰번호';
COMMENT ON COLUMN token.token IS '토큰';
COMMENT ON COLUMN token.generated_time IS '토큰생성시간';
COMMENT ON COLUMN token.token_status IS '토큰 상태 (Y:정상, N:사용불가)';


--DB에서 토큰 만료하기
CREATE OR REPLACE PROCEDURE update_token_status AS
BEGIN
    UPDATE token
    SET TOKEN_STATUS = 'N'
    WHERE GENERATED_TIME < SYSDATE - INTERVAL '30' MINUTE
    AND TOKEN_STATUS = 'Y';
    COMMIT;
END;
/
--토큰만료 프로시저 자동실행
/*
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'UPDATE_TOKEN_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN update_token_status; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=5',  -- 5분마다 실행
        enabled         => TRUE,
        comments        => '토큰 만료 (5분)'
    );
END;
/
-- 작업 중지
BEGIN
    DBMS_SCHEDULER.STOP_JOB('UPDATE_TOKEN_JOB');
END;
/
-- 작업 삭제
BEGIN
    DBMS_SCHEDULER.DROP_JOB('UPDATE_TOKEN_JOB');
END;
/
*/

--관리자 권한
CREATE TABLE role (
    user_no      NUMBER,
    role_type    VARCHAR2(20) 
    CONSTRAINT role_type_check CHECK (role_type IN ('superAdmin', 'admin', 'viewer')),
    /*
        role_type에 들어갈 데이터
        최고 관리자 superAdmin
        그냥 관리자 admin
        뷰어(읽기만 가능) viewer
    */

    CONSTRAINT role_user_no_uk UNIQUE (user_no),
    CONSTRAINT role_user_no_fk FOREIGN KEY (user_no) REFERENCES member(user_no) ON DELETE CASCADE
);
COMMENT ON TABLE role IS '관리자 권한';
COMMENT ON COLUMN role.user_no IS '회원 식별번호';
COMMENT ON COLUMN role.role_type IS '권한 유형';

--베이커리 테이블
CREATE TABLE bakery (
    bakery_no      VARCHAR2(30),
    open_date      VARCHAR2(20), -- yyyy-MM-dd꼴
    phone          VARCHAR2(20),
    road_address   VARCHAR2(300),
    jibun_address  VARCHAR2(300),
    bakery_name    VARCHAR2(300),
    latitude       VARCHAR2(20), -- 위도
    longitude      VARCHAR2(20)  -- 경도
);

COMMENT ON TABLE bakery IS '뽱집';
COMMENT ON COLUMN bakery.bakery_no IS '뽱집 식별번호(관리번호)';
COMMENT ON COLUMN bakery.open_date IS '개업일(인허가 일자)';
COMMENT ON COLUMN bakery.phone IS '전화번호';
COMMENT ON COLUMN bakery.road_Address IS '도로명 주소';
COMMENT ON COLUMN bakery.jibun_Address IS '지번 주소';
COMMENT ON COLUMN bakery.LATITUDE IS '위도';
COMMENT ON COLUMN bakery.LONGITUDE IS '경도';

-----------------------------------------------------
--                      DML                        --
-----------------------------------------------------
--관리자 계정
--비밀번호 : asdf

--최고 관리자
insert all
into member(user_no, user_id, user_pwd, user_name, status, enrolldate)
values(0, 'superAdmin@yami', '$2a$10$tOfmGQsO.Z7P1YhUZCKzrOosri/uhPci8hfqCN6jrHZcgxRgYjqyi', '최고 관리자', 'Y', SYSDATE)
into role(user_no, role_type)
values(0, 'superAdmin')
select * from dual;

--일반 관리자
insert all
into member(user_no, user_id, user_pwd, user_name, status, enrolldate)
values(-1, 'admin@yami', '$2a$10$tOfmGQsO.Z7P1YhUZCKzrOosri/uhPci8hfqCN6jrHZcgxRgYjqyi', '일반 관리자', 'Y', SYSDATE)
into role(user_no, role_type)
values(-1, 'admin')
select * from dual;

--뷰어
insert all
into member(user_no, user_id, user_pwd, user_name, status, enrolldate)
values(-2, 'viewer@yami', '$2a$10$tOfmGQsO.Z7P1YhUZCKzrOosri/uhPci8hfqCN6jrHZcgxRgYjqyi', '뷰어', 'Y', SYSDATE)
into role(user_no, role_type)
values(-2, 'viewer')
select * from dual;

--만료된 토큰 체험
insert into token(user_no,token_no,token,generated_time,token_status)
values(0,0,0,SYSDATE,'N');

--좌표
insert into coords (COORD_NO,LATITUDE,LONGITUDE,COORD_ADDRESS)
values(-1,37.5392375,126.9003409,'서울특별시 영등포구 당산2동');
insert into member_coords values(0,-1);
update member
set main_coord = -1
where user_no = 0;

insert into coords (COORD_NO,LATITUDE,LONGITUDE,COORD_ADDRESS)
values(-2,0,0,'이 세상 어딘가');
insert into member_coords values(0,-2);

insert into coords (COORD_NO,LATITUDE,LONGITUDE,COORD_ADDRESS)
values(-3,0,0,'저 바다 너머');
insert into member_coords values(0,-3);

insert into coords (COORD_NO,LATITUDE,LONGITUDE,COORD_ADDRESS)
values(-4,0,0,'깊은 산 속 옹달샘');
insert into member_coords values(0,-4);

insert into location(LOCATION_NO,LOCATION_DATE,ROAD_ADDRESS
,JIBUN_ADDRESS,DETAIL_ADDRESS,ZIP_CODE)
values(-1,sysdate,'서울 영등포구 선유동2로 57 이레빌딩'
,'서울 영등포구 양평동4가 2', '20층 어딘가','07212');
insert into member_location values(0,-1);

insert into location(LOCATION_NO, LOCATION_DATE, ROAD_ADDRESS
, JIBUN_ADDRESS, DETAIL_ADDRESS, ZIP_CODE)
values(-2, sysdate, '서울 종로구 사직로 161 경복궁'
, '서울 종로구 세종로 1-1', '근정전 앞', '03045');
insert into member_location values(0, -2);

insert into location(LOCATION_NO, LOCATION_DATE
, ROAD_ADDRESS, JIBUN_ADDRESS, DETAIL_ADDRESS, ZIP_CODE)
values(-3, sysdate, '부산 해운대구 해운대해변로 264'
, '부산 해운대구 중동 1411-1', '해운대 백사장 중앙', '48094');
insert into member_location values(0, -3);

insert into location(LOCATION_NO, LOCATION_DATE
, ROAD_ADDRESS, JIBUN_ADDRESS, DETAIL_ADDRESS, ZIP_CODE)
values(-4, sysdate, '경북 경주시 첨성로 140'
, '경북 경주시 인왕동 839-1', '첨성대 남쪽 잔디밭', '38171');
insert into member_location values(0, -4);

commit;