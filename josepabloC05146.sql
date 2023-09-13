-- Código de creación de datos con especificaciones
CREATE DATABASE [PP1]  
ON   
(NAME = N'PP1',  -- Logical name of the Data file 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\PP1.mdf',  -- The operating system file name 
    SIZE = 10,  -- The size of the file 
    MAXSIZE = 20,  -- The maximum size to which the file can grow, the default is MB 
    FILEGROWTH = 2)  -- The automatic growth increment of the file, the default is MB 
LOG ON  
(NAME = N'PP1_log',  -- Logical name of the Log file 
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\PP1_Log.ldf', -- The operating system file name 
    SIZE = 5,  -- The size of the file 
    MAXSIZE = 20,  -- The maximum size to which the file can grow, the default is MB 
    FILEGROWTH = 2);  -- The automatic growth increment of the file, the default is MB 
GO

--Usar PP1 para realizar los respectivos procesos de bases de datos
USE PP1;
GO

-- Creación de tabla proveedor
CREATE TABLE proveedor(  --crea tabla proveedor para base de datos PP1 con sus respectivos atributos
cedula BIGINT NOT NULL CONSTRAINT PK_proveedor_cedula PRIMARY KEY, --no se pone identity porque se ocupa poner vario valores numericos necesarios para una cedula
tipo_cedula CHAR(38) NOT NULL,
nombre CHAR(38) NOT NULL,
correo CHAR(38) NOT NULL,
telefono INTEGER NOT NULL CHECK (telefono >= 0)
);

-- Creación de tabla territorio
CREATE TABLE territorio(  --crea tabla territorio para base de datos PP1 con sus respectivos atributos
ID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_territorio_id PRIMARY KEY, --poner identity es necesario para que la tabla vaya aumentando 1 a 1 en filas
provincia CHAR(38) NOT NULL,
canton CHAR(38) NOT NULL,
distrito CHAR(38) NOT NULL
);

-- Creación de tabla producto
CREATE TABLE producto(  --crea tabla producto para base de datos PP1 con sus respectivos atributos
ID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_producto_id PRIMARY KEY, --poner identity es necesario para que la tabla vaya aumentando 1 a 1 en filas 
ID_universal INT NOT NULL,
nombre CHAR(38) NOT NULL,
precio INTEGER NOT NULL CHECK (precio > 0),
tamannio DECIMAL(38,2) NOT NULL CHECK (tamannio > 0),
color CHAR(38) NOT NULL
);

-- Creación de tabla subcategoria
CREATE TABLE subcategoria(  --crea tabla subcategoria para base de datos PP1 con sus respectivos atributos
ID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_subcategoria_id PRIMARY KEY, --poner identity es necesario para que la tabla vaya aumentando 1 a 1 en filas 
nombre CHAR(38) NOT NULL
);

-- Creación de tabla categoria
CREATE TABLE categoria(  --crea tabla categoria para base de datos PP1 con sus respectivos atributos
ID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_categoria_id PRIMARY KEY, --poner identity es necesario para que la tabla vaya aumentando 1 a 1 en filas
nombre CHAR(38) NOT NULL
);

-- Creación de tabla factura
CREATE TABLE factura( --crea tabla factura para base de datos PP1 con sus respectivos atributos
numero_factura INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_numero_factura PRIMARY KEY, --poner identity es necesario para que la tabla vaya aumentando 1 a 1 en filas
info_product CHAR(38) NOT NULL,
unidades_compradas INTEGER NOT NULL CHECK (unidades_compradas >=1),
precio_pactado INT NOT NULL CHECK (precio_pactado >= 1),
porcen_impuestos DECIMAL (38,2) NOT NULL,
porcen_descuento DECIMAL (38,2) NOT NULL,
fecha_factura DATE NOT NULL
);

