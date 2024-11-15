CREATE DATABASE Equiposss
GO
USE Equiposss

GO
CREATE TABLE Personas(
id_persona int primary key,
nombre_completo nvarchar(50) not null,
dni int not null,
fecha_nac date not null,
alta bit NOT NULL
)
GO
CREATE TABLE Posiciones(
id_posicion int identity primary key,
posicion varchar(25) not null
)
GO
CREATE TABLE Ligas(
id_liga int primary key,
liga varchar(50),
alta bit NOT NULL
)
GO
CREATE TABLE Equipos(
id_equipo int primary key,
nombre_equipo nvarchar(25) not null,
director_tecnico int not null,
id_liga int not null,
alta bit NOT NULL,
CONSTRAINT fk_director_tecnico FOREIGN KEY (director_tecnico) REFERENCES Personas(id_persona),
CONSTRAINT fk_id_liga_equipo FOREIGN KEY (id_liga) REFERENCES Ligas(id_liga)
)
GO
CREATE TABLE EquiposLigasInfo(
id_equipo_liga_info int identity primary key,
id_equipo int not null,
partidos_g smallint,
partidos_p smallint,
puntuacion INT,
alta bit not null,
CONSTRAINT fk_equipo_stats FOREIGN KEY (id_equipo) REFERENCES Equipos(id_equipo)
)
GO
CREATE TABLE Jugadores(
id_jugador int primary key,
id_persona int not null,
nro_camiseta smallint not null,
id_posicion int not null,
id_equipo int not null,
alta bit not null,
CONSTRAINT fk_persona FOREIGN KEY (id_persona) REFERENCES Personas(id_persona),
CONSTRAINT fk_posicion FOREIGN KEY (id_posicion) REFERENCES Posiciones(id_posicion),
CONSTRAINT fk_equipo FOREIGN KEY (id_equipo) REFERENCES Equipos(id_equipo),
)
GO
CREATE TABLE JugadoresLog(
id_jugador_log int identity primary key,
id_jugador int not null,
nro_camiseta smallint not null,
id_posicion int not null,
id_equipo int not null,
fecha_actualizacion date not null,
CONSTRAINT fk_jugador_log FOREIGN KEY (id_jugador) REFERENCES Jugadores(id_jugador),
CONSTRAINT fk_posicion_log FOREIGN KEY (id_posicion) REFERENCES Posiciones(id_posicion),
CONSTRAINT fk_equipo_log FOREIGN KEY (id_equipo) REFERENCES Equipos(id_equipo)
)
GO
CREATE TABLE Usuarios(
id_usuario int primary key,
usuario nvarchar(25) not null,
contrasena nvarchar(25) not null,
rol varchar(15) not null,
id_equipo int,
CONSTRAINT fk_equipo_favorito FOREIGN KEY (id_equipo) REFERENCES Equipos(id_equipo)
)
GO
CREATE TABLE Partidos(
id_partido int identity primary key,
id_local int not null,
id_visitante int not null,
fecha_partido date not null,
hora_partido time not null,
arbitro int not null,
resultado_local int,
resultado_visitante int,
CONSTRAINT fk_equipo_local FOREIGN KEY (id_local) REFERENCES Equipos(id_equipo),
CONSTRAINT fk_equipo_visitante FOREIGN KEY (id_visitante) REFERENCES Equipos(id_equipo),
CONSTRAINT fk_arbitro FOREIGN KEY (arbitro) REFERENCES Personas(id_persona)
)
GO
SET DATEFORMAT DMY
GO

GO
CREATE PROC SP_INSERTAR_PERSONA
@id_persona int, @nombre_completo varchar(50), @dni bigint, @fecha_nac date
AS
	INSERT INTO Personas VALUES(@id_persona, @nombre_completo, @dni, @fecha_nac, 1)
GO
CREATE PROC SP_INSERTAR_POSICION
@posicion varchar(25)
AS
	INSERT INTO Posiciones VALUES(@posicion)
GO
CREATE PROC SP_INSERTAR_EQUIPO
@id_equipo int, @nombre_equipo varchar(25), @director_tecnico int
AS
	INSERT INTO Equipos(id_equipo, nombre_equipo, director_tecnico, alta) VALUES(@id_equipo, @nombre_equipo, @director_tecnico, 1)
GO
CREATE PROC SP_INSERTAR_JUGADOR
@id_jugador int, @id_persona int, @nro_camiseta smallint, @id_posicion int, @id_equipo int
AS
	INSERT INTO Jugadores VALUES(@id_jugador, @id_persona, @nro_camiseta, @id_posicion, @id_equipo, 1)
GO
CREATE PROC SP_INSERTAR_USUARIO
@id_usuario int, @usuario varchar(25), @contrasena varchar(25), @rol varchar(15), @equipo_favorito int
AS
	INSERT INTO Usuarios VALUES(@id_usuario, @usuario, @contrasena, @rol, @equipo_favorito)
GO
CREATE TRIGGER TG_LOG_JUGADOR
ON Jugadores
AFTER UPDATE
AS BEGIN
	IF UPDATE(id_equipo) OR UPDATE(id_posicion) OR UPDATE(nro_camiseta)
	BEGIN
		DECLARE @fecha_actualizacion date = GETDATE();
		INSERT INTO JugadoresLog
		SELECT id_jugador, nro_camiseta, id_posicion, id_equipo, @fecha_actualizacion
		FROM inserted i
	END
END

go

INSERT INTO Ligas VALUES(1, 'Premier League', 1)
INSERT INTO Ligas VALUES(2,'Liga Extrangera', 1)


go

INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(1, 'Mikel Arteta', 45678901, '1982-03-26', 1),
(2, 'Pep Guardiola', 45678902, '1971-01-18', 1),
(3, 'Jürgen Klopp', 45678903, '1967-06-16', 1),
(4, 'Ange Postecoglou', 45678904, '1965-08-27', 1),
(5, 'Unai Emery', 45678905, '1971-11-03', 1),
(6, 'Erik ten Hag', 45678906, '1970-02-02', 1),
(7, 'Eddie Howe', 45678907, '1977-11-29', 1),
(8, 'Roberto De Zerbi', 45678908, '1979-06-06', 1),
(9, 'Mauricio Pochettino', 45678909, '1972-03-02', 1),
(10, 'David Moyes', 45678910, '1963-04-25', 1),
(11, 'Gary O'+char(39)+'Neil', 45678911, '1983-05-18', 1),
(12, 'Vincent Kompany', 45678912, '1986-04-10', 1),
(13, 'Rob Edwards', 45678913, '1982-12-25', 1),
(14, 'Chris Wilder', 45678914, '1967-09-23', 1),
(15, 'Andoni Iraola', 45678915, '1982-06-22', 1),
(16, 'Marco Silva', 45678916, '1977-07-12', 1),
(17, 'Sean Dyche', 45678917, '1971-06-28', 1),
(18, 'Nuno Espírito Santo', 45678918, '1974-01-25', 1),
(19, 'Thomas Frank', 45678919, '1973-10-09', 1),
(20, 'Roy Hodgson', 45678920, '1947-08-09', 1),
(21, 'DT Liga Extranjera', 45678921, '1980-01-01', 1)
GO

-- Insertando los 20 equipos de la Premier League
INSERT INTO Equipos (id_equipo, nombre_equipo, director_tecnico, id_liga, alta) VALUES 
(1, 'Arsenal', 1, 1, 1),
(2, 'Manchester City', 2, 1, 1),
(3, 'Liverpool', 3, 1, 1),
(4, 'Tottenham', 4, 1, 1),
(5, 'Aston Villa', 5, 1, 1),
(6, 'Manchester United', 6, 1, 1),
(7, 'Newcastle United', 7, 1, 1),
(8, 'Brighton', 8, 1, 1),
(9, 'Chelsea', 9, 1, 1),
(10, 'West Ham United', 10, 1, 1),
(11, 'Wolverhampton', 11, 1, 1),
(12, 'Burnley', 12, 1, 1),
(13, 'Luton Town', 13, 1, 1),
(14, 'Sheffield United', 14, 1, 1),
(15, 'Bournemouth', 15, 1, 1),
(16, 'Fulham', 16, 1, 1),
(17, 'Everton', 17, 1, 1),
(18, 'Nottingham Forest', 18, 1, 1),
(19, 'Brentford', 19, 1, 1),
(20, 'Crystal Palace', 20, 1, 1),
(21, 'Club Extranjero', 21, 2, 1)
GO

INSERT INTO Posiciones (posicion) VALUES 
-- Porteros
('Portero'),
-- Defensas
('Defensa Central'),
('Lateral Derecho'),
('Lateral Izquierdo'),
-- Mediocampistas
('Mediocentro Defensivo'),
('Mediocentro'),
('Mediocentro Ofensivo'),
-- Extremos
('Extremo Derecho'),
('Extremo Izquierdo'),
('Segundo Delantero'),
-- Delanteros
('Delantero Centro')
GO

-- Insertar Personas (Jugadores del Arsenal)
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(1000, 'Aaron Ramsdale', 30001234, '1998-05-14', 1),
(1001, 'David Raya', 30001235, '1995-09-15', 1),
(1002, 'Karl Hein', 30001236, '2002-04-13', 1),
(1003, 'William Saliba', 30001237, '2001-03-24', 1),
(1004, 'Ben White', 30001238, '1997-10-08', 1),
(1005, 'Gabriel Magalhães', 30001239, '1997-12-19', 1),
(1006, 'Jakub Kiwior', 30001240, '2000-02-15', 1),
(1007, 'Oleksandr Zinchenko', 30001241, '1996-12-15', 1),
(1008, 'Takehiro Tomiyasu', 30001242, '1998-11-05', 1),
(1009, 'Jurrien Timber', 30001243, '2001-06-17', 1),
(1010, 'Cédric Soares', 30001244, '1991-08-31', 1),
(1011, 'Thomas Partey', 30001245, '1993-06-13', 1),
(1012, 'Jorginho', 30001246, '1991-12-20', 1),
(1013, 'Martin Ødegaard', 30001247, '1998-12-17', 1),
(1014, 'Emile Smith Rowe', 30001248, '2000-07-28', 1),
(1015, 'Kai Havertz', 30001249, '1999-06-11', 1),
(1016, 'Fábio Vieira', 30001250, '2000-05-30', 1),
(1017, 'Mohamed Elneny', 30001251, '1992-07-11', 1),
(1018, 'Declan Rice', 30001252, '1999-01-14', 1),
(1019, 'Bukayo Saka', 30001253, '2001-09-05', 1),
(1020, 'Gabriel Martinelli', 30001254, '2001-06-18', 1),
(1021, 'Leandro Trossard', 30001255, '1994-12-04', 1),
(1022, 'Reiss Nelson', 30001256, '1999-12-10', 1),
(1023, 'Gabriel Jesus', 30001257, '1997-04-03', 1),
(1024, 'Eddie Nketiah', 30001258, '1999-05-30', 1);

-- Insertar Jugadores del Arsenal
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES
-- Porteros
(1000, 1000, 1, 1, 1, 1),    -- Ramsdale
(1001, 1001, 22, 1, 1, 1),   -- Raya
(1002, 1002, 31, 1, 1, 1),   -- Hein

-- Defensas
(1003, 1003, 2, 2, 1, 1),    -- Saliba
(1004, 1004, 4, 3, 1, 1),    -- White
(1005, 1005, 6, 2, 1, 1),    -- Gabriel
(1006, 1006, 15, 2, 1, 1),   -- Kiwior
(1007, 1007, 35, 4, 1, 1),   -- Zinchenko
(1008, 1008, 18, 3, 1, 1),   -- Tomiyasu
(1009, 1009, 12, 2, 1, 1),   -- Timber
(1010, 1010, 17, 3, 1, 1),   -- Cedric

-- Mediocampistas
(1011, 1011, 5, 5, 1, 1),    -- Partey
(1012, 1012, 20, 6, 1, 1),   -- Jorginho
(1013, 1013, 8, 7, 1, 1),    --  degaard
(1014, 1014, 10, 7, 1, 1),   -- Smith Rowe
(1015, 1015, 29, 7, 1, 1),   -- Havertz
(1016, 1016, 21, 7, 1, 1),   -- Vieira
(1017, 1017, 25, 5, 1, 1),   -- Elneny
(1018, 1018, 41, 5, 1, 1),   -- Rice

-- Extremos y Delanteros
(1019, 1019, 7, 8, 1, 1),    -- Saka
(1020, 1020, 11, 9, 1, 1),   -- Martinelli
(1021, 1021, 19, 9, 1, 1),   -- Trossard
(1022, 1022, 24, 8, 1, 1),   -- Nelson
(1023, 1023, 9, 11, 1, 1),   -- Jesus
(1024, 1024, 14, 11, 1, 1);  -- Nketiah

----

-- Insertar Personas (Jugadores del Manchester City)
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(1025, 'Ederson Moraes', 30001259, '1993-08-17', 1),
(1026, 'Stefan Ortega', 30001260, '1992-11-06', 1),
(1027, 'Scott Carson', 30001261, '1985-09-03', 1),
(1028, 'Rúben Dias', 30001262, '1997-05-14', 1),
(1029, 'John Stones', 30001263, '1994-05-28', 1),
(1030, 'Nathan Aké', 30001264, '1995-02-18', 1),
(1031, 'Kyle Walker', 30001265, '1990-05-28', 1),
(1032, 'Josko Gvardiol', 30001266, '2002-01-23', 1),
(1033, 'Manuel Akanji', 30001267, '1995-07-19', 1),
(1034, 'Sergio Gómez', 30001268, '2000-09-04', 1),
(1035, 'Rico Lewis', 30001269, '2004-11-21', 1),
(1036, 'Rodri', 30001270, '1996-06-22', 1),
(1037, 'Kevin De Bruyne', 30001271, '1991-06-28', 1),
(1038, 'Matheus Nunes', 30001272, '1998-08-27', 1),
(1039, 'Bernardo Silva', 30001273, '1994-08-10', 1),
(1040, 'Phil Foden', 30001274, '2000-05-28', 1),
(1041, 'Mateo Kovacic', 30001275, '1994-05-06', 1),
(1042, 'Jack Grealish', 30001276, '1995-09-10', 1),
(1043, 'Jeremy Doku', 30001277, '2002-05-27', 1),
(1044, 'Oscar Bobb', 30001278, '2003-07-12', 1),
(1045, 'Erling Haaland', 30001279, '2000-07-21', 1),
(1046, 'Julián Álvarez', 30001280, '2000-01-31', 1);

-- Insertar Jugadores del Manchester City
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES
-- Porteros
(1025, 1025, 31, 1, 2, 1),   -- Ederson
(1026, 1026, 18, 1, 2, 1),   -- Ortega
(1027, 1027, 33, 1, 2, 1),   -- Carson

-- Defensas
(1028, 1028, 3, 2, 2, 1),    -- Dias
(1029, 1029, 5, 2, 2, 1),    -- Stones
(1030, 1030, 6, 2, 2, 1),    -- Ak 
(1031, 1031, 2, 3, 2, 1),    -- Walker
(1032, 1032, 24, 4, 2, 1),   -- Gvardiol
(1033, 1033, 25, 2, 2, 1),   -- Akanji
(1034, 1034, 21, 4, 2, 1),   -- Sergio G mez
(1035, 1035, 82, 3, 2, 1),   -- Rico Lewis

