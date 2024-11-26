create database fincaCacao;
use fincaCacao;

-- drop database fincaCacao;
create table proveedores(
id_proveedor int auto_increment primary key,
nombre1 varchar(50),
nombre2 varchar(50),
apellido1 varchar(50),
apellido2 varchar(50),
cedula varchar(50),
direccion varchar(50),
telefono varchar(50),
correo_electronico varchar(50),
fecha_de_registro date,
pais varchar(50),
ciudad varchar(50),
pueblo varchar(50)

);

create table finca(
id_finca int auto_increment primary key,
nombre varchar(50),
ancho decimal(10,2),
largo decimal(10,2),
unidad_de_medida varchar(50),
pais varchar(50),
ciudad varchar(50),
pueblo varchar(50),
telefono varchar(50),
correo_electronico varchar(50),
direccion varchar(50),
tipo_propiedad varchar(50),
descripcion varchar(200)
);

create table compras(
id_compra int auto_increment primary key,
nombre_producto varchar(50),
cantidad int,
costo int,
fecha_compra date,
estado varchar(50),
deuda int,
id_finca int,
foreign key(id_finca)references finca(id_finca)
);

create table cultivo(
id_cultivo int auto_increment primary key,
id_finca int,
foreign key(id_finca)references finca(id_finca),
nombre varchar(50),
ancho decimal(10,2),
largo decimal(10,2),
unidad_de_medida varchar(50),
cantidad_de_plantas decimal(10,2),
fecha_siembra date,
produccion_anual decimal(10,2),
edad_del_cultivo int,
nombre_cientifico varchar(50)
);

create table areas_finca(
id_area_finca int auto_increment primary key,
nombre varchar(50),
descripcion varchar(200),
id_finca int,
foreign key(id_finca) references finca(id_finca)

);

create table agroquimicos(
id_agroquimico int auto_increment primary key,
nombre_marca varchar(50),
tipo varchar(50),
categoria varchar(50),
stock int,
descripcion varchar(200),
empaque varchar(50),
peso decimal(10,2),
unidad_de_medida varchar(50),
costo decimal(10,2),
fecha_verncimiento date,
metodo_aplicacion varchar(50),
id_compra int,
foreign key(id_compra) references compras(id_compra)
);

create table herramientas(
id_herramienta int auto_increment primary key,
categoria varchar(50),
tipo varchar(50),
stock int,
estado varchar(50),
tipo_combustible varchar(50),
id_compra int,
foreign key (id_compra) references compras(id_compra),
id_area_finca int,
foreign key(id_area_finca)references areas_finca(id_area_finca)
);



create table lotes(
id_lote int auto_increment primary key,
ancho decimal(10,2),
largo decimal(10,2),
unidad_de_medida varchar(50),
cantidad_de_plantas int,
id_cultivo int,
foreign key(id_cultivo) references cultivo(id_cultivo)
);

create table cuidado_cultivo(
id_cuidado_cultivo int auto_increment primary key,
descripcion_aplicacion varchar(150),
fecha_cuidado date,
unidad_de_medida varchar(50),
medida_dosis decimal(10,2),
tipo_cuidado varchar(50),
id_lote int,
foreign key(id_lote)references lotes(id_lote),
id_agroquimico int,
foreign key(id_agroquimico)references agroquimicos(id_agroquimico),
id_herramienta int,
foreign key(id_herramienta) references herramientas(id_herramienta) 
);

create table cargos(
id_cargo int auto_increment primary key,
nombre varchar(50),
categoria varchar(50),
frecuencia_pago varchar(50),
fecha_pago date,
salario decimal(10,2),
id_area_finca int,
foreign key(id_area_finca) references areas_finca(id_area_finca)
);

create table empleados(
id_empleado int auto_increment primary key,
nombre1 varchar(50),
nombre2 varchar(50),
apellido1 varchar(50),
apellido2 varchar(50),
cedula varchar(50),
telefono varchar(50),
correo_electronico varchar(50),
fecha_ingreso date,
fecha_salida date,
estado varchar(50),
fecha_nacimiento date,
id_finca int,
foreign key(id_finca) references finca(id_finca),
id_cargo int,
foreign key(id_cargo) references cargos(id_cargo)
);

create table pagos_finca(
id_pago_finca int auto_increment primary key,
pago_servicios decimal(10,2),
pagos_extras decimal(10,2),
fecha_pago_servicios date,
fecha_pago_extras date,
descripcion_pago_servicios varchar(50),
descripcion_pago_extra varchar(50),
id_finca int,
foreign key(id_finca)references finca(id_finca)
);

create table Horarios_empleados(
id_horario_empleado int auto_increment primary key,
hora_entrada datetime,
hora_salida datetime,
horas_almuerzo datetime,
id_empleado int,
foreign key(id_empleado) references empleados(id_empleado)
);

create table vacaciones(
id_vacaciones int auto_increment primary key,
fecha_salida date,
fecha_llegada date,
motivo varchar(50),
id_empleado int,
foreign key(id_empleado)references empleados(id_empleado)
);

