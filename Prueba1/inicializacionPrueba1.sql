DROP database taquilla_virtual_1;

CREATE DATABASE IF NOT EXISTS taquilla_virtual_1;
                                            
USE taquilla_virtual_1;
                           
\. /home/hugo/SINF/baseDeDatos.sql
\. /home/hugo/SINF/procedimientos.sql
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.comprarLibre TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.crearReserva TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.pagarReservada TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.crearAnulacion TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.consultarRecintos TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.consultarEvento TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.consultarEventos TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.consultarEventosUbicacion TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.consultarEventosEspectaculo TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.consultarLibres TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.consultarGradas TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual_1.consultarMiReserva TO 'cliente'@'localhost';
FLUSH PRIVILEGES;
\. /home/hugo/SINF/Prueba1.sql