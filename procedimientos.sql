#################### PROCEDURES ####################

#################### CREAR ####################

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearCalendario(IN fecha DATETIME)
    BEGIN
    
    INSERT INTO Calendario(fecha) VALUES(fecha);
    
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearRecinto(IN ubicacionExacta VARCHAR(250), IN nombre VARCHAR(50))
    BEGIN

    INSERT INTO Recinto VALUES(ubicacionExacta, nombre);
END
 //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearEspectaculo(IN descripcion VARCHAR(250), IN nombre VARCHAR(50), IN tipo VARCHAR(50), IN participantes VARCHAR(50), IN duracion INT, IN penalizacion INT)
    BEGIN
    
    INSERT INTO Espectaculo VALUES(descripcion, nombre, tipo, participantes, duracion, penalizacion);
    
    END
 //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearEvento(IN descripcion VARCHAR(250), IN nombre VARCHAR(50), IN tipo VARCHAR(50), IN participantes VARCHAR(50), IN duracion INT ,IN penalizacion INT, IN fechaYo DATETIME, IN ubicacionExacta VARCHAR(250), IN tiempoCancelacion INT, IN tiempoValidezReserva INT, IN tiempoReserva INT)
    BEGIN
    DECLARE finYo DATETIME;
    DECLARE cuenta INT;

    #Empieza antes que yo y acaba despues de que yo empiece
    #Empieza antes de que yo acabe y acaba despues de que yo acabe
    #Empieza despues de mi inicio y acaba antes que mi final

    IF((SELECT count(*) FROM Espectaculo WHERE Espectaculo.descripcion=descripcion)=0) THEN
        CALL crearEspectaculo(descripcion,nombre,tipo,participantes,duracion,penalizacion);
    END IF;


    SELECT date_add(fechaYo, interval duracion minute) INTO finYo;

    SELECT count(*) INTO cuenta FROM (SELECT Evento.fecha,(SELECT date_add(Evento.fecha, interval Espectaculo.duracion minute)) AS finOtro FROM Evento INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion INNER JOIN Recinto ON Evento.ubicacionExacta=Recinto.ubicacionExacta WHERE Evento.ubicacionExacta=ubicacionExacta AND Evento.fecha=fechaYo) AS tablaAux WHERE (tablaAux.fecha<fechaYo AND finOtro>fechaYo) OR (tablaAux.fecha<finYo AND finOtro>finYo) OR (tablaAux.fecha>fechaYo AND finOtro<finYo) ;
    IF(cuenta=0) THEN
        INSERT INTO Evento(fecha,ubicacionExacta,descripcion,tiempoCancelacion,tiempoReserva,tiempoValidezReserva) VALUES(fechaYo, ubicacionExacta, descripcion, tiempoCancelacion, tiempoReserva, tiempoValidezReserva);
    END IF;
END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearGrada(IN maxEntrada INT, IN nombre VARCHAR(50), IN precioAdulto INT, IN precioJubilado INT, IN precioParado INT, IN precioInfantil INT, IN precioBebe INT, IN maxReservas INT, IN fecha DATETIME, IN ubicacionExacta VARCHAR(250))
    BEGIN
    INSERT INTO Grada VALUES(nombre, precioAdulto, precioJubilado, precioParado, precioInfantil, precioBebe, maxReservas, fecha, ubicacionExacta);
    CALL crearEntradas(maxEntrada,nombre,fecha,ubicacionExacta);
END //
DELIMITER ;