-- Creación de tabla cliente
CREATE TABLE cliente(  --crea tabla cliente para base de datos PP1 con sus respectivos atributos
cedula BIGINT NOT NULL CONSTRAINT PK_cliente_cedula PRIMARY KEY, --no se pone identity porque se ocupa poner vario valores numericos necesarios para una cedula
tipo_cedula CHAR(38) NOT NULL,
nombre CHAR(38) NOT NULL,
direccion CHAR(38) NOT NULL,
correo CHAR(38) NOT NULL
);


-- Agregar relaciones cardinales

-- Proveedor a Territorio (N:1) (muchos a 1)
ALTER TABLE proveedor --permite agregar columnas a la tabla proveedor
ADD territorio_id INT; --agrega variable territorio_id

-- Establecer la clave foránea
ALTER TABLE proveedor  --permite modificar tabla proveedor
ADD CONSTRAINT FK_proveedor_territorio --permite crear una foreign key
FOREIGN KEY (territorio_id) --le indica cual columna es la foreign key de la tabla proveedor
REFERENCES territorio(ID); --le indica cual columna primary key de otra tabla debe usar como foreign key


-- Proveedor a Producto (1:N) (1 a muchos)
ALTER TABLE producto --permite agregar columnas a la tabla proveedor
ADD proveedor_id BIGINT; --agrega variable proveedor_id

-- Establecer la clave foránea
ALTER TABLE producto --permite modificar tabla producto
ADD CONSTRAINT FK_proveedor_producto --permite crear una foreign key
FOREIGN KEY (proveedor_id) --le indica cual columna es la foreign key de la tabla producto
REFERENCES proveedor(cedula);--le indica cual columna primary key de otra tabla debe usar como foreign key

-- Producto a Subcategoría (N:1) (muchos a 1)
ALTER TABLE producto --permite agregar columnas a la tabla producto
ADD subcategoria_id INT; --agrega variable subcategoria_id

-- Establecer la clave foránea
ALTER TABLE producto --permite modificar tabla producto
ADD CONSTRAINT FK_subcategoria_producto  --permite crear una foreign key
FOREIGN KEY (subcategoria_id) --le indica cual columna es la foreign key de la tabla producto
REFERENCES subcategoria(ID); --le indica cual columna primary key de otra tabla debe usar como foreign key

-- Subcategoría a Categoría (N:1) (muchos a 1)
ALTER TABLE subcategoria  --permite agregar columnas a la tabla subcategoria
ADD categoria_id INT; --agrega variable categoria_id

-- Establecer la clave foránea
ALTER TABLE subcategoria --permite modificar tabla subcategoria
ADD CONSTRAINT FK_subcategoria_categoria --permite crear una foreign key
FOREIGN KEY (categoria_id) --le indica cual columna es la foreign key de la tabla subcategoria
REFERENCES categoria(ID); --le indica cual columna primary key de otra tabla debe usar como foreign key

---------------------------------------------------------------------------------------------------------------------------------
-- Producto a Factura (N:M) (muchos a muchos)
--Creación de la tabla de unión Producto
CREATE TABLE compra (
producto_id INT PRIMARY KEY,
factura_numero INT
);

--Establecer la clave foránea entre compra y producto
ALTER TABLE compra
ADD CONSTRAINT FK_compra_producto
FOREIGN KEY (producto_id)
REFERENCES producto(ID)

--Establecer la clave foránea entre compra y factura
AlTER TABLE compra
ADD CONSTRAINT FK_compra_factura
FOREIGN KEY (factura_numero)
REFERENCES factura(numero_factura)
--------------------------------------------------------------------------------------------------------------------------------

-- Factura a cliente (N:1) (muchos a 1)
ALTER TABLE factura --permite agregar columnas a la tabla factura
ADD cliente_cedula BIGINT; --agrega variable cliente_cedula

-- Establecer la clave foránea
AlTER TABLE factura  --permite modificar tabla factura
ADD CONSTRAINT FK_factura_cliente --permite crear una foreign key
FOREIGN KEY (cliente_cedula) --le indica cual columna es la foreign key de la tabla factura
REFERENCES cliente(cedula); --le indica cual columna primary key de otra tabla debe usar como foreign key

