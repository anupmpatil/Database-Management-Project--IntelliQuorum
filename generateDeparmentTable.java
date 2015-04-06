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
 * GENERATE and FILL UP DEPARTMENT TABLE 
 * @author Anup_Dell
 */
public class generateDeparmentTable {

    /**
     * @param args the command line arguments
     */
	 private static final int MAX_ARRAY_LEN = 30000;
    public static void main(String[] args) {
        // TODO code application logic here
        
        
        try{
            
            long universityids[] = new long[MAX_ARRAY_LEN];
            int topicid[] = new int [75];
            String topicname[] = new String[75];
            long dumparray[] = new long[MAX_ARRAY_LEN];
            
            // connection 
            Class.forName("org.postgresql.Driver");
			String url = "jdbc:postgresql://localhost:5433/intelliqV3";
			Connection conn = DriverManager.getConnection(url,"postgres","wipro123");
            
            // read all university ids
            String updateString = "Select universityid from university";
            PreparedStatement updateSales = null;
            ResultSet rs = null;
            updateSales = conn.prepareStatement(updateString);
            rs = updateSales.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
            int numberOfColumns = rsmd.getColumnCount();
            Statement stmt = null;
            int unicount = 0;
			while (rs.next())
			{
				universityids[unicount] = rs.getInt("universityid");
				System.out.println(universityids[unicount]);
				unicount++;
			}
  
			updateString = "Select * from topics";
			updateSales = null;
			rs = null;
			updateSales = conn.prepareStatement(updateString);
			rs = updateSales.executeQuery();
			rsmd = null;
  
			int topiccount = 0;
			while (rs.next())
			{
				topicid[topiccount] = rs.getInt("topicid");
				topicname[topiccount] = rs.getString("name");
				topiccount++;
			}	
			System.out.println("reached here 2");
			int dumpsize = (unicount - 1) * (topiccount - 1);
			System.out.println((unicount - 1));
			System.out.println((topiccount - 1));
			System.out.println(dumpsize);
			int departmentindex = 1;
			for (int uni = 0; uni < unicount; uni++)
			{
				for (int tpc = 0; tpc < topiccount; tpc ++)
				{          
					System.out.println("Inserting ...");
					String sql= "INSERT INTO department(departmentid, deparmentname, departmentmajor, universityid) VALUES(?, ?, ?, ?)";
					PreparedStatement ps1 = conn.prepareStatement(sql);
					ps1.setLong(1, departmentindex);
					ps1.setString(2, "Department of " + topicname[tpc]);
					ps1.setInt(3, topicid[tpc]);
					ps1.setLong(4, universityids[uni]);
					//ps1.setDate(3, java.sql.Date.valueOf("1998-11-11"));
					int val = ps1.executeUpdate();
					System.out.println(departmentindex+ " inserted : ");
					departmentindex ++;
				}
			}
			System.out.println("Dumpsize" + dumpsize);
			System.out.println("departmentindex" + departmentindex);
            conn.close();
			System.out.println("reached here 2");
        }
        catch(Exception e)
        {
            System.err.print("Exception: ");
            System.err.println(e.getMessage());
        }
    }
}
