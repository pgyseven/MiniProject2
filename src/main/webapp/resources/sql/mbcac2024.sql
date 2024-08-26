use mbcac2024;

-- 멤버 테이블 생성
CREATE TABLE `mbcac2024`.`Member` (
  `userId` VARCHAR(20) NOT NULL,
  `userName` VARCHAR(20) NOT NULL,
  `userBirth` INT NOT NULL,
  `phoneNum` VARCHAR(40) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `userClass` VARCHAR(20) NOT NULL DEFAULT 'FRIENDS',
  PRIMARY KEY (`userId`));
  
  
-- 9번 책 / 3권 / gayoon Cart에 담기
insert into Cart (bookNum, qty, userId) values(9, 3, 'gayoon');
insert into Cart(bookNum, qty, userId) values(2, 5, 'gayoon');


select * from Cart where userId = 'gayoon';
  
  
  SELECT 
    b.title,
    b.salePrice,
    c.qty,
    m.userId,
    m.userName
FROM 
    Cart c
INNER JOIN 
    Book b ON c.bookNum = b.bookNo
INNER JOIN 
    Member m ON c.userId = m.userId
WHERE 
    c.userId = 'gayoon';
  
 