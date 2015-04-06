/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.Random;

/**
 * Populating question table
 *
 * @author Anup_Dell
 */
public class populateQuestionTable {

    /**
     * @param args the command line arguments
     */
    private static final String CHAR_LIST
            = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    private static final int RANDOM_STRING_LENGTH = 10;
	
	private static final int MAX_ARRAY_SIZE = 20000;

    public static void main(String[] args) {
        // TODO code application logic here
        try {
            populateQuestionTable populateTable = new populateQuestionTable();
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://localhost:5433/tempdata";

            Connection conn = DriverManager.getConnection(url, "postgres", "wipro123");

            // read all university ids
            String updateString = "Select discussionforumid, researcher_researcherid from question order by discussionforumid";
            PreparedStatement updateSales = null;
            ResultSet rs = null;
            updateSales = conn.prepareStatement(updateString);
            rs = updateSales.executeQuery();
            

            String url1 = "jdbc:postgresql://localhost:5433/Intell_v4";
            Connection conn1 = DriverManager.getConnection(url1, "postgres", "wipro123");

            int unicount = 0;
            long researcherids[] = new long[MAX_ARRAY_SIZE];
            long forumid[] = new long[MAX_ARRAY_SIZE];
            while (rs.next()) {
                forumid[unicount] = rs.getInt("discussionforumid");
                researcherids[unicount] = rs.getInt("researcher_researcherid");
                System.out.println(researcherids[unicount]);
                unicount++;
            }
            Random randomGenerator = new Random();
            for (int i = 0; i < unicount; i++) {
                updateString = "Select specialization_id,major from researcher where researcherid = " + researcherids[i];
                PreparedStatement sel = null;
                rs = null;
                sel = conn1.prepareStatement(updateString);
                rs = sel.executeQuery();
                int topicid = 0;
                int subtopic = 0;
                int numberofupvotes = randomGenerator.nextInt(200);
                int numberofdownvotes = randomGenerator.nextInt(50);
                while (rs.next()) {
                    topicid = rs.getInt("major");
                    subtopic = rs.getInt("specialization_id");
                }
                String sql = "Update question set subtopics_topics_topicid = " + topicid + ", subtopics_subtopicid=" + subtopic + ", numberofupvotes = " + numberofupvotes + ", numberofdownvotes = " + numberofdownvotes + ", description = \'" + populateTable.getDescription() + "\' where discussionforumid = " + forumid[i];
                PreparedStatement ps1 = conn.prepareStatement(sql);
        
                int val = ps1.executeUpdate();
                System.out.println(" updated : ");
            }
        } catch (Exception e) {
            System.err.print("Exception: ");
            System.err.println(e.getMessage());
            e.printStackTrace();
        }
    }

    public String generateRandomString(int wordlength) {

        StringBuffer randStr = new StringBuffer();
        for (int i = 0; i < wordlength; i++) {
            int number = getRandomNumber();
            char ch = CHAR_LIST.charAt(number);
            randStr.append(ch);
        }
        return randStr.toString();
    }

    private int getRandomNumber() {
        int randomInt = 0;
        Random randomGenerator = new Random();
        randomInt = randomGenerator.nextInt(CHAR_LIST.length());
        if (randomInt - 1 == -1) {
            return randomInt;
        } else {
            return randomInt - 1;
        }
    }

    String getDescription() {
        String description = null;
        Random randomGenerator = new Random();
        //randomInt = randomGenerator.nextInt(CHAR_LIST.length());
        int desLen = randomGenerator.nextInt(2000);
        if (desLen < 50) {
            desLen = desLen + 100;
        }
        int worldLen = randomGenerator.nextInt(10);
        while (desLen > 10) {
            String word = generateRandomString(worldLen);
            if (description == null) {
                description = word;
            } else {
                description = description + " " + word;
            }
            desLen = desLen - word.length();
            worldLen = randomGenerator.nextInt(10);
        }
        if (description.length() > 1997) {
            description = description.substring(0, 1997);
        }
        description = description + ".";

        
        return description;
    }
}