-- Mediocampistas
(1036, 1036, 16, 5, 2, 1),   -- Rodri
(1037, 1037, 17, 7, 2, 1),   -- De Bruyne
(1038, 1038, 27, 6, 2, 1),   -- Matheus Nunes
(1039, 1039, 20, 7, 2, 1),   -- Bernardo Silva
(1040, 1040, 47, 7, 2, 1),   -- Foden
(1041, 1041, 8, 6, 2, 1),    -- Kovacic

-- Extremos y Delanteros
(1042, 1042, 10, 9, 2, 1),   -- Grealish
(1043, 1043, 11, 8, 2, 1),   -- Doku
(1044, 1044, 52, 8, 2, 1),   -- Oscar Bobb
(1045, 1045, 9, 11, 2, 1),   -- Haaland
(1046, 1046, 19, 10, 2, 1);  -- Juli n  lvarez


-- Insertar Personas (Jugadores del Liverpool)
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(1050, 'Alisson Becker', 30001281, '1992-10-02', 1),
(1051, 'Caoimhin Kelleher', 30001282, '1998-11-23', 1),
(1052, 'Adrián San Miguel', 30001283, '1987-01-03', 1),
(1053, 'Virgil van Dijk', 30001284, '1991-07-08', 1),
(1054, 'Ibrahima Konaté', 30001285, '1999-05-25', 1),
(1055, 'Joe Gomez', 30001286, '1997-05-23', 1),
(1056, 'Joel Matip', 30001287, '1991-08-08', 1),
(1057, 'Andy Robertson', 30001288, '1994-03-11', 1),
(1058, 'Trent Alexander-Arnold', 30001289, '1998-10-07', 1),
(1059, 'Kostas Tsimikas', 30001290, '1996-05-12', 1),
(1060, 'Jarell Quansah', 30001291, '2003-01-29', 1),
(1061, 'Conor Bradley', 30001292, '2003-07-09', 1),
(1062, 'Alexis Mac Allister', 30001293, '1998-12-24', 1),
(1063, 'Dominik Szoboszlai', 30001294, '2000-10-25', 1),
(1064, 'Wataru Endo', 30001295, '1993-02-09', 1),
(1065, 'Curtis Jones', 30001296, '2001-01-30', 1),
(1066, 'Ryan Gravenberch', 30001297, '2002-05-16', 1),
(1067, 'Harvey Elliott', 30001298, '2003-04-04', 1),
(1068, 'Stefan Bajcetic', 30001299, '2004-10-22', 1),
(1069, 'Mohamed Salah', 30001300, '1992-06-15', 1),
(1070, 'Luis Díaz', 30001301, '1997-01-13', 1),
(1071, 'Diogo Jota', 30001302, '1996-12-04', 1),
(1072, 'Darwin Núñez', 30001303, '1999-06-24', 1),
(1073, 'Cody Gakpo', 30001304, '1999-05-07', 1);

-- Insertar Jugadores del Liverpool
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES
-- Porteros
(1050, 1050, 1, 1, 3, 1),    -- Alisson
(1051, 1051, 62, 1, 3, 1),   -- Kelleher
(1052, 1052, 13, 1, 3, 1),   -- Adri n

-- Defensas
(1053, 1053, 4, 2, 3, 1),    -- Van Dijk
(1054, 1054, 5, 2, 3, 1),    -- Konat 
(1055, 1055, 2, 3, 3, 1),    -- Gomez
(1056, 1056, 32, 2, 3, 1),   -- Matip
(1057, 1057, 26, 4, 3, 1),   -- Robertson
(1058, 1058, 66, 3, 3, 1),   -- Alexander-Arnold
(1059, 1059, 21, 4, 3, 1),   -- Tsimikas
(1060, 1060, 78, 2, 3, 1),   -- Quansah
(1061, 1061, 84, 3, 3, 1),   -- Bradley

-- Mediocampistas
(1062, 1062, 10, 6, 3, 1),   -- Mac Allister
(1063, 1063, 8, 7, 3, 1),    -- Szoboszlai
(1064, 1064, 3, 5, 3, 1),    -- Endo
(1065, 1065, 17, 6, 3, 1),   -- Curtis Jones
(1066, 1066, 38, 6, 3, 1),   -- Gravenberch
(1067, 1067, 19, 7, 3, 1),   -- Elliott
(1068, 1068, 43, 5, 3, 1),   -- Bajcetic

-- Extremos y Delanteros
(1069, 1069, 11, 8, 3, 1),   -- Salah
(1070, 1070, 7, 9, 3, 1),    -- Luis D az
(1071, 1071, 20, 10, 3, 1),  -- Diogo Jota
(1072, 1072, 9, 11, 3, 1),   -- Darwin N  ez
(1073, 1073, 18, 11, 3, 1);  -- Cody Gakpo


----


-- Insertar Personas (Jugadores del Tottenham)
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(1075, 'Guglielmo Vicario', 30001305, '1996-10-07', 1),
(1076, 'Fraser Forster', 30001306, '1988-03-17', 1),
(1077, 'Brandon Austin', 30001307, '1999-01-08', 1),
(1078, 'Cristian Romero', 30001308, '1998-04-27', 1),
(1079, 'Micky van de Ven', 30001309, '2001-04-19', 1),
(1080, 'Destiny Udogie', 30001310, '2002-11-28', 1),
(1081, 'Pedro Porro', 30001311, '1999-09-13', 1),
(1082, 'Ben Davies', 30001312, '1993-04-24', 1),
(1083, 'Eric Dier', 30001313, '1994-01-15', 1),
(1084, 'Emerson Royal', 30001314, '1999-01-14', 1),
(1085, 'Radu Dragusin', 30001315, '2002-02-03', 1),
(1086, 'Rodrigo Bentancur', 30001316, '1997-06-25', 1),
(1087, 'Yves Bissouma', 30001317, '1996-08-30', 1),
(1088, 'Pape Matar Sarr', 30001318, '2002-09-14', 1),
(1089, 'Oliver Skipp', 30001319, '2000-09-16', 1),
(1090, 'Pierre-Emile Højbjerg', 30001320, '1995-08-05', 1),
(1091, 'James Maddison', 30001321, '1996-11-23', 1),
(1092, 'Giovani Lo Celso', 30001322, '1996-04-09', 1),
(1093, 'Dejan Kulusevski', 30001323, '2000-04-25', 1),
(1094, 'Brennan Johnson', 30001324, '2001-05-23', 1),
(1095, 'Manor Solomon', 30001325, '1999-07-24', 1),
(1096, 'Son Heung-min', 30001326, '1992-07-08', 1),
(1097, 'Richarlison', 30001327, '1997-05-10', 1),
(1098, 'Timo Werner', 30001328, '1996-03-06', 1);

-- Insertar Jugadores del Tottenham
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES
-- Porteros
(1075, 1075, 13, 1, 4, 1),   -- Vicario
(1076, 1076, 20, 1, 4, 1),   -- Forster
(1077, 1077, 40, 1, 4, 1),   -- Austin

-- Defensas
(1078, 1078, 17, 2, 4, 1),   -- Romero
(1079, 1079, 37, 2, 4, 1),   -- Van de Ven
(1080, 1080, 38, 4, 4, 1),   -- Udogie
(1081, 1081, 23, 3, 4, 1),   -- Porro
(1082, 1082, 33, 4, 4, 1),   -- Davies
(1083, 1083, 15, 2, 4, 1),   -- Dier
(1084, 1084, 12, 3, 4, 1),   -- Emerson Royal
(1085, 1085, 6, 2, 4, 1),    -- Dragusin

-- Mediocampistas
(1086, 1086, 30, 6, 4, 1),   -- Bentancur
(1087, 1087, 8, 5, 4, 1),    -- Bissouma
(1088, 1088, 29, 6, 4, 1),   -- Sarr
(1089, 1089, 4, 6, 4, 1),    -- Skipp
(1090, 1090, 5, 5, 4, 1),    -- H jbjerg
(1091, 1091, 10, 7, 4, 1),   -- Maddison
(1092, 1092, 18, 7, 4, 1),   -- Lo Celso

-- Extremos y Delanteros
(1093, 1093, 21, 8, 4, 1),   -- Kulusevski
(1094, 1094, 28, 8, 4, 1),   -- Johnson
(1095, 1095, 27, 9, 4, 1),   -- Solomon
(1096, 1096, 7, 10, 4, 1),   -- Son
(1097, 1097, 9, 11, 4, 1),   -- Richarlison
(1098, 1098, 16, 11, 4, 1);  -- Werner

------

--Aston Villa
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(1100, 'Emiliano Martínez', 30001329, '1992-09-02', 1),
(1101, 'Robin Olsen', 30001330, '1990-01-08', 1),
(1102, 'Filip Marschall', 30001331, '2003-05-09', 1),
(1103, 'Pau Torres', 30001332, '1997-01-16', 1),
(1104, 'Diego Carlos', 30001333, '1993-03-15', 1),
(1105, 'Ezri Konsa', 30001334, '1997-10-23', 1),
(1106, 'Clément Lenglet', 30001335, '1995-06-17', 1),
(1107, 'Lucas Digne', 30001336, '1993-07-20', 1),
(1108, 'Matty Cash', 30001337, '1997-08-07', 1),
(1109, 'Alex Moreno', 30001338, '1993-06-08', 1),
(1110, 'Calum Chambers', 30001339, '1995-01-20', 1),
(1111, 'Douglas Luiz', 30001340, '1998-05-09', 1),
(1112, 'Boubacar Kamara', 30001341, '1999-11-23', 1),
(1113, 'John McGinn', 30001342, '1994-10-18', 1),
(1114, 'Jacob Ramsey', 30001343, '2001-05-28', 1),
(1115, 'Youri Tielemans', 30001344, '1997-05-07', 1),
(1116, 'Leander Dendoncker', 30001345, '1995-04-15', 1),
(1117, 'Tim Iroegbunam', 30001346, '2003-06-16', 1),
(1118, 'Morgan Rogers', 30001347, '2002-07-26', 1),
(1119, 'Leon Bailey', 30001348, '1997-08-09', 1),
(1120, 'Moussa Diaby', 30001349, '1999-07-07', 1),
(1121, 'Nicolò Zaniolo', 30001350, '1999-07-02', 1),
(1122, 'Bertrand Traoré', 30001351, '1995-09-06', 1),
(1123, 'Ollie Watkins', 30001352, '1995-12-30', 1),
(1124, 'Jhon Durán', 30001353, '2003-12-13', 1);

-- Insertar Jugadores del Aston Villa
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES
-- Porteros
(1100, 1100, 1, 1, 5, 1),    -- Emiliano Mart nez
(1101, 1101, 25, 1, 5, 1),   -- Olsen
(1102, 1102, 40, 1, 5, 1),   -- Marschall

-- Defensas
(1103, 1103, 4, 2, 5, 1),    -- Pau Torres
(1104, 1104, 3, 2, 5, 1),    -- Diego Carlos
(1105, 1105, 5, 2, 5, 1),    -- Konsa
(1106, 1106, 25, 2, 5, 1),   -- Lenglet
(1107, 1107, 12, 4, 5, 1),   -- Digne
(1108, 1108, 2, 3, 5, 1),    -- Cash
(1109, 1109, 15, 4, 5, 1),   -- Moreno
(1110, 1110, 16, 2, 5, 1),   -- Chambers

-- Mediocampistas
(1111, 1111, 6, 6, 5, 1),    -- Douglas Luiz
(1112, 1112, 44, 5, 5, 1),   -- Kamara
(1113, 1113, 7, 6, 5, 1),    -- McGinn
(1114, 1114, 41, 7, 5, 1),   -- Jacob Ramsey
(1115, 1115, 8, 6, 5, 1),    -- Tielemans
(1116, 1116, 32, 5, 5, 1),   -- Dendoncker
(1117, 1117, 36, 6, 5, 1),   -- Iroegbunam
(1118, 1118, 23, 7, 5, 1),   -- Morgan Rogers

-- Extremos y Delanteros
(1119, 1119, 31, 8, 5, 1),   -- Bailey
(1120, 1120, 19, 8, 5, 1),   -- Diaby
(1121, 1121, 22, 9, 5, 1),   -- Zaniolo
(1122, 1122, 17, 9, 5, 1),   -- Traor 
(1123, 1123, 11, 11, 5, 1),  -- Watkins
(1124, 1124, 24, 11, 5, 1);  -- Dur n


------

INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(1125, 'André Onana', 30001354, '1996-04-02', 1),
(1126, 'Altay Bayindir', 30001355, '1998-04-14', 1),
(1127, 'Tom Heaton', 30001356, '1986-04-15', 1),
(1128, 'Raphaël Varane', 30001357, '1993-04-25', 1),
(1129, 'Lisandro Martínez', 30001358, '1998-01-18', 1),
(1130, 'Harry Maguire', 30001359, '1993-03-05', 1),
(1131, 'Victor Lindelöf', 30001360, '1994-07-17', 1),
(1132, 'Luke Shaw', 30001361, '1995-07-12', 1),
(1133, 'Aaron Wan-Bissaka', 30001362, '1997-11-26', 1),
(1134, 'Diogo Dalot', 30001363, '1999-03-18', 1),
(1135, 'Jonny Evans', 30001364, '1988-01-03', 1),
(1136, 'Tyrell Malacia', 30001365, '1999-08-17', 1),
(1137, 'Casemiro', 30001366, '1992-02-23', 1),
(1138, 'Bruno Fernandes', 30001367, '1994-09-08', 1),
(1139, 'Christian Eriksen', 30001368, '1992-02-14', 1),
(1140, 'Mason Mount', 30001369, '1999-01-10', 1),
(1141, 'Scott McTominay', 30001370, '1996-12-08', 1),
(1142, 'Sofyan Amrabat', 30001371, '1996-08-21', 1),
(1143, 'Kobbie Mainoo', 30001372, '2005-04-19', 1),
(1144, 'Marcus Rashford', 30001373, '1997-10-31', 1),
(1145, 'Alejandro Garnacho', 30001374, '2004-07-01', 1),
(1146, 'Antony', 30001375, '2000-02-24', 1),
(1147, 'Facundo Pellistri', 30001376, '2001-12-20', 1),
(1148, 'Rasmus Højlund', 30001377, '2003-02-04', 1),
(1149, 'Anthony Martial', 30001378, '1995-12-05', 1);

-- Insertar Jugadores del Manchester United
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES
-- Porteros
(1125, 1125, 24, 1, 6, 1),   -- Onana
(1126, 1126, 1, 1, 6, 1),    -- Bayindir
(1127, 1127, 22, 1, 6, 1),   -- Heaton

-- Defensas
(1128, 1128, 19, 2, 6, 1),   -- Varane
(1129, 1129, 6, 2, 6, 1),    -- Mart nez
(1130, 1130, 5, 2, 6, 1),    -- Maguire
(1131, 1131, 2, 2, 6, 1),    -- Lindel f
(1132, 1132, 23, 4, 6, 1),   -- Shaw
(1133, 1133, 29, 3, 6, 1),   -- Wan-Bissaka
(1134, 1134, 20, 3, 6, 1),   -- Dalot
(1135, 1135, 35, 2, 6, 1),   -- Evans
(1136, 1136, 12, 4, 6, 1),   -- Malacia

