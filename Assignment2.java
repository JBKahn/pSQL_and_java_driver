//package assignment2;
import java.sql.*;
import java.io.*;

/**
 * Joseph Kahn - 997595883
 * Patricia Teodora B. Yambao - 998319127
 * @author
 */
public class Assignment2 {
   
    private Connection dbConnection;
    private Statement sql;
    private PreparedStatement ps;
    private ResultSet rs;
   
    /**
     * Identify the postgreSQL driver using method Class.forName.
     */
    public Assignment2() {
        try {
            Class.forName("org.postgresql.Driver");
         }catch (ClassNotFoundException e) {
                        return;
                    }
    }
 
    /**
     * Connect to a database, saving the Connection in dbConnection.
     *
     * @param URL - URL of the database
     * @param username - username for the database
     * @param password - password for the database
     * @return true iff the connection was made successfully.
     */
    boolean connectDB(String URL, String username, String password) {
      try {
            this.dbConnection = DriverManager.getConnection(URL, username, password);
            this.sql = dbConnection.createStatement();
        }
        catch (SQLException e) {
            return false;
        }
        return true;
    }
 
    /**
     * Disconnect from the database we are currently connected to.
     *
     * @return true iff the connection was closed successfully.
     */
    boolean disconnectDB() {
      try {
            this.dbConnection.close();
            this.sql.close();
        }
        catch (SQLException e) {
            return false;
        }
        return true;
    }
 
    /**
    * Insert a student into the database.
    * 
    * @param sid - The student's id number.
    * @param lastName - The last name of the student.
    * @param firstName - The first name of the student.
    * @param age - The age of the student.
    * @param sex - The sex (either 'M' or 'F').
    * @param dname - The name of the department to which the student belongs.
    * @param yearOfStudy - The student's year of study.
    * @return true iff the insertion was successful.
    */
    boolean insertStudent(
        int sid, 
        String lastName, 
        String firstName, 
        int age,
        String sex, 
        String dname, 
        int yearOfStudy)
    {
        try {
            String dcode = "";
            String query = String.format("SELECT dcode FROM department WHERE dname = '%s';", dname);
            ResultSet rs = sql.executeQuery(query);
            if (rs.next()) {
                dcode = rs.getString("dcode");
            } else {
                return false;
            }
            
            query = String.format("SELECT sid FROM student WHERE sid = %d;", sid);
            rs = sql.executeQuery(query);
            if (rs.next()) {
                return false;
            }
            
            if (!(("M".equals(sex) || "F".equals(sex)) && (yearOfStudy > 0 && yearOfStudy < 7) )  ){
                return false;
            }  
            rs.close();

            query = String.format("INSERT INTO student VALUES (%d, '%s', '%s', '%s', %d, '%s', %d);",
                sid, lastName, firstName, sex, age, dcode, yearOfStudy);
            this.sql.executeUpdate(query);
        }
        catch (SQLException e) {
            return false;
        }
        return true;
    }

    /**
    * Returns the number of students in department dname.
    *
    * @param dname - The name of a department.
    * @return the number of students in department dname or -1 in the event of an error.
    *       
    */
    int getStudentsCount(String dname) 
    {
        int studentcount = 0;
        try{
            String query = String.format("SELECT * FROM department D WHERE D.dname = '%s';", dname);
            rs = this.sql.executeQuery(query);
            if (!(rs.next())) {
                rs.close();
                return -1;
            }

            query = String.format("SELECT count(*) FROM student S, department D " + 
                "WHERE S.dcode = D.dcode AND D.dname = '%s';", dname);
            rs = this.sql.executeQuery(query);
            if (rs.next()) {
                studentcount = rs.getInt("count");
            }
            rs.close();
        }catch (SQLException e) {
            return -1;
        }
        return studentcount;
    }

    /**
    * Returns the info of student with the student number sid.
    *
    * @param sid - The sid of the student.
    * @return the student's information or an empty string in the event that the student does not exist.
    *       
    */
    String getStudentInfo(int sid)
    {
        String student = "";
        try{
            String query = String.format("SELECT * FROM student S, department D WHERE D.dcode = S.dcode AND sid = %d;", sid);
            rs = this.sql.executeQuery(query);
            if (rs.next()) {
                student = (rs.getString("sfirstname").trim() + ":" + rs.getString("slastname").trim() + ":" + rs.getString("sex").trim() + ":" + 
                    rs.getInt("age") + ":" + rs.getInt("yearofstudy") + ":" + rs.getString("dcode").trim());
            }
            rs.close();
        }catch (SQLException e) {
            return "";
        }
        return student;
    }
 