#crear todas las entradas de una grada
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearEntradas(IN maxEntradas INT, IN nombre VARCHAR(50),IN fecha DATETIME, IN ubicacionExacta VARCHAR(250))
    BEGIN
    DECLARE indice INT;
    SET indice =0;
    bucle: LOOP
        IF(indice=maxEntradas) THEN
            LEAVE bucle;
        END IF;

        INSERT INTO Entradas(nombre,fecha,ubicacionExacta,contador) VALUES(nombre,fecha,ubicacionExacta,indice);
        SET indice=indice+1;

    END LOOP bucle;    
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearUsuarios(IN nombre VARCHAR(50), IN fecha DATETIME, IN ubicacionExacta VARCHAR(250), IN adulto INT, IN jubilado INT, IN parado INT, IN infantil INT, IN bebe INT)
    BEGIN
    IF(adulto=1) THEN
        INSERT INTO TipoUsuario(tipo,nombre,fecha,ubicacionExacta) VALUES("Adulto",nombre,fecha,ubicacionExacta);
    END IF;
    IF(jubilado=1) THEN
        INSERT INTO TipoUsuario(tipo,nombre,fecha,ubicacionExacta) VALUES("Jubilado",nombre,fecha,ubicacionExacta);
    END IF;
    IF(parado=1) THEN
        INSERT INTO TipoUsuario(tipo,nombre,fecha,ubicacionExacta) VALUES("Parado",nombre,fecha,ubicacionExacta);
    END IF;
    IF(infantil=1) THEN
        INSERT INTO TipoUsuario(tipo,nombre,fecha,ubicacionExacta) VALUES("Infantil",nombre,fecha,ubicacionExacta);
    END IF;
    IF(bebe=1) THEN
        INSERT INTO TipoUsuario(tipo,nombre,fecha,ubicacionExacta) VALUES("Bebe",nombre,fecha,ubicacionExacta);
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearLocalidades(IN numeracion VARCHAR(50), IN nombre VARCHAR(50), IN fecha DATETIME, IN ubicacionExacta VARCHAR(250))
    BEGIN
    DECLARE contaAux,numAux INT;

    SELECT contador INTO contaAux FROM Entradas WHERE Entradas.nombre=nombre AND Entradas.fecha=fecha AND Entradas.ubicacionExacta=ubicacionExacta LIMIT 1;
    SELECT count(*) INTO numAux FROM Localidad WHERE Localidad.nombre=nombre AND Localidad.fecha=fecha AND Localidad.ubicacionExacta=ubicacionExacta;
    INSERT INTO Localidad(numeracion,nombre,fecha,ubicacionExacta,contador) VALUES(numeracion,nombre,fecha,ubicacionExacta,numAux+contaAux);
    END
 //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearLibres(IN numeracion VARCHAR(50), IN disponibilidad VARCHAR(50), IN nombre VARCHAR(50), IN fecha DATETIME, IN ubicacionExacta VARCHAR(250), IN tipoUsuario VARCHAR(50))
    BEGIN
        DECLARE contadorAux INT;
        CALL crearLocalidades(numeracion,nombre,fecha,ubicacionExacta);
        SELECT contador INTO contadorAux FROM Localidad WHERE Localidad.numeracion=numeracion AND Localidad.nombre=nombre AND Localidad.fecha=fecha AND Localidad.ubicacionExacta=ubicacionExacta;
        IF (tipoUsuario!='Todos') THEN 
            UPDATE Localidad SET Localidad.tipoPredefinido=TRUE WHERE Localidad.numeracion=numeracion AND Localidad.nombre=nombre AND Localidad.fecha=fecha AND Localidad.ubicacionExacta=ubicacionExacta;
            INSERT INTO Libre(numeracion,disponibilidad,nombre,fecha,ubicacionExacta,tipoUsuario,contador) VALUES(numeracion, disponibilidad, nombre, fecha, ubicacionExacta, tipoUsuario,contadorAux);
        ELSE
            INSERT INTO Libre(numeracion,disponibilidad,nombre,fecha,ubicacionExacta,contador) VALUES(numeracion, disponibilidad, nombre, fecha, ubicacionExacta,contadorAux);    
        END IF;
        
    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearReserva(IN numeracion VARCHAR(50), IN nombre VARCHAR(50), IN fecha DATETIME, IN ubicacionExacta VARCHAR(250), IN tipoUsuario VARCHAR(50))
    BEGIN

        DECLARE tipoUsuarioAux,estadoAux VARCHAR(50);
        DECLARE contadorAux,maxReservaAux,numReservasAux, tMaxReservaAux INT;
        DECLARE tMaxReserva DATETIME;
      
        SELECT (Evento.tiempoReserva) INTO tMaxReservaAux FROM Calendario INNER JOIN Evento on Evento.fecha=Calendario.fecha INNER JOIN Recinto on Recinto.ubicacionExacta=Evento.ubicacionExacta where Calendario.fecha=fecha AND Recinto.ubicacionExacta=ubicacionExacta; 
        SELECT date_add(now(), interval tMaxReservaAux minute) INTO tMaxReserva;
      
        SELECT Libre.disponibilidad,Libre.tipoUsuario,Libre.contador INTO estadoAux,tipoUsuarioAux,contadorAux FROM Libre WHERE Libre.numeracion=numeracion AND Libre.nombre=nombre AND Libre.fecha=fecha AND Libre.ubicacionExacta=ubicacionExacta;
        SELECT count(*) INTO numReservasAux FROM Reservada WHERE Reservada.nombre=nombre AND Reservada.fecha=fecha AND Reservada.ubicacionExacta=ubicacionExacta;
        SELECT Grada.maxReservas INTO maxReservaAux FROM Grada WHERE Grada.nombre=nombre AND Grada.fecha=fecha AND Grada.ubicacionExacta=ubicacionExacta;
        
        
        IF (estadoAux='Disponible' AND (tipoUsuario=tipoUsuarioAux OR tipoUsuarioAux is NULL) AND numReservasAux<maxReservaAux AND tMaxReserva<=fecha) THEN
            INSERT INTO Reservada(numeroReserva,numeracion,contador,nombre,fecha,ubicacionExacta,tipoUsuario) VALUES(numReservasAux+1, numeracion, contadorAux, nombre, fecha, ubicacionExacta, tipoUsuario);
            DELETE FROM Libre WHERE Libre.numeracion=numeracion AND Libre.nombre=nombre AND Libre.fecha=fecha AND Libre.ubicacionExacta=ubicacionExacta;
        END IF;
    END