-- Mediocampistas
(1137, 1137, 18, 5, 6, 1),   -- Casemiro
(1138, 1138, 8, 7, 6, 1),    -- Bruno Fernandes
(1139, 1139, 14, 7, 6, 1),   -- Eriksen
(1140, 1140, 7, 7, 6, 1),    -- Mount
(1141, 1141, 39, 6, 6, 1),   -- McTominay
(1142, 1142, 4, 5, 6, 1),    -- Amrabat
(1143, 1143, 37, 6, 6, 1),   -- Mainoo

-- Extremos y Delanteros
(1144, 1144, 10, 9, 6, 1),   -- Rashford
(1145, 1145, 17, 9, 6, 1),   -- Garnacho
(1146, 1146, 21, 8, 6, 1),   -- Antony
(1147, 1147, 28, 8, 6, 1),   -- Pellistri
(1148, 1148, 11, 11, 6, 1),  -- H jlund
(1149, 1149, 9, 11, 6, 1);   -- Martial

------
--Nothingham Forest
-- Primero insertamos las personas (datos personales de los jugadores)
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(1300, 'Matt Turner', 33001234, '1994-06-24', 1),
(1301, 'Odysseas Vlachodimos', 33001235, '1994-04-26', 1),
(1302, 'Wayne Hennessey', 33001236, '1987-01-24', 1),
(1303, 'Gonzalo Montiel', 33001237, '1997-01-01', 1),
(1304, 'Serge Aurier', 33001238, '1992-12-24', 1),
(1305, 'Neco Williams', 33001239, '2001-04-13', 1),
(1306, 'Joe Worrall', 33001240, '1997-01-10', 1),
(1307, 'Felipe', 33001241, '1989-05-16', 1),
(1308, 'Willy Boly', 33001242, '1991-02-03', 1),
(1309, 'Moussa Niakhaté', 33001243, '1996-03-08', 1),
(1310, 'Murillo', 33001244, '2002-03-21', 1),
(1311, 'Harry Toffolo', 33001245, '1995-08-19', 1),
(1312, 'Nuno Tavares', 33001246, '2000-01-26', 1),
(1313, 'Ryan Yates', 33001247, '1997-11-21', 1),
(1314, 'Ibrahim Sangaré', 33001248, '1997-12-02', 1),
(1315, 'Orel Mangala', 33001249, '1998-03-18', 1),
(1316, 'Nicolas Domínguez', 33001250, '1998-06-28', 1),
(1317, 'Danilo', 33001251, '2001-04-29', 1),
(1318, 'Brandon Aguilera', 33001252, '2003-06-28', 1),
(1319, 'Morgan Gibbs-White', 33001253, '2000-01-27', 1),
(1320, 'Anthony Elanga', 33001254, '2002-04-27', 1),
(1321, 'Callum Hudson-Odoi', 33001255, '2000-11-07', 1),
(1322, 'Divock Origi', 33001256, '1995-04-18', 1),
(1323, 'Chris Wood', 33001257, '1991-12-07', 1),
(1324, 'Taiwo Awoniyi', 33001258, '1997-08-12', 1);

-- Luego insertamos los jugadores con sus posiciones y n meros
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES
-- Porteros
(1300, 1300, 1, 1, 18, 1),    -- Turner
(1301, 1301, 13, 1, 18, 1),   -- Vlachodimos
(1302, 1302, 23, 1, 18, 1),   -- Hennessey

-- Defensas
(1303, 1303, 2, 3, 18, 1),    -- Montiel
(1304, 1304, 24, 3, 18, 1),   -- Aurier
(1305, 1305, 7, 3, 18, 1),    -- Williams
(1306, 1306, 4, 2, 18, 1),    -- Worrall
(1307, 1307, 22, 2, 18, 1),   -- Felipe
(1308, 1308, 3, 2, 18, 1),    -- Boly
(1309, 1309, 5, 2, 18, 1),    -- Niakhat 
(1310, 1310, 15, 2, 18, 1),   -- Murillo
(1311, 1311, 14, 4, 18, 1),   -- Toffolo
(1312, 1312, 32, 4, 18, 1),   -- Tavares

-- Mediocampistas
(1313, 1313, 22, 5, 18, 1),   -- Yates
(1314, 1314, 6, 5, 18, 1),    -- Sangar 
(1315, 1315, 8, 6, 18, 1),    -- Mangala
(1316, 1316, 16, 6, 18, 1),   -- Dom nguez
(1317, 1317, 28, 6, 18, 1),   -- Danilo
(1318, 1318, 21, 7, 18, 1),   -- Aguilera
(1319, 1319, 10, 7, 18, 1),   -- Gibbs-White

-- Extremos y Delanteros
(1320, 1320, 17, 8, 18, 1),   -- Elanga
(1321, 1321, 11, 9, 18, 1),   -- Hudson-Odoi
(1322, 1322, 27, 10, 18, 1),  -- Origi
(1323, 1323, 9, 11, 18, 1),   -- Wood
(1324, 1324, 30, 11, 18, 1);  -- Awoniyi


--Newcastle
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(2000, 'Nick Pope', 30001234, '1992-04-19', 1),
(2001, 'Martin Dúbravka', 30001235, '1989-01-15', 1),
(2002, 'Loris Karius', 30001236, '1993-06-22', 1),
(2003, 'Kieran Trippier', 30001237, '1990-09-19', 1),
(2004, 'Sven Botman', 30001238, '2000-01-12', 1),
(2005, 'Dan Burn', 30001239, '1992-05-09', 1),
(2006, 'Fabian Schär', 30001240, '1991-12-20', 1),
(2007, 'Paul Dummett', 30001241, '1991-09-26', 1),
(2008, 'Emil Krafth', 30001242, '1994-08-02', 1),
(2009, 'Matt Targett', 30001243, '1995-09-18', 1),
(2010, 'Tino Livramento', 30001244, '2002-11-12', 1),
(2011, 'Bruno Guimarães', 30001245, '1997-11-16', 1),
(2012, 'Sandro Tonali', 30001246, '2000-05-08', 1),
(2013, 'Joe Willock', 30001247, '1999-08-20', 1),
(2014, 'Sean Longstaff', 30001248, '1997-10-30', 1),
(2015, 'Elliot Anderson', 30001249, '2002-11-06', 1),
(2016, 'Lewis Miley', 30001250, '2006-05-01', 1),
(2017, 'Miguel Almirón', 30001251, '1994-02-10', 1),
(2018, 'Harvey Barnes', 30001252, '1997-12-09', 1),
(2019, 'Anthony Gordon', 30001253, '2001-02-24', 1),
(2020, 'Jacob Murphy', 30001254, '1995-02-24', 1),
(2021, 'Alexander Isak', 30001255, '1999-09-21', 1),
(2022, 'Callum Wilson', 30001256, '1992-02-27', 1),
(2023, 'Joelinton', 30001257, '1996-08-14', 1),
(2024, 'Lewis Hall', 30001258, '2004-09-08', 1);


-- Insertando datos de jugadores
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES
-- Porteros
(2000, 2000, 20, 1, 7, 1), -- Nick Pope
(2001, 2001, 1, 1, 7, 1),  -- Martin D bravka
(2002, 2002, 12, 1, 7, 1), -- Loris Karius

-- Defensas
(2003, 2003, 2, 3, 7, 1),  -- Kieran Trippier
(2004, 2004, 4, 2, 7, 1),  -- Sven Botman
(2005, 2005, 33, 2, 7, 1), -- Dan Burn
(2006, 2006, 5, 2, 7, 1),  -- Fabian Sch r
(2007, 2007, 3, 4, 7, 1),  -- Paul Dummett
(2008, 2008, 17, 3, 7, 1), -- Emil Krafth
(2009, 2009, 13, 4, 7, 1), -- Matt Targett
(2010, 2010, 21, 3, 7, 1), -- Tino Livramento

-- Mediocampistas
(2011, 2011, 39, 6, 7, 1), -- Bruno Guimar es
(2012, 2012, 8, 5, 7, 1),  -- Sandro Tonali
(2013, 2013, 28, 6, 7, 1), -- Joe Willock
(2014, 2014, 36, 6, 7, 1), -- Sean Longstaff
(2015, 2015, 32, 7, 7, 1), -- Elliot Anderson
(2016, 2016, 67, 6, 7, 1), -- Lewis Miley

-- Extremos y Mediapuntas
(2017, 2017, 24, 8, 7, 1), -- Miguel Almir n
(2018, 2018, 15, 9, 7, 1), -- Harvey Barnes
(2019, 2019, 10, 9, 7, 1), -- Anthony Gordon
(2020, 2020, 23, 8, 7, 1), -- Jacob Murphy
(2021, 2021, 14, 11, 7, 1), -- Alexander Isak
(2022, 2022, 9, 11, 7, 1),  -- Callum Wilson
(2023, 2023, 7, 10, 7, 1),  -- Joelinton
(2024, 2024, 16, 4, 7, 1); 


--Brighton
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(2025, 'Jason Steele', 30002025, '1990-08-18', 1),
(2026, 'Bart Verbruggen', 30002026, '2002-08-18', 1),
(2027, 'Tom McGill', 30002027, '2000-03-25', 1),
(2028, 'Lewis Dunk', 30002028, '1991-11-21', 1),
(2029, 'Jan Paul van Hecke', 30002029, '2000-06-08', 1),
(2030, 'Igor Julio', 30002030, '2001-02-16', 1),
(2031, 'Pervis Estupiñán', 30002031, '1998-01-21', 1),
(2032, 'Tariq Lamptey', 30002032, '2000-09-30', 1),
(2033, 'Joel Veltman', 30002033, '1992-01-15', 1),
(2034, 'Jack Hinshelwood', 30002034, '2005-03-14', 1),
(2035, 'James Milner', 30002035, '1986-01-04', 1),
(2036, 'Pascal Groß', 30002036, '1991-06-15', 1),
(2037, 'Billy Gilmour', 30002037, '2001-06-11', 1),
(2038, 'Carlos Baleba', 30002038, '2004-01-03', 1),
(2039, 'Jakub Moder', 30002039, '1999-04-07', 1),
(2040, 'Adam Lallana', 30002040, '1988-05-10', 1),
(2041, 'Mahmoud Dahoud', 30002041, '1996-01-01', 1),
(2042, 'Kaoru Mitoma', 30002042, '1997-05-20', 1),
(2043, 'Simon Adingra', 30002043, '2002-01-01', 1),
(2044, 'Facundo Buonanotte', 30002044, '2004-12-23', 1),
(2045, 'João Pedro', 30002045, '2001-09-26', 1),
(2046, 'Danny Welbeck', 30002046, '1990-11-26', 1),
(2047, 'Evan Ferguson', 30002047, '2004-10-19', 1),
(2048, 'Ansu Fati', 30002048, '2002-10-31', 1),
(2049, 'Julio Enciso', 30002049, '2004-01-23', 1);

-- Insertar Jugadores del Brighton
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES 
-- Porteros
(2025, 2025, 23, 1, 8, 1),  -- Jason Steele
(2026, 2026, 1, 1, 8, 1),   -- Bart Verbruggen
(2027, 2027, 38, 1, 8, 1),  -- Tom McGill

-- Defensas
(2028, 2028, 5, 2, 8, 1),   -- Lewis Dunk
(2029, 2029, 29, 2, 8, 1),  -- Jan Paul van Hecke
(2030, 2030, 14, 2, 8, 1),  -- Igor Julio
(2031, 2031, 30, 4, 8, 1),  -- Pervis Estupi  n
(2032, 2032, 2, 3, 8, 1),   -- Tariq Lamptey
(2033, 2033, 34, 3, 8, 1),  -- Joel Veltman
(2034, 2034, 42, 3, 8, 1),  -- Jack Hinshelwood

-- Mediocampistas
(2035, 2035, 7, 6, 8, 1),   -- James Milner
(2036, 2036, 13, 7, 8, 1),  -- Pascal Gro 
(2037, 2037, 11, 6, 8, 1),  -- Billy Gilmour
(2038, 2038, 4, 5, 8, 1),   -- Carlos Baleba
(2039, 2039, 15, 6, 8, 1),  -- Jakub Moder
(2040, 2040, 14, 7, 8, 1),  -- Adam Lallana
(2041, 2041, 8, 6, 8, 1),   -- Mahmoud Dahoud

-- Extremos y Delanteros
(2042, 2042, 22, 9, 8, 1),  -- Kaoru Mitoma
(2043, 2043, 24, 8, 8, 1),  -- Simon Adingra
(2044, 2044, 17, 10, 8, 1), -- Facundo Buonanotte
(2045, 2045, 9, 11, 8, 1),  -- Jo o Pedro
(2046, 2046, 18, 11, 8, 1), -- Danny Welbeck
(2047, 2047, 28, 11, 8, 1), -- Evan Ferguson
(2048, 2048, 31, 9, 8, 1),  -- Ansu Fati
(2049, 2049, 20, 10, 8, 1); -- Julio Enciso



--Chelsea
-- Insertar Personas (Jugadores del Chelsea)
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(2050, 'Robert Sánchez', 30002050, '1997-11-18', 1),
(2051, 'Đorđe Petrović', 30002051, '1999-10-08', 1),
(2052, 'Marcus Bettinelli', 30002052, '1992-05-24', 1),
(2053, 'Thiago Silva', 30002053, '1984-09-22', 1),
(2054, 'Benoît Badiashile', 30002054, '2001-03-26', 1),
(2055, 'Wesley Fofana', 30002055, '2000-12-17', 1),
(2056, 'Trevoh Chalobah', 30002056, '1999-07-05', 1),
(2057, 'Reece James', 30002057, '1999-12-08', 1),
(2058, 'Ben Chilwell', 30002058, '1996-12-21', 1),
(2059, 'Malo Gusto', 30002059, '2003-05-19', 1),
(2060, 'Levi Colwill', 30002060, '2003-02-26', 1),
(2061, 'Marc Cucurella', 30002061, '1998-07-22', 1),
(2062, 'Enzo Fernández', 30002062, '2001-01-17', 1),
(2063, 'Moises Caicedo', 30002063, '2001-11-02', 1),
(2064, 'Conor Gallagher', 30002064, '2000-02-06', 1),
(2065, 'Carney Chukwuemeka', 30002065, '2003-10-20', 1),
(2066, 'Lesley Ugochukwu', 30002066, '2004-03-26', 1),
(2067, 'Cole Palmer', 30002067, '2002-05-06', 1),
(2068, 'Noni Madueke', 30002068, '2002-03-10', 1),
(2069, 'Mykhailo Mudryk', 30002069, '2001-01-05', 1),
(2070, 'Raheem Sterling', 30002070, '1994-12-08', 1),
(2071, 'Christopher Nkunku', 30002071, '1997-11-14', 1),
(2072, 'Armando Broja', 30002072, '2001-09-10', 1),
(2073, 'Nicolas Jackson', 30002073, '2001-06-20', 1),
(2074, 'Ian Maatsen', 30002074, '2002-03-10', 1);

-- Insertar Jugadores del Chelsea
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES 
-- Porteros
(2050, 2050, 1, 1, 9, 1),   -- Robert S nchez
(2051, 2051, 28, 1, 9, 1),  -- ?or?e Petrovi?
(2052, 2052, 13, 1, 9, 1),  -- Marcus Bettinelli

