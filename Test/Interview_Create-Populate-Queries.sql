CREATE TABLE Sales
(
  TransactionID varchar(3)  NOT NULL PRIMARY KEY,
  DealerID varchar(4) NOT NULL,
  Model varchar(3) NOT NULL,
  SalesType varchar(1) NOT NULL,
  SoldDate date NOT NULL
  );

INSERT INTO Sales VALUES ('001', '5555', 'NV',  'D', '2023-01-25');
INSERT INTO Sales VALUES ('002', '6666', 'NV2', '2', '2022-12-15');
INSERT INTO Sales VALUES ('003', '7777', 'TNT', '1', '2022-11-01');

CREATE TABLE Dealership
(
  DealerID varchar(3)  NOT NULL PRIMARY KEY,
  State varchar(2) NOT NULL,
  Status varchar(1) NOT NULL,
  Type varchar(2) NOT NULL
  );
  
INSERT INTO Dealership VALUES ('5555', 'MN', 'A', 'FR');
INSERT INTO Dealership VALUES ('7777', 'CO', 'I', 'BU');
INSERT INTO Dealership VALUES ('6666', 'NY', 'A', 'GV');

CREATE TABLE Returns
(
  TransactionID varchar(3)  NOT NULL PRIMARY KEY,
  ReturnDate date NOT NULL,
  ReasonCode INT NOT NULL,
  Status varchar(1) NOT NULL,
  );

INSERT INTO Returns VALUES ('002', '2023-01-10', 1, 'P');
INSERT INTO Returns VALUES ('005', '2022-12-23', 2, 'D');
INSERT INTO Returns VALUES ('009', '2022-11-01', 1, 'A');

-- Query 1
-- Locate Sales where the Dealer has a status of A and State equals MN and is not found in the Returns Table.  Group by Model.

SELECT s.Model, COUNT(s.TransactionID) AS TransactionCount, MIN(s.DealerID) AS "First Dealer", MAX(s.DealerID) AS "Last Dealer", MIN(s.SoldDate) AS "Earliest Sale Date", MAX(s.SoldDate) AS "Latest Sale Date"
FROM Sales s  LEFT JOIN Dealership d ON s.DealerID = d.DealerID
              LEFT JOIN Returns r ON s.TransactionID = r.TransactionID
WHERE d.Status = 'A' 
  AND r.TransactionID IS NULL
  GROUP BY s.Model;

-- Query 2 
-- Locate Sales with a Salestype that is not equal to 1 or 2, with a Dealer that has a status of A and is not found in the Returns table.  Order by SoldDate.

SELECT s.TransactionID, s.DealerID, s.Model, s.SalesType, s.SoldDate
FROM Sales s  LEFT JOIN Dealership d ON s.DealerID = d.DealerID
              LEFT JOIN Returns r ON s.TransactionID = r.TransactionID
WHERE s.SalesType NOT IN ('1', '2')
  AND d.Status = 'A' 
  AND r.TransactionID IS NULL
ORDER BY s.SoldDate;

-- Query 3
-- Locate returns that are for Model NV, that have a ReasonCode of 1, and Return date is greater than 12012022. 

SELECT r.TransactionID, r.ReturnDate, r.ReasonCode, r.Status
FROM Returns r  LEFT JOIN Sales s ON r.TransactionID = s.TransactionID
WHERE s.Model = 'NV'
  AND r.ReasonCode = 1
  AND r.ReturnDate > '2022-12-01';

