DROP database taquilla_virtual_3;

CREATE DATABASE IF NOT EXISTS taquilla_virtual_3;
                                            
USE taquilla_virtual_3;
                           
\. /home/hugo/SINF/baseDeDatos.sql
\. /home/hugo/SINF/procedimientos.sql
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.comprarLibre TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.crearReserva TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.pagarReservada TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.crearAnulacion TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.consultarRecintos TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.consultarEvento TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.consultarEventos TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.consultarEventosUbicacion TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.consultarEventosEspectaculo TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.consultarLibres TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.consultarGradas TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_3.consultarMiReserva TO 'cliente'@'localhost';
FLUSH PRIVILEGES;
\. /home/hugo/SINF/Prueba3.sql