-- Defensas
(2053, 2053, 6, 2, 9, 1),   -- Thiago Silva
(2054, 2054, 5, 2, 9, 1),   -- Beno t Badiashile
(2055, 2055, 33, 2, 9, 1),  -- Wesley Fofana
(2056, 2056, 14, 2, 9, 1),  -- Trevoh Chalobah
(2057, 2057, 24, 3, 9, 1),  -- Reece James
(2058, 2058, 21, 4, 9, 1),  -- Ben Chilwell
(2059, 2059, 27, 3, 9, 1),  -- Malo Gusto
(2060, 2060, 26, 2, 9, 1),  -- Levi Colwill
(2061, 2061, 3, 4, 9, 1),   -- Marc Cucurella

-- Mediocampistas
(2062, 2062, 8, 6, 9, 1),   -- Enzo Fern ndez
(2063, 2063, 25, 5, 9, 1),  -- Moises Caicedo
(2064, 2064, 23, 6, 9, 1),  -- Conor Gallagher
(2065, 2065, 17, 7, 9, 1),  -- Carney Chukwuemeka
(2066, 2066, 16, 5, 9, 1),  -- Lesley Ugochukwu

-- Extremos y Delanteros
(2067, 2067, 20, 8, 9, 1),  -- Cole Palmer
(2068, 2068, 11, 8, 9, 1),  -- Noni Madueke
(2069, 2069, 10, 9, 9, 1),  -- Mykhailo Mudryk
(2070, 2070, 7, 9, 9, 1),   -- Raheem Sterling
(2071, 2071, 18, 10, 9, 1), -- Christopher Nkunku
(2072, 2072, 19, 11, 9, 1), -- Armando Broja
(2073, 2073, 15, 11, 9, 1), -- Nicolas Jackson
(2074, 2074, 29, 4, 9, 1);  -- Ian Maatsen



--Westham
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES 
(2075, 'Alphonse Areola', 30002075, '1993-02-27', 1),
(2076, 'Łukasz Fabiański', 30002076, '1985-04-18', 1),
(2077, 'Krisztián Hegyi', 30002077, '2002-12-27', 1),
(2078, 'Kurt Zouma', 30002078, '1994-10-27', 1),
(2079, 'Nayef Aguerd', 30002079, '1996-03-30', 1),
(2080, 'Angelo Ogbonna', 30002080, '1988-05-23', 1),
(2081, 'Konstantinos Mavropanos', 30002081, '1997-12-11', 1),
(2082, 'Vladimir Coufal', 30002082, '1992-08-22', 1),
(2083, 'Ben Johnson', 30002083, '2000-01-24', 1),
(2084, 'Aaron Cresswell', 30002084, '1989-12-15', 1),
(2085, 'Emerson Palmieri', 30002085, '1994-08-03', 1),
(2086, 'Tomáš Souček', 30002086, '1995-02-27', 1),
(2087, 'Edson Álvarez', 30002087, '1997-10-24', 1),
(2088, 'James Ward-Prowse', 30002088, '1994-11-01', 1),
(2089, 'Pablo Fornals', 30002089, '1996-02-22', 1),
(2090, 'Flynn Downes', 30002090, '1999-01-20', 1),
(2091, 'Mohammed Kudus', 30002091, '2000-08-02', 1),
(2092, 'Lucas Paquetá', 30002092, '1997-08-27', 1),
(2093, 'Said Benrahma', 30002093, '1995-08-10', 1),
(2094, 'Jarrod Bowen', 30002094, '1996-12-20', 1),
(2095, 'Maxwel Cornet', 30002095, '1996-09-27', 1),
(2096, 'Danny Ings', 30002096, '1992-07-23', 1),
(2097, 'Michail Antonio', 30002097, '1990-03-28', 1),
(2098, 'Divin Mubama', 30002098, '2004-10-25', 1),
(2099, 'Thilo Kehrer', 30002099, '1996-09-21', 1);

-- Insertar Jugadores del West Ham United
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES 
-- Porteros
(2075, 2075, 23, 1, 10, 1),  -- Alphonse Areola
(2076, 2076, 1, 1, 10, 1),   -- ?ukasz Fabia?ski
(2077, 2077, 40, 1, 10, 1),  -- Kriszti n Hegyi

-- Defensas
(2078, 2078, 4, 2, 10, 1),   -- Kurt Zouma
(2079, 2079, 27, 2, 10, 1),  -- Nayef Aguerd
(2080, 2080, 21, 2, 10, 1),  -- Angelo Ogbonna
(2081, 2081, 15, 2, 10, 1),  -- Konstantinos Mavropanos
(2082, 2082, 5, 3, 10, 1),   -- Vladimir Coufal
(2083, 2083, 2, 3, 10, 1),   -- Ben Johnson
(2084, 2084, 3, 4, 10, 1),   -- Aaron Cresswell
(2085, 2085, 33, 4, 10, 1),  -- Emerson Palmieri

-- Mediocampistas
(2086, 2086, 28, 6, 10, 1),  -- Tom  Sou?ek
(2087, 2087, 19, 5, 10, 1),  -- Edson  lvarez
(2088, 2088, 7, 6, 10, 1),   -- James Ward-Prowse
(2089, 2089, 8, 7, 10, 1),   -- Pablo Fornals
(2090, 2090, 12, 6, 10, 1),  -- Flynn Downes
(2091, 2091, 14, 8, 10, 1),  -- Mohammed Kudus
(2092, 2092, 10, 7, 10, 1),  -- Lucas Paquet 
(2093, 2093, 22, 9, 10, 1),  -- Said Benrahma

-- Extremos y Delanteros
(2094, 2094, 20, 8, 10, 1),  -- Jarrod Bowen
(2095, 2095, 17, 9, 10, 1),  -- Maxwel Cornet
(2096, 2096, 18, 11, 10, 1), -- Danny Ings
(2097, 2097, 9, 11, 10, 1),  -- Michail Antonio
(2098, 2098, 36, 11, 10, 1), -- Divin Mubama
(2099, 2099, 24, 2, 10, 1);  -- Thilo Kehrer

--Wolverhamptom
-- Primero insertamos los datos en la tabla Personas
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES
(2100, 'José Pedro Malheiro de Sá', 30002100, '1993-01-17', 1),
(2101, 'Daniel Bentley', 30002101, '1993-07-13', 1),
(2102, 'Santiago Bueno', 30002102, '1998-11-09', 1),
(2103, 'Craig Dawson', 30002103, '1990-05-06', 1),
(2104, 'Toti António', 30002104, '1999-01-16', 1),
(2105, 'Max Kilman', 30002105, '1997-05-23', 1),
(2106, 'Rayan Aït-Nouri', 30002106, '2001-06-06', 1),
(2107, 'Hugo Bueno', 30002107, '2002-09-18', 1),
(2108, 'Nelson Semedo', 30002108, '1993-11-16', 1),
(2109, 'Matt Doherty', 30002109, '1992-01-16', 1),
(2110, 'João Gomes', 30002110, '2001-02-12', 1),
(2111, 'Mario Lemina', 30002111, '1993-09-01', 1),
(2112, 'Boubacar Traore', 30002112, '2001-08-20', 1),
(2113, 'Tommy Doyle', 30002113, '2001-10-17', 1),
(2114, 'Jean-Ricner Bellegarde', 30002114, '1998-06-27', 1),
(2115, 'Pablo Sarabia', 30002115, '1992-05-11', 1),
(2116, 'Pedro Neto', 30002116, '2000-03-09', 1),
(2117, 'Hwang Hee-chan', 30002117, '1996-01-26', 1),
(2118, 'Daniel Podence', 30002118, '1995-10-21', 1),
(2119, 'Matheus Cunha', 30002119, '1999-05-27', 1),
(2120, 'Sasa Kalajdzic', 30002120, '1997-07-07', 1),
(2121, 'Fabio Silva', 30002121, '2002-07-19', 1),
(2122, 'Nathan Fraser', 30002122, '2005-02-03', 1),
(2123, 'Joe Hodge', 30002123, '2002-09-24', 1),
(2124, 'Tawanda Chirewa', 30002124, '2003-12-03', 1);

-- Luego insertamos los registros en la tabla Jugadores
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES
(2100, 2100, 1, 1, 11, 1),    -- Jos  S  (Portero)
(2101, 2101, 13, 1, 11, 1),   -- Bentley (Portero)
(2102, 2102, 23, 2, 11, 1),   -- Santiago Bueno (Defensa Central)
(2103, 2103, 15, 2, 11, 1),   -- Craig Dawson (Defensa Central)
(2104, 2104, 24, 2, 11, 1),   -- Toti (Defensa Central)
(2105, 2105, 4, 2, 11, 1),    -- Max Kilman (Defensa Central)
(2106, 2106, 3, 4, 11, 1),    -- Rayan A t-Nouri (Lateral Izquierdo)
(2107, 2107, 64, 4, 11, 1),   -- Hugo Bueno (Lateral Izquierdo)
(2108, 2108, 22, 3, 11, 1),   -- Nelson Semedo (Lateral Derecho)
(2109, 2109, 2, 3, 11, 1),    -- Matt Doherty (Lateral Derecho)
(2110, 2110, 8, 5, 11, 1),    -- Jo o Gomes (Mediocentro Defensivo)
(2111, 2111, 5, 6, 11, 1),    -- Mario Lemina (Mediocentro)
(2112, 2112, 6, 5, 11, 1),    -- Boubacar Traore (Mediocentro Defensivo)
(2113, 2113, 69, 6, 11, 1),   -- Tommy Doyle (Mediocentro)
(2114, 2114, 25, 6, 11, 1),   -- Bellegarde (Mediocentro)
(2115, 2115, 21, 8, 11, 1),   -- Pablo Sarabia (Extremo Derecho)
(2116, 2116, 7, 8, 11, 1),    -- Pedro Neto (Extremo Derecho)
(2117, 2117, 11, 9, 11, 1),   -- Hwang Hee-chan (Extremo Izquierdo)
(2118, 2118, 10, 9, 11, 1),   -- Daniel Podence (Extremo Izquierdo)
(2119, 2119, 9, 11, 11, 1),   -- Matheus Cunha (Delantero Centro)
(2120, 2120, 18, 11, 11, 1),  -- Sasa Kalajdzic (Delantero Centro)
(2121, 2121, 17, 10, 11, 1),  -- Fabio Silva (Segundo Delantero)
(2122, 2122, 58, 11, 11, 1),  -- Nathan Fraser (Delantero Centro)
(2123, 2123, 14, 6, 11, 1),   -- Joe Hodge (Mediocentro)
(2124, 2124, 67, 7, 11, 1);   -- Tawanda Chirewa (Mediocentro Ofensivo)



--Burnley
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES
(2125, 'James Trafford', 30002125, '2002-10-10', 1),
(2126, 'Arijanet Muric', 30002126, '1998-11-07', 1),
(2127, 'Lawrence Vigouroux', 30002127, '1993-11-19', 1),
(2128, 'Jordan Beyer', 30002128, '2000-05-19', 1),
(2129, 'Ameen Al-Dakhil', 30002129, '2002-03-06', 1),
(2130, 'Dara O'+char(39)+'Shea', 30002130, '1999-03-04', 1),
(2131, 'Hjalmar Ekdal', 30002131, '1998-10-21', 1),
(2132, 'Charlie Taylor', 30002132, '1993-09-18', 1),
(2133, 'Connor Roberts', 30002133, '1995-09-23', 1),
(2134, 'Vitinho', 30002134, '1999-07-09', 1),
(2135, 'Josh Cullen', 30002135, '1996-04-07', 1),
(2136, 'Josh Brownhill', 30002136, '1995-12-19', 1),
(2137, 'Sander Berge', 30002137, '1998-02-14', 1),
(2138, 'Johann Berg Gudmundsson', 30002138, '1990-10-27', 1),
(2139, 'Jack Cork', 30002139, '1989-06-25', 1),
(2140, 'Samuel Bastien', 30002140, '1996-09-26', 1),
(2141, 'Luca Koleosho', 30002141, '2004-09-15', 1),
(2142, 'Wilson Odobert', 30002142, '2004-11-28', 1),
(2143, 'Mike Tresor', 30002143, '1999-05-28', 1),
(2144, 'Zeki Amdouni', 30002144, '2000-12-04', 1),
(2145, 'Jay Rodriguez', 30002145, '1989-07-29', 1),
(2146, 'Lyle Foster', 30002146, '2000-09-03', 1),
(2147, 'Nathan Redmond', 30002147, '1994-03-06', 1),
(2148, 'Michael Obafemi', 30002148, '2000-07-06', 1),
(2149, 'Anass Zaroury', 30002149, '2000-11-07', 1);

-- Luego insertamos los registros en la tabla Jugadores
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES
(2125, 2125, 1, 1, 12, 1),    -- James Trafford (Portero)
(2126, 2126, 13, 1, 12, 1),   -- Arijanet Muric (Portero)
(2127, 2127, 25, 1, 12, 1),   -- Lawrence Vigouroux (Portero)
(2128, 2128, 5, 2, 12, 1),    -- Jordan Beyer (Defensa Central)
(2129, 2129, 4, 2, 12, 1),    -- Ameen Al-Dakhil (Defensa Central)
(2130, 2130, 3, 2, 12, 1),    -- Dara O'Shea (Defensa Central)
(2131, 2131, 24, 2, 12, 1),   -- Hjalmar Ekdal (Defensa Central)
(2132, 2132, 2, 4, 12, 1),    -- Charlie Taylor (Lateral Izquierdo)
(2133, 2133, 14, 3, 12, 1),   -- Connor Roberts (Lateral Derecho)
(2134, 2134, 7, 3, 12, 1),    -- Vitinho (Lateral Derecho)
(2135, 2135, 24, 5, 12, 1),   -- Josh Cullen (Mediocentro Defensivo)
(2136, 2136, 8, 6, 12, 1),    -- Josh Brownhill (Mediocentro)
(2137, 2137, 32, 6, 12, 1),   -- Sander Berge (Mediocentro)
(2138, 2138, 7, 8, 12, 1),    -- Johann Berg Gudmundsson (Extremo Derecho)
(2139, 2139, 4, 5, 12, 1),    -- Jack Cork (Mediocentro Defensivo)
(2140, 2140, 26, 6, 12, 1),   -- Samuel Bastien (Mediocentro)
(2141, 2141, 17, 9, 12, 1),   -- Luca Koleosho (Extremo Izquierdo)
(2142, 2142, 23, 9, 12, 1),   -- Wilson Odobert (Extremo Izquierdo)
(2143, 2143, 27, 7, 12, 1),   -- Mike Tresor (Mediocentro Ofensivo)
(2144, 2144, 9, 11, 12, 1),   -- Zeki Amdouni (Delantero Centro)
(2145, 2145, 19, 11, 12, 1),  -- Jay Rodriguez (Delantero Centro)
(2146, 2146, 11, 11, 12, 1),  -- Lyle Foster (Delantero Centro)
(2147, 2147, 18, 8, 12, 1),   -- Nathan Redmond (Extremo Derecho)
(2148, 2148, 10, 10, 12, 1),  -- Michael Obafemi (Segundo Delantero)
(2149, 2149, 8, 9, 12, 1);    -- Anass Zaroury (Extremo Izquierdo)

