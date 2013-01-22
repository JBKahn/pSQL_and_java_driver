DROP TABLE student CASCADE;
DROP TABLE department CASCADE;
DROP TABLE instructor CASCADE;
DROP TABLE course CASCADE;
DROP TABLE courseSection CASCADE;
DROP TABLE studentCourse CASCADE;
DROP TABLE prerequisites CASCADE;

-- The department table contains the departments at the university
CREATE TABLE department (
        dcode       CHAR(3) PRIMARY KEY,
        dname       VARCHAR(20) NOT NULL);

-- The student table contains information about the students at the univerity.
-- sid is the student number.
-- sex is either 'M' or 'F'
-- yearofstudy is the student's current year at the university. One of 1 or 2 or 3 or 4 or 5. 
CREATE TABLE student (
        sid         INTEGER PRIMARY KEY,
        slastname   CHAR(20) NOT NULL,
        sfirstname  CHAR(20) NOT NULL,
        sex	    CHAR(1)  NOT NULL,
        age 	    INTEGER  NOT NULL,
	dcode       CHAR(3)  NOT NULL, 
        yearofstudy INTEGER  NOT NULL,
	FOREIGN KEY (dcode) REFERENCES department(dcode) ON DELETE RESTRICT);

-- The instructor table contains information about the instructors at the university.
-- iid is the instructor employee id.
-- idegree is the highest post-graduate degree held by the instructor. It can be one of "PHD" or "MSC" or "BSC".
-- an instructor can only be associated with one department.
CREATE TABLE instructor (
        iid         INTEGER PRIMARY KEY,
        ilastname   CHAR(20) NOT NULL,
        ifirstname  CHAR(20) NOT NULL,
        idegree	    CHAR (5) NOT NULL,
        dcode	    CHAR(3)  NOT NULL,
        FOREIGN KEY (dcode) REFERENCES department(dcode) ON DELETE RESTRICT);
	
-- The course table contains the courses offered at the university.
CREATE TABLE course (
        cid         INTEGER,
        dcode	    CHAR(3) REFERENCES DEPARTMENT(dcode) ON DELETE RESTRICT,
        cname	    CHAR(20) NOT NULL,
        PRIMARY KEY (cid, dcode));

-- The courseSection table contains the sections that are offered 
-- for courses at the university for each semester of each year.
-- Semester values are '9' fall, '1' winter, and '5' summer.
-- Section is things like "L0101"
CREATE TABLE courseSection (
        csid        INTEGER PRIMARY KEY,
        cid         INTEGER NOT NULL,
        dcode       CHAR(3) NOT NULL,
        year	    INTEGER NOT NULL,
        semester    INTEGER NOT NULL,
        section	    CHAR(5) NOT NULL,
        iid         INTEGER REFERENCES instructor(iid),
        FOREIGN KEY (cid, dcode) REFERENCES course(cid, dcode), 
        UNIQUE (cid, dcode, year, semester, section));

-- The studentCourse table contains the courses a student has enrolled in, and their grade.
-- the grade is maintained as an integer value from 0 to 100.
CREATE TABLE studentCourse (
        sid         INTEGER REFERENCES student(sid),
        csid	    INTEGER REFERENCES courseSection(csid),
        grade	    INTEGER NOT NULL DEFAULT -1,
        PRIMARY KEY (sid, csid));

-- The prerequisites table contains the prerequisites for each course.  There may be more than
-- one per course.  The course for which the prerequisite applies is identified by (cid, dcode).
-- The prerequisite for that course is identified by (pcid, pcode).
CREATE TABLE prerequisites (
        cid	    INTEGER  NOT NULL,
        dcode	    CHAR (3) NOT NULL,
        pcid	    INTEGER  NOT NULL,
        pdcode      CHAR(3)  NOT NULL,
        FOREIGN KEY (cid, dcode) REFERENCES course(cid, dcode),
        FOREIGN KEY (pcid, pdcode) REFERENCES course(cid, dcode),
        PRIMARY KEY (cid, dcode,pcid, pdcode));


INSERT INTO department VALUES (999, 'Rename Me');
INSERT INTO department VALUES (998, 'Delete Me');
INSERT INTO department VALUES (123, 'Computer Science');
INSERT INTO department VALUES (110, 'Math');
INSERT INTO department VALUES (223, 'Philosophy');
INSERT INTO department VALUES (210, 'Biology');