--Insercion de datos

--insercion de datos a tabla proveedor con sus respectivos atributos
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (118470015,'fisica','jose pablo', 'josepablomorajimenez@gmail.com', 86514434);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (502580522,'fisica','yisel', 'yiseljimenezulate@gmail.com', 63437461);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (204750615,'fisica','marianela', 'nelacub3ro@gmail.com', 83849176);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (305500547 ,'fisica','carlos', 'charleszamon@gmail.com', 62675092);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (402500424,'fisica','kevin', 'thorken@gmail.com', 71097652);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (603050520,'fisica','Andrea', 'andregu.com', 71653021);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (700570144,'fisica','felipe', 'felixarguello@hotmail.com', 86346701);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (117410289,'fisica','juan pablo', 'juanpablomorabrizuela@gmail.com', 74514309);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (305620210,'fisica','fabian', 'fabiux@yahoo.com', 63645183);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (334812345,'juridica','tazatica', 'tazatica@hotmail.com', 22457103);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (212912957,'juridica','tazoton', 'tazoton@walmart.com', 22850909);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (191256709,'juridica','artesaniasmora', 'artemora@outlook.com', 22458232);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (534901245,'juridica','tazitica', 'tazitica@outlook.com', 22850194);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (704250455 ,'fisica','daniel', 'daniux@xupiv.com', 71097249);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (604470297,'fisica','fernando', 'fernando@cnavaro.com', 62098461);
insert into proveedor (cedula, tipo_cedula, nombre, correo, telefono) values (207440409,'juridica','tazastricolor', 'tazastricolor@ziinx.com.mx', 22190381);

--insercion de datos a tabla territorio con sus respectivos atributos

insert into territorio (provincia,canton,distrito) values ('san jose','aseri','tabarca');
insert into territorio (provincia,canton,distrito) values ('guanacaste','Nicoya','san antonio');
insert into territorio (provincia,canton,distrito) values ('alajuela','orotina','coyolar');
insert into territorio (provincia,canton,distrito) values ('cartago','turrialba','peralta');
insert into territorio (provincia,canton,distrito) values ('heredia','belen','san antonio');
insert into territorio (provincia,canton,distrito) values ('puntarenas','buenos aires','boruca');
insert into territorio (provincia,canton,distrito) values ('limon','matina','matina');
insert into territorio (provincia,canton,distrito) values ('san jose','acosta','cangrejal');
insert into territorio (provincia,canton,distrito) values ('cartago','paraiso','cachi');
insert into territorio (provincia,canton,distrito) values ('cartago','el guarco','el tejar');
insert into territorio (provincia,canton,distrito) values ('alajuela','oreamuno','santa rosa');
insert into territorio (provincia,canton,distrito) values ('san jose','goicochea','mata de platano');
insert into territorio (provincia,canton,distrito) values ('guanacaste','liberia','mayorga');
insert into territorio (provincia,canton,distrito) values ('limon','limon','limon');
insert into territorio (provincia,canton,distrito) values ('puntarenas','parrita','parrita');
insert into territorio (provincia,canton,distrito) values ('alajuela','atenas','mercedes');

--insercion de datos a tabla producto con sus respectivos atributos

insert into producto (ID_universal,nombre,precio,tamannio,color) values (1,'taza cafe',6100,9,'rojo');
insert into producto (ID_universal,nombre,precio,tamannio,color) values (2,'taza desayuno ',4950,7,'amarillo');
insert into producto (ID_universal,nombre,precio,tamannio,color) values (3,'taza termica',5500,8.2,'azul');
insert into producto (ID_universal,nombre,precio,tamannio,color) values (4,'taza ceramica',4500,8.1,'negra');
insert into producto (ID_universal,nombre,precio,tamannio,color) values (5,'taza plastico',4000,8.6,'blanca');
insert into producto (ID_universal,nombre,precio,tamannio,color) values (6,'taza acero inoxidable',3000,7.5,'blanca');

