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
 * POPULATING personalweblink, researcher_has_personalweblink
 * @author Anup_Dell
 */
public class populateResearchTable {

    /**
     * @param args the command line arguments
     */
    
    private static final String CHAR_LIST =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    private static final int RANDOM_STRING_LENGTH = 10;
	private static final int MAX_ARRAY_SIZE = 300000;
    
    public static void main(String[] args) {
        // TODO code application logic here
        try{
            populateResearchTable ja = new populateResearchTable();
            Class.forName("org.postgresql.Driver");
	    String url = "jdbc:postgresql://localhost:5433/Intell_v4";
            
	    Connection conn = DriverManager.getConnection(url,"postgres","wipro123");
            
            // read all university ids
            String updateString = "Select r.researcherid, u.firstname, u.lastname from researcher r, users u where r.researcherid = u.userid order by researcherid";
            PreparedStatement updateSales = null;
            ResultSet rs = null;
            updateSales = conn.prepareStatement(updateString);
            rs = updateSales.executeQuery();
            int unicount = 0;
            long researcherids[] = new long[MAX_ARRAY_SIZE];
            String firstname[] = new String[MAX_ARRAY_SIZE];
            String lastname[] = new String[MAX_ARRAY_SIZE];
            
            while (rs.next())
            {
                researcherids[unicount] = rs.getInt("researcherid");
                firstname[unicount] = rs.getString("firstname");
                lastname[unicount] = rs.getString("lastname");
                System.out.println(researcherids[unicount]);
                unicount++;
            }
            long answerid = 0;
            Random randomGenerator = new Random();
            String httpStart = "http://www.";
            String linkPart;
            String com = ".com/";
            String insertionString;
            long linkid = 0;
            for (int i = 0; i < unicount; i ++)
            {
                
                
                for(int j = 0; j < 3; j++)
                {
                    int num = randBetween(100000, 1000000);
					String extension = firstname[i] + "_" + lastname[i] +"_" + Integer.toString(num);
                    int linkLen = randBetween(10,25);
                    linkPart = ja.generateRandomString(linkLen);
                    insertionString = httpStart + linkPart + com + extension; 
                    //int index = randomGenerator.nextInt(299999);
                    String sql= "INSERT INTO personalweblink(linkid, url) VALUES(?, ?)";
                    PreparedStatement ps1 = conn.prepareStatement(sql);
                    ps1.setLong(1, linkid);
                    ps1.setString(2, insertionString);
                    int val = ps1.executeUpdate();
                    System.out.println(linkid + " inserted : ");
                    
                    String sql1= "INSERT INTO researcher_has_personalweblink(linkid, researcherid) VALUES(?, ?)";
                    PreparedStatement ps2 = conn.prepareStatement(sql1);
                    ps2.setLong(1, linkid);
                    ps2.setLong(2, researcherids[i]);
                    val = ps2.executeUpdate();
                    System.out.println(linkid + " inserted : ");
                    linkid++;
                }
            }
        }
        catch(Exception e)
        {
            System.err.print("Exception: ");
            System.err.println(e.getMessage()); e.printStackTrace();
        }
    }
    
    public String generateRandomString(int wordlength){
         
        StringBuffer randStr = new StringBuffer();
        for(int i = 0; i < wordlength; i++){
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
    
     public static int randBetween(int start, int end) {
        return start + (int)Math.round(Math.random() * (end - start));
    }
    
}
