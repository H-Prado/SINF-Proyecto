CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'sinf2022.';
CREATE USER IF NOT EXISTS 'admin' IDENTIFIED BY 'sinf2022.';
GRANT ALL ON taquilla_virtual.* TO 'admin'@'localhost';
CREATE USER IF NOT EXISTS 'cliente'@'localhost' IDENTIFIED BY 'sinf2022.';
CREATE USER IF NOT EXISTS 'cliente' IDENTIFIED BY 'sinf2022.';
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
                 
CREATE TABLE IF NOT EXISTS Calendario (     fecha DATETIME,
                                            PRIMARY KEY(fecha));

CREATE TABLE IF NOT EXISTS Recinto (        ubicacionExacta VARCHAR(250) PRIMARY KEY,
                                            nombre VARCHAR(50));

CREATE TABLE IF NOT EXISTS Espectaculo (    descripcion VARCHAR(250),
                                            nombre VARCHAR(50), 
                                            tipo VARCHAR(50),
                                            participantes VARCHAR(50),
                                            duracion INT,
                                            penalizacion INT,
                                            PRIMARY KEY (descripcion));

#
CREATE TABLE IF NOT EXISTS Evento(          fecha DATETIME NOT NULL,
                                            ubicacionExacta VARCHAR(250) NOT NULL,
                                            descripcion VARCHAR(250) NOT NULL,
                                            tiempoCancelacion INT,
                                            tiempoReserva INT,
                                            tiempoValidezReserva INT,
                                            FOREIGN KEY(fecha) REFERENCES Calendario(fecha),
                                            FOREIGN KEY(ubicacionExacta) REFERENCES Recinto(ubicacionExacta),
                                            FOREIGN KEY(descripcion) REFERENCES Espectaculo(descripcion),
                                            PRIMARY KEY(fecha,ubicacionExacta));

CREATE TABLE IF NOT EXISTS Grada (          nombre VARCHAR(50),
                                            precioAdulto INT,
                                            precioJubilado INT,
                                            precioParado INT,
                                            precioInfantil INT,
                                            precioBebe INT,
                                            maxReservas INT,
                                            fecha DATETIME NOT NULL,
                                            ubicacionExacta VARCHAR(250) NOT NULL,
                                            FOREIGN KEY(fecha,ubicacionExacta) REFERENCES Evento(fecha,ubicacionExacta) ON UPDATE CASCADE,
                                            PRIMARY KEY(nombre,fecha,ubicacionExacta));

CREATE TABLE IF NOT EXISTS Entradas (       contador INT,
                                            nombre VARCHAR(50),
                                            fecha DATETIME,
                                            ubicacionExacta VARCHAR(250),
                                            FOREIGN KEY(nombre,fecha,ubicacionExacta) REFERENCES Grada(nombre,fecha,ubicacionExacta) ON UPDATE CASCADE,
                                            PRIMARY KEY(contador,nombre,fecha,ubicacionExacta));

CREATE TABLE IF NOT EXISTS Localidad (      numeracion VARCHAR(50),
                                            contador INT,
                                            nombre VARCHAR(50),
                                            fecha DATETIME,
                                            ubicacionExacta VARCHAR(250),
                                            tipoPredefinido BOOLEAN DEFAULT false,
                                            UNIQUE(contador,nombre,fecha,ubicacionExacta),
                                            UNIQUE(numeracion,nombre,fecha,ubicacionExacta),
                                            FOREIGN KEY(contador,nombre,fecha,ubicacionExacta) REFERENCES Entradas(contador,nombre,fecha,ubicacionExacta) ON UPDATE CASCADE,
                                            PRIMARY KEY(numeracion,contador,nombre,fecha,ubicacionExacta));

CREATE TABLE IF NOT EXISTS TipoUsuario(     tipo VARCHAR(50),
                                            #contador INT UNIQUE,
                                            nombre VARCHAR(50),
                                            fecha DATETIME,
                                            ubicacionExacta VARCHAR(250),
                                            FOREIGN KEY(nombre,fecha,ubicacionExacta) REFERENCES Entradas(nombre,fecha,ubicacionExacta) ON UPDATE CASCADE,
                                            PRIMARY KEY(tipo,nombre,fecha,ubicacionExacta));

CREATE TABLE IF NOT EXISTS Libre (          disponibilidad VARCHAR(50) NOT NULL,
                                            numeracion VARCHAR(50) ,
                                            contador INT ,
                                            nombre VARCHAR(50),
                                            fecha DATETIME,
                                            ubicacionExacta VARCHAR(250),
                                            tipoUsuario VARCHAR(50),
                                            FOREIGN KEY(numeracion,contador,nombre,fecha,ubicacionExacta) REFERENCES Localidad(numeracion,contador,nombre,fecha,ubicacionExacta) ON UPDATE CASCADE,
                                            FOREIGN KEY(tipoUsuario,nombre,fecha,ubicacionExacta) REFERENCES TipoUsuario(tipo,nombre,fecha,ubicacionExacta),
                                            PRIMARY KEY(numeracion,contador,nombre,fecha,ubicacionExacta));