--Brentford
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta) VALUES
(2150, 'Mark Flekken', 30002150, '1993-06-13', 1),
(2151, 'Thomas Strakosha', 30002151, '1995-03-19', 1),
(2152, 'Ethan Pinnock', 30002152, '1993-05-29', 1),
(2153, 'Ben Mee', 30002153, '1989-09-21', 1),
(2154, 'Nathan Collins', 30002154, '2001-04-30', 1),
(2155, 'Kristoffer Ajer', 30002155, '1998-04-17', 1),
(2156, 'Mathias Jorgensen', 30002156, '1990-04-23', 1),
(2157, 'Rico Henry', 30002157, '1997-07-08', 1),
(2158, 'Aaron Hickey', 30002158, '2002-06-10', 1),
(2159, 'Mads Roerslev', 30002159, '1999-06-24', 1),
(2160, 'Christian Norgaard', 30002160, '1994-03-10', 1),
(2161, 'Mathias Jensen', 30002161, '1996-01-01', 1),
(2162, 'Vitaly Janelt', 30002162, '1998-05-10', 1),
(2163, 'Frank Onyeka', 30002163, '1998-01-01', 1),
(2164, 'Shandon Baptiste', 30002164, '1998-04-08', 1),
(2165, 'Josh Dasilva', 30002165, '1998-10-23', 1),
(2166, 'Bryan Mbeumo', 30002166, '1999-08-07', 1),
(2167, 'Yoane Wissa', 30002167, '1996-09-03', 1),
(2168, 'Keane Lewis-Potter', 30002168, '2001-02-22', 1),
(2169, 'Mikkel Damsgaard', 30002169, '2000-07-03', 1),
(2170, 'Kevin Schade', 30002170, '2001-11-27', 1),
(2171, 'Neal Maupay', 30002171, '1996-08-14', 1),
(2172, 'Ivan Toney', 30002172, '1996-03-16', 1),
(2173, 'Michael Olakigbe', 30002173, '2004-02-16', 1),
(2174, 'Charlie Goode', 30002174, '1995-08-03', 1);

-- Luego insertamos los registros en la tabla Jugadores
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta) VALUES
(2150, 2150, 1, 1, 19, 1),    -- Mark Flekken (Portero)
(2151, 2151, 13, 1, 19, 1),   -- Thomas Strakosha (Portero)
(2152, 2152, 5, 2, 19, 1),    -- Ethan Pinnock (Defensa Central)
(2153, 2153, 16, 2, 19, 1),   -- Ben Mee (Defensa Central)
(2154, 2154, 22, 2, 19, 1),   -- Nathan Collins (Defensa Central)
(2155, 2155, 20, 2, 19, 1),   -- Kristoffer Ajer (Defensa Central)
(2156, 2156, 3, 2, 19, 1),    -- Mathias Jorgensen (Defensa Central)
(2157, 2157, 3, 4, 19, 1),    -- Rico Henry (Lateral Izquierdo)
(2158, 2158, 2, 4, 19, 1),    -- Aaron Hickey (Lateral Izquierdo)
(2159, 2159, 30, 3, 19, 1),   -- Mads Roerslev (Lateral Derecho)
(2160, 2160, 6, 5, 19, 1),    -- Christian Norgaard (Mediocentro Defensivo)
(2161, 2161, 8, 6, 19, 1),    -- Mathias Jensen (Mediocentro)
(2162, 2162, 27, 6, 19, 1),   -- Vitaly Janelt (Mediocentro)
(2163, 2163, 15, 5, 19, 1),   -- Frank Onyeka (Mediocentro Defensivo)
(2164, 2164, 26, 6, 19, 1),   -- Shandon Baptiste (Mediocentro)
(2165, 2165, 10, 7, 19, 1),   -- Josh Dasilva (Mediocentro Ofensivo)
(2166, 2166, 19, 8, 19, 1),   -- Bryan Mbeumo (Extremo Derecho)
(2167, 2167, 11, 9, 19, 1),   -- Yoane Wissa (Extremo Izquierdo)
(2168, 2168, 7, 9, 19, 1),    -- Keane Lewis-Potter (Extremo Izquierdo)
(2169, 2169, 24, 7, 19, 1),   -- Mikkel Damsgaard (Mediocentro Ofensivo)
(2170, 2170, 9, 8, 19, 1),    -- Kevin Schade (Extremo Derecho)
(2171, 2171, 14, 10, 19, 1),  -- Neal Maupay (Segundo Delantero)
(2172, 2172, 17, 11, 19, 1),  -- Ivan Toney (Delantero Centro)
(2173, 2173, 36, 8, 19, 1),   -- Michael Olakigbe (Extremo Derecho)
(2174, 2174, 4, 2, 19, 1);    -- Charlie Goode (Defensa Central)



--Crystal Palace
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta)
VALUES 
(2200, 'Sam Johnstone', 30002200, '1993-03-25', 1),
(2201, 'Dean Henderson', 30002201, '1997-03-12', 1),
(2202, 'Remi Matthews', 30002202, '1994-02-10', 1),
(2203, 'Marc Guéhi', 30002203, '2000-07-13', 1),
(2204, 'Joachim Andersen', 30002204, '1996-05-31', 1),
(2205, 'Rob Holding', 30002205, '1995-09-20', 1),
(2206, 'Chris Richards', 30002206, '2000-03-28', 1),
(2207, 'James Tomkins', 30002207, '1989-03-29', 1),
(2208, 'Nathaniel Clyne', 30002208, '1991-04-05', 1),
(2209, 'Joel Ward', 30002209, '1989-10-29', 1),
(2210, 'Tyrick Mitchell', 30002210, '1999-09-01', 1),
(2211, 'Jefferson Lerma', 30002211, '1994-10-25', 1),
(2212, 'Cheick Doucouré', 30002212, '2000-01-08', 1),
(2213, 'Will Hughes', 30002213, '1995-04-17', 1),
(2214, 'Jairo Riedewald', 30002214, '1996-09-09', 1),
(2215, 'Eberechi Eze', 30002215, '1998-06-29', 1),
(2216, 'Michael Olise', 30002216, '2001-12-12', 1),
(2217, 'Jordan Ayew', 30002217, '1991-09-11', 1),
(2218, 'Jeffrey Schlupp', 30002218, '1992-12-23', 1),
(2219, 'Jesurun Rak-Sakyi', 30002219, '2002-10-05', 1),
(2220, 'Odsonne Édouard', 30002220, '1998-01-16', 1),
(2221, 'Jean-Philippe Mateta', 30002221, '1997-06-28', 1),
(2222, 'Naouirou Ahamada', 30002222, '2002-03-29', 1),
(2223, 'Malcolm Ebiowei', 30002223, '2003-09-04', 1),
(2224, 'John-Kymani Gordon', 30002224, '2002-10-19', 1);

-- Insertar Jugadores
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta)
VALUES
-- Porteros
(2200, 2200, 1, 1, 20, 1),   -- Sam Johnstone
(2201, 2201, 13, 1, 20, 1),  -- Dean Henderson
(2202, 2202, 25, 1, 20, 1),  -- Remi Matthews

-- Defensas
(2203, 2203, 6, 2, 20, 1),   -- Marc Gu hi
(2204, 2204, 16, 2, 20, 1),  -- Joachim Andersen
(2205, 2205, 4, 2, 20, 1),   -- Rob Holding
(2206, 2206, 26, 2, 20, 1),  -- Chris Richards
(2207, 2207, 5, 2, 20, 1),   -- James Tomkins
(2208, 2208, 17, 3, 20, 1),  -- Nathaniel Clyne
(2209, 2209, 2, 3, 20, 1),   -- Joel Ward
(2210, 2210, 3, 4, 20, 1),   -- Tyrick Mitchell

-- Mediocampistas
(2211, 2211, 8, 5, 20, 1),   -- Jefferson Lerma
(2212, 2212, 28, 5, 20, 1),  -- Cheick Doucour 
(2213, 2213, 19, 6, 20, 1),  -- Will Hughes
(2214, 2214, 44, 6, 20, 1),  -- Jairo Riedewald
(2215, 2215, 10, 7, 20, 1),  -- Eberechi Eze
(2216, 2216, 7, 8, 20, 1),   -- Michael Olise
(2217, 2217, 9, 8, 20, 1),   -- Jordan Ayew
(2218, 2218, 15, 9, 20, 1),  -- Jeffrey Schlupp
(2219, 2219, 49, 8, 20, 1),  -- Jesurun Rak-Sakyi

-- Delanteros
(2220, 2220, 22, 11, 20, 1), -- Odsonne  douard
(2221, 2221, 14, 11, 20, 1), -- Jean-Philippe Mateta
(2222, 2222, 21, 7, 20, 1),  -- Naouirou Ahamada
(2223, 2223, 23, 8, 20, 1),  -- Malcolm Ebiowei
(2224, 2224, 45, 10, 20, 1); -- John-Kymani Gordon


INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta)
VALUES 
-- Luton Town (25 jugadores)
(200, 'Thomas Kaminski', 30001234, '1992-10-23', 1),
(201, 'James Shea', 30001235, '1991-06-16', 1),
(202, 'Tim Krul', 30001236, '1988-04-03', 1),
(203, 'Teden Mengi', 30001237, '2002-04-30', 1),
(204, 'Gabriel Osho', 30001238, '1998-08-14', 1),
(205, 'Amari Bell', 30001239, '1994-05-05', 1),
(206, 'Reece Burke', 30001240, '1996-09-02', 1),
(207, 'Tom Lockyer', 30001241, '1994-12-03', 1),
(208, 'Dan Potts', 30001242, '1994-04-13', 1),
(209, 'Issa Kaboré', 30001243, '2001-05-12', 1),
(210, 'Alfie Doughty', 30001244, '1999-12-20', 1),
(211, 'Jordan Clark', 30001245, '1993-09-24', 1),
(212, 'Pelly Ruddock', 30001246, '1994-03-23', 1),
(213, 'Ross Barkley', 30001247, '1993-12-05', 1),
(214, 'Albert Sambi Lokonga', 30001248, '1999-10-22', 1),
(215, 'Marvelous Nakamba', 30001249, '1994-01-19', 1),
(216, 'Tahith Chong', 30001250, '1999-12-04', 1),
(217, 'Carlton Morris', 30001251, '1995-12-16', 1),
(218, 'Elijah Adebayo', 30001252, '1998-01-07', 1),
(219, 'Cauley Woodrow', 30001253, '1994-12-02', 1),
(220, 'Jacob Brown', 30001254, '1998-04-10', 1),
(221, 'Chiedozie Ogbene', 30001255, '1997-05-01', 1),
(222, 'John McAtee', 30001256, '1999-09-15', 1),
(223, 'Joe Taylor', 30001257, '2002-09-30', 1),
(224, 'Andros Townsend', 30001258, '1991-07-16', 1),


-- Sheffield United (25 jugadores)
(225, 'Wes Foderingham', 30001259, '1991-01-14', 1),
(226, 'Adam Davies', 30001260, '1992-07-17', 1),
(227, 'Jordan Amissah', 30001261, '2001-09-08', 1),
(228, 'George Baldock', 30001262, '1993-03-09', 1),
(229, 'Jayden Bogle', 30001263, '2000-07-27', 1),
(230, 'Anel Ahmedhodzic', 30001264, '1999-03-26', 1),
(231, 'Jack Robinson', 30001265, '1993-09-01', 1),
(232, 'Auston Trusty', 30001266, '1998-08-12', 1),
(233, 'Chris Basham', 30001267, '1988-07-20', 1),
(234, 'Max Lowe', 30001268, '1997-05-11', 1),
(235, 'Ben Osborn', 30001269, '1994-08-05', 1),
(236, 'Oliver Norwood', 30001270, '1991-04-12', 1),
(237, 'Gustavo Hamer', 30001271, '1997-06-24', 1),
(238, 'Vinicius Souza', 30001272, '1999-06-16', 1),
(239, 'James McAtee', 30001273, '2002-10-18', 1),
(240, 'John Fleck', 30001274, '1991-08-24', 1),
(241, 'Andre Brooks', 30001275, '2003-09-07', 1),
(242, 'Oliver McBurnie', 30001276, '1996-06-04', 1),
(243, 'Cameron Archer', 30001277, '2001-12-09', 1),
(244, 'Rhian Brewster', 30001278, '2000-04-01', 1),
(245, 'Daniel Jebbison', 30001279, '2003-07-25', 1),
(246, 'Will Osula', 30001280, '2003-09-11', 1),
(247, 'Bénie Traoré', 30001281, '2002-08-14', 1),
(248, 'Anis Slimane', 30001282, '2001-03-16', 1),
(249, 'Luke Thomas', 30001283, '2001-06-10', 1),

-- Bournemouth (25 jugadores)
(250, 'Neto', 30001284, '1989-07-19', 1),
(251, 'Andrei Radu', 30001285, '1997-05-28', 1),
(252, 'Mark Travers', 30001286, '1999-05-18', 1),
(253, 'Adam Smith', 30001287, '1991-04-29', 1),
(254, 'Max Aarons', 30001288, '2000-01-04', 1),
(255, 'Chris Mepham', 30001289, '1997-11-05', 1),
(256, 'Marcos Senesi', 30001290, '1997-05-10', 1),
(257, 'Illia Zabarnyi', 30001291, '2002-09-01', 1),
(258, 'Lloyd Kelly', 30001292, '1998-10-06', 1),
(259, 'Milos Kerkez', 30001293, '2003-11-07', 1),
(260, 'Lewis Cook', 30001294, '1997-02-03', 1),
(261, 'Ryan Christie', 30001295, '1995-02-22', 1),
(262, 'Joe Rothwell', 30001296, '1995-01-11', 1),
(263, 'Philip Billing', 30001297, '1996-06-11', 1),
(264, 'Tyler Adams', 30001298, '1999-02-14', 1),
(265, 'Alex Scott', 30001299, '2003-08-25', 1),
(266, 'Marcus Tavernier', 30001300, '1999-03-22', 1),
(267, 'Justin Kluivert', 30001301, '1999-05-05', 1),
(268, 'Dominic Solanke', 30001302, '1997-09-14', 1),
(269, 'Antoine Semenyo', 30001303, '2000-01-07', 1),
(270, 'Kieffer Moore', 30001304, '1992-08-08', 1),
(271, 'Luis Sinisterra', 30001305, '1999-06-17', 1),
(272, 'David Brooks', 30001306, '1997-07-08', 1),
(273, 'Dango Ouattara', 30001307, '2002-02-11', 1),
(274, 'Hamed Traorè', 30001308, '2000-02-16', 1),

