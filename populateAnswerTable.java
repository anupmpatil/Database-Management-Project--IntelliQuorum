/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;

/**
 * POPULATING answerthread table. Question has answer. Answers may have replies.
 * Program assumes that each question has 10 answers. Randomly some number n of
 * them will answers to questions and rest (10 - n) will be answers to answers.
 *
 * @author Anup_Dell
 */
public class populateAnswerTable {

    /**
     * @param args the command line arguments
     */
    private static final String CHAR_LIST
            = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    private static final int RANDOM_STRING_LENGTH = 10;
    private static final int MAX_ARRAY_LENGTH = 20000;

    public static void main(String[] args) {
        // TODO code application logic here
        try {
            populateAnswerTable ja = new populateAnswerTable();
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://localhost:5433/Intell_v4";

            Connection conn = DriverManager.getConnection(url, "postgres", "wipro123");

            // read all university ids
            String updateString = "Select discussionforumid, researcher_researcherid, subtopics_subtopicid, subtopics_topics_topicid from question order by discussionforumid";
            PreparedStatement updateSales = null;
            ResultSet rs = null;
            updateSales = conn.prepareStatement(updateString);
            rs = updateSales.executeQuery();
            int unicount = 0;
            long researcherids[] = new long[MAX_ARRAY_LENGTH];
            long forumid[] = new long[MAX_ARRAY_LENGTH];
            long majorid[] = new long[MAX_ARRAY_LENGTH];
            long subid[] = new long[MAX_ARRAY_LENGTH];
            while (rs.next()) {
                forumid[unicount] = rs.getInt("discussionforumid");
                researcherids[unicount] = rs.getInt("researcher_researcherid");
                majorid[unicount] = rs.getInt("subtopics_topics_topicid");
                subid[unicount] = rs.getInt("subtopics_subtopicid");
                System.out.println(researcherids[unicount]);
                unicount++;
            }
            long answerid = 0;
            Random randomGenerator = new Random();

            // FOR EACH QUESTION
            for (int i = 0; i < unicount; i++) {
                int ansNum = 10;
                long replierid[] = new long[10];
                int replierCnt = 0;

                // ASSUMING QUESTIONS WILL BE ANSWERED BY RESEARCHER WITH SAME SPECIALIZATION OR RESEARCHER WITH SAME MAJOR
                updateString = "Select researcherid from researcher where specialization_id = " + subid[i];
                updateSales = null;
                rs = null;
                updateSales = conn.prepareStatement(updateString);
                rs = updateSales.executeQuery();

                boolean moreRepNeeded = true;

                while (rs.next()) {
                    replierid[replierCnt] = rs.getInt("researcherid");
                    replierCnt++;
                    if (replierCnt > 9) {
                        moreRepNeeded = false;
                        break;
                    }
                }

                if (moreRepNeeded) {
                    updateString = "Select researcherid from researcher where major = " + majorid[i];
                    updateSales = null;
                    rs = null;
                    updateSales = conn.prepareStatement(updateString);
                    rs = updateSales.executeQuery();
                    while (rs.next()) {
                        replierid[replierCnt] = rs.getInt("researcherid");
                        replierCnt++;
                        if (replierCnt > 9) {
                            moreRepNeeded = false;
                            break;
                        }
                    }
                }

                //immediate parents
                int num = randBetween(1, 5);
                int loopsize = replierid.length - num;
                long insertedIds[] = new long[loopsize];
                int ins = 0;

                // IMMEDIATE ANSWERS
                for (int k = 0; k < loopsize; k++) {
                    System.out.println("Inserting ...");

                    String sql = "INSERT INTO answerthread(question_discussionforumid, answerid, answer, numberofupvotes, numberofdownvotes, replierid) VALUES(?, ?, ?, ?, ?, ?)";
                    PreparedStatement ps1 = conn.prepareStatement(sql);
                    ps1.setLong(1, forumid[i]);
                    ps1.setLong(2, answerid);
                    ps1.setString(3, ja.getDescription());
                    int numberofupvotes = randomGenerator.nextInt(200);
                    int numberofdownvotes = randomGenerator.nextInt(50);
                    ps1.setInt(4, numberofupvotes);
                    ps1.setInt(5, numberofdownvotes);
                    ps1.setLong(6, replierid[k]);
                    insertedIds[ins] = answerid;
                    ins++;
                    int val = ps1.executeUpdate();
                    System.out.println(researcherids[i] + " inserted : ");
                    answerid++;

                }

                // ANSWERS TO ANSWERS
                for (int j = 0; j < num; j++) {
                    System.out.println("Inserting ...");

                    String sql = "INSERT INTO answerthread(question_discussionforumid, answerid, immediateparentanswerid, answer, numberofupvotes, numberofdownvotes, replierid) VALUES(?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement ps1 = conn.prepareStatement(sql);
                    ps1.setLong(1, forumid[i]);
                    ps1.setLong(2, answerid);
                    int index = randBetween(0, (insertedIds.length - 1));
                    ps1.setLong(3, insertedIds[index]);

                    ps1.setString(4, ja.getDescription());
                    int numberofupvotes = randomGenerator.nextInt(200);
                    int numberofdownvotes = randomGenerator.nextInt(50);
                    ps1.setInt(5, numberofupvotes);
                    ps1.setInt(6, numberofdownvotes);
                    ps1.setLong(7, replierid[loopsize]);
                    loopsize++;
        //insertedIds[ins] = answerid;
                    //ins ++;
                    int val = ps1.executeUpdate();
                    System.out.println(researcherids[i] + " inserted : ");
                    answerid++;
                }
            }

        } catch (Exception e) {
            System.err.print("Exception: ");
            System.err.println(e.getMessage());
            e.printStackTrace();
        }

    }

    public static int randBetween(int start, int end) {
        return start + (int) Math.round(Math.random() * (end - start));
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
        if (description.length() > 2997) {
            description = description.substring(0, 2997);
        }
        description = description + ".";

        return description;
    }
}