//
DELIMITER ;

DELIMITER // 
CREATE PROCEDURE IF NOT EXISTS comprarLibre(IN formaPago VARCHAR(50), IN numeracion VARCHAR(50), IN nombre VARCHAR(50), IN fecha DATETIME, IN ubicacionExacta VARCHAR(250), IN tipoUsuario VARCHAR(50))
    BEGIN
        DECLARE tipoUsuarioAux,estadoAux VARCHAR(50);
        DECLARE contadorAux,precioAux INT;

        SELECT Libre.disponibilidad,Libre.tipoUsuario,Libre.contador INTO estadoAux,tipoUsuarioAux,contadorAux FROM Libre WHERE Libre.numeracion=numeracion AND Libre.nombre=nombre  AND Libre.fecha=fecha AND Libre.ubicacionExacta=ubicacionExacta;
        IF (estadoAux='Disponible' AND (tipoUsuario=tipoUsuarioAux OR tipoUsuarioAux is NULL) AND NOW()<fecha) THEN
            IF(tipoUsuario="Bebe") THEN
                SELECT Grada.precioBebe INTO precioAux FROM Grada WHERE Grada.nombre=nombre AND Grada.fecha=fecha AND Grada.ubicacionExacta=ubicacionExacta;
            ELSEIF(tipoUsuario="Adulto") THEN
                SELECT Grada.precioAdulto INTO precioAux FROM Grada WHERE Grada.nombre=nombre AND Grada.fecha=fecha AND Grada.ubicacionExacta=ubicacionExacta;
            ELSEIF(tipoUsuario="Infantil") THEN
                SELECT Grada.precioInfantil INTO precioAux FROM Grada WHERE Grada.nombre=nombre AND Grada.fecha=fecha AND Grada.ubicacionExacta=ubicacionExacta;
            ELSEIF(tipoUsuario="Parado") THEN
                SELECT Grada.precioParado INTO precioAux FROM Grada WHERE Grada.nombre=nombre AND Grada.fecha=fecha AND Grada.ubicacionExacta=ubicacionExacta;
            ELSEIF(tipoUsuario="Jubilado") THEN
                SELECT Grada.precioJubilado INTO precioAux FROM Grada WHERE Grada.nombre=nombre AND Grada.fecha=fecha AND Grada.ubicacionExacta=ubicacionExacta;
            END IF;
            INSERT INTO Comprada(numeracion,nombre,fecha,ubicacionExacta,tipoUsuario,formaPago,contador,precio) VALUES(numeracion,nombre,fecha,ubicacionExacta,tipoUsuario,formaPago,contadorAux,precioAux);
            DELETE FROM Libre WHERE Libre.numeracion=numeracion AND Libre.nombre=nombre AND Libre.fecha=fecha AND Libre.ubicacionExacta=ubicacionExacta;
        END IF;
    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS pagarReservada(IN formaPago VARCHAR(50), IN numeracion VARCHAR(50), IN nombre VARCHAR(50), IN fecha DATETIME, IN ubicacionExacta VARCHAR(250), IN numeroReserva INT)
    BEGIN
        DECLARE tipoUsuarioAux,estadoAux VARCHAR(50);
        DECLARE tMaxReserva, tMaxReservaAuxDos DATETIME;
        DECLARE tMaxReservaAux,contadorAux,precioAux INT;

        SELECT (Evento.tiempoValidezReserva) INTO tMaxReservaAux FROM Calendario INNER JOIN Evento on Evento.fecha=Calendario.fecha INNER JOIN Recinto on Recinto.ubicacionExacta=Evento.ubicacionExacta where Calendario.fecha=fecha AND Recinto.ubicacionExacta=ubicacionExacta; 
        SELECT Reservada.tiempoReserva,Reservada.contador,Reservada.tipoUsuario INTO tMaxReservaAuxDos,contadorAux,tipoUsuarioAux FROM Reservada WHERE Reservada.numeracion=numeracion AND Reservada.nombre=nombre AND Reservada.fecha=fecha AND Reservada.ubicacionExacta=ubicacionExacta AND Reservada.numeroReserva=numeroReserva;
        SELECT date_add(tMaxReservaAuxDos, interval tMaxReservaAux minute) INTO tMaxReserva;
        IF(tipoUsuarioAux="Bebe") THEN
            SELECT Grada.precioBebe INTO precioAux FROM Grada WHERE Grada.nombre=nombre AND Grada.fecha=fecha AND Grada.ubicacionExacta=ubicacionExacta;
        ELSEIF(tipoUsuarioAux="Adulto") THEN
            SELECT Grada.precioAdulto INTO precioAux FROM Grada WHERE Grada.nombre=nombre AND Grada.fecha=fecha AND Grada.ubicacionExacta=ubicacionExacta;
        ELSEIF(tipoUsuarioAux="Infantil") THEN
            SELECT Grada.precioInfantil INTO precioAux FROM Grada WHERE Grada.nombre=nombre AND Grada.fecha=fecha AND Grada.ubicacionExacta=ubicacionExacta;
        ELSEIF(tipoUsuarioAux="Parado") THEN
            SELECT Grada.precioParado INTO precioAux FROM Grada WHERE Grada.nombre=nombre AND Grada.fecha=fecha AND Grada.ubicacionExacta=ubicacionExacta;
        ELSEIF(tipoUsuarioAux="Jubilado") THEN
            SELECT Grada.precioJubilado INTO precioAux FROM Grada WHERE Grada.nombre=nombre AND Grada.fecha=fecha AND Grada.ubicacionExacta=ubicacionExacta;
        END IF;
       
        IF(SELECT count(*) FROM Reservada WHERE Reservada.numeracion=numeracion AND Reservada.nombre=nombre AND Reservada.fecha=fecha AND Reservada.ubicacionExacta=ubicacionExacta AND Reservada.numeroReserva=numeroReserva) THEN
            IF(tMaxReserva>NOW()) THEN
                INSERT INTO Comprada(formaPago,numeracion,nombre,fecha,ubicacionExacta,contador,tipoUsuario,precio) VALUES (formaPago,numeracion,nombre,fecha,ubicacionExacta,contadorAux,tipoUsuarioAux,precioAux);
                DELETE FROM Reservada WHERE Reservada.nombre=nombre AND Reservada.fecha = fecha AND Reservada.ubicacionExacta=ubicacionExacta AND Reservada.numeracion=numeracion;
            END IF;
        END IF;
    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS crearAnulacion(IN numeracion VARCHAR(50), IN nombre VARCHAR(50), IN fecha DATETIME, IN ubicacionExacta VARCHAR(250))
    BEGIN
        DECLARE tiempoCancelacionMax DATETIME;
        DECLARE numReservasAux,maxCompraAux,penalizacionAux,contadorAux,tiempoCancelacionMaxAux,precioAux INT;
        DECLARE tipoUsuarioAux,mAux VARCHAR(50);
        DECLARE predefinidoAux BOOLEAN;

        SELECT count(*) INTO numReservasAux FROM Reservada WHERE numeracion=Reservada.numeracion AND nombre=Reservada.nombre AND fecha=Reservada.fecha AND ubicacionExacta=Reservada.ubicacionExacta;
        SELECT count(*) INTO maxCompraAux FROM Comprada WHERE numeracion=Comprada.numeracion AND nombre=Comprada.nombre AND fecha=Comprada.fecha AND ubicacionExacta=Comprada.ubicacionExacta;
        SELECT Evento.tiempoCancelacion INTO tiempoCancelacionMaxAux FROM Calendario INNER JOIN Evento on Evento.fecha=Calendario.fecha INNER JOIN Recinto on Recinto.ubicacionExacta=Evento.ubicacionExacta where Calendario.fecha=fecha AND Recinto.ubicacionExacta=ubicacionExacta;
        SELECT date_add(now(), interval tiempoCancelacionMaxAux minute) INTO tiempoCancelacionMax;

        SELECT Espectaculo.penalizacion INTO penalizacionAux FROM Calendario INNER JOIN Evento on Evento.fecha=Calendario.fecha INNER JOIN Recinto on Recinto.ubicacionExacta=Evento.ubicacionExacta INNER JOIN Espectaculo on Espectaculo.descripcion=Evento.descripcion where Calendario.fecha=fecha AND Recinto.ubicacionExacta=ubicacionExacta;
        SELECT Localidad.tipoPredefinido INTO predefinidoAux FROM Localidad WHERE numeracion=Localidad.numeracion AND nombre=Localidad.nombre AND fecha=Localidad.fecha AND ubicacionExacta=Localidad.ubicacionExacta;
        
        #si el evento todavia no ha empezado
        IF(NOW()<fecha AND (numReservasAux OR maxCompraAux)) THEN
            IF (numReservasAux) THEN
                SELECT Reservada.Contador, Reservada.TipoUsuario, Reservada.numeroReserva INTO contadorAux,tipoUsuarioAux,mAux FROM Reservada WHERE numeracion=Reservada.numeracion AND nombre=Reservada.nombre AND fecha=Reservada.fecha AND ubicacionExacta=Reservada.ubicacionExacta;
                DELETE FROM Reservada WHERE numeracion=Reservada.numeracion AND nombre=Reservada.nombre AND fecha=Reservada.fecha AND ubicacionExacta=Reservada.ubicacionExacta;
                SET precioAux=0;
            ELSE
                SELECT Comprada.Contador, Comprada.TipoUsuario, Comprada.formaPago, Comprada.precio INTO contadorAux,tipoUsuarioAux,mAux,precioAux FROM Comprada WHERE numeracion=Comprada.numeracion AND nombre=Comprada.nombre AND fecha=Comprada.fecha AND ubicacionExacta=Comprada.ubicacionExacta;
                DELETE FROM Comprada WHERE numeracion=Comprada.numeracion AND nombre=Comprada.nombre AND fecha=Comprada.fecha AND ubicacionExacta=Comprada.ubicacionExacta;
            END IF;
            IF(tiempoCancelacionMax>fecha) THEN
                INSERT INTO Anulada(m,numeracion,contador,nombre,fecha,ubicacionExacta,tipoUsuario,costePenalizacion,precio) VALUES(mAux, numeracion, contadorAux, nombre, fecha, ubicacionExacta, tipoUsuarioAux,penalizacionAux,precioAux);  #penalizacion
                IF (predefinidoAux=1) THEN
                    INSERT INTO Libre(disponibilidad,numeracion,contador,nombre,fecha,ubicacionExacta,tipoUsuario) VALUES ('Disponible',numeracion,contadorAux,nombre,fecha,ubicacionExacta,tipoUsuarioAux);
                ELSE
                    INSERT INTO Libre(disponibilidad,numeracion,contador,nombre,fecha,ubicacionExacta) VALUES ('Disponible',numeracion,contadorAux,nombre,fecha,ubicacionExacta);
                END IF;
            ELSE
                INSERT INTO Anulada(m,numeracion,contador,nombre,fecha,ubicacionExacta,tipoUsuario,precio) VALUES(mAux, numeracion, contadorAux, nombre, fecha, ubicacionExacta, tipoUsuarioAux,precioAux);
                IF (predefinidoAux=1) THEN
                    INSERT INTO Libre(disponibilidad,numeracion,contador,nombre,fecha,ubicacionExacta,tipoUsuario) VALUES ('Disponible',numeracion,contadorAux,nombre,fecha,ubicacionExacta,tipoUsuarioAux);
                ELSE 
                    INSERT INTO Libre(disponibilidad,numeracion,contador,nombre,fecha,ubicacionExacta) VALUES ('Disponible',numeracion,contadorAux,nombre,fecha,ubicacionExacta);
                END IF;
            END IF;
        END IF;
    END
