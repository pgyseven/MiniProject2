use webshjin;

-- 회원 테이블 생성
CREATE TABLE `webshjin`.`member` (
  `userId` VARCHAR(8) NOT NULL,
  `userPwd` VARCHAR(200) NOT NULL,
  `userName` VARCHAR(12) NULL,
  `mobile` VARCHAR(13) NULL,
  `email` VARCHAR(50) NULL,
  `registerDate` DATETIME NULL DEFAULT now(),
  `userImg` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE INDEX `mobile_UNIQUE` (`mobile` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
COMMENT = '회원 테이블';

-- 회원 테이블 수정(회원 포인트 점수 컬럼 부여)
ALTER TABLE `webshjin`.`member` 
ADD COLUMN `userPoint` INT NULL DEFAULT 100 AFTER `userImg`;

-- DB서버의 현재날짜와 현재 시간을 출력하는 쿼리문;
select now();


select md5('1234');
select sha1('1234');

select sha1(md5('1234'));

-- member 테이블 수정
ALTER TABLE `webshjin`.`member` 
CHANGE COLUMN `userImg` `userImg` VARCHAR(50) NOT NULL DEFAULT 'avatar.png' ;


-- Member테이블에 회원을 insert하는 쿼리문
insert into member(userId, userPwd, userName, mobile, email)
values(?, sha1(md5(?)), ?, ?, ?);

-- userId로 해당 유저의 정보를 검색하는 쿼리문
select * from member where userId = 'dooly';

-- member테이블의 모든 회원 정보 검색하는 쿼리문
select * from member;


-- dooly회원의 이메일을 수정하는 쿼리문
update member set email = 'dooly@dooly.com'
where userId = 'dooly';

-- ?회원이 전화번호를 변경할 때 쿼리문
update member set mobile=?
where userId = ?;

-- userId가 ?인 회원 삭제 (회원 탈퇴)
delete from member where userId = ? 