/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;
import java.util.Date;

/**
 * GENERATION OF abstract FOR PUBLICATION TABLE.
 * THE ABSTRACTS WERE STORED IN TEMPORARY TABLE IN DATABASE.
 * THEN THIS TABLE WAS EXTRACTED TO CSV AND THEN THIS COLUMN WAS COPIED IN ANOTHER CSV.
 * @author Anup_Dell
 */
public class generateAbstract {

    /**
     * @param args the command line arguments
     */
    
    private static final String CHAR_LIST =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    private static final int RANDOM_STRING_LENGTH = 10;
    
    public static void main(String[] args) {
        // TODO code application logic here
        try{
            generateAbstract ja = new generateAbstract();
            Class.forName("org.postgresql.Driver");
            String url1 = "jdbc:postgresql://localhost:5433/tempdata";	    
            Connection conn1 = DriverManager.getConnection(url1,"postgres","wipro123");
            
            
            int cnt = 85000;
            int cnt1 = 1;
            //int cnt2 = 1658;
            String des;
            int index = 15768;
            for (int i = 0; i < cnt; i++)
            {                
                String sql= "Insert into descriptiontable1(abstract) values (?)";                
                PreparedStatement ps1 = conn1.prepareStatement(sql);
                des = ja.getDescription();                
                ps1.setString(1, des);                
                int val = ps1.executeUpdate();
                index++;                
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
    
    String getDescription()
    {
        String description = null;
        Random randomGenerator = new Random();
        
        int desLen = randBetween(3000,5000);
        if (desLen < 50)
        {
            desLen = desLen + 100;
        }
        int worldLen = randomGenerator.nextInt(10);
        
            while (desLen > 10)
            {
                int senLen = randBetween(5,20);
                for (int k = 0; k < senLen; k++)
                {
                String word = generateRandomString(worldLen);
                if (description == null)
                {
                    description =  word;
                }
                else
                {
                    description =  description + " "+ word;
                }
                desLen = desLen - word.length();
                worldLen = randomGenerator.nextInt(10);
                }
                description = description + ".\n";
            }
            if(description.length() > 4997)
            {
                description = description.substring(0, 4997);
            }
        
        return description;
    }
    public static int randBetween(int start, int end) {
        return start + (int)Math.round(Math.random() * (end - start));
    }
    
}