//
DELIMITER ;


################################### MODIFICACIONES ###################################

DELIMITER // 
CREATE PROCEDURE IF NOT EXISTS modificarDisponibilidad(IN disponibilidad VARCHAR(50) ,IN ubicacion VARCHAR(50), IN fecha DATETIME, IN nombre VARCHAR(50), IN numeracion VARCHAR(50))
    BEGIN
        UPDATE Libre SET Libre.disponibilidad=disponibilidad WHERE Libre.ubicacionExacta=ubicacion AND Libre.fecha=fecha AND Libre.numeracion=numeracion AND Libre.nombre=nombre;
    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS modificarUsuarioPredef(IN usuarioNuevo VARCHAR(50) ,IN ubicacion VARCHAR(50), IN fecha DATETIME, IN nombre VARCHAR(50), IN numeracion VARCHAR(50))
    BEGIN
        DECLARE free1,free2 INT;
        SELECT count(*) INTO free1 FROM Comprada WHERE Comprada.ubicacionExacta=ubicacion AND Comprada.fecha=fecha AND Comprada.nombre=nombre AND Comprada.numeracion=numeracion;
        SELECT count(*) INTO free2 FROM Reservada WHERE Reservada.ubicacionExacta=ubicacion AND Reservada.fecha=fecha AND Reservada.nombre=nombre AND Reservada.numeracion=numeracion;
        IF(free1=0 AND free2=0) THEN
            IF (usuarioNuevo!='Adulto' AND usuarioNuevo!='Parado' AND usuarioNuevo!='Jubilado' AND usuarioNuevo!='Bebe' AND usuarioNuevo!='Infantil') THEN
                UPDATE Localidad SET Localidad.tipoPredefinido=false WHERE Localidad.ubicacionExacta=ubicacion AND Localidad.fecha=fecha AND Localidad.numeracion=numeracion AND Localidad.nombre=nombre;
                UPDATE Libre SET Libre.tipoUsuario=NULL WHERE Libre.ubicacionExacta=ubicacion AND Libre.fecha=fecha AND Libre.nombre=nombre AND Libre.numeracion=numeracion;
            ELSE
                UPDATE Localidad SET Localidad.tipoPredefinido=true WHERE Localidad.ubicacionExacta=ubicacion AND Localidad.fecha=fecha AND Localidad.numeracion=numeracion AND Localidad.nombre=nombre;
                UPDATE Libre SET Libre.tipoUsuario=usuarioNuevo WHERE Libre.ubicacionExacta=ubicacion AND Libre.fecha=fecha AND Libre.nombre=nombre AND Libre.numeracion=numeracion;
            END IF;
        END IF;
    END
