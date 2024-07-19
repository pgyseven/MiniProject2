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
delete from member where userId = ?; 


-- 계층형 게시판 생성
CREATE TABLE `webshjin`.`hboard` (
  `boardNo` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(20) NOT NULL,
  `content` VARCHAR(2000) NULL,
  `writer` VARCHAR(8) NULL,
  `postDate` DATETIME NULL DEFAULT now(),
  `readCount` INT NULL DEFAULT 0,
  `ref` INT NULL DEFAULT 0,
  `step` INT NULL DEFAULT 0,
  `refOrder` INT NULL DEFAULT 0,
  PRIMARY KEY (`boardNo`),
  INDEX `hboard_member_fk_idx` (`writer` ASC) VISIBLE,
  CONSTRAINT `hboard_member_fk`
    FOREIGN KEY (`writer`)
    REFERENCES `webshjin`.`member` (`userId`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
COMMENT = '계층형 게시판';


-- 계층형 게시판의 모든 게시글을 가져오는 쿼리문
select * from hboard order by boardNo desc;

-- 계층형 게시판에 게시글을 등록하는 쿼리문
insert into hboard(title, content, writer)
values('아싸~~~ 1등이다', '내용 무..', 'dooly');

insert into hboard(title, content, writer)
values('에이', '1등 놓쳤네..', 'kildong');

insert into hboard(title, content, writer)
values(?, ?, ?);

-- 유저에게 지급되는 포인트를 정의한 테이블 생성
CREATE TABLE `webshjin`.`pointdef` (
  `pointWhy` VARCHAR(20) NOT NULL,
  `pointScore` INT NULL,
  PRIMARY KEY (`pointWhy`))
COMMENT = '유저에게 적립할 포인트에 대한 정의 테이블.\n어떤 사유로 몇 포인트를 지급하는지에 대해 정의\n';

-- pointdef 테이블의 기초 데이터
INSERT INTO `webshjin`.`pointdef` (`pointWhy`, `pointScore`) VALUES ('회원가입', '100');
INSERT INTO `webshjin`.`pointdef` (`pointWhy`, `pointScore`) VALUES ('로그인', '1');
INSERT INTO `webshjin`.`pointdef` (`pointWhy`, `pointScore`) VALUES ('글작성', '10');
INSERT INTO `webshjin`.`pointdef` (`pointWhy`, `pointScore`) VALUES ('댓글작성', '2');
INSERT INTO `webshjin`.`pointdef` (`pointWhy`, `pointScore`) VALUES ('게시글신고', '-10');

-- 유저의 포인트 적립 내역을 기록하는 poinlog 테이블 생성
CREATE TABLE `webshjin`.`pointlog` (
  `pointLogNo` INT NOT NULL AUTO_INCREMENT,
  `pointWho` VARCHAR(8) NOT NULL,
  `pointWhen` DATETIME NULL DEFAULT now(),
  `pointWhy` VARCHAR(20) NOT NULL,
  `pointScore` INT NOT NULL,
  PRIMARY KEY (`pointLogNo`),
  CONSTRAINT `pointdef_member_fk`
    FOREIGN KEY (`pointWho`)
    REFERENCES `webshjin`.`member` (`userId`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
COMMENT = '어떤유저에게 어떤 사유로 몇 포인트가 언제 지급되었는지를 기록 테이블';

-- 계층형 게시판 글 삭제 쿼리문
DELETE FROM hboard WHERE boardNo=1;


-- 포인트 지급 log를 저장하는 쿼리문 
insert into pointlog(pointWho, pointWhy, pointScore)
values(?, ?, (select pointScore from pointdef where pointWhy = ?));


-- 유저에게 지급된 point를 update하는 쿼리문
update member set userpoint = userpoint + (select pointScore from pointdef where pointWhy = '글작성') 
where userId = ?;


-- 게시글의 첨부파일을 저장하는 테이블 생성
CREATE TABLE `webshjin`.`boardimg` (
  `boardImgNo` INT NOT NULL AUTO_INCREMENT,
  `newFileName` VARCHAR(50) NOT NULL,
  `originFileName` VARCHAR(50) NOT NULL,
  `ext` VARCHAR(4) NULL,
  `size` INT NULL,
  `boardNo` INT NOT NULL,
  `base64Img` TEXT NULL,
  INDEX `board_boardNo_fk_idx` (`boardNo` ASC) VISIBLE,
  PRIMARY KEY (`boardImgNo`),
  CONSTRAINT `board_boardNo_fk`
    FOREIGN KEY (`boardNo`)
    REFERENCES `webshjin`.`hboard` (`boardNo`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
COMMENT = '게시판에 업로드 되는 업로드 파일을 기록하는 테이블';

-- 게시글 첨부파일 테이블 수정
ALTER TABLE `webshjin`.`boardimg` 
ADD COLUMN `thumbFileName` VARCHAR(60) NULL AFTER `originFileName`;

-- 첨부파일 테이블 명 변경
ALTER TABLE `webshjin`.`boardimg` 
RENAME TO  `webshjin`.`boardupfiles` ;

-- 컬럼 크기 수정
ALTER TABLE `webshjin`.`boardupfiles` 
CHANGE COLUMN `ext` `ext` VARCHAR(20) NULL DEFAULT NULL ;

-- 컬럼명 변경
ALTER TABLE `webshjin`.`boardupfiles` 
CHANGE COLUMN `boardImgNo` `boardUpFileNo` INT NOT NULL AUTO_INCREMENT ;

-- 방금 insert된 글의 글번호를 가져오는 쿼리문
select max(boardNo) from  hboard;

-- 유저가 게시글을 저장할때 파일업로드 하는 쿼리문
insert into boardupfiles(newFileName, originFileName, thumbFileName, ext, size, boardNo, base64Img)
values(?, ?, ?, ?, ?, ?, ?);

use webshjin;

-- 게시판 상세 페이지를 출력하는 쿼리문
select * from hboard where boardNo = ?;
SELECT * FROM BOARDUPFILES WHERE BOARDnO= 16;

-- 게시글과 첨부파일, 작성자 정보까지 함께 출력해보자(조인 테이블 3 개 3 -1 개의 조인 조건이 나와야 한다)
select h.boardNo, h.title, h.content, h.writer, h.postdate, h.readcount
, f.*, m.username, m.email
from hboard h  left outer join boardupfiles f
on h.boardNo = f.boardNo
inner join member m
on h.writer = m.userId
where h.boardNo=16;