create table bonificacion_descuento(
id_bonificacion_descuento int auto_increment primary key,
porcentaje decimal(10,2),
descripcion varchar(150),
estado varchar(50),
tipo varchar(50)

);

create table pagos_empleados(
id_pago_empleado int auto_increment primary key,
fecha_pago date,
total_pagado decimal(10,2),
id_empleado int,
foreign key(id_empleado) references empleados(id_empleado),
id_bonificacion_descuento int,
foreign key(id_bonificacion_descuento)references bonificacion_descuento(id_bonificacion_descuento)
);

create table clientes(
id_cliente int auto_increment primary key,
nombre1 varchar(50),
nombre2 varchar(50),
apellido1 varchar(50),
apellido2 varchar(50),
cedula varchar(50),
direccion varchar(50),
telefono varchar(50),
pais varchar(50),
ciudad varchar(50),
pueblo varchar(50),
fecha_registro date
);

create table maquinaria(
id_maquinaria int auto_increment primary key,
tipo varchar(50),
descripcion varchar(50),
tipo_combustible varchar(50),
categoria varchar(50),
estado varchar(50)
);

create table metodo_pago(
id_metodo_pago int auto_increment primary key,
tipo varchar(50),
fecha_pago date
);

create table registro_envio(
id_registro_envio int auto_increment primary key,
id_transporte int,
foreign key(id_transporte)references maquinaria(id_maquinaria),
id_empleado int,
foreign key(id_empleado) references empleados(id_empleado),
pais varchar(50),
ciudad varchar(50),
pueblo varchar(50),
fecha_salida date,
fecha_llegada date,
problema_envio tinyint,
descripcion_problema varchar(50),
precio_total_envio decimal(10,2),
porcentaje_envio decimal(10,2),
id_metodo_pago int,
foreign key(id_metodo_pago)references metodo_pago(id_metodo_pago)

);


create table procesos(
id_proceso int auto_increment primary key,
fecha_inicio date,
fecha_fin date,
caracteristicas varchar(200),
producto_esperado varchar(150),
problema_proceso tinyint,
descripcion_problema varchar(200),
id_maquinaria int,
foreign key(id_maquinaria)references maquinaria(id_maquinaria),
id_area_finca int,
foreign key(id_area_finca)references areas_finca(id_area_finca),
id_empleado int,
foreign key(id_empleado)references empleados(id_empleado)

);

create table productos(
id_producto int auto_increment primary key,
nombre varchar(50),
empaque varchar(50),
stock int,
precio decimal(10,2),
peso decimal(10,2),
unidad_de_medida varchar(50),
fecha_vencimiento date,
fecha_produccion date,
id_proceso int,
foreign key(id_proceso)references procesos(id_proceso)
);
create table ventas(
id_venta int auto_increment primary key,
cantidad_producto int,
total decimal(10,2),
precio_a_pagar decimal(10,2),
id_empleado int,
foreign key(id_empleado)references empleados(id_empleado),
id_cliente int,
foreign key(id_cliente)references clientes(id_cliente),
id_producto int,
foreign key(id_producto)references productos(id_producto),
id_descuento int,
foreign key(id_descuento)references bonificacion_descuento(id_bonificacion_descuento),
id_envio int,
foreign key(id_envio)references registro_envio(id_registro_envio)
);

create table monitoreos(
id_monitoreo int auto_increment primary key,
fecha_monitoreo date,
descripcion_resultado varchar(50),
observaciones varchar(150),
frecuencia varchar(50),
id_cuidado_cultivo int,
foreign key(id_cuidado_cultivo) references cuidado_cultivo(id_cuidado_cultivo),
id_empleado int,
foreign key(id_empleado) references empleados(id_empleado)
);

create table plantas_enfermas(
id_planta_enferma int auto_increment primary key,
estado varchar(50),
tipo_enfermedad varchar(50),
nombre_enfermedad varchar(90),
descripcion varchar(150),
fecha_entrada varchar(50),
fecha_salida varchar(50),
numero_surco_ubicacion int,
numero_planta_ubicacion int,
id_monitoreo int,
foreign key(id_monitoreo)references monitoreos(id_monitoreo)
);

create table cosecha(
id_cosecha int auto_increment primary key,
cantidad int,
unidad_de_medida varchar(50),
fecha_cosecha date,
problema_cosecha tinyint,
descripcion_problema varchar(150),
id_empleado int,
foreign key(id_empleado)references empleados(id_empleado),
id_herramienta int,
foreign key(id_herramienta)references herramientas(id_herramienta),
id_cultivo int,
foreign key(id_cultivo)references cultivo(id_cultivo)
);

create table daños(
id_daño int auto_increment primary key,
tipo varchar(50),
descripcion varchar(150),
costo_reparacion decimal(10,2),
fecha_daño date,
fecha_reparacion date,
fecha_reparacion_terminada date,
id_herramienta int,
foreign key(id_herramienta) references herramientas(id_herramienta),
id_maquina int,
foreign key(id_maquina) references maquinaria(id_maquinaria)
);