--insercion de datos a tabla subcategoria con sus respectivos atributos

insert into subcategoria(nombre) values ('taza decorativa');
insert into subcategoria(nombre) values ('taza dedicatoria');

--insercion de datos a tabla categoria con sus respectivos atributos

insert into categoria(nombre) values('artesanal');
insert into categoria(nombre) values('industrial');

--insercion de datos a tabla factura con sus respectivos atributos

insert into factura(info_product,unidades_compradas,precio_pactado,porcen_impuestos, porcen_descuento, fecha_factura) values ('taza desayuno decorativa artesanal',4,12000,5.3,15.3,'01/06/2023');
insert into factura(info_product,unidades_compradas,precio_pactado,porcen_impuestos, porcen_descuento, fecha_factura) values ('taza plastico dedicatoria industrial',6,33000,7.2,20,'01/13/2023');
insert into factura(info_product,unidades_compradas,precio_pactado,porcen_impuestos, porcen_descuento, fecha_factura) values ('taza cafe dedicatoria industrial',1,3900,10.5,15,'01/17/2023');
insert into factura(info_product,unidades_compradas,precio_pactado,porcen_impuestos, porcen_descuento, fecha_factura) values ('taza inoxidable dedicatoria artesanal',3,10200,7,5,'01/25/2023');
insert into factura(info_product,unidades_compradas,precio_pactado,porcen_impuestos, porcen_descuento, fecha_factura) values ('taza ceramica dedicatoria artesanal',2,9000,9,12,'01/30/2023');
insert into factura(info_product,unidades_compradas,precio_pactado,porcen_impuestos, porcen_descuento, fecha_factura) values ('taza ceramica decorativa artesanal',6,28200,11,9,'01/04/2023');
insert into factura(info_product,unidades_compradas,precio_pactado,porcen_impuestos, porcen_descuento, fecha_factura) values ('taza termica decorativa artesanl',4,14400,9,14,'01/15/2023');
insert into factura(info_product,unidades_compradas,precio_pactado,porcen_impuestos, porcen_descuento, fecha_factura) values ('taza cafe dedicatoria artesanal',4,20600,9,5,'01/20/2023');
insert into factura(info_product,unidades_compradas,precio_pactado,porcen_impuestos, porcen_descuento, fecha_factura) values ('taza ceramic dedicatoria industrial',1,4600,8,20,'01/23/2023');
insert into factura(info_product,unidades_compradas,precio_pactado,porcen_impuestos, porcen_descuento, fecha_factura) values ('taza ceramica decatoria artesanl',4,16200,5,19,'01/29/2023');

--insercion de datos a tabla cliente con sus respectivos atributos

insert into cliente(cedula,tipo_cedula,nombre,direccion,correo) values (703830138 ,'fisico','daniel','frente al pali','ceim.iokga80@xupiv.com');
insert into cliente(cedula,tipo_cedula,nombre,direccion,correo) values (305840094,'juridico','partytime','pulperia alos 100m','partytime@outlook.com');
insert into cliente(cedula,tipo_cedula,nombre,direccion,correo) values (605920149,'fisico','arianna','atras iglesia 200m','vanepov235@sesxe.com');
insert into cliente(cedula,tipo_cedula,nombre,direccion,correo) values (119310917,'fisico','jimena','a la par ebais','treddekozomu-9389@yopmail.com');
insert into cliente(cedula,tipo_cedula,nombre,direccion,correo) values (210780152,'fisco','valentina','detras porton amarillo','valentina@ma.zyns.com');
insert into cliente(cedula,tipo_cedula,nombre,direccion,correo) values (402850193,'juridica','fiestas felices','subiendo la cuesta','fiestasfelices@dripzgaming.com');