-- Fulham (25 jugadores)
(275, 'Bernd Leno', 30001309, '1992-03-04', 1),
(276, 'Marek Rodák', 30001310, '1996-12-13', 1),
(277, 'Steven Benda', 30001311, '1998-10-01', 1),
(278, 'Kenny Tete', 30001312, '1995-10-09', 1),
(279, 'Timothy Castagne', 30001313, '1995-12-05', 1),
(280, 'Tosin Adarabioyo', 30001314, '1997-09-24', 1),
(281, 'Tim Ream', 30001315, '1987-10-05', 1),
(282, 'Calvin Bassey', 30001316, '1999-12-31', 1),
(283, 'Issa Diop', 30001317, '1997-01-09', 1),
(284, 'Antonee Robinson', 30001318, '1997-08-08', 1),
(285, 'João Palhinha', 30001319, '1995-07-09', 1),
(286, 'Harrison Reed', 30001320, '1995-01-27', 1),
(287, 'Tom Cairney', 30001321, '1991-01-20', 1),
(288, 'Andreas Pereira', 30001322, '1996-01-01', 1),
(289, 'Sasa Lukic', 30001323, '1996-08-13', 1),
(290, 'Harry Wilson', 30001324, '1997-03-22', 1),
(291, 'Bobby Decordova-Reid', 30001325, '1993-02-02', 1),
(292, 'Willian', 30001326, '1988-08-09', 1),
(293, 'Alex Iwobi', 30001327, '1996-05-03', 1),
(294, 'Raúl Jiménez', 30001328, '1991-05-05', 1),
(295, 'Carlos Vinícius', 30001329, '1995-03-25', 1),
(296, 'Rodrigo Muniz', 30001330, '2001-05-04', 1),
(297, 'Adama Traoré', 30001331, '1996-01-25', 1),
(298, 'Manor Solomon', 30001332, '1999-07-24', 1),
(299, 'Fode Ballo-Touré', 30001333, '1997-01-03', 1),

-- Everton (25 jugadores)
(300, 'Jordan Pickford', 30001334, '1994-03-07', 1),
(301, 'João Virgínia', 30001335, '1999-10-10', 1),
(302, 'Andy Lonergan', 30001336, '1983-10-19', 1),
(303, 'Seamus Coleman', 30001337, '1988-10-11', 1),
(304, 'Nathan Patterson', 30001338, '2001-10-16', 1),
(305, 'James Tarkowski', 30001339, '1992-11-19', 1),
(306, 'Michael Keane', 30001340, '1993-01-11', 1),
(307, 'Ben Godfrey', 30001341, '1998-01-15', 1),
(308, 'Jarrad Branthwaite', 30001342, '2002-06-27', 1),
(309, 'Vitaliy Mykolenko', 30001343, '1999-05-29', 1),
(310, 'Ashley Young', 30001344, '1985-07-09', 1),
(311, 'Abdoulaye Doucouré', 30001345, '1993-01-01', 1),
(312, 'Amadou Onana', 30001346, '2001-08-16', 1),
(313, 'James Garner', 30001347, '2001-03-13', 1),
(314, 'Idrissa Gueye', 30001348, '1989-09-26', 1),
(315, 'André Gomes', 30001349, '1993-07-30', 1),
(316, 'Dwight McNeil', 30001350, '1999-11-22', 1),
(317, 'Jack Harrison', 30001351, '1996-11-20', 1),
(318, 'Arnaut Danjuma', 30001352, '1997-01-31', 1),
(319, 'Dominic Calvert-Lewin', 30001353, '1997-03-16', 1),
(320, 'Beto', 30001354, '1998-01-31', 1),
(321, 'Youssef Chermiti', 30001355, '2004-05-24', 1),
(322, 'Lewis Dobbin', 30001356, '2003-01-03', 1),
(323, 'Alex Iwobi', 30001357, '1996-05-03', 1),
(324, 'Demarai Gray', 30001358, '1996-06-28', 1)


-- Insert completo de Jugadores para los equipos 13 al 18
INSERT INTO Jugadores (id_jugador, id_persona, nro_camiseta, id_posicion, id_equipo, alta)
VALUES 
-- Luton Town (id_equipo = 13)
(200, 200, 1, 1, 13, 1),   -- Kaminski (portero)
(201, 201, 13, 1, 13, 1),  -- Shea (portero)
(202, 202, 23, 1, 13, 1),  -- Krul (portero)
(203, 203, 15, 2, 13, 1),  -- Mengi (defensa)
(204, 204, 4, 2, 13, 1),   -- Osho (defensa)
(205, 205, 3, 2, 13, 1),   -- Bell (defensa)
(206, 206, 5, 2, 13, 1),   -- Burke (defensa)
(207, 207, 4, 2, 13, 1),   -- Lockyer (defensa)
(208, 208, 16, 2, 13, 1),  -- Potts (defensa)
(209, 209, 2, 2, 13, 1),   -- Kabor  (defensa)
(210, 210, 14, 3, 13, 1),  -- Doughty (mediocampista)
(211, 211, 20, 3, 13, 1),  -- Clark (mediocampista)
(212, 212, 17, 3, 13, 1),  -- Ruddock (mediocampista)
(213, 213, 8, 3, 13, 1),   -- Barkley (mediocampista)
(214, 214, 6, 3, 13, 1),   -- Lokonga (mediocampista)
(215, 215, 19, 3, 13, 1),  -- Nakamba (mediocampista)
(216, 216, 7, 3, 13, 1),   -- Chong (mediocampista)
(217, 217, 9, 4, 13, 1),   -- Morris (delantero)
(218, 218, 11, 4, 13, 1),  -- Adebayo (delantero)
(219, 219, 10, 4, 13, 1),  -- Woodrow (delantero)
(220, 220, 21, 4, 13, 1),  -- Brown (delantero)
(221, 221, 22, 4, 13, 1),  -- Ogbene (delantero)
(222, 222, 18, 4, 13, 1),  -- McAtee (delantero)
(223, 223, 25, 4, 13, 1),  -- Taylor (delantero)
(224, 224, 12, 3, 13, 1),  -- Townsend (mediocampista)

-- Sheffield United (id_equipo = 14)
(225, 225, 1, 1, 14, 1),   -- Foderingham (portero)
(226, 226, 13, 1, 14, 1),  -- Davies (portero)
(227, 227, 23, 1, 14, 1),  -- Amissah (portero)
(228, 228, 2, 2, 14, 1),   -- Baldock (defensa)
(229, 229, 20, 2, 14, 1),  -- Bogle (defensa)
(230, 230, 4, 2, 14, 1),   -- Ahmedhodzic (defensa)
(231, 231, 3, 2, 14, 1),   -- Robinson (defensa)
(232, 232, 5, 2, 14, 1),   -- Trusty (defensa)
(233, 233, 6, 2, 14, 1),   -- Basham (defensa)
(234, 234, 32, 2, 14, 1),  -- Lowe (defensa)
(235, 235, 23, 2, 14, 1),  -- Osborn (defensa)
(236, 236, 16, 3, 14, 1),  -- Norwood (mediocampista)
(237, 237, 8, 3, 14, 1),   -- Hamer (mediocampista)
(238, 238, 22, 3, 14, 1),  -- Souza (mediocampista)
(239, 239, 10, 3, 14, 1),  -- McAtee (mediocampista)
(240, 240, 4, 3, 14, 1),   -- Fleck (mediocampista)
(241, 241, 32, 3, 14, 1),  -- Brooks (mediocampista)
(242, 242, 9, 4, 14, 1),   -- McBurnie (delantero)
(243, 243, 19, 4, 14, 1),  -- Archer (delantero)
(244, 244, 7, 4, 14, 1),   -- Brewster (delantero)
(245, 245, 25, 4, 14, 1),  -- Jebbison (delantero)
(246, 246, 27, 4, 14, 1),  -- Osula (delantero)
(247, 247, 17, 4, 14, 1),  -- Traor  (delantero)
(248, 248, 14, 3, 14, 1),  -- Slimane (mediocampista)
(249, 249, 33, 2, 14, 1),  -- Thomas (defensa)

-- Bournemouth (id_equipo = 15)
(250, 250, 1, 1, 15, 1),   -- Neto (portero)
(251, 251, 13, 1, 15, 1),  -- Radu (portero)
(252, 252, 23, 1, 15, 1),  -- Travers (portero)
(253, 253, 2, 2, 15, 1),   -- Smith (defensa)
(254, 254, 15, 2, 15, 1),  -- Aarons (defensa)
(255, 255, 6, 2, 15, 1),   -- Mepham (defensa)
(256, 256, 4, 2, 15, 1),   -- Senesi (defensa)
(257, 257, 5, 2, 15, 1),   -- Zabarnyi (defensa)
(258, 258, 3, 2, 15, 1),   -- Kelly (defensa)
(259, 259, 26, 2, 15, 1),  -- Kerkez (defensa)
(260, 260, 8, 3, 15, 1),   -- Cook (mediocampista)
(261, 261, 10, 3, 15, 1),  -- Christie (mediocampista)
(262, 262, 14, 3, 15, 1),  -- Rothwell (mediocampista)
(263, 263, 29, 3, 15, 1),  -- Billing (mediocampista)
(264, 264, 27, 3, 15, 1),  -- Adams (mediocampista)
(265, 265, 20, 3, 15, 1),  -- Scott (mediocampista)
(266, 266, 16, 3, 15, 1),  -- Tavernier (mediocampista)
(267, 267, 7, 4, 15, 1),   -- Kluivert (delantero)
(268, 268, 9, 4, 15, 1),   -- Solanke (delantero)
(269, 269, 24, 4, 15, 1),  -- Semenyo (delantero)
(270, 270, 21, 4, 15, 1),  -- Moore (delantero)
(271, 271, 11, 4, 15, 1),  -- Sinisterra (delantero)
(272, 272, 17, 3, 15, 1),  -- Brooks (mediocampista)
(273, 273, 27, 4, 15, 1),  -- Ouattara (delantero)
(274, 274, 19, 3, 15, 1),  -- Traor  (mediocampista)

-- Fulham (id_equipo = 16)
(275, 275, 1, 1, 16, 1),   -- Leno (portero)
(276, 276, 13, 1, 16, 1),  -- Rod k (portero)
(277, 277, 23, 1, 16, 1),  -- Benda (portero)
(278, 278, 2, 2, 16, 1),   -- Tete (defensa)
(279, 279, 21, 2, 16, 1),  -- Castagne (defensa)
(280, 280, 16, 2, 16, 1),  -- Adarabioyo (defensa)
(281, 281, 13, 2, 16, 1),  -- Ream (defensa)
(282, 282, 3, 2, 16, 1),   -- Bassey (defensa)
(283, 283, 31, 2, 16, 1),  -- Diop (defensa)
(284, 284, 33, 2, 16, 1),  -- Robinson (defensa)
(285, 285, 6, 3, 16, 1),   -- Palhinha (mediocampista)
(286, 286, 4, 3, 16, 1),   -- Reed (mediocampista)
(287, 287, 10, 3, 16, 1),  -- Cairney (mediocampista)
(288, 288, 18, 3, 16, 1),  -- Pereira (mediocampista)
(289, 289, 8, 3, 16, 1),   -- Lukic (mediocampista)
(290, 290, 7, 3, 16, 1),   -- Wilson (mediocampista)
(291, 291, 14, 3, 16, 1),  -- Decordova-Reid (mediocampista)
(292, 292, 20, 3, 16, 1),  -- Willian (mediocampista)
(293, 293, 22, 3, 16, 1),  -- Iwobi (mediocampista)
(294, 294, 9, 4, 16, 1),   -- Jim nez (delantero)
(295, 295, 30, 4, 16, 1),  -- Vin cius (delantero)
(296, 296, 19, 4, 16, 1),  -- Muniz (delantero)
(297, 297, 11, 4, 16, 1),  -- Traor  (delantero)
(298, 298, 27, 4, 16, 1),  -- Solomon (delantero)
(299, 299, 15, 2, 16, 1),  -- Ballo-Tour  (defensa)

-- Everton (id_equipo = 17)
(300, 300, 1, 1, 17, 1),    -- Pickford (portero)
(301, 301, 13, 1, 17, 1),   -- Virg nia (portero)
(302, 302, 23, 1, 17, 1),   -- Lonergan (portero)
(303, 303, 23, 2, 17, 1),   -- Coleman (defensa)
(304, 304, 2, 2, 17, 1),    -- Patterson (defensa)
(305, 305, 6, 2, 17, 1),    -- Tarkowski (defensa)
(306, 306, 5, 2, 17, 1),    -- Keane (defensa)
(307, 307, 22, 2, 17, 1),   -- Godfrey (defensa)
(308, 308, 32, 2, 17, 1),   -- Branthwaite (defensa)
(309, 309, 19, 2, 17, 1),   -- Mykolenko (defensa)
(310, 310, 18, 2, 17, 1),   -- Young (defensa)
(311, 311, 16, 3, 17, 1),   -- Doucour  (mediocampista)
(312, 312, 8, 3, 17, 1),    -- Onana (mediocampista)
(313, 313, 37, 3, 17, 1),   -- Garner (mediocampista)
(314, 314, 27, 3, 17, 1),   -- Gueye (mediocampista)
(315, 315, 21, 3, 17, 1),   -- Gomes (mediocampista)
(316, 316, 7, 3, 17, 1),    -- McNeil (mediocampista)
(317, 317, 11, 3, 17, 1),   -- Harrison (mediocampista)
(318, 318, 10, 3, 17, 1),   -- Danjuma (mediocampista)
(319, 319, 9, 4, 17, 1),    -- Calvert-Lewin (delantero)
(320, 320, 14, 4, 17, 1),   -- Beto (delantero)
(321, 321, 28, 4, 17, 1),   -- Chermiti (delantero)
(322, 322, 61, 4, 17, 1),   -- Dobbin (delantero)
(323, 323, 17, 3, 17, 1),   -- Iwobi (mediocampista)
(324, 324, 11, 3, 17, 1);   -- Gray (mediocampista)

-- Inserts for EquiposLigasInfo table 
INSERT INTO EquiposLigasInfo (id_equipo, partidos_g, partidos_p, puntuacion, alta)
VALUES
  (1, 9, 2, 27, 1),
  (2, 10, 1, 30, 1),
  (3, 6, 5, 18, 1),
  (4, 7, 4, 21, 1),
  (5, 7, 4, 21, 1),
  (6, 5, 6, 15, 1),
  (7, 6, 5, 18, 1),
  (8, 5, 6, 15, 1),
  (9, 4, 7, 12, 1),
  (10, 8, 3, 24, 1),
  (11, 7, 4, 21, 1),
  (12, 4, 7, 12, 1),
  (13, 9, 2, 27, 1),
  (14, 4, 7, 12, 1),
  (15, 3, 8, 18, 1),
  (16, 2, 9, 6, 1),
  (17, 1, 10, 3, 1),
  (18, 5, 6, 15, 1),
  (19, 6, 5, 18, 1),
  (20, 2, 9, 6, 1);