CREATE TABLE IF NOT EXISTS Comprada (       formaPago VARCHAR(50) NOT NULL,
                                            numeracion VARCHAR(50) ,
                                            contador INT ,
                                            nombre VARCHAR(50),
                                            fecha DATETIME,
                                            ubicacionExacta VARCHAR(250),
                                            tiempoCompra DATETIME DEFAULT NOW(),
                                            tipoUsuario VARCHAR(50) NOT NULL,
                                            precio INT NOT NULL,
                                            FOREIGN KEY(numeracion,contador,nombre,fecha,ubicacionExacta) REFERENCES Localidad(numeracion,contador,nombre,fecha,ubicacionExacta) ON UPDATE CASCADE,
                                            FOREIGN KEY(tipoUsuario,nombre,fecha,ubicacionExacta) REFERENCES TipoUsuario(tipo,nombre,fecha,ubicacionExacta),
                                            PRIMARY KEY(numeracion,contador,nombre,fecha,ubicacionExacta));
                                        
CREATE TABLE IF NOT EXISTS Reservada (      numeroReserva INT ,
                                            numeracion VARCHAR(50) ,
                                            contador INT ,
                                            nombre VARCHAR(50),
                                            fecha DATETIME,
                                            ubicacionExacta VARCHAR(250),
                                            tipoUsuario VARCHAR(50) NOT NULL,
                                            tiempoReserva DATETIME DEFAULT NOW(),
                                            UNIQUE(numeroReserva,numeracion,nombre,fecha,ubicacionExacta),
                                            FOREIGN KEY(numeracion,contador,nombre,fecha,ubicacionExacta) REFERENCES Localidad(numeracion,contador,nombre,fecha,ubicacionExacta) ON UPDATE CASCADE,
                                            FOREIGN KEY(tipoUsuario,nombre,fecha,ubicacionExacta) REFERENCES TipoUsuario(tipo,nombre,fecha,ubicacionExacta),
                                            PRIMARY KEY(numeracion,contador,nombre,fecha,ubicacionExacta));

CREATE TABLE IF NOT EXISTS Anulada(         m VARCHAR(50),
                                            numeracion VARCHAR(50) ,
                                            contador INT,
                                            nombre VARCHAR(50),
                                            fecha DATETIME,
                                            ubicacionExacta VARCHAR(250),
                                            tipoUsuario VARCHAR(50) NOT NULL,
                                            horaAnulacion DATETIME DEFAULT NOW(), 
                                            costePenalizacion INT DEFAULT 0,
                                            precio INT,
                                            FOREIGN KEY(numeracion,contador,nombre,fecha,ubicacionExacta) REFERENCES Localidad(numeracion,contador,nombre,fecha,ubicacionExacta) ON UPDATE CASCADE,
                                            FOREIGN KEY(tipoUsuario,nombre,fecha,ubicacionExacta) REFERENCES TipoUsuario(tipo,nombre,fecha,ubicacionExacta),
                                            PRIMARY KEY(horaAnulacion,numeracion,contador,nombre,fecha,ubicacionExacta));



CREATE INDEX indiceCalendario ON Calendario(fecha);

CREATE INDEX indiceRecinto ON Recinto(ubicacionExacta);

CREATE INDEX indiceEspectaculo ON Espectaculo(descripcion);

CREATE INDEX indiceEvento ON Evento(ubicacionExacta,fecha);

CREATE INDEX indiceGrada ON Grada(ubicacionExacta,fecha,nombre);

CREATE INDEX indiceEntradas ON Entradas(ubicacionExacta,fecha,nombre,contador);

CREATE INDEX indiceLocalidad ON Localidad(ubicacionExacta,fecha,nombre,contador,numeracion);

CREATE INDEX indiceLibres ON Libre(ubicacionExacta,fecha,nombre,contador,numeracion);

CREATE INDEX indiceComprada ON Comprada(ubicacionExacta,fecha,nombre,contador,numeracion);

CREATE INDEX indiceReservada ON Reservada(ubicacionExacta,fecha,nombre,contador,numeracion);

CREATE INDEX indiceTipoUsuario ON TipoUsuario(ubicacionExacta,fecha,nombre,tipo);

CREATE INDEX indiceAnulada ON Anulada(numeracion,nombre,fecha,ubicacionExacta);

