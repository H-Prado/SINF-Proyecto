import java.awt.event.*;
import java.awt.*;
import javax.swing.*;
import java.sql.*;
import java.sql.DriverManager;

public class Taquilla extends JFrame implements ActionListener,ItemListener{

    JFrame frame;  
    JButton btn;
    JRadioButton rBtn1, rBtn2, rBtn3, rBtn4, rBtn5, rBtn6,rBtn7;
    private JButton boton1;
    static JFrame f;
    static JLabel l, l1;
    static JComboBox c1;
    static JTextField tf;
    Icon icon = UIManager.getIcon("FileChooser.newFolderIcon");
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost/taquilla_virtual?characterEncoding=latin1&useSSL=false";
    Connection conn = null;
    Statement stmt = null, stmt2 = null;
    CallableStatement cstmt = null;
    static final String USER = "root";
    static final String PASS = "sinf2022.";
    int tipoUsuarioAdulto=0,tipoUsuarioJubilado=0,tipoUsuarioParado=0,tipoUsuarioInfantil=0,tipoUsuarioBebe=0;
    String SQL;

    Taquilla(int tipo){

        try{
            
            Class.forName("com.mysql.jdbc.Driver");
            conn=DriverManager.getConnection(DB_URL,USER,PASS);  
            System.out.println("Connecting to database...");

            System.out.println("Creating statement...");
            stmt = conn.createStatement();

            String sqldata = "use taquilla_virtual";
            int ok = stmt.executeUpdate(sqldata);
            System.out.println("Query OK, "+ok+" row afected ");

            if(tipo == 0){

                JFrame adminFrame = new JFrame();  
                String nombreRecinto, ubiRecinto, fecha, descripcionEspectaculo, nombreEspectaculo,tipoEspectaculo,participantes,nombreGrada,numeracion,disponibilidad,tipoUsuario;
                int penalizacion,duracion,tiempoReserva,tiempoValidezReserva,timepoAnulacion, precioAdulto, precioJubilado, precioParado, precioInfantil, precioBebe, maxReservas, maxEntrada;
                

                String  recintos [] = new String [1000];

                int i = 0;
                
                ResultSet rs1 = stmt.executeQuery("SELECT * From Recinto;");
                while (rs1.next()) {
                            recintos[i]=rs1.getString(2)+","+rs1.getString(1);
                            i++;
                }
                recintos[i] = "Otro";
    

                String s = (String)JOptionPane.showInputDialog(
                                    frame,
                                    "Seleccione el recinto:\n",
                                    "Customized Dialog",
                                    JOptionPane.PLAIN_MESSAGE,
                                    icon,
                                    recintos,
                                    "Vigo");

                if ((s != "Otro") && (s.length() > 0)) {
                    ubiRecinto = s;                        
                }else{

                    nombreRecinto = JOptionPane.showInputDialog(adminFrame, "Escriba el nombre del nuevo recinto");
                    ubiRecinto = JOptionPane.showInputDialog(adminFrame, "Escriba la ubicación exacta del nuevo recinto");
                    SQL = "{call crearRecinto(?,?)}";
                    cstmt = conn.prepareCall (SQL);
                    cstmt.setString(1, ubiRecinto);
                    cstmt.setString(2, nombreRecinto);
                    cstmt.executeUpdate();
                }

                String  fechas [] = new String [1000];
                int indice=0;
                ResultSet rs = stmt.executeQuery("SELECT * FROM Calendario;");
                while (rs.next()) {
                            fechas[indice]=rs.getString(1);
                            indice++;
                }
                fechas[indice]="Otro";
                fecha = (String)JOptionPane.showInputDialog(
                                    frame,
                                    "Seleccione la fecha:\n",
                                    "Customized Dialog",
                                    JOptionPane.PLAIN_MESSAGE,
                                    icon,
                                    fechas,
                                    "");

                if ((fecha != "Otro") && (s.length() > 0)) {
                    
                }else{

                    fecha = JOptionPane.showInputDialog(adminFrame, "Escriba la fecha del evento: (aaaammddhhmmss)");
                    SQL = "{call crearCalendario(?)}";
                    cstmt = conn.prepareCall (SQL);
                    cstmt.setString(1, fecha);
                    cstmt.executeUpdate();
                    
                }
                nombreEspectaculo = JOptionPane.showInputDialog(adminFrame, "¿Cuál será el nombre del espectáculo?");
                descripcionEspectaculo = JOptionPane.showInputDialog(adminFrame, "¿Cuál será la descripción del espectáculo?");
                tipoEspectaculo = JOptionPane.showInputDialog(adminFrame, "¿Cuál será el tipo del espectáculo?");
                participantes = JOptionPane.showInputDialog(adminFrame, "¿Quienes participarán en el evento del espectáculo?");
                duracion = Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Cuál será la duración del espectáculo en minutos?"));
                penalizacion = Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Cuál será la penalización del espectáculo?"));
                timepoAnulacion = Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Cuál será la tiempo de cancelación  del espectáculo?"));
                tiempoValidezReserva = Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Cuál será el tiempo de validez de una reserva del espectáculo?"));
                tiempoReserva = Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Hasta qué momento se podrá reservar una entrada para el evento?"));
                
                SQL = "{call crearEvento(?,?,?,?,?,?,?,?,?,?,?)}";
                cstmt = conn.prepareCall (SQL);
                cstmt.setString(1, descripcionEspectaculo);
                cstmt.setString(2, nombreEspectaculo);
                cstmt.setString(3, tipoEspectaculo);
                cstmt.setString(4, participantes);
                cstmt.setInt(5, duracion);
                cstmt.setInt(6, penalizacion);
                cstmt.setString(7, fecha);
                cstmt.setString(8, ubiRecinto);
                cstmt.setInt(9, timepoAnulacion);
                cstmt.setInt(10, tiempoValidezReserva);
                cstmt.setInt(11, tiempoReserva);

                cstmt.executeUpdate();

                do{
                nombreGrada = JOptionPane.showInputDialog(adminFrame, "¿Cuál será el nombre de la grada?");
                precioAdulto = Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Cuál será el precio de adulto?"));
                precioBebe = Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Cuál será el precio de bebé?"));
                precioInfantil = Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Cuál será el precio infantil?"));
                precioJubilado = Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Cuál será el precio de jubilado?"));
                precioParado= Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Cuál será el precio de parado?"));
                maxEntrada= Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Cuál será el aforo de la grada?"));
                maxReservas = Integer.parseInt(JOptionPane.showInputDialog(adminFrame, "¿Cuál será el número máximo de reservas?"));
                
                SQL = "{call crearGrada(?,?,?,?,?,?,?,?,?,?)}";
                cstmt = conn.prepareCall (SQL);
                cstmt.setInt(1, maxEntrada);
                cstmt.setString(2, nombreGrada);
                cstmt.setInt(3, precioAdulto);
                cstmt.setInt(4, precioJubilado);
                cstmt.setInt(5, precioParado);
                cstmt.setInt(6, precioInfantil);
                cstmt.setInt(7, precioBebe);
                cstmt.setInt(8, maxReservas);
                cstmt.setString(9, fecha);
                cstmt.setString(10, ubiRecinto);

                cstmt.executeUpdate();

                tipoUsuarioAdulto = 0;
                tipoUsuarioBebe = 0;
                tipoUsuarioInfantil = 0;
                tipoUsuarioJubilado = 0;
                tipoUsuarioParado = 0;

                tipoUsuarioJubilado = JOptionPane.showConfirmDialog(adminFrame, "¿Quieres negarle la entrada a los Jubilados?");
                tipoUsuarioBebe = JOptionPane.showConfirmDialog(adminFrame, "¿Quieres negarle la entrada a los Bebé?");
                tipoUsuarioInfantil = JOptionPane.showConfirmDialog(adminFrame, "¿Quieres negarle la entrada a los Niños?");
                tipoUsuarioParado = JOptionPane.showConfirmDialog(adminFrame, "¿Quieres negarle la entrada a los Parado?");
                tipoUsuarioAdulto = JOptionPane.showConfirmDialog(adminFrame, "¿Quieres negarle la entrada a los Adultos?");

                SQL = "{call crearUsuarios(?,?,?,?,?,?,?,?)}";
                cstmt = conn.prepareCall (SQL);
                cstmt.setString(1, nombreGrada);
                cstmt.setString(2, fecha);
                cstmt.setString(3, ubiRecinto);
                cstmt.setInt(4, tipoUsuarioAdulto);
                cstmt.setInt(5, tipoUsuarioJubilado);
                cstmt.setInt(6, tipoUsuarioParado);
                cstmt.setInt(7, tipoUsuarioInfantil);
                cstmt.setInt(8, tipoUsuarioBebe);

                cstmt.executeUpdate();


                do{    

                numeracion = JOptionPane.showInputDialog(adminFrame, "¿Cuál es la numeración de la localidad?");
                disponibilidad = JOptionPane.showInputDialog(adminFrame, "¿Cuál es la disponibilidad de la grada?");
                tipoUsuario = JOptionPane.showInputDialog(adminFrame, "¿Cuál será el tipo de usuario de la grada?");

                
                SQL = "{call crearLibres(?,?,?,?,?,?)}";
                cstmt = conn.prepareCall (SQL);
                cstmt.setString(1, numeracion);
                cstmt.setString(2, disponibilidad);
                cstmt.setString(3, nombreGrada);
                cstmt.setString(4, fecha);
                cstmt.setString(5, ubiRecinto);
                cstmt.setString(6, tipoUsuario); 

                cstmt.executeUpdate();
  

                }while(JOptionPane.showConfirmDialog(adminFrame, "¿Quieres añadir más localidades?")==0);             

                }while(JOptionPane.showConfirmDialog(adminFrame, "¿Quieres añadir más gradas?")==0);

                
               
                
            }else{
                frame = new JFrame();  
                // Create the label
                JLabel label = new JLabel("¿Qué quieres hacer?", JLabel.CENTER);
                label.setBounds(20,0,350,80);  

                // Create the radio buttons
                rBtn1 = new JRadioButton("Comprar una entrada");
                rBtn2 = new JRadioButton("Reservar una entrada");
                rBtn3 = new JRadioButton("Anular una entrada"); 
                rBtn4 = new JRadioButton("Consultar mi reserva"); 
                rBtn5 = new JRadioButton("Consultar los eventos"); 
                rBtn6 = new JRadioButton("Consultar los eventos para un espectáculo"); 
                rBtn7 = new JRadioButton("Consultar las localidades libres para un evento"); 


                // Set the position of the radio buttons
                rBtn1.setBounds(40,60,400,50);  
                rBtn2.setBounds(40,100,400,50);  
                rBtn3.setBounds(40,140,400,50); 
                rBtn4.setBounds(40,180,400,50); 
                rBtn5.setBounds(40,220,400,50); 
                rBtn6.setBounds(40,260,400,50); 
                rBtn7.setBounds(40,300,400,50); 


                // Add radio buttons to group
                ButtonGroup bg = new ButtonGroup();  
                bg.add(rBtn1);
                bg.add(rBtn2);  
                bg.add(rBtn3); 
                bg.add(rBtn4); 
                bg.add(rBtn5); 
                bg.add(rBtn6); 
                bg.add(rBtn7);

                btn = new JButton("Enviar");  
                btn.setBounds(100,360,80,30);  
                btn.addActionListener(this);  

                // Add buttons to frame
                frame.add(label);
                frame.add(rBtn1);
                frame.add(rBtn2);   
                frame.add(rBtn3);
                frame.add(rBtn4);
                frame.add(rBtn5);   
                frame.add(rBtn6);
                frame.add(rBtn7);   
                frame.add(btn); 
                frame.setSize(500,600);  
                frame.setLayout(null);  
                frame.setVisible(true); 



            }
        }catch(SQLException se){
            se.printStackTrace();
        }catch(Exception e){
            e.printStackTrace();
        }
    }  