-- Inserts for Partidos table
INSERT INTO Partidos (id_local, id_visitante, fecha_partido, hora_partido, arbitro, resultado_local, resultado_visitante)
VALUES
  (1, 2, '2023-08-12', '15:00', 201, 2, 1),
  (1, 3, '2023-08-19', '17:30', 202, 1, 2),
  (2, 4, '2023-08-13', '15:00', 203, 0, 3),
  (2, 5, '2023-08-26', '13:00', 204, 1, 1),
  (3, 1, '2023-09-02', '15:00', 205, 2, 1),
  (3, 6, '2023-09-16', '17:30', 206, 1, 1),
  (4, 2, '2023-09-03', '15:00', 207, 2, 0),
  (4, 7, '2023-09-23', '13:00', 208, 3, 1),
  (5, 4, '2023-08-20', '15:00', 209, 1, 2),
  (5, 8, '2023-09-17', '17:30', 210, 2, 1),
  (6, 9, '2023-08-12', '13:00', 211, 2, 0),
  (6, 10, '2023-08-19', '15:00', 212, 1, 1),
  (7, 11, '2023-08-13', '17:30', 213, 1, 2),
  (7, 12, '2023-08-26', '15:00', 214, 0, 1),
  (8, 13, '2023-09-02', '13:00', 215, 2, 0),
  (8, 14, '2023-09-16', '15:00', 216, 1, 1),
  (9, 15, '2023-09-03', '17:30', 217, 2, 1),
  (9, 16, '2023-09-23', '15:00', 218, 1, 0),
  (10, 17, '2023-08-20', '13:00', 219, 0, 2),
  (10, 18, '2023-09-17', '15:00', 220, 1, 1),
  (11, 19, '2023-08-12', '15:00', 221, 2, 1),
  (11, 20, '2023-08-19', '17:30', 222, 1, 0),
  (12, 1, '2023-08-13', '15:00', 223, 1, 2),
  (12, 3, '2023-08-26', '13:00', 224, 0, 1),
  (13, 4, '2023-09-02', '15:00', 225, 1, 1),
  (13, 5, '2023-09-16', '17:30', 226, 2, 0),
  (14, 6, '2023-09-03', '15:00', 227, 1, 2),
  (14, 7, '2023-09-23', '13:00', 228, 0, 1),
  (15, 8, '2023-08-20', '15:00', 229, 2, 1),
  (15, 9, '2023-09-17', '17:30', 230, 1, 0),
  (16, 10, '2023-08-12', '13:00', 231, 1, 1),
  (16, 11, '2023-08-19', '15:00', 232, 2, 0),
  (17, 12, '2023-08-13', '17:30', 233, 1, 1),
  (17, 13, '2023-08-26', '15:00', 234, 0, 2),
  (18, 14, '2023-09-02', '13:00', 235, 1, 0),
  (18, 15, '2023-09-16', '15:00', 236, 2, 1),
  (19, 16, '2023-09-03', '17:30', 237, 1, 1),
  (19, 17, '2023-09-23', '15:00', 238, 2, 0),
  (20, 18, '2023-08-20', '13:00', 239, 1, 2),
  (20, 19, '2023-09-17', '15:00', 240, 0, 1);



  --JugadoresLog Arsenal
  set dateformat dmy
  go
insert into JugadoresLog(id_jugador, nro_camiseta, id_posicion, id_equipo, fecha_actualizacion)
values (1000, 1,1,14,'20/08/2021'), --ramsdale
(1001,22,1,19,'15/08/2023'), -- raya
(1002,31,1,1,'01/07/2022'), --hein

(1003,2,2,1,'15/07/2021'), --saliba
(1004,4,3,8,'30/07/2021'), --white
(1005,6,2,1,'01/09/2020'), --magalhaes
(1006,15,2,1,'23/01/2023'), --kiwior
(1007,35,4,2,'22/07/2022'), --zinchenko
(1008,18,3,1,'31/08/2021'), --tomiyasu
(1009,12,2,1,'14/07/2023'), --timber
(1010,17,3,16,'30/06/2023'), --cedric

(1011,5,5,1,'05/10/2020'),--partey
(1012,20,6,9,'31/01/2023'), --jorginho
(1013,8,7,1,'20/08/2021'), --odegaard
(1014,10,7,1,'01/08/2020'), --smith rowe
(1015,29,7,9,'01/07/2023'), --havertz
(1016,21,7,1,'01/07/2022'), --vieira
(1017,25,5,1,'03/08/2020'), --elneny
(1018,41,5,10,'15/07/2023'), --rice

(1019,7,8,1,'01/07/2019'),--saka
(1020,11,9,1,'02/07/2019'),--martinelli
(1021,19,9,8,'20/01/2022'),-- trossard
(1022,24,8,1,'30/06/2022'), --nelson
(1023,9,11,2,'04/07/2022'), --jesus
(1024,14,11,1,'02/01/2020') --nketiah

--JugadoresLog Man City
insert into  JugadoresLog(id_jugador, nro_camiseta, id_posicion, id_equipo, fecha_actualizacion)
values (1025, 31, 1, 2,'01/07/2017'),   -- Ederson
(1026, 18, 1, 2,'01/07/2022'),   -- Ortega
(1027, 33, 1, 2, '20/07/2021'),   -- Carson

-- Defensas
(1028, 3, 2, 2,'29/09/2020'),    -- Dias
(1029, 5, 2, 17,'09/08/2016'),    -- Stones
(1030, 6, 2, 15,'05/08/2020'),    -- Ak 
(1031, 2, 3, 4, '14/07/2017'),    -- Walker
(1032, 24, 4, 2,'05/08/2023'),   -- Gvardiol
(1033, 25, 2, 2,'01/09/2022'),   -- Akanji
(1034, 21, 4, 2,'16/08/2022'),   -- Sergio G mez
(1035, 82, 3, 2,'01/07/2022');   -- Rico Lewis

insert into  JugadoresLog(id_jugador, nro_camiseta, id_posicion, id_equipo, fecha_actualizacion)
values (1036, 16, 5, 2, '04/07/2019'),   -- Rodri
(1037, 17, 7, 2,'30/08/2015'),   -- De Bruyne
(1038, 27, 6, 11,'01/09/2023'),   -- Matheus Nunes
(1039, 20, 7, 2,'01/07/2017'),   -- Bernardo Silva
(1040, 47, 7, 2,'01/07/2017'),   -- Foden
(1041, 8, 6, 9, '01/07/2023'),    -- Kovacic

-- Extremos y Delanteros
(1042, 10, 9, 5,'05/08/2021'),   -- Grealish
(1043, 11, 8, 2,'24/08/2023'),   -- Doku
(1044, 52, 8, 2,'01/07/2023'),   -- Oscar Bobb
(1045, 9, 11, 2,'01/07/2022'),   -- Haaland
(1046, 19, 10, 2,'07/07/2022');  -- Juli n  lvarez

--JugadoresLog Liverpool
insert into  JugadoresLog(id_jugador, nro_camiseta, id_posicion, id_equipo, fecha_actualizacion)
values
-- Porteros
(1050, 1, 1, 3,'19/07/2018'),    -- Alisson
(1051, 62, 1, 3,'01/07/2019'),   -- Kelleher
(1052, 13, 1, 10,'05/08/2019'),   -- Adri n
-- Defensas
(1053, 4, 2, 3,'01/01/2018'),    -- Van Dijk
(1054, 5, 2, 3,'01/07/2021'),    -- Konat 
(1055, 2, 3, 3,'01/07/2015'),    -- Gomez
(1056, 32, 2, 3,'01/07/2016'),   -- Matip
(1057, 26, 4, 3,'21/07/2017'),   -- Robertson
(1058, 66, 3, 3,'01/07/2016'),   -- Alexander-Arnold
(1059, 21, 4, 3,'10/08/2020'),   -- Tsimikas
(1060, 78, 2, 3,'01/07/2023'),   -- Quansah
(1061, 84, 3, 3,'01/07/2023'),   -- Bradley
-- Mediocampistas
(1062, 10, 6, 8, '01/07/2023'),   -- Mac Allister
(1063, 8, 7, 3,'02/07/2023'),    -- Szoboszlai
(1064, 3, 5, 3,'18/08/2023'),    -- Endo
(1065, 17, 6, 3,'01/07/2020'),   -- Curtis Jones
(1066, 38, 6, 3,'01/09/2023'),   -- Gravenberch
(1067, 19, 7, 3,'01/07/2021'),   -- Elliott
(1068, 43, 5, 3,'01/07/2022'),   -- Bajcetic

-- Extremos y Delanteros
(1069, 11, 8, 3,'01/07/2017'),   -- Salah
(1070, 7, 9, 3,'30/01/2022'),    -- Luis D az
(1071, 20, 10, 11,'19/09/2020'),  -- Diogo Jota
(1072, 9, 11, 3,'01/07/2022'),   -- Darwin N  ez
(1073, 18, 11, 3,'01/01/2023'),  -- Cody Gakpo

--JugadoresLog Tottenham
(1075, 13, 1, 4,'01/07/2023'),   -- Vicario
(1076, 20, 1, 4,'01/07/2022'),   -- Forster
(1077, 40, 1, 4,'01/08/2021'),   -- Austin
-- Defensas
(1078, 17, 2, 4,'30/08/2022'),   -- Romero
(1079, 37, 2, 4,'08/08/2023'),   -- Van de Ven
(1080, 38, 4, 4,'30/06/2023'),   -- Udogie
(1081, 23, 3, 4,'01/07/2023'),   -- Porro
(1082, 33, 4, 4,'23/11/2014'),   -- Davies
(1083, 15, 2, 4,'31/07/2014'),   -- Dier
(1084, 12, 3, 4,'31/08/2021'),   -- Emerson Royal
(1085, 6, 2, 4,'11/01/2024'),    -- Dragusin

-- Mediocampistas
(1086, 30, 6, 4,'31/01/2022'),   -- Bentancur
(1087, 8, 5, 8,'01/07/2022'),    -- Bissouma
(1088, 29, 6, 4,'30/06/2022'),   -- Sarr
(1089, 4, 6, 4,'31/05/2021'),    -- Skipp
(1090, 5, 5, 4,'11/08/2020'),    -- H jbjerg
(1091, 10, 7, 4,'01/07/2023'),   -- Maddison
(1092, 18, 7, 4,'30/06/2023'),   -- Lo Celso
-- Extremos y Delanteros
(1093, 21, 8, 4,'01/07/2023'),   -- Kulusevski
(1094, 28, 8, 18,'01/09/2023'),   -- Johnson
(1095, 27, 9, 4,'11/07/2023'),   -- Solomon
(1096, 7, 10, 4,'28/08/2015'),   -- Son
(1097, 9, 11, 17,'01/07/2022'),   -- Richarlison
(1098, 16, 11, 4,'09/01/2024')  -- Werner
GO
INSERT INTO Usuarios VALUES(1, 'minimega', '1234', 'Propietario', 1)
INSERT INTO Usuarios VALUES(2, 'normaluser', '1234', 'Hinchada', 2)
INSERT INTO Usuarios VALUES(3, 'superuser', '1234', 'Propietario', 1)
GO
CREATE PROC sp_mostrar_titulares
@id_equipo int
AS
	SELECT 
    jugadores_con_fila.nro_camiseta, 
    jugadores_con_fila.nombre_completo, 
    jugadores_con_fila.posicion, 
    jugadores_con_fila.fecha_nac, 
    jugadores_con_fila.nombre_equipo
FROM (
    SELECT 
        j.nro_camiseta, 
        p.nombre_completo, 
        pos.posicion, 
        p.fecha_nac, 
        e.nombre_equipo,
        ROW_NUMBER() OVER (PARTITION BY pos.posicion ORDER BY j.nro_camiseta) AS fila
    FROM Jugadores j 
    JOIN Personas p ON p.id_persona = j.id_persona 
    JOIN Equipos e ON e.id_equipo = j.id_equipo
    JOIN Posiciones pos ON pos.id_posicion = j.id_posicion
    WHERE e.id_equipo = 2
) AS jugadores_con_fila
WHERE jugadores_con_fila.fila = 1
ORDER BY jugadores_con_fila.nro_camiseta;


GO
ALTER PROC [dbo].[SP_INSERTAR_PERSONA]
@id_persona int, @nombre_completo varchar(50), @fecha_nac date
AS
	INSERT INTO Personas VALUES(@id_persona, @nombre_completo, 1234, @fecha_nac, 1)
GO

--JugadoresLog Arsenal

insert into JugadoresLog(id_jugador, nro_camiseta, id_posicion, id_equipo, fecha_actualizacion)
values (1000, 1,1,14,'20/08/2021'), --ramsdale
(1001,22,1,19,'15/08/2023'), -- raya

(1003,2,2,21,'15/07/2021'), --saliba
(1004,4,3,8,'30/07/2021'), --white
(1005,6,2,21,'01/09/2020'), --magalhaes
(1007,35,4,2,'22/07/2022'), --zinchenko

(1012,20,6,9,'31/01/2023'), --jorginho
(1013,8,7,21,'20/08/2021'), --odegaard
(1014,10,7,1,'01/08/2020'), --smith rowe
(1015,29,7,9,'01/07/2023'), --havertz
(1016,21,7,21,'01/07/2022'), --vieira
(1017,25,5,21,'03/08/2020'), --elneny
(1018,41,5,10,'15/07/2023'), --rice

(1019,7,8,1,'01/07/2019'),--saka
(1020,11,9,21,'02/07/2019'),--martinelli
(1021,19,9,8,'20/01/2022'),-- trossard
(1022,24,8,21,'30/06/2022'), --nelson
(1023,9,11,2,'04/07/2022'), --jesus
(1024,14,11,1,'02/01/2020'), --nketiah

--JugadoresLog Man City

(1025, 31, 1, 21,'01/07/2017'),   -- Ederson
(1026, 18, 1, 21,'01/07/2022'),   -- Ortega

-- Defensas
(1028, 3, 2, 21,'29/09/2020'),    -- Dias
(1029, 5, 2, 17,'09/08/2016'),    -- Stones
(1030, 6, 2, 15,'05/08/2020'),    -- Aké
(1031, 2, 3, 4, '14/07/2017'),    -- Walker
(1032, 24, 4, 21,'05/08/2023'),   -- Gvardiol
(1033, 25, 2, 21,'01/09/2022'),   -- Akanji
(1034, 21, 4, 21,'16/08/2022'),   -- Sergio Gómez
(1035, 82, 3, 2,'01/07/2022'),   -- Rico Lewis

-- Mediocampistas
(1036, 16, 5, 21, '04/07/2019'),   -- Rodri
(1037, 17, 7, 21,'30/08/2015'),   -- De Bruyne
(1038, 27, 6, 11,'01/09/2023'),   -- Matheus Nunes
(1039, 20, 7, 21,'01/07/2017'),   -- Bernardo Silva
(1040, 47, 7, 2,'01/07/2017'),   -- Foden
(1041, 8, 6, 9, '01/07/2023'),    -- Kovacic

-- Extremos y Delanteros
(1042, 10, 9, 5,'05/08/2021'),   -- Grealish
(1043, 11, 8, 21,'24/08/2023'),   -- Doku
(1044, 52, 8, 2,'01/07/2023'),   -- Oscar Bobb
(1045, 9, 11, 21,'01/07/2022'),   -- Haaland
(1046, 19, 10, 21,'07/07/2022'),  -- Julián Álvarez

--JugadoresLog Liverpool
-- Porteros
(1050, 1, 1, 21,'19/07/2018'),    -- Alisson
(1051, 62, 1, 3,'01/07/2019'),   -- Kelleher
(1052, 13, 1, 10,'05/08/2019'),   -- Adrián
-- Defensas
(1053, 4, 2, 3,'01/01/2018'),    -- Van Dijk
(1054, 5, 2, 21,'01/07/2021'),    -- Konaté
(1055, 2, 3, 3,'01/07/2015'),    -- Gomez
(1056, 32, 2, 21,'01/07/2016'),   -- Matip
(1057, 26, 4, 3,'21/07/2017'),   -- Robertson
(1058, 66, 3, 3,'01/07/2016'),   -- Alexander-Arnold
(1059, 21, 4, 21,'10/08/2020'),   -- Tsimikas
(1060, 78, 2, 3,'01/07/2023'),   -- Quansah
(1061, 84, 3, 3,'01/07/2023'),   -- Bradley
-- Mediocampistas
(1062, 10, 6, 8, '01/07/2023'),   -- Mac Allister
(1063, 8, 7, 21,'02/07/2023'),    -- Szoboszlai
(1064, 3, 5, 21,'18/08/2023'),    -- Endo
(1065, 17, 6, 3,'01/07/2020'),   -- Curtis Jones
(1066, 38, 6, 21,'01/09/2023'),   -- Gravenberch
(1067, 19, 7, 3,'01/07/2021'),   -- Elliott
(1068, 43, 5, 21,'01/07/2022'),   -- Bajcetic

