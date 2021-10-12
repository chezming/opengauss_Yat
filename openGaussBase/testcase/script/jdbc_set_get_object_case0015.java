import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.sql.*;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Properties;


/**
 **/
public class jdbc_set_get_object_case0015 {
    static public String driver = "org.postgresql.Driver";
    public static Properties getConfigFromFile(String filePath) {
        Properties props = new Properties();
        try {
            BufferedInputStream config = new BufferedInputStream(new FileInputStream(filePath));
            props.load(config);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return props;
    }

    public static String genURLFromPro(Properties props) {
        String hostname = props.getProperty("hostname");
        String[] hostnames = hostname.split(",");
        String port = props.getProperty("port");
        String[] ports = port.split(",");
        String dbname = props.getProperty("dbname");
        return genURLFromHostsPortsDBname(hostnames, ports, dbname);
    }

    public static String genURLFromHostsPortsDBname(String[] hostnames, String[] ports, String dbname) {
        String sourceURL;
        if (hostnames.length == 1) {
            sourceURL = "jdbc:postgresql://" + hostnames[0] + ":" + ports[0] + "/" + dbname;
        } else {
            ArrayList<String> ip_port_pare = new ArrayList<>();
            if (ports.length == 1) {
                for (String ip : hostnames) {
                    ip_port_pare.add(ip + ":" + ports[0]);
                }
            } else {
                for (int i = 0; i < hostnames.length; i++) {
                    ip_port_pare.add(hostnames[i] + ":" + ports[i]);
                }
            }
            sourceURL = "jdbc:postgresql://" + String.join(",", ip_port_pare) + "/" + dbname;
        }
        return sourceURL;
    }

    public static Connection GetConnection(Properties props) {
        Connection connR;
        String sourceURL = genURLFromPro(props);
        try {
            Class.forName(driver).newInstance();
            connR = DriverManager.getConnection(sourceURL, props);
        } catch (Exception var10) {
            var10.printStackTrace();
            return null;
        }
        return connR;
    }


    public static void main(String[] args) {
        Properties pros = new Properties();
        Properties pros_conf=null;
        String jdbc_config_file = null;
        for (int i = 0; i < args.length; i++) {
            switch (args[i]) {
                case "--config-file":
                    jdbc_config_file = args[i + 1];
                    pros_conf=getConfigFromFile(jdbc_config_file);
                    break;
                case "-F":
                    jdbc_config_file = args[i + 1];
                    pros_conf=getConfigFromFile(jdbc_config_file);
                    break;
                default:
                    break;
            }
        }
        //建立连接
        if (pros_conf!=null){
            //以参数为准，覆盖配置文件中的
            pros_conf.putAll(pros);
        }
        Connection conn = GetConnection(pros_conf);
        if(conn==null){
            System.out.println("连接失败");
            return;
        }else{
            try{
                String sql = "select * from jdbc_set_get_object_case0015 order by 1 desc ;";
                PreparedStatement ps_select=conn.prepareStatement(sql);
                ResultSet rs=ps_select.executeQuery();
                int idx = 0;
                while(rs.next()){
                    LocalDate result1 = rs.getObject(1, LocalDate.class);
                    System.out.println("第"+ idx + "行结果：" + result1) ;
                    idx = idx + 1;
                }
                ps_select.close();

                sql = "select sysdate ;";
                PreparedStatement ps_time=conn.prepareStatement(sql);
                ResultSet rs1=ps_time.executeQuery();
                while(rs1.next()){
                    String result = rs1.getString(1);
                    System.out.println(result) ;
                }
                ps_time.close();

            }catch (SQLException s){
                s.printStackTrace();
            }
        }
        try{
            conn.close();
        }catch (SQLException s){
            s.printStackTrace();
        }
        
    }
}