    public void actionPerformed(ActionEvent e){
        
        try{
            conn=DriverManager.getConnection(DB_URL,USER,PASS);
            stmt = conn.createStatement();  
            String numTarjeta, entradaAnular, reservaConsultar, eventosConsultar;
            JFrame frameUsuario = new JFrame();
            JFrame framePago = new JFrame();
            JFrame frameNumeracion = new JFrame();

            int salir = 0;

            if(rBtn1.isSelected()){  
                JOptionPane.showMessageDialog(this,"Has seleccionado comprar una entrada.");
                String ubicacion = JOptionPane.showInputDialog(frameNumeracion, "Indique la ubicacion del evento");
                String fecha = JOptionPane.showInputDialog(frameNumeracion, "Indique la fecha del evento");
                String nombreGrada = JOptionPane.showInputDialog(frameNumeracion, "Indique la grada");
                String numeracion = JOptionPane.showInputDialog(frameNumeracion, "Indique la numeracion de la localidad");
                Object[] tiposPosibles = {"Jubilado", "Bebé", "Infantil", "Adulto", "Parado"};
                String seleccionTipo = (String)JOptionPane.showInputDialog(
                                    frame,
                                    "Seleccione el Tipo de Usuario:\n",
                                    "Customized Dialog",
                                    JOptionPane.PLAIN_MESSAGE,
                                    icon,
                                    tiposPosibles,
                                    "Jubilado");

                Object[] formaPago = {"Tarjeta", "Efectivo"};
                String seleccionPago = (String)JOptionPane.showInputDialog(
                                    frame,
                                    "Seleccione la Forma de Pago:\n",
                                    "Customized Dialog",
                                    JOptionPane.PLAIN_MESSAGE,
                                    icon,
                                    formaPago,
                                    "Tarjeta");

                if ((seleccionPago != null) && (seleccionPago.length() > 0)) {
                    if(seleccionPago == "Tarjeta"){
                        numTarjeta = JOptionPane.showInputDialog(framePago, "Indique el número de la tarjeta");
                    }
                }
                SQL = "{call comprarLibre(?,?,?,?,?,?)}";
                cstmt = conn.prepareCall (SQL);
                cstmt.setString(1, seleccionPago);
                cstmt.setString(2, numeracion);
                cstmt.setString(3, nombreGrada);
                cstmt.setString(4, fecha);
                cstmt.setString(5, ubicacion);
                cstmt.setString(6, seleccionTipo); 

                cstmt.executeUpdate();

            }
            else if(rBtn2.isSelected()){
                JOptionPane.showMessageDialog(this,"Has seleccionado reservar una entrada.");
                String ubicacion = JOptionPane.showInputDialog(frameNumeracion, "Indique la ubicacion del evento");
                String fecha = JOptionPane.showInputDialog(frameNumeracion, "Indique la fecha del evento");
                String nombreGrada = JOptionPane.showInputDialog(frameNumeracion, "Indique la grada a la que quiere asistir");
                Object[] tiposPosibles = {"Jubilado", "Bebé", "Infantil", "Adulto", "Parado"};
                String seleccionTipo = (String)JOptionPane.showInputDialog(
                                    frame,
                                    "Seleccione el Tipo de Usuario:\n",
                                    "Customized Dialog",
                                    JOptionPane.PLAIN_MESSAGE,
                                    icon,
                                    tiposPosibles,
                                    "Jubilado");

                String numeracion = JOptionPane.showInputDialog(frameNumeracion, "Indique la numeracion de la localidad");
                SQL = "{call crearReserva(?,?,?,?,?)}";
                cstmt = conn.prepareCall (SQL);
                cstmt.setString(1, numeracion);
                cstmt.setString(2, nombreGrada);
                cstmt.setString(3, fecha);
                cstmt.setString(4, ubicacion);
                cstmt.setString(5, seleccionTipo); 

                cstmt.executeUpdate();


            }
            else if(rBtn3.isSelected())
            {
                JOptionPane.showMessageDialog(this,"Has seleccionado anular una reserva o una compra.");
                String numeracion2 = JOptionPane.showInputDialog(frameUsuario, "Indique la entrada que quiere anular");
                String nombreGrada = JOptionPane.showInputDialog(frameUsuario, "Indique la grada de la entrada que quiere anular");
                String fecha = JOptionPane.showInputDialog(frameUsuario, "Indique la fecha del evento cuya entrada quiere anular");
                String ubiRecinto = JOptionPane.showInputDialog(frameUsuario, "Indique la ubicación del recinto");
                SQL = "{call crearAnulacion(?,?,?,?)}";
                cstmt = conn.prepareCall (SQL);
                cstmt.setString(1, numeracion2);
                cstmt.setString(2, nombreGrada);
                cstmt.setString(3, fecha);
                cstmt.setString(4, ubiRecinto);

                cstmt.executeUpdate();

            }
            else if(rBtn4.isSelected())
            {
                JOptionPane.showMessageDialog(this,"Has seleccionado consultar tu reserva.");
                reservaConsultar = JOptionPane.showInputDialog(framePago, "Indique el número de reserva que quiere consultar");
                String ubicacion = JOptionPane.showInputDialog(framePago, "Indique la ubicacion del evento");
                String fecha = JOptionPane.showInputDialog(framePago, "Indique la fecha del evento");
                String grada = JOptionPane.showInputDialog(framePago, "Indique la grada del evento");
                String todo;
                ResultSet rs2 = stmt.executeQuery("SELECT * From Reservada WHERE Reservada.numeroReserva='" + reservaConsultar +"' AND Reservada.ubicacionExacta='"+ubicacion+"' AND Reservada.fecha='"+fecha+"' AND Reservada.nombre='"+grada+"';");
                rs2.next();
                todo=rs2.getString(1)+", "+rs2.getString(2)+", "+rs2.getString(3)+", "+rs2.getString(4)+", "+rs2.getString(5)+", "+rs2.getString(6)+", "+rs2.getString(7)+", "+rs2.getString(8);
                JOptionPane.showMessageDialog(this,todo);

                
                
            }

            else if(rBtn5.isSelected())
            {
                JOptionPane.showMessageDialog(this,"Has seleccionado consultar los eventos.");
                String[] eventosConsulta = new String [100000];



                ResultSet rs3 = stmt.executeQuery("SELECT Espectaculo.nombre as NombreEspectaculo, Espectaculo.descripcion, Recinto.nombre as NombreRecinto, Recinto.ubicacionExacta as Ubicacion, Calendario.fecha  FROM Evento INNER JOIN Recinto ON  Evento.ubicacionExacta=Recinto.ubicacionExacta INNER JOIN Calendario ON Evento.fecha=Calendario.fecha INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion;");
                int a = 0;
                while(rs3.next()){
                    eventosConsulta[a]=rs3.getString(1)+", "+rs3.getString(2)+", "+rs3.getString(3)+", "+rs3.getString(4)+", "+rs3.getString(5);
                    a++;
                }
                
                String consultarEventoEspectaculo = (String)JOptionPane.showInputDialog(
                    frame,
                    "Los eventos son:\n",
                    "Customized Dialog",
                    JOptionPane.PLAIN_MESSAGE,
                    icon,
                    eventosConsulta,
                    "");
                
            }
            else if(rBtn6.isSelected())
            {
                JOptionPane.showMessageDialog(this,"Has seleccionado consultar los eventos para un espectáculo.");
                String[] eventoEspectaculo = new String [1000000];


                String descripcionEspectaculo = JOptionPane.showInputDialog(framePago, "Indique la descripción del espectáculo");

                ResultSet rs4 = stmt.executeQuery("SELECT Espectaculo.nombre as NombreEspectaculo, Espectaculo.descripcion, Recinto.nombre as NombreRecinto, Recinto.ubicacionExacta as Ubicacion, Calendario.fecha  FROM Evento INNER JOIN Recinto ON  Evento.ubicacionExacta=Recinto.ubicacionExacta INNER JOIN Calendario ON Evento.fecha=Calendario.fecha INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion WHERE Espectaculo.descripcion ='"+descripcionEspectaculo+"';");
                int w = 0;
                while(rs4.next()){
                    eventoEspectaculo[w]=rs4.getString(1)+", "+rs4.getString(2)+", "+rs4.getString(3)+", "+rs4.getString(4)+", "+rs4.getString(5);
                    w++;
                }
                
                String consultarEventoEspectaculo = (String)JOptionPane.showInputDialog(
                    frame,
                    "Los eventos en los que habrá ese espectáculo son:\n",
                    "Customized Dialog",
                    JOptionPane.PLAIN_MESSAGE,
                    icon,
                    eventoEspectaculo,
                    "");



            }
            else 
            {
                JOptionPane.showMessageDialog(this,"Has seleccionado consultar localidades libres para un Evento.");
                String fecha= JOptionPane.showInputDialog(frameUsuario, "Indique la fecha del evento");
                String ubicacion = JOptionPane.showInputDialog(frameUsuario, "Indique la ubicacion del Recinto");
                String[]  numeracion = new String [1000];
                String[]  disponibilidad = new String [1000];
                String[]  tipoUsuario = new String [1000];
                String[]  grada = new String [1000];
                String[]  precioAdulto = new String [1000];
                String[]  precioJubilado = new String [1000];
                String[]  precioInfantil = new String [1000];
                String[]  precioBebe = new String [1000];
                String[]  precioParado = new String [1000];
                String[]  todo = new String [1000];
                int indice=0;
                ResultSet rs = stmt.executeQuery("SELECT Libre.numeracion,Libre.disponibilidad,Libre.tipoUsuario,Libre.nombre,Grada.precioAdulto,Grada.precioBebe,Grada.precioInfantil,Grada.precioJubilado,Grada.precioParado FROM  Libre INNER JOIN Grada ON Libre.ubicacionExacta=Grada.ubicacionExacta AND Libre.fecha=Grada.fecha AND Libre.nombre=Grada.nombre WHERE Libre.ubicacionExacta='"+ubicacion+"' AND Libre.fecha='"+fecha+"';");
                while (rs.next())
                {
                    numeracion[indice]=rs.getString(1);
                    disponibilidad[indice]=rs.getString(2);
                    tipoUsuario[indice]=rs.getString(3);
                    grada[indice]=rs.getString(4);
                    precioAdulto[indice]=rs.getString(5);
                    precioBebe[indice]=rs.getString(6);
                    precioInfantil[indice]=rs.getString(7);
                    precioJubilado[indice]=rs.getString(8);
                    precioParado[indice]=rs.getString(9);
                    todo[indice]=numeracion[indice]+","+disponibilidad[indice]+","+tipoUsuario[indice]+","+grada[indice]+","+precioAdulto[indice]+","+precioBebe[indice]+","+precioInfantil[indice]+","+precioJubilado[indice]+","+precioParado[indice];
                    indice++;
                }
                
                String consultaLocalidad = (String)JOptionPane.showInputDialog(
                    frame,
                    "Las localidades libres son las siguientes con formato(Numeracion,Disponibilidad,UsuarioEspecificoCompra,Grada,PrecioAdulo,PrecioBebe,PrecioInfantil,PrecioJubilado,PrecioParado):\n",
                    "Customized Dialog",
                    JOptionPane.PLAIN_MESSAGE,
                    icon,
                    todo,
                    "");

            }
                  
        }
        catch(SQLException se){
            se.printStackTrace();
        }
        catch(Exception e2){
            e2.printStackTrace();
        }
        finally
        {
            try
            {
                if(stmt!=null)
                    stmt.close();
            }
            catch(SQLException se2){
            }
            try
            {
                if(conn!=null)
                    conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
    }
         
    }

    public void itemStateChanged(ItemEvent e)
    {
        // if the state combobox is changed
        if (e.getSource() == c1) {
 
            l1.setText(c1.getSelectedItem() + " selected");
        }
    }
    
    

    public static void main(String[] args){
    int tipo_usuario=0;
    //while(tipo_usuario!=2){
            JFrame jFrame = new JFrame();
            tipo_usuario= JOptionPane.showConfirmDialog(jFrame, "¿Eres administrador?");
            if(tipo_usuario!=2){
                new Taquilla(tipo_usuario);
            }
        //}
        // System.exit(0);
    }

    // private static void consultarRecintos(stmt) {
    //     try{
    //         String sql;
    //         int ok;
    //         sql = "CALL consultarRecintos";
    //         ok = stmt.executeUpdate(sql);
    //     }catch (SQLException | IOException e) {
    //         e.printStackTrace();
    //     }
    // }
}
