-- Crear una secuencia para generar valores de idcliente automáticamente
CREATE SEQUENCE seq_clientes
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
  
  CREATE TABLE clientes (
    idcliente NUMBER(10) PRIMARY KEY,
    nombre VARCHAR2(50),
    apellido VARCHAR2(50),
    genero CHAR(1),
    edad NUMBER(3),
    sueldo NUMBER(10, 2)
);

-- Llenar la tabla con 1000 registros ficticios
BEGIN
  FOR i IN 1..1000 LOOP
    INSERT INTO clientes(idcliente, nombre, apellido, genero, edad, sueldo)
    VALUES (seq_clientes.NEXTVAL, 
            'Cliente' || i, 
            'Apellido' || i, 
            CASE WHEN MOD(i, 2) = 0 THEN 'M' ELSE 'F' END, 
            DBMS_RANDOM.VALUE(18, 65), 
            ROUND(DBMS_RANDOM.VALUE(20000, 80000), 2)
           );
  END LOOP;
  COMMIT;
END;
/
select * from clientes;

select max(sueldo) from clientes;


--La persona con el Sueldo Mayor
SELECT nombre, sueldo
FROM clientes
WHERE sueldo = (SELECT MAX(sueldo) FROM clientes);

--Cuantos hombres y cuantas mujeres hay
SELECT genero, COUNT(*) as cantidad
FROM clientes
GROUP BY genero;

--Total de personas que tienen un 10 en su apelldo
SELECT COUNT(*) as cantidad
FROM clientes
WHERE apellido LIKE '%10%';


--Cuantos hombres tienen sueldos arriba de 25,000
SELECT COUNT(*) as cantidad
FROM clientes
WHERE genero = 'M' AND sueldo > 25000;



--Cuantas mujeres ganan menos de 50,000
SELECT COUNT(*) as cantidad
FROM clientes
WHERE genero = 'F' AND sueldo < 50000;



--Encontrar todas las personas cuyo nombre Termine en 0
SELECT nombre, apellido
FROM clientes
WHERE nombre LIKE '%0';



--La suma de todos los Sueldos
SELECT SUM(sueldo) as suma_sueldos
FROM clientes;


--El sueldo Minimo
SELECT MIN(sueldo) as sueldo_minimo
FROM clientes;



--El Promedio de todos los sueldos
SELECT AVG(sueldo) as promedio_sueldos
FROM clientes;




--consulta #7
DELETE FROM Documentos WHERE caso IN (SELECT idcaso FROM Casos);
DELETE FROM Comentarios WHERE caso IN (SELECT idcaso FROM Casos);
DELETE FROM Movimientos WHERE idcaso IN (SELECT idcaso FROM Casos);
DELETE FROM Casos;
COMMIT;

--consulta #8
SELECT YEAR(fecha_crea) año, MONTH(fecha_crea) mes, COUNT(*) total_casos
FROM Casos
GROUP BY YEAR(fecha_crea), MONTH(fecha_crea)
ORDER BY año, mes;

--consulta #9
SELECT C.*, P.nombres nombre_pesona_crea 
FROM CASOS C 
INNER JOIN USUARIO U ON C.USUARIO_CREA =U.USUARIO
INNER JOIN PERSONAS P ON U.PERSONA = P.PERSONA;

--consluta #10
SELECT P.nombres nombre_persona, COUNT(*) total_casos
FROM CASOS C 
INNER JOIN USUARIO U ON C.USUARIO_CREA =U.USUARIO
INNER JOIN PERSONAS P ON U.PERSONA = P.PERSONA
GROUP BY P.nombres;




CREATE TABLE Empleados (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Salario DECIMAL(10, 2),
    Departamento VARCHAR(50)
);

INSERT INTO Empleados (ID, Nombre, Apellido, Salario, Departamento)
VALUES
    (2, 'María', 'Gomez', 55000, 'Ventas'),
    (3, 'Luis', 'Rodriguez', 70000, 'Tecnología'),
    (4, 'Ana', 'Martinez', 48000, 'Recursos Humanos');

CREATE TABLE Clientes (
    IDCliente INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Ciudad VARCHAR(50)
);

CREATE TABLE Pedidos (
    IDPedido INT PRIMARY KEY,
    IDCliente INT,
    Producto VARCHAR(50),
    Cantidad INT,
    Fecha DATE,
    FOREIGN KEY (IDCliente) REFERENCES Clientes(IDCliente)
);

INSERT INTO Clientes (IDCliente, Nombre, Ciudad)
VALUES
    (1, 'Cliente 1', 'Ciudad A'),
    (2, 'Cliente 2', 'Ciudad B'),
    (3, 'Cliente 3', 'Ciudad A');

INSERT INTO Pedidos (IDPedido, IDCliente, Producto, Cantidad, Fecha)
VALUES
    (1, 1, 'Producto 1', 10, '2023-01-15'),
    (2, 2, 'Producto 2', 5, '2023-01-20'),
    (3, 1, 'Producto 3', 8, '2023-01-22'),
    (4, 3, 'Producto 1', 12, '2023-01-25');

CREATE TABLE Estudiantes (
    IDEstudiante INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Edad INT,
    Promedio DECIMAL(4, 2)
);

INSERT INTO Estudiantes (IDEstudiante, Nombre, Edad, Promedio)
VALUES
    (1, 'Estudiante 1', 18, 85.5),
    (2, 'Estudiante 2', 22, 91.2),
    (3, 'Estudiante 3', 19, 88.7),
    (4, 'Estudiante 4', 21, 79.8);

select * from empleados;