    /**
    * Return true if the department with dcode, dcoode, was renamed newName.
    *
    * @param dcode - The dcode of the department to be renamed.
    * @param newName - The new department name.
    * @return true iff the department was successfully renamed.
    *       
    */
    boolean chgDept(String dcode, String newName)
    {
        try{
            String query = String.format("SELECT * FROM department WHERE dcode = '%s';",dcode);
            ResultSet rs = this.sql.executeQuery(query);
            if (!rs.next()) {
                return true;
            }
            rs.close();
            query = String.format("UPDATE department SET dname = '%s' WHERE dcode = '%s';", newName, dcode);
            this.sql.executeUpdate(query);
        }catch (SQLException e) {
            return false;
        }
        return true;
    }

    /**
    * Return true if the department with dcode, dcoode, was deleted.
    *
    * @param dcode - The dcode of the department to be deleted.
    * @return true iff the department was successfully deleted.
    *       
    */
    boolean deleteDept(String dcode)
    {
        String query;
        try{
            query = String.format("SELECT * FROM department WHERE dcode = '%s';", dcode);
            ResultSet rs = this.sql.executeQuery(query);
            if (!rs.next()) {
                return true;
            }
            rs.close();
        }catch (SQLException e) {
            return false;
        }
        try{
            query = String.format("DELETE FROM studentCourse WHERE sid IN " +
            "(SELECT sid FROM student WHERE dcode = '%s');", dcode);
            sql.executeUpdate(query);
        }catch (SQLException e) {}
        try{
            query = String.format("DELETE FROM student WHERE dcode = '%s';",dcode);
            sql.executeUpdate(query);
        }catch (SQLException e) {}
        try{
            query = String.format("DELETE FROM courseSection WHERE dcode = '%s';",dcode);
            sql.executeUpdate(query);
        }catch (SQLException e) {}
        try{
            query = String.format("DELETE FROM instructor WHERE dcode = '%s';",dcode);
            sql.executeUpdate(query);
        }catch (SQLException e) {}
        try{
            query = String.format("DELETE FROM prerequisites WHERE dcode = '%s';",dcode);
            sql.executeUpdate(query);
        }catch (SQLException e) {}
        try{
            query = String.format("DELETE FROM course WHERE dcode = '%s';",dcode);
            sql.executeUpdate(query);
        }catch (SQLException e) {}
        try{
            query = String.format("DELETE FROM department WHERE dcode = '%s';",dcode);
            sql.executeUpdate(query);
        }catch (SQLException e) {}
        return true;
    }

    /**
    * Returns a string with all the courses a student with student id sid has taken.
    *
    * @param sid - The sid of the student.
    * @return a string with all the courses a student with student id sid has taken, if 
    * the student doesn't exist then the empty string is returned.
    *       
    */
    String listCourses(int sid)
    {
        String courses = "";
        try{
            String query = String.format("SELECT C.cname, D.dname, CS.semester, CS.year" + 
            ", SC.grade FROM course C, courseSection CS, department D, " +
                "studentCourse SC WHERE CS.dcode = C.dcode AND CS.cid = C.cid AND " + 
                "D.dcode = C.dcode AND SC.csid = CS.csid AND SC.sid = %d;", sid);
            rs = this.sql.executeQuery(query);
            while (rs.next()) {
                courses += (rs.getString("cname").trim() + ":" + rs.getString("dname").trim() + ":" + 
                    rs.getInt("semester") + ":" + rs.getInt("year") + ":" + 
                    rs.getInt("grade") + "#");
            }
            rs.close();
        }catch (SQLException e) {
            System.out.println("failure");
        }
        return courses;
    }

    /**
    * Increases the grades of all the students who took a course in the course section identified by csid by 10% :)
    * Note: A student's mark may not go above 100.
    *
    * @param csid - The course section id.
    * @return Returns true if the update was successful, false otherwise.
    *       
    */
    boolean updateGrades(int csid)
    {
        try{
            String query = String.format("UPDATE studentCourse SET grade = 100 WHERE 1.1*grade > 100 AND csid = %d;", csid);
            this.sql.executeUpdate(query);
            query = String.format("UPDATE studentCourse SET grade = grade * 1.1 WHERE 1.1*grade <= 100 AND grade >= 0 AND csid = %d;", csid);
            this.sql.executeUpdate(query);

        }catch (SQLException e) {
            return false;
        }
        return true;
    }

