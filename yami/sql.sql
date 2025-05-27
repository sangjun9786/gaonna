----------------시스템계정--------------------
--DROP USER yami CASCADE;--계정 삭제
--
--create user yami identified by yami;
--grant resource, connect to yami;
----------------------------------------------

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

--member테이블
CREATE TABLE member (
    user_no    NUMBER,
    user_id    VARCHAR2(50),
    user_pwd   VARCHAR2(100),
    user_name  VARCHAR2(50),
    phone      VARCHAR2(20),
    user_location   VARCHAR2(50),
    enrolldate DATE,
    modifydate DATE          DEFAULT SYSDATE,
    status     VARCHAR2(1)   DEFAULT 'U',
    
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
COMMENT ON COLUMN member.user_location IS '사용자 위치';
COMMENT ON COLUMN member.enrolldate IS '가입일';
COMMENT ON COLUMN member.modifydate IS '수정일';
COMMENT ON COLUMN member.status IS '회원 상태 (Y:정상, N:탈퇴, E:휴면, U:이메일 미인증)';



--이메일 인증용 토큰 저장소
CREATE TABLE token (
    user_no         NUMBER,
    token_no        NUMBER CONSTRAINT token_no_nn NOT NULL,
    token           VARCHAR2(50) CONSTRAINT token_nn NOT NULL,
    generated_time  DATE DEFAULT SYSDATE CONSTRAINT generated_time_nn NOT NULL,
    token_status    VARCHAR2(1)   DEFAULT 'Y' CHECK (token_status IN ('Y', 'N')),
    
    CONSTRAINT token_no_pk PRIMARY KEY (token_no),
    CONSTRAINT user_no_fk FOREIGN KEY (user_no) REFERENCES member(user_no)
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
    super_admin  CHAR(1) DEFAULT 'N' CONSTRAINT super_admin_ck CHECK (super_admin IN ('Y', 'N')),
    admin        CHAR(1) DEFAULT 'N' CONSTRAINT admin_ck CHECK (admin IN ('Y', 'N')),
    viewer       CHAR(1) DEFAULT 'N' CONSTRAINT viewer_ck CHECK (viewer IN ('Y', 'N')),
    
    CONSTRAINT role_pk PRIMARY KEY (user_no),
    CONSTRAINT role_user_no_fk FOREIGN KEY (user_no) REFERENCES member(user_no)
);
COMMENT ON TABLE role IS '관리자 권한';
COMMENT ON COLUMN role.user_no IS '회원 식별번호';
COMMENT ON COLUMN role.super_admin IS '최고 관리자';
COMMENT ON COLUMN role.admin IS '일반 관리자';
COMMENT ON COLUMN role.viewer IS '뷰어(읽기 권한 관리자)';

-----------------------------------------------------
--                      DML                        --
-----------------------------------------------------
--관리자 계정
--비밀번호 : asdf

--최고 관리자
insert all
into member(user_no, user_id, user_pwd, user_name, status)
values(0, 'superAdmin@yami', '$2a$10$tOfmGQsO.Z7P1YhUZCKzrOosri/uhPci8hfqCN6jrHZcgxRgYjqyi', '최고 관리자', 'Y')
into role(user_no, super_admin)
values(0, 'Y')
select * from dual;

--일반 관리자
insert all
into member(user_no, user_id, user_pwd, user_name, status)
values(-1, 'admin@yami', '$2a$10$tOfmGQsO.Z7P1YhUZCKzrOosri/uhPci8hfqCN6jrHZcgxRgYjqyi', '일반 관리자', 'Y')
into role(user_no, admin)
values(-1, 'Y')
select * from dual;

--뷰어
insert all
into member(user_no, user_id, user_pwd, user_name, status)
values(-2, 'viewer@yami', '$2a$10$tOfmGQsO.Z7P1YhUZCKzrOosri/uhPci8hfqCN6jrHZcgxRgYjqyi', '뷰어', 'Y')
into role(user_no, viewer)
values(-2, 'Y')
select * from dual;

--만료된 토큰 체험
insert into token(user_no,token_no,token,generated_time,token_status)
values(0,0,0,SYSDATE,'N');

commit;