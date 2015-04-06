/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication10;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;

/**
 * POPULATING profilestats
 *
 * @author Anup_Dell
 */
public class populateProfiles {

    /**
     * @param args the command line arguments
     */
	 
	private static final int MAX_ARRAY_SIZE = 300000;
	
	
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://localhost:5433/Intell_v4";

            Connection conn = DriverManager.getConnection(url, "postgres", "wipro123");

            // read all university ids
            String updateString = "Select researcherid from researcher order by researcherid";
            PreparedStatement updateSales = null;
            ResultSet rs = null;
            updateSales = conn.prepareStatement(updateString);
            rs = updateSales.executeQuery();
            int unicount = 0;
            long researcherids[] = new long[MAX_ARRAY_SIZE];
            
            while (rs.next()) {
                researcherids[unicount] = rs.getInt("researcherid");
                System.out.println(researcherids[unicount]);
                unicount++;
            }
            long answerid = 0;
            Random randomGenerator = new Random();
            for (int i = 0; i < unicount; i++) {
                for (int j = 0; j < 3; j++) {
                    int index = randomGenerator.nextInt(MAX_ARRAY_SIZE - 1);
                    String sql = "INSERT INTO profilestats(researcherid, visitorid) VALUES(?, ?)";
                    PreparedStatement ps1 = conn.prepareStatement(sql);
                    ps1.setLong(1, researcherids[i]);
                    ps1.setLong(2, researcherids[index]);
                    int val = ps1.executeUpdate();
                    System.out.println(researcherids[i] + " inserted : ");
                }
            }
        } catch (Exception e) {
            System.err.print("Exception: ");
            System.err.println(e.getMessage());
            e.printStackTrace();
        }
    }
}