INSERT INTO student VALUES (1, 'kahn', 'joe', 'F', 20, '123', 4);
INSERT INTO student VALUES (2, 'kahn', 'jill', 'F', 23, '110', 4);
INSERT INTO student VALUES (3, 'kahn', 'john', 'M', 21, '110', 3);
INSERT INTO student VALUES (4, 'kahn', 'jane', 'F', 24, '123', 3);
INSERT INTO student VALUES (5, 'Zadrian', 'aaron', 'M', 21, '110', 2);
INSERT INTO student VALUES (6, 'Zadrian', 'alyssa', 'F', 24, '123', 2);
INSERT INTO student VALUES (7, 'Zadrian', 'abe', 'M', 20, '123', 1);
INSERT INTO student VALUES (8, 'Zadrian', 'alexa', 'F', 23, '110', 1);
INSERT INTO student VALUES (11, 'Patric', 'joe', 'M', 20, '223', 4);
INSERT INTO student VALUES (12, 'Patric', 'jill', 'F', 23, '210', 4);
INSERT INTO student VALUES (13, 'Patric', 'john', 'M', 21, '210', 3);
INSERT INTO student VALUES (14, 'Patric', 'jane', 'F', 24, '223', 3);
INSERT INTO student VALUES (15, 'Pizza', 'aaron', 'M', 21, '210', 2);
INSERT INTO student VALUES (16, 'Pizza', 'alyssa', 'F', 24, '223', 2);
INSERT INTO student VALUES (17, 'Pizza', 'abe', 'M', 20, '223', 1);
INSERT INTO student VALUES (18, 'Pizza', 'alexa', 'F', 23, '210', 1);
INSERT INTO student VALUES (21, 'Sisco', 'Fran', 'M', 99, '210', 1);

INSERT INTO instructor VALUES (1, 'Kirk', 'James', 'PHD', '123');
INSERT INTO instructor VALUES (2, 'errrr', 'Spock', 'PHD', '123');
INSERT INTO instructor VALUES (3, 'McCoy', 'Leonard', 'PHD', '123');
INSERT INTO instructor VALUES (4, 'errrr', 'Worf', 'BSC', '123');
INSERT INTO instructor VALUES (5, 'Jean-Luc', 'Picard', 'MSC', '123');

INSERT INTO instructor VALUES (11, 'Raynor', 'James', 'PHD', '110');
INSERT INTO instructor VALUES (12, 'Kerrigan', 'Sarah', 'BSC', '110');
INSERT INTO instructor VALUES (13, 'Tassadar', 'Something', 'MSC', '110');
INSERT INTO instructor VALUES (14, 'Zeratul', 'Something', 'MSC', '110');
INSERT INTO instructor VALUES (15, 'Mengsk', 'Arcturus', 'MSC', '110');

INSERT INTO instructor VALUES (21, 'Who', 'Doctor', 'PHD', '223');
INSERT INTO instructor VALUES (22, 'Jane', 'Sarah', 'BSC', '223');
INSERT INTO instructor VALUES (23, 'Davros', 'Emperor', 'MSC', '223');
INSERT INTO instructor VALUES (24, 'Harkness', 'Jack', 'BSC', '223');
INSERT INTO instructor VALUES (25, 'Mott', 'Wilifred', 'MSC', '223');

INSERT INTO instructor VALUES (31, 'Reynolds', 'Malcolm', 'PHD', '210');
INSERT INTO instructor VALUES (32, 'Cobb', 'Jayne', 'BSC', '210');
INSERT INTO instructor VALUES (33, 'Frye', 'Kaylee', 'MSC', '210');
INSERT INTO instructor VALUES (34, 'Washburne', 'Zoe', 'PHD', '210');
INSERT INTO instructor VALUES (35, 'Washburne', 'Hoban', 'MSC', '210');

INSERT INTO course VALUES (1234, '123', 'a Python');
INSERT INTO course VALUES (1235, '123', 'Java Time');
INSERT INTO course VALUES (1236, '123', 'C++ is a gogo');
INSERT INTO course VALUES (1237, '123', 'Databasin');