-- Extremos y Delanteros
(1069, 11, 8, 21,'01/07/2017'),   -- Salah
(1070, 7, 9, 21,'30/01/2022'),    -- Luis Díaz
(1071, 20, 10, 11,'19/09/2020'),  -- Diogo Jota
(1072, 9, 11, 21,'01/07/2022'),   -- Darwin Núñez
(1073, 18, 11, 21,'01/01/2023'),  -- Cody Gakpo

--JugadoresLog Tottenham
(1075, 13, 1, 21,'01/07/2023'),   -- Vicario
(1076, 20, 1, 4,'01/07/2022'),   -- Forster
(1077, 40, 1, 21,'01/08/2021'),   -- Austin
-- Defensas
(1078, 17, 2, 4,'30/08/2022'),   -- Romero
(1079, 37, 2, 21,'08/08/2023'),   -- Van de Ven
(1080, 38, 4, 21,'30/06/2023'),   -- Udogie
(1081, 23, 3, 21,'01/07/2023'),   -- Porro
(1082, 33, 4, 4,'23/11/2014'),   -- Davies
(1083, 15, 2, 21,'31/07/2014'),   -- Dier
(1084, 12, 3, 21,'31/08/2021'),   -- Emerson Royal
(1085, 6, 2, 21,'11/01/2024'),    -- Dragusin

-- Mediocampistas
(1086, 30, 6, 21,'31/01/2022'),   -- Bentancur
(1087, 8, 5, 8,'01/07/2022'),    -- Bissouma
(1088, 29, 6, 21,'30/06/2022'),   -- Sarr
(1089, 4, 6, 4,'31/05/2021'),    -- Skipp
(1090, 5, 5, 4,'11/08/2020'),    -- Højbjerg
(1091, 10, 7, 4,'01/07/2023'),   -- Maddison
(1092, 18, 7, 21,'30/06/2023'),   -- Lo Celso
-- Extremos y Delanteros
(1093, 21, 8, 21,'01/07/2023'),   -- Kulusevski
(1094, 28, 8, 18,'01/09/2023'),   -- Johnson
(1095, 27, 9, 21,'11/07/2023'),   -- Solomon
(1096, 7, 10, 21,'28/08/2015'),   -- Son
(1097, 9, 11, 17,'01/07/2022'),   -- Richarlison
(1098, 16, 11, 21,'09/01/2024'),  -- Werner

--JugadoresLog Aston Villa
(1100, 1, 1, 1,'16/09/2020'),    -- Emiliano Martínez
(1101, 25, 1, 21,'01/07/2022' ),   -- Olsen
(1102, 40, 1, 5, '01/07/2023'),   -- Marschall

-- Defensas
(1103, 4, 2, 21, '12/07/2023'),    -- Pau Torres
(1104, 3, 2, 21, '01/07/2022'),    -- Diego Carlos
(1105, 5, 2, 19, '11/07/2019'),    -- Konsa
(1106, 25, 2, 21,'01/09/2023'),   -- Lenglet
(1107, 12, 4, 17,'13/01/2022'),   -- Digne
(1108, 2, 3, 18,'03/09/2020' ),    -- Cash
(1109, 15, 4, 21,'11/01/2023'),   -- Moreno
(1110, 16, 2, 1,'27/01/2022'),   -- Chambers

-- Mediocampistas
(1111, 6, 6, 2, '25/07/2019' ),    -- Douglas Luiz
(1112, 44, 5, 21,'01/07/2022'),   -- Kamara
(1113, 7, 6, 21, '08/08/2018'),    -- McGinn
(1114, 41, 7, 5, '01/07/2020'),   -- Jacob Ramsey
(1115, 8, 6, 5, '01/07/2023'),    -- Tielemans
(1116, 32, 5, 11, '01/09/2022'),   -- Dendoncker
(1117, 36, 6, 5,'31/05/2023'),   -- Iroegbunam
(1118, 23, 7, 5,'01/02/2024'),   -- Morgan Rogers

-- Extremos y Delanteros
(1119, 31, 8, 21,'04/08/2021'),   -- Bailey
(1120, 19, 8, 21,'22/07/2023'),   -- Diaby
(1121, 22, 9, 21,'18/08/2023'),   -- Zaniolo
(1122, 17, 9, 21,'31/01/2023'),   -- Traoré
(1123, 11, 11, 19,'09/09/2020'),  -- Watkins
(1124, 24, 11, 21,'23/01/2023'),  -- Durán

--Jugadores Man Und

-- Porteros
(1125, 24, 1, 21, '20-07-2023'),   -- Onana
-- Defensas
(1128, 19, 2, 21, '14-08-2021'),   -- Varane
(1129, 6, 2, 21, '28-07-2022'),    -- Martínez
(1130, 5, 2, 6, '05-08-2019'),    -- Maguire
(1133, 29, 3, 20, '01-07-2019'),   -- Wan-Bissaka
-- Mediocampistas
(1137, 18, 5, 21,'22-08-2022'),   -- Casemiro
(1138, 8, 7, 21, '29-01-2020'),    -- Bruno Fernandes
(1141, 39, 6, 6, '01-07-2017'),   -- McTominay
-- Extremos y Delanteros
(1144, 10, 9, 6,'01-01-2016'),   -- Rashford
(1145, 17, 9, 6, '01-07-2022'),   -- Garnacho
(1146, 21, 8, 21, '30-08-2022'),   -- Antony

--JugadoresLog Newcastle

-- Porteros
(2000, 20, 1, 7, '01-07-2022'), -- Nick Pope

-- Defensas
(2003, 2, 3, 21, '07-01-2022'),  -- Kieran Trippier
(2005, 33, 2, 8, '31-01-2022'), -- Dan Burn
(2006, 5, 2, 21, '26-07-2018'),  -- Fabian Schär

-- Mediocampistas
(2011, 39, 6, 21,'30-01-2022'), -- Bruno Guimarães
(2012, 8, 5, 21, '03-07-2023'),  -- Sandro Tonali
(2013, 28, 6, 1, '13-08-2021'), -- Joe Willock

-- Extremos y Mediapuntas
(2017, 24, 8, 21,'31-01-2019'), -- Miguel Almirón
(2021, 14, 11, 21,'26-08-2022'), -- Alexander Isak
(2023, 7, 10, 21, '23-07-2019'),  -- Joelinton

--JugadoresLog Brighton
-- Porteros
(2025, 23, 1, 8, '01-07-2018'),  -- Jason Steele
-- Defensas
(2028, 5, 2, 8, '04-11-2013'),   -- Lewis Dunk
(2029, 29, 2, 8, '31-05-2022'),  -- Jan Paul van Hecke
(2031, 30, 4, 21, '16-08-2022'),  -- Pervis Estupiñán
-- Mediocampistas
(2035, 7, 6, 3, '01-07-2023'),   -- James Milner
(2037, 11, 6, 9, '01-09-2022'),  -- Billy Gilmour
-- Extremos y Delanteros
(2042, 22, 9, 21, '30-06-2022'),  -- Kaoru Mitoma
(2044, 17, 10, 21, '01-01-2023'), -- Facundo Buonanotte
(2045, 9, 11, 8, '01-07-2023'),  -- João Pedro
(2048, 31, 9, 21, '01-09-2023'),  -- Ansu Fati


--JugadoresLog Chelsea
-- Porteros
(2050, 1, 1, 8, '05-08-2023'),   -- Robert Sánchez
-- Defensas
(2055, 33, 2, 9, '20-08-2022'),  -- Wesley Fofana
(2059, 27, 3, 21, '20-06-2023'),  -- Malo Gusto
(2061, 3, 4, 8, '05-08-2022'),   -- Marc Cucurella

-- Mediocampistas
(2062, 8, 6, 21, '31-01-2023'),   -- Enzo Fernández
(2063, 25, 5, 8, '14-08-2023'),  -- Moises Caicedo
(2064, 23, 6, 9, '01-07-2022'),  -- Conor Gallagher

-- Extremos y Delanteros
(2067, 20, 8, 2, '01-09-2023'),  -- Cole Palmer
(2070, 7, 9, 1, '12-07-2022'),   -- Raheem Sterling

--JugadoresLog Westham 
-- Porteros
(2075, 23, 1, 21, '01-07-2022'),  -- Alphonse Areola
-- Defensas
(2078, 4, 2, 9, '28-08-2021'),   -- Kurt Zouma
(2079, 27, 2, 21, '01-07-2022'),  -- Nayef Aguerd
-- Mediocampistas
(2087, 19, 5, 21, '10-08-2023'),  -- Edson Álvarez
(2092, 10, 7, 21, '29-08-2022'),  -- Lucas Paquetá
-- Extremos y Delanteros
(2094, 20, 8, 10, '31-01-2020'),  -- Jarrod Bowen
(2095, 17, 9, 10, '05-08-2022'),  -- Maxwel Cornet

--JugadoresLog Wolverhampton
(2100, 1, 1, 21, '15-07-2021'),    -- José Sá (Portero)
(2102, 23, 2, 21, '31-08-2023'),   -- Santiago Bueno (Defensa Central)
(2109, 2, 3, 21, '20-07-2023'),    -- Matt Doherty (Lateral Derecho)
(2110, 8, 5, 21, '30-01-2023'),    -- João Gomes (Mediocentro Defensivo)
(2115, 21, 8, 21, '17-01-2023'),   -- Pablo Sarabia (Extremo Derecho)
(2119, 9, 11, 21, '01-07-2023'),   -- Matheus Cunha (Delantero Centro)

-- JugadoresLog Fulham(16)
(275, 1, 1, 1, '02-08-2022'),   -- Leno (portero)

(278, 2, 2, 21, '10-09-2020'),   -- Tete (defensa)
(279, 21, 2, 16, '29-08-2023'),  -- Castagne (defensa)

(285, 6, 3, 21, '04-07-2022'),   -- Palhinha (mediocampista)
(286, 4, 3, 16, '30-08-2020'),   -- Reed (mediocampista)
(289, 8, 3, 21, '31-01-2023'),   -- Lukic (mediocampista)

(294, 9, 4, 11, '25-07-2023'),   -- Jiménez (delantero)
(295, 30, 4, 21, '01-09-2022'),  -- Vinícius (delantero)
(297, 11, 4, 11, '12-08-2023'),  -- Traoré (delantero)


-- JugadoresLog Everton(17)
(300, 1, 1, 17, '01-07-2017'),    -- Pickford (portero)

(303, 23, 2, 17, '31-05-2010'),   -- Coleman (defensa)
(305, 6, 2, 12, '02-07-2022'),    -- Tarkowski (defensa)
(309, 19, 2, 21, '01-01-2022'),   -- Mykolenko (defensa)

(311, 16, 3, 17, '08-09-2020'),   -- Doucouré (mediocampista)
(313, 37, 3, 6, '01-09-2022'),   -- Garner (mediocampista)
(316, 7, 3, 12, '28-07-2022'),    -- McNeil (mediocampista)

(319, 9, 4, 14, '31-08-2016'),    -- Calvert-Lewin (delantero)
(320, 14, 4, 21, '29-08-2023'),   -- Beto (delantero)



-- JugadoresLog Nothingham Forest(18)
-- Porteros
(1300, 1, 1, 1, '09-08-2023'),    -- Turner
-- Defensas
(1303, 2, 3, 21, '23-08-2023'),    -- Montiel
(1304, 24, 3, 18, '07-09-2022'),   -- Aurier
(1305, 7, 3, 1, '10-07-2022'),    -- Williams
-- Mediocampistas
(1313, 22, 5, 18, '31-05-2018'),   -- Yates
(1314, 6, 5, 21, '01-09-2023'),    -- Sangaré
(1315, 8, 6, 21, '31-07-2022'),    -- Mangala
-- Extremos y Delanteros
(1320, 17, 8, 6, '25-07-2023'),   -- Elanga
(1321, 11, 9, 9, '01-09-2023'),   -- Hudson-Odoi


-- JugadoresLog Brentford(19)
(2150, 1, 1, 21, '01-07-2023'),    -- Mark Flekken (Portero)

(2152, 5, 2, 19, '02-07-2019'),    -- Ethan Pinnock (Defensa Central)
(2153, 16, 2, 12, '22-07-2022'),   -- Ben Mee (Defensa Central)

(2160, 6, 5, 21, '01-07-2019'),    -- Christian Norgaard (Mediocentro Defensivo)
(2161, 8, 6, 21, '10-07-2019'),    -- Mathias Jensen (Mediocentro)

(2168, 7, 9, 19, '12-07-2022'),    -- Keane Lewis-Potter (Extremo Izquierdo)
(2171, 14, 10, 17, '01-09-2023'),  -- Neal Maupay (Segundo Delantero)

-- JugadoresLog Crystal Palace(20)
-- Porteros
(2200, 1, 1, 20, '01-07-2022'),   -- Sam Johnstone

-- Defensas
(2203, 6, 2, 9, '18-07-2021'),   -- Marc Guéhi
(2204, 16, 2, 21, '28-07-2021'),  -- Joachim Andersen

-- Mediocampistas
(2211, 8, 5, 15, '01-07-2023'),   -- Jefferson Lerma
(2212, 28, 5, 21, '11-07-2022'),  -- Cheick Doucouré
(2213, 19, 6, 20, '28-08-2021'),  -- Will Hughes

-- Delanteros
(2220, 22, 11, 21, '31-08-2021'), -- Odsonne Édouard
(2221, 14, 11, 21, '31-01-2022'); -- Jean-Philippe Mateta
GO
INSERT INTO Personas (id_persona, nombre_completo, dni, fecha_nac, alta)
VALUES 
    (501, 'Laura Martínez Sánchez', 23456789, '1990-05-15', 1),
    (502, 'Carlos Alberto Rodríguez', 24567890, '1988-11-23', 1),
    (503, 'María José González', 25678901, '1992-03-30', 1),
    (504, 'Juan Pablo Fernández', 26789012, '1985-07-18', 1),
    (505, 'Ana Isabel López Castro', 27890123, '1993-09-25', 1),
    (506, 'Roberto Carlos Mendoza', 28901234, '1987-12-03', 1),
    (507, 'Patricia Elena Vargas', 29012345, '1991-04-11', 1),
    (508, 'Diego Alejandro Torres', 21234567, '1989-08-22', 1),
    (509, 'Carmen Rosa Jiménez', 22345678, '1986-01-14', 1),
    (510, 'Miguel Ángel Morales', 23456987, '1994-06-28', 1);
GO
CREATE PROC SP_GET_FREE_DIRECTORES
AS
select * from Personas
where id_persona not in (select director_tecnico from Equipos)
AND id_persona not in (select id_persona from Jugadores)