    /**
     * Return the course with the highest average mark and the lowest averge mark from the 'Computer Science' department
     * which has had an enrollment of at least 3 students.
     * 
     * @return the course with the highest average mark and the lowest averge mark from the 'Computer Science' department
     * which has had an enrollment of at least 3 students.     
     */
    String query7()
    {
        String grades = "";
        try{
            String query = "CREATE VIEW courseaverages AS " +
            "SELECT c.cname, CS.semester, CS.year, AVG(SC.grade) AS avggrd " +
            "FROM course C, courseSection CS, department D, studentCourse SC " +
            "WHERE CS.dcode = C.dcode AND CS.cid = C.cid AND D.dcode = C.dcode AND SC.csid = CS.csid AND D.dname = 'Computer Science' " +
            "GROUP BY CS.csid, c.cname " + 
            "HAVING COUNT(SC.sid) > 2;" ;
            this.sql.executeUpdate(query);
            query = ("SELECT cname, semester, year, avggrd FROM courseaverages WHERE avggrd in " + 
                "(SELECT MAX(avggrd) FROM courseaverages) OR avggrd in (SELECT MIN(avggrd) FROM courseaverages);");
            rs = this.sql.executeQuery(query);
            while (rs.next()) {
                grades = rs.getString("cname") + ":" + rs.getInt("semester") + ":" + rs.getInt("year") + ":" + rs.getInt("avggrd") + '#';
            }
            rs.close();
            query = "DROP VIEW courseaverages;" ;
            this.sql.executeUpdate(query);
        } catch (SQLException e) {
        }
        return grades;
    }


    /**
     * Create a table containing all the female students in the .Computer Science. department who are in their fourth year
     * of study. The name of the table is femaleStudents and the attibutes are: 
     * sid INTEGER (student id), fname CHAR (20) (first name), lname CHAR (20) (last name)
     * 
     * @return true if the database was successfully updated, false otherwise.   
     */
    boolean updateDB()
    {
        String insertion = "";
        String query = "CREATE TABLE femaleStudents (sid INTEGER PRIMARY KEY, fname CHAR(20) NOT NULL, lname CHAR(20) NOT NULL," 
                    + "FOREIGN KEY (sid) REFERENCES student(sid) ON DELETE RESTRICT);";
        try {
            sql.executeUpdate(query);
            query = "SELECT sid, slastname, sfirstname FROM student WHERE sex = 'F' AND yearofstudy = 4;";
            rs = this.sql.executeQuery(query);
        
            if (rs.next()) {
                insertion = String.format("INSERT INTO femaleStudents VALUES (%d, '%s', '%s');",
                    rs.getInt("sid"), rs.getString("slastname"), rs.getString("sfirstname"));
                this.sql.executeUpdate(insertion);
            }
            rs.close();
        } catch (SQLException e) {
            return false;
        }
        return true;
    }
    
    public static void main(String[] args) {
    Assignment2 a = new Assignment2();
    a.connectDB("jdbc:postgresql://localhost:5432/csc343h-g1boggyp", "g1boggyp", "database");
    //a.insertStudent(12345, "Kahn", "Joe", 22, "F", "Computer Science", 4);
    //a.insertStudent(12345, "Kahndasdasdasdasdasdasdaddadasdasdasdas", "Joe", 22, "F", "Computer Science", 4);
    //a.insertStudent(12345, "Kahn", "Joe", 22, "X", "Computer Science", 4);
    //a.insertStudent(12345, "Kahn", "Joe", 22, "F", "Cats", 4);
    //a.insertStudent(12345, "Kahn", "Joe", 22, "F", "Computer Science", 9);
    //a.insertStudent(12345, "Kahn", "Joe", 22, "F", "Computer Science", -1);
    //a.getStudentsCount("Computer Science");
    //a.getStudentsCount("cats");
    //a.chgDept("999", "Cool Dept");
    //a.chgDept("789", "Cool Dept");
    //a.deleteDept("998");
    //a.deleteDept("123");
    //System.out.println(a.listCourses(7));
    //System.out.println(a.listCourses(5664654));
    //System.out.println(a.listCourses(21));
    //System.out.println(a.listCourses(7));
    //a.query7();
    //a.updateGrades(100006);
    //a.query7();
    //System.out.println(a.getStudentInfo(21));
    //System.out.println(a.getStudentInfo(34343));
    //System.out.println(a.getStudentInfo(7));
    //a.updateDB();
    a.disconnectDB();
    }
}