INSERT INTO course VALUES (1233, '110', 'summer only');
INSERT INTO course VALUES (1234, '110', 'Algebra');
INSERT INTO course VALUES (1235, '110', 'Math Blaster');
INSERT INTO course VALUES (1236, '110', 'Linear Algebra');
INSERT INTO course VALUES (1237, '110', 'Statistics');

INSERT INTO course VALUES (1234, '223', 'Does God Exist');
INSERT INTO course VALUES (1235, '223', 'Mean To Exist');
INSERT INTO course VALUES (1236, '223', 'P and Not P');
INSERT INTO course VALUES (1237, '223', 'Can We Get Jobs');

INSERT INTO course VALUES (1234, '210', 'Cells');
INSERT INTO course VALUES (1235, '210', 'Physiology');
INSERT INTO course VALUES (1236, '210', 'Genetics');
INSERT INTO course VALUES (1237, '210', 'Diseases');

INSERT INTO courseSection VALUES (100001, 1234, '123', 2000, 9, 'L0101', 1);
INSERT INTO courseSection VALUES (100002, 1234, '123', 2000, 5, 'L0102', 2);

INSERT INTO courseSection VALUES (100003, 1235, '123', 2000, 9, 'L0101', 1);
INSERT INTO courseSection VALUES (100004, 1235, '123', 2000, 5, 'L0101', 1);
INSERT INTO courseSection VALUES (100005, 1235, '123', 2000, 1, 'L0101', 3);

INSERT INTO courseSection VALUES (100006, 1236, '123', 2001, 5, 'L0101', 1);
INSERT INTO courseSection VALUES (100007, 1236, '123', 2000, 1, 'L0101', 5);

INSERT INTO courseSection VALUES (100008, 1237, '123', 2001, 5, 'L0101', 4);
INSERT INTO courseSection VALUES (100009, 1237, '123', 2002, 9, 'L0101', 4);
INSERT INTO courseSection VALUES (100010, 1237, '123', 2002, 1, 'L0101', 5);


INSERT INTO courseSection VALUES (200091, 1233, '110', 2000, 5, 'L0101', 11);

INSERT INTO courseSection VALUES (200001, 1234, '110', 2000, 9, 'L0101', 11);
INSERT INTO courseSection VALUES (200002, 1234, '110', 2000, 5, 'L0102', 12);

INSERT INTO courseSection VALUES (200003, 1235, '110', 2000, 9, 'L0101', 11);
INSERT INTO courseSection VALUES (200004, 1235, '110', 2000, 5, 'L0101', 11);
INSERT INTO courseSection VALUES (200005, 1235, '110', 2000, 1, 'L0101', 13);

INSERT INTO courseSection VALUES (200006, 1236, '110', 2001, 5, 'L0101', 11);
INSERT INTO courseSection VALUES (200007, 1236, '110', 2000, 1, 'L0101', 15);

INSERT INTO courseSection VALUES (200008, 1237, '110', 2001, 5, 'L0101', 14);
INSERT INTO courseSection VALUES (200009, 1237, '110', 2002, 9, 'L0101', 14);
INSERT INTO courseSection VALUES (200010, 1237, '110', 2002, 1, 'L0101', 15);



INSERT INTO courseSection VALUES (300001, 1234, '223', 2000, 9, 'L0101', 21);
INSERT INTO courseSection VALUES (300002, 1234, '223', 2000, 5, 'L0102', 22);

INSERT INTO courseSection VALUES (300003, 1235, '223', 2000, 9, 'L0101', 21);
INSERT INTO courseSection VALUES (300004, 1235, '223', 2000, 5, 'L0101', 21);
INSERT INTO courseSection VALUES (300005, 1235, '223', 2000, 1, 'L0101', 23);

INSERT INTO courseSection VALUES (300006, 1236, '223', 2001, 5, 'L0101', 21);
INSERT INTO courseSection VALUES (300007, 1236, '223', 2000, 1, 'L0101', 25);

INSERT INTO courseSection VALUES (300008, 1237, '223', 2001, 5, 'L0101', 24);
INSERT INTO courseSection VALUES (300009, 1237, '223', 2002, 9, 'L0101', 24);
INSERT INTO courseSection VALUES (300010, 1237, '223', 2002, 1, 'L0101', 25);