select * from Empleados
WHERE salario >= 5000;

SELECT departamento, COUNT(*) usuarios_depto
from Empleados
GROUP BY departamento;

SELECT nombre, salario from Empleados
WHERE salario = (SELECT MAX(salario) FROM Empleados);

SELECT c.nombre, p.IDPedido, p.producto, p.cantidad, p.fecha
FROM Pedidos p
INNER JOIN Clientes c ON p.IDCliente = c.IDCliente
WHERE c.nombre='Cliente 1';

select c.idcliente,c.nombre, COUNT(p.idpedido) cantidad_pedidos
FROM Clientes c 
INNER JOIN Pedidos p on c.IDCliente = p.IDCliente
GROUP BY c.IDCliente, c.nombre
ORDER by cantidad_pedidos DESC limit 1;

SELECT c.Ciudad, SUM(p.Cantidad) Total_Productos_Vendidos
FROM Clientes c
INNER JOIN Pedidos p ON c.IDCliente = p.IDCliente
GROUP BY c.Ciudad;

SELECT * from Pedidos
WHERE fecha BETWEEN '2023-01-01' and '2023-01-31';

SELECT * from Estudiantes
WHERE edad <20;

SELECT nombre, promedio from Estudiantes
WHERE promedio=(SELECT max(promedio)from Estudiantes);

SELECT AVG(Edad) Promedio_Edad
FROM Estudiantes;

SELECT COUNT(*) total_estudiantes from Estudiantes;


CREATE TABLE TMP_JSON_TABLE as SELECT idcliente, json_object(
        'idcliente' value idcliente, 
        'nombre' value nombre, 
        'apellido' value apellido, 
        'genero' value genero, 
        'edad' value edad, 
        'sueldo' value sueldo) as jsonData
FROM clientes
WHERE SUELDO > 40000;
select * from TMP_JSON_TABLE;
select COUNT(*) from TMP_JSON_TABLE;

select json_value(jsonData, '$.nombre'), json_value(jsonData, '$.sueldo') from TMP_JSON_TABLE;

INSERt INTO TMP_JSON_TABLE (IDCLIENTE,JSONDATA) VALUES (1,'{
    "nombre":"Juan Perez",
    "edad": 30,
    "puesto": "Dessarrollador de software",
    "deparamento": "tecnologia de inforacion",
    "salario": 60000.00,
    "fecha_contratacion": "2021-01-15"

}');

select json_value (jsonData, '$.nombre') nombre, json_value(jsonData,'$.puesto') puesto, json_value(jsonData, '$.salario') salario from TMP_JSON_TABLE;

drop table TMP_JSON_TABLE;

DELETE FROM TMP_JSON_TABLE;


INSERT INTO  TMP_JSON_TABLE(IDCLIENTE, JSONDATA) VALUES (1, '{
  "nombre": "Juan Pérez",
  "edad": 30,
  "puesto": "Desarrollador de Software",
  "departamento": "Tecnología de la Información",
  "salario": 60000.00,
  "fecha_contratacion": "2021-01-15"
}');

INSERT INTO TMP_JSON_TABLE (IDCLIENTE, JSONDATA) VALUES (
    2,
    '{
            "ability": {
                "name": "limber",
                "url": "https://pokeapi.co/api/v2/ability/7/"
            },
            "is_hidden": false,
            "slot": 1
        }'
);


select 
json_value(jsonData, '$.nombre') nombre,
json_value(jsonData, '$.puesto') puesto,
json_value(jsonData, '$.salario') salario
from TMP_JSON_TABLE where idcliente = 1;

SELECT 
json_value(jsondata, '$.ability.name') name
, json_value(jsondata, '$.ability.url') url
from TMP_JSON_TABLE where idcliente = 2;

INSERT INTO TMP_JSON_TABLE (IDCLIENTE, JSONDATA) VALUES (
    3,
    '{
  "nombre": "Juan Pérez",
  "edad": 30,
  "puesto": "Desarrollador de Software",
  "departamento": "Tecnología de la Información",
  "salario": 60000.00,
  "fecha_contratacion": "2021-01-15",
  "direccion": {
    "calle": "Calle Principal 123",
    "ciudad": "Ciudad de Ejemplo",
    "codigo_postal": "12345",
    "pais": "EjemploLand"
  },
  "contacto": {
    "telefono": "123-456-7890",
    "email": "juan.perez@example.com"
    }
}'
);

Escriba las consultas, para obtener el nombre, edad y puesto dentro dle json.
Escriba las consultas, para obtener la calle, ciudad y pais, de la direccion
3. escriba las consultas para obtener el telefono, email del contacto.
Enviar a jperezr50@miumg.edu.gt

--investigar como funciona json table
--Escriba las consultas, para obtener el nombre, edad y puesto dentro dle json.
select 
json_value(jsonData, '$.nombre') nombre,
json_value(jsonData, '$.edad') edad,
json_value(jsonData, '$.puesto') puesto
from TMP_JSON_TABLE where idcliente = 3;


--Escriba las consultas, para obtener la calle, ciudad y pais, de la direccion
select 
json_value(jsonData, '$.direccion.calle') calle,
json_value(jsonData, '$.direccion.ciudad') cuidad,
json_value(jsonData, '$.direccion.pais') pais
from TMP_JSON_TABLE where idcliente = 3;

--3. escriba las consultas para obtener el telefono, email del contacto.
select 
json_value(jsonData, '$.contacto.telefono') telefono,
json_value(jsonData, '$.contacto.email') email
from TMP_JSON_TABLE where idcliente = 3;

