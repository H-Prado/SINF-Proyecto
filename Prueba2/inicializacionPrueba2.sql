DROP database taquilla_virtual_2;

CREATE DATABASE IF NOT EXISTS taquilla_virtual_2;
                                            
USE taquilla_virtual_2;
                           
\. /home/hugo/SINF/baseDeDatos.sql
\. /home/hugo/SINF/procedimientos.sql
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.comprarLibre TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.crearReserva TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.pagarReservada TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.crearAnulacion TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.consultarRecintos TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.consultarEvento TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.consultarEventos TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.consultarEventosUbicacion TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.consultarEventosEspectaculo TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.consultarLibres TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.consultarGradas TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_2.consultarMiReserva TO 'cliente'@'localhost';
FLUSH PRIVILEGES;
\. /home/hugo/SINF/Prueba2.sql