INSERT INTO courseSection VALUES (400001, 1234, '210', 2000, 9, 'L0101', 31);
INSERT INTO courseSection VALUES (400002, 1234, '210', 2000, 5, 'L0102', 32);

INSERT INTO courseSection VALUES (400003, 1235, '210', 2000, 9, 'L0101', 31);
INSERT INTO courseSection VALUES (400004, 1235, '210', 2000, 5, 'L0101', 31);
INSERT INTO courseSection VALUES (400005, 1235, '210', 2000, 1, 'L0101', 33);

INSERT INTO courseSection VALUES (400006, 1236, '210', 2001, 9, 'L0101', 31);
INSERT INTO courseSection VALUES (400007, 1236, '210', 2000, 1, 'L0101', 35);

INSERT INTO courseSection VALUES (400008, 1237, '210', 2001, 5, 'L0101', 34);
INSERT INTO courseSection VALUES (400009, 1237, '210', 2002, 9, 'L0101', 34);
INSERT INTO courseSection VALUES (400010, 1237, '210', 2002, 1, 'L0101', 35);



INSERT INTO studentCourse VALUES (1, 100001, 96);

INSERT INTO studentCourse VALUES (4, 100001, 87);
INSERT INTO studentCourse VALUES (4, 100003, 93);
INSERT INTO studentCourse VALUES (4, 100006, 53);

INSERT INTO studentCourse VALUES (6, 100001, 67);
INSERT INTO studentCourse VALUES (6, 100003, 43);
INSERT INTO studentCourse VALUES (6, 100006, 43);

INSERT INTO studentCourse VALUES (7, 100001, 95);
INSERT INTO studentCourse VALUES (7, 100003, 95);
INSERT INTO studentCourse VALUES (7, 100006, 68);
INSERT INTO studentCourse VALUES (7, 100008, 46);

INSERT INTO studentCourse VALUES (2, 200001, 96);

INSERT INTO studentCourse VALUES (3, 200001, 87);
INSERT INTO studentCourse VALUES (3, 200003, 93);
INSERT INTO studentCourse VALUES (3, 200006, 53);

INSERT INTO studentCourse VALUES (5, 200001, 67);
INSERT INTO studentCourse VALUES (5, 200003, 43);
INSERT INTO studentCourse VALUES (5, 200006, 43);

INSERT INTO studentCourse VALUES (8, 200001, 95);
INSERT INTO studentCourse VALUES (8, 200003, 95);
INSERT INTO studentCourse VALUES (8, 200006, 68);
INSERT INTO studentCourse VALUES (8, 200008, 46);

INSERT INTO studentCourse VALUES (11, 300001, 96);

INSERT INTO studentCourse VALUES (14, 300001, 87);
INSERT INTO studentCourse VALUES (14, 300003, 93);
INSERT INTO studentCourse VALUES (14, 300006, 53);

INSERT INTO studentCourse VALUES (16, 300001, 67);
INSERT INTO studentCourse VALUES (16, 300003, 43);
INSERT INTO studentCourse VALUES (16, 300006, 43);

INSERT INTO studentCourse VALUES (17, 300001, 95);
INSERT INTO studentCourse VALUES (17, 300003, 95);
INSERT INTO studentCourse VALUES (17, 300006, 68);
INSERT INTO studentCourse VALUES (17, 300008, 46);

INSERT INTO studentCourse VALUES (12, 400001, 96);

INSERT INTO studentCourse VALUES (13, 400001, 87);
INSERT INTO studentCourse VALUES (13, 400003, 93);
INSERT INTO studentCourse VALUES (13, 400006, 53);

INSERT INTO studentCourse VALUES (15, 400001, 67);
INSERT INTO studentCourse VALUES (15, 400003, 43);
INSERT INTO studentCourse VALUES (15, 400006, 43);

INSERT INTO studentCourse VALUES (18, 400001, 95);
INSERT INTO studentCourse VALUES (18, 400003, 95);
INSERT INTO studentCourse VALUES (18, 400006, 68);
INSERT INTO studentCourse VALUES (18, 400008, 46);

INSERT INTO prerequisites VALUES (1235, '210', 1234, '210');
INSERT INTO prerequisites VALUES (1236, '210', 1235, '210');
INSERT INTO prerequisites VALUES (1237, '210', 1236, '210');

INSERT INTO prerequisites VALUES (1235, '123', 1234, '210');