//
DELIMITER ;


################################### BORRAR ###################################

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS borrarEspectaculo (IN descrip VARCHAR(250))
    BEGIN
        DECLARE fechaAux DATETIME;
        DECLARE ubicacionAux VARCHAR(250);
        DECLARE Comprita,Anuladita INT;
        DECLARE cursorEvento CURSOR FOR SELECT Evento.fecha, Evento.ubicacionExacta FROM Evento WHERE Evento.descripcion=descrip;
        SELECT count(*) INTO Comprita FROM Comprada INNER JOIN Evento ON Comprada.fecha=Evento.fecha AND Comprada.ubicacionExacta=Evento.ubicacionExacta WHERE Evento.descripcion=descrip;
        SELECT count(*) INTO Anuladita FROM Anulada INNER JOIN Evento ON Anulada.fecha=Evento.fecha AND Anulada.ubicacionExacta=Evento.ubicacionExacta WHERE Evento.descripcion=descrip;
        IF (comprita=0 AND Anuladita=0) THEN
            OPEN cursorEvento;
                BEGIN
                DECLARE cursorEventosFinal BOOLEAN;
                DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursorEventosFinal=true;
                    bucleCursor: LOOP
                        FETCH cursorEvento INTO fechaAux,ubicacionAux;
                        IF (cursorEventosFinal=true)THEN
                            LEAVE bucleCursor;
                        END IF;
                        DELETE FROM Libre WHERE fecha=fechaAux AND ubicacionExacta=ubicacionAux;
                        DELETE FROM Reservada WHERE fecha=fechaAux AND ubicacionExacta=ubicacionAux;
                        DELETE FROM Localidad WHERE fecha=fechaAux AND ubicacionExacta=ubicacionAux;                        
                        DELETE FROM TipoUsuario WHERE fecha=fechaAux AND ubicacionExacta=ubicacionAux;
                        DELETE FROM Entradas WHERE fecha=fechaAux AND ubicacionExacta=ubicacionAux;
                        DELETE FROM Grada WHERE fecha=fechaAux AND ubicacionExacta=ubicacionAux;
                        DELETE FROM Evento WHERE fecha=fechaAux AND ubicacionExacta=ubicacionAux;  
                    END LOOP;
                    DELETE FROM Espectaculo WHERE Espectaculo.descripcion=descrip;
                END;
        END IF;
    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS borrarRecinto (IN ubi VARCHAR(250))
    BEGIN
        DECLARE Comprita,Anuladita INT;
        SELECT count(*) INTO Comprita FROM Comprada WHERE ubicacionExacta=ubi;
        SELECT count(*) INTO Anuladita FROM Anulada WHERE ubicacionExacta=ubi;
        IF (comprita=0 AND Anuladita=0) THEN
            DELETE FROM Libre WHERE ubicacionExacta=ubi;
            DELETE FROM Reservada WHERE ubicacionExacta=ubi;
            DELETE FROM Localidad WHERE ubicacionExacta=ubi;                      
            DELETE FROM TipoUsuario WHERE ubicacionExacta=ubi;
            DELETE FROM Entradas WHERE ubicacionExacta=ubi;
            DELETE FROM Grada WHERE ubicacionExacta=ubi;
            DELETE FROM Evento WHERE ubicacionExacta=ubi;
            DELETE FROM Recinto WHERE ubicacionExacta=ubi;
        END IF;
    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS borrarEvento (IN fechita DATETIME, IN ubi VARCHAR(250))
    BEGIN
        DECLARE Comprita,Anuladita INT;
        SELECT count(*) INTO Comprita FROM Comprada WHERE ubicacionExacta=ubi AND fecha=fechita;
        SELECT count(*) INTO Anuladita FROM Anulada WHERE ubicacionExacta=ubi AND fecha=fechita;    
        IF (comprita=0 AND Anuladita=0) THEN
            DELETE FROM Libre WHERE ubicacionExacta=ubi AND fecha=fechita;
            DELETE FROM Reservada WHERE ubicacionExacta=ubi AND fecha=fechita;
            DELETE FROM Localidad WHERE ubicacionExacta=ubi AND fecha=fechita;                      
            DELETE FROM TipoUsuario WHERE ubicacionExacta=ubi AND fecha=fechita;
            DELETE FROM Entradas WHERE ubicacionExacta=ubi AND fecha=fechita;
            DELETE FROM Grada WHERE ubicacionExacta=ubi AND fecha=fechita;
            DELETE FROM Evento WHERE ubicacionExacta=ubi AND fecha=fechita;
        END IF;
    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS borrarGrada (IN nombrecito VARCHAR(50), IN fechita DATETIME, IN ubi VARCHAR(250))
    BEGIN
        DECLARE Comprita,Anuladita INT;
        SELECT count(*) INTO Comprita FROM Comprada WHERE ubicacionExacta=ubi AND fecha=fechita AND nombre=nombrecito;
        SELECT count(*) INTO Anuladita FROM Anulada WHERE ubicacionExacta=ubi AND fecha=fechita AND nombre=nombrecito;    
        IF (comprita=0 AND Anuladita=0) THEN
            DELETE FROM Libre WHERE ubicacionExacta=ubi AND fecha=fechita AND nombre=nombrecito;
            DELETE FROM Reservada WHERE ubicacionExacta=ubi AND fecha=fechita AND nombre=nombrecito;
            DELETE FROM Localidad WHERE ubicacionExacta=ubi AND fecha=fechita AND nombre=nombrecito;                      
            DELETE FROM TipoUsuario WHERE ubicacionExacta=ubi AND fecha=fechita AND nombre=nombrecito;
            DELETE FROM Entradas WHERE ubicacionExacta=ubi AND fecha=fechita AND nombre=nombrecito;
            DELETE FROM Grada WHERE ubicacionExacta=ubi AND fecha=fechita AND nombre=nombrecito;
        END IF;
    END
