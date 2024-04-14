/* 2. Write commands for creating tables and inserting values */

/* Create Course table */
CREATE TABLE Course (
  course_id INT PRIMARY KEY,
  department VARCHAR(255),
  course_number INT,
  course_name VARCHAR(255),
  semester VARCHAR(255),
  year INT
);

/* Create Student table */
CREATE TABLE Student (
  student_id INT PRIMARY KEY,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  course_id INT,
  FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

/* Create Assignment table */
CREATE TABLE Assignment (
  assignment_id INT PRIMARY KEY,
  category VARCHAR(255),
  percentage DECIMAL(5,2),
  course_id INT,
  FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

/* Create Grades table */ 
CREATE TABLE Grades (
  grade_id INT PRIMARY KEY,
  assignment_id INT,
  student_id INT,
  score DECIMAL(5,2),
  FOREIGN KEY (assignment_id) REFERENCES 
  Assignment(assignment_id),
  FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

/* Insert values into tables: */

/* Insert values into Course table */
INSERT INTO Course (course_id, department, course_number, course_name, semester, year)
VALUES (1, 'CSCI', 432, 'Database Systems', 'Spring', 2024);

/* Insert values into Student table */
INSERT INTO Student (student_id, first_name, last_name, course_id)
VALUES (1, 'Jamie', 'Stevens', 1),
       (2, 'Monae', 'Adams', 1),
       (3, 'Alliston', 'Dunn', 1),
       (4, 'Sam', 'McQueen', 1);

/* Insert values into Assignment table */
INSERT INTO Assignment (assignment_id, category, percentage, course_id)
VALUES (1, 'Assignments', 15.0, 1),
       (2, 'Midterm', 30.0, 1),
       (3, 'Project', 15.0, 1),
       (4, 'Final Exam', 40.0, 1);

/* Insert values into Grades table */
INSERT INTO Grades (grade_id, assignment_id, student_id, score)
VALUES (1, 1, 1, 6.5),
       (2, 2, 1, 92.0),
       (3, 3, 1, 75.0),
       (4, 4, 1, 88.0),
       (5, 1, 2, 9.0),
       (6, 2, 2, 84.5),
       (7, 3, 2, 82.0),
       (8, 4, 2, 92.0),
       (9, 1, 3, 7.0),
       (10, 2, 3, 78.0),
       (11, 3, 3, 90.0),
       (12, 4, 3, 95.0),
       (13, 2, 4, 78.0),
       (14, 3, 4, 70.0),
       (15, 4, 4, 85.0);

/* 3. Show the tables with the contents that you have inserted */ 

SELECT * FROM Course;
SELECT * FROM Student;
SELECT * FROM Assignment;
SELECT * FROM Grades;

/* 5. Retrieve all students in a given course (e.g., course_id = 1): */

SELECT s.* FROM Student s
JOIN Course c ON s.course_id = c.course_id
WHERE c.course_id = 1;

/* 4. Retrieve average/highest/lowest score of an assignment (e.g., assignment_id = 2): */

/* Average score */
SELECT AVG(score) AS average_score
FROM Grades
WHERE assignment_id = 2;

/* Highest score */
SELECT MAX(score) AS highest_score
FROM Grades
WHERE assignment_id = 2;

/* Lowest score */
SELECT MIN(score) AS lowest_score
FROM Grades
WHERE assignment_id = 2;

/* 6. Retrieve all students in a given course and all of their scores on every assignmnet (e.g., course_id = 1): */
SELECT s.first_name, s.last_name, a.assignment_id, a.category, g.score
FROM Student s
JOIN Grades g ON s.student_id = g.student_id
JOIN Assignment a ON g.assignment_id = a.assignment_id
WHERE a.course_id = 1
ORDER BY s.last_name, s.first_name, a.assignment_id;

/* 7. Add an assignment to a course (e.g., course_id = 1): */

INSERT INTO Assignment (assignment_id, category, percentage, course_id)
VALUES (5, 'Extra Credit', 10.0, 1);

/* 8. Change the percentages of categories for a course (e.g., course_id = 1, new percentage for Homework = 30%): */

UPDATE Assignment
SET percentage = 30.0
WHERE category = 'Assignments' AND course_id = 1;

/* 9. Add 2 points to the score of each student on an assignment (e.g., assignment_id = 3) */

UPDATE Grades
SET score = score + 2
WHERE assignment_id = 3;

/* 10. Add 2 points to the score of students whose last name contains a 'Q' */

UPDATE Grades
SET score = score + 2
WHERE assignment_id = 1 AND student_id IN (
  SELECT student_id FROM Student s 
  WHERE s.last_name LIKE '%Q%'
);

SELECT s.first_name, s.last_name, g.score
FROM Student s
JOIN Grades g ON s.student_id = g.student_id
JOIN Assignment a ON g.assignment_id = a.assignment_id
WHERE s.last_name LIKE '%Q%';

/* 11. Compute the grade for a student (e.g., student_id = 1): */

SELECT s.first_name, s.last_name, SUM(a.percentage * g.score / 100) AS grade
FROM Student s
JOIN Grades g ON s.student_id = g.student_id
JOIN Assignment a ON g.assignment_id = a.assignment_id
WHERE s.student_id = 1
GROUP BY s.first_name, s.last_name;

/* 12. Compute the grade for a student, where the lowest score for a given category is dropped (e.g., student_id = 2): */ 

SELECT s.first_name, s.last_name, SUM((g.score - lowest_score.min_score) * a.percentage / 100) AS grade
FROM Student s
JOIN Grades g ON s.student_id = g.student_id
JOIN Assignment a ON g.assignment_id = a.assignment_id
JOIN (
    SELECT assignment_id, MIN(score) as min_score
    FROM Grades
    GROUP BY assignment_id
) lowest_score ON g.assignment_id = lowest_score.assignment_id AND g.score != lowest_score.min_score
WHERE s.student_id = 2
GROUP BY s.first_name, s.last_name;
