DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
   employee_id INT PRIMARY KEY,
   first_name VARCHAR (255) NOT NULL,
   last_name VARCHAR (255) NOT NULL,
   manager_id INT,
   FOREIGN KEY (manager_id) 
   REFERENCES employee (employee_id) 
);
INSERT INTO employee (
   employee_id,
   first_name,
   last_name,
   manager_id
)
VALUES
   (1, 'Windy', 'Hays', NULL),
   (2, 'Ava', 'Christensen', 1),
   (3, 'Hassan', 'Conner', 1),
   (4, 'Anna', 'Reeves', 2),
   (5, 'Sau', 'Norman', 2),
   (6, 'Kelsie', 'Hays', 3),
   (7, 'Tory', 'Goff', 3),
   (8, 'Salley', 'Lester', 3);