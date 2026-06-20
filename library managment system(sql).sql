create database libarary_project;

use libarary_project;

-- Table: tbl_publisher
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);

-- Table: tbl_book
CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
);

-- Table: tbl_book_authors
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
);
select * from  tbl_book_authors;
-- Table: tbl_library_branch
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);
select * from tbl_library_branch;
-- Table: tbl_book_copies
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID INT primary key auto_increment,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
);
select * from tbl_book_copies;
-- Table: tbl_borrower
CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);
select * from tbl_borrower;
-- Table: tbl_book_loans
drop table tbl_book_loans;
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut varchar(100),
    book_loans_DueDate varchar(100),
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);
select * from tbl_book_loans;



-- 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

SELECT bc.book_copies_No_Of_Copies AS 'Number Of Copies'
FROM tbl_book_copies AS bc
JOIN tbl_book AS b 
    ON bc.book_copies_BookID = b.book_BookID
JOIN tbl_library_branch AS lb 
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe'
  AND lb.library_branch_BranchName = 'Sharpstown';
  
-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT 
    lb.library_branch_BranchName AS 'Branch Name',
    bc.book_copies_No_Of_Copies  AS 'Number Of Copies'
FROM tbl_book_copies AS bc
JOIN tbl_book AS b 
    ON bc.book_copies_BookID = b.book_BookID
JOIN tbl_library_branch AS lb 
    ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe';

-- 3.Retrieve the names of all borrowers who do not have any books checked out.

SELECT 
    borrower_BorrowerName AS 'Borrower Name'
FROM tbl_borrower AS br
WHERE br.borrower_CardNo NOT IN (
    SELECT DISTINCT book_loans_CardNo 
    FROM tbl_book_loans
);

-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title,
-- the borrower's name, and the borrower's address. 

SELECT b.book_Title  AS 'Book Title',br.borrower_BorrowerName AS 'Borrower Name',
    br.borrower_BorrowerAddress AS 'Borrower Address'
FROM tbl_book_loans AS bl
JOIN tbl_book AS b 
    ON bl.book_loans_BookID = b.book_BookID
JOIN tbl_borrower AS br 
    ON bl.book_loans_CardNo = br.borrower_CardNo
JOIN tbl_library_branch AS lb 
    ON bl.book_loans_BranchID = lb.library_branch_BranchID
WHERE lb.library_branch_BranchName = 'Sharpstown'
  AND bl.book_loans_DueDate = '2/3/2018';


-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

  SELECT 
    lb.library_branch_BranchName  AS 'Branch Name',
    COUNT(*)                       AS 'Total Books Loaned'
FROM tbl_book_loans AS bl
JOIN tbl_library_branch AS lb 
    ON bl.book_loans_BranchID = lb.library_branch_BranchID
GROUP BY lb.library_branch_BranchName;

-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

SELECT 
    br.borrower_BorrowerName     AS 'Borrower Name',
    br.borrower_BorrowerAddress  AS 'Borrower Address',
    COUNT(*)                      AS 'Total Books Checked Out'
FROM tbl_book_loans AS bl
JOIN tbl_borrower AS br 
    ON bl.book_loans_CardNo = br.borrower_CardNo
GROUP BY 
    br.borrower_CardNo,
    br.borrower_BorrowerName,
    br.borrower_BorrowerAddress
HAVING COUNT(*) > 5;

-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT 
    b.book_Title AS 'Book Title',
    bc.book_copies_No_Of_Copies AS 'Copies At Central'
FROM tbl_book AS b
JOIN tbl_book_authors AS ba ON b.book_BookID = ba.book_authors_BookID
JOIN tbl_book_copies AS bc ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch AS lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE ba.book_authors_AuthorName = 'Stephen King'
AND lb.library_branch_BranchName = 'Central';
  
  