//
DELIMITER ;


################################### CONSULTAS ###################################

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarRecintos ()
    BEGIN
    SELECT * FROM Recinto;
    END
    //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarGradas (IN fecha DATETIME,IN ubicacion VARCHAR(250))
    BEGIN
    SELECT * FROM Grada INNER JOIN Evento ON Grada.ubicacionExacta=Evento.ubicacionExacta AND Grada.fecha=Evento.fecha WHERE Evento.ubicacionExacta=ubicacion AND Evento.fecha=fecha;
    END
    //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarEvento(IN descripcion VARCHAR(250),IN fecha DATETIME,IN ubicacion VARCHAR(250))
    BEGIN
    
        SELECT Espectaculo.nombre as NombreEspectaculo, Espectaculo.descripcion, Recinto.nombre as NombreRecinto, Recinto.ubicacionExacta as Ubicacion, Calendario.fecha  FROM Evento INNER JOIN Recinto ON  Evento.ubicacionExacta=Recinto.ubicacionExacta INNER JOIN Calendario ON Evento.fecha=Calendario.fecha INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion where Espectaculo.descripcion=descripcion AND Recinto.ubicacionExacta=ubicacion AND Calendario.fecha=fecha;
    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarEventosEspectaculo(IN descripcion VARCHAR(250))
    BEGIN
        SELECT Espectaculo.nombre as NombreEspectaculo, Espectaculo.descripcion, Recinto.nombre as NombreRecinto, Recinto.ubicacionExacta as Ubicacion, Calendario.fecha  FROM Evento INNER JOIN Recinto ON  Evento.ubicacionExacta=Recinto.ubicacionExacta INNER JOIN Calendario ON Evento.fecha=Calendario.fecha INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion where Espectaculo.descripcion=descripcion;
    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarEventos()
    BEGIN
        SELECT Espectaculo.nombre as NombreEspectaculo, Espectaculo.descripcion, Recinto.nombre as NombreRecinto, Recinto.ubicacionExacta as Ubicacion, Calendario.fecha  FROM Evento INNER JOIN Recinto ON  Evento.ubicacionExacta=Recinto.ubicacionExacta INNER JOIN Calendario ON Evento.fecha=Calendario.fecha INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion;
    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarEventosUbicacion(IN ubicacion VARCHAR(250))
    BEGIN
        SELECT Espectaculo.nombre as NombreEspectaculo, Espectaculo.descripcion, Recinto.nombre as NombreRecinto, Recinto.ubicacionExacta as Ubicacion, Calendario.fecha  FROM Evento INNER JOIN Recinto ON  Evento.ubicacionExacta=Recinto.ubicacionExacta INNER JOIN Calendario ON Evento.fecha=Calendario.fecha INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion where Recinto.ubicacionExacta=ubicacion;
    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarLibres (IN fecha DATETIME,IN ubicacion VARCHAR(250))
    BEGIN
        SELECT Espectaculo.nombre as NombrePelicula,Libre.numeracion,Libre.nombre as Grada ,Libre.tipoUsuario,Libre.disponibilidad FROM Libre INNER JOIN Evento ON Libre.fecha=Evento.fecha AND Libre.ubicacionExacta=Evento.ubicacionExacta INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion WHERE Libre.ubicacionExacta=ubicacion AND Libre.fecha=fecha ;
    END
    //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarCompradas (IN fecha DATETIME,IN ubicacion VARCHAR(250))
    BEGIN
        SELECT Espectaculo.nombre as NombrePelicula, Comprada.formaPago, Comprada.numeracion, Comprada.nombre as Grada, Comprada.tiempoCompra, Comprada.tipoUsuario,Comprada.preci AS Precio FROM Comprada INNER JOIN Evento ON Comprada.fecha=Evento.fecha AND Comprada.ubicacionExacta=Evento.ubicacionExacta INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion WHERE Comprada.ubicacionExacta=ubicacion AND Comprada.fecha=fecha;
    END
    //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarReservadas (IN fecha DATETIME,IN ubicacion VARCHAR(250))
    BEGIN
        SELECT Espectaculo.nombre as NombrePelicula, Reservada.numeroReserva, Reservada.numeracion, Reservada.nombre as Grada, Reservada.tiempoReserva, Reservada.tipoUsuario FROM Reservada INNER JOIN Evento ON Reservada.fecha=Evento.fecha AND Reservada.ubicacionExacta=Evento.ubicacionExacta INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion WHERE Reservada.ubicacionExacta=ubicacion AND Reservada.fecha=fecha;
    END
    //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarMiReserva (IN reserva INT, IN nombre VARCHAR(50), IN fecha DATETIME, IN ubicacion VARCHAR(250))
    BEGIN
        SELECT Espectaculo.nombre as NombrePelicula, Reservada.numeroReserva, Reservada.numeracion, Reservada.nombre as Grada, Reservada.tiempoReserva, Reservada.tipoUsuario FROM Reservada INNER JOIN Evento ON Reservada.fecha=Evento.fecha AND Reservada.ubicacionExacta=Evento.ubicacionExacta INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion WHERE Reservada.ubicacionExacta=ubicacion AND Reservada.fecha=fecha AND Reservada.numeroReserva=reserva AND Reservada.nombre=nombre;
    END
    //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarCompradasPorPago(IN formaDePago VARCHAR(50))
    BEGIN
        SELECT Comprada.numeracion, Comprada.nombre AS NombreGrada, Comprada.fecha AS FechaEvento, Comprada.ubicacionExacta AS Recinto, Espectaculo.nombre AS Espectaculo, Comprada.tipoUsuario AS TipoUsuario, Comprada.tiempoCompra AS FechaCompra, Comprada.Precio AS Precio FROM Comprada INNER JOIN Evento ON Evento.fecha=Comprada.fecha  AND Evento.ubicacionExacta=Comprada.ubicacionExacta INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion WHERE Comprada.formaPago=formaDePago order by Comprada.tiempoCompra DESC;

    END
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS consultarAnuladas (IN fecha DATETIME,IN ubicacion VARCHAR(250))
    BEGIN
        SELECT Espectaculo.nombre as NombrePelicula, Anulada.m as TipoAnulacion, Anulada.numeracion, Anulada.nombre as Grada, Anulada.horaAnulacion, Anulada.tipoUsuario, Anulada.precio FROM Anulada INNER JOIN Evento ON Anulada.fecha=Evento.fecha AND Anulada.ubicacionExacta=Evento.ubicacionExacta INNER JOIN Espectaculo ON Evento.descripcion=Espectaculo.descripcion WHERE Anulada.ubicacionExacta=ubicacion AND Anulada.fecha=fecha;
    END
    //
DELIMITER ;