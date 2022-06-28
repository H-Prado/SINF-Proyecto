DROP database taquilla_virtual;

CREATE DATABASE IF NOT EXISTS taquilla_virtual;
                                            
USE taquilla_virtual;
                           
\. /home/hugo/SINF/baseDeDatos.sql
\. /home/hugo/SINF/procedimientos.sql
GRANT EXECUTE ON PROCEDURE taquilla_virtual.comprarLibre TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual.crearReserva TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual.pagarReservada TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual.crearAnulacion TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual.consultarRecintos TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual.consultarEvento TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual.consultarEventos TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual.consultarEventosUbicacion TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual.consultarEventosEspectaculo TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual.consultarLibres TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual.consultarGradas TO 'cliente'@'localhost';
GRANT EXECUTE ON PROCEDURE taquilla_virtual.consultarMiReserva TO 'cliente'@'localhost';
FLUSH PRIVILEGES;
\. /home/hugo/SINF/PruebaEnVivo.sql