
use fincaCacao

-- ############################################################
-- cracion de funciones

-- 1. obtener el total de compras realizados por un cliente.
delimiter // 
create function total_ventas_productos( id int)
returns int 
deterministic
begin 
declare total int;
select count(v.id_cliente) into total from ventas v inner join clientes c on v.id_cliente=c.id_cliente where v.id_cliente=id;
return total;
end //
delimiter ;

select total_ventas_productos(2);


-- 2. obtener el cliente con mayor total en compras
delimiter // 
create function mayor_pedidoo()
returns varchar(50)
deterministic
begin 
declare nombre_cliente varchar(50);
select c.nombre1 into nombre_cliente from ventas v inner join clientes c on v.id_cliente=C.id_cliente group by 1 order by sum(v.total) desc limit 1 ;
return nombre_cliente;
end //
delimiter ;

select mayor_pedidoo() as clienteConMayorTotal, v.total from ventas v inner join clientes c on v.id_cliente=C.id_cliente order by v.total desc limit 1 ;


-- 3.Esta función le permite al usuario registrar más herramientas.
delimiter // 
create function añadir_herramienta(categoria2 varchar(50), tipo2 varchar(50), stock2 int, estado2 varchar(50), tipo_combustible2 varchar(50), id_compra2 int, id_area_finca2 int)
returns integer deterministic
begin 
insert into herramientas(categoria, tipo, stock, estado, tipo_combustible, id_compra, id_area_finca)
values (categoria2, tipo2, stock2, estado2, tipo_combustible2, id_compra2, id_area_finca2);
return last_insert_id();
end //
delimiter ;

select añadir_herramienta('corte', 'machete', 10, 'Dañado', null, 1,1);

-- 4.	Esta función le permite al usuario eliminar un registro de las herramientas.
delimiter //
create function eliminar_herramienta(id int)
returns int deterministic
begin 
	delete from herramientas 
    where id_herramienta=id;
    return 1;
end;
// delimiter ;
-- drop function eliminar_herramienta;
select eliminar_herramienta(51);

-- 5.Esta función le permite al usuario registrar una compra.
select * from compras;
delimiter //
create function añadir_compra(nombre_producto varchar(50), cantidad int, costo int, fecha_compra date, estado varchar(50), deuda int, id_finca int, id_proveedor int)
returns integer deterministic
begin 
insert into compras(nombre_producto, cantidad, costo, fecha_compra, estado, deuda, id_finca, id_proveedor )
values (nombre_producto, cantidad, costo, fecha_compra, estado, deuda, id_finca, id_proveedor );
return last_insert_id();

end //
delimiter ;
select añadir_compra('Fungicida Organico', 10, 2000, now(), 'pagado', 0, 1,2);

-- 6.	Esta función le permite al usuario registrar una planta enferma.
delimiter // 
create function añadir_planta_enferma(estado varchar(50), tipo_enfermedad varchar(50), nombre_enfermedad varchar(90), descripcion varchar(150), fecha_entrada varchar(50), fecha_salida varchar(50), numero_surco_ubicacion int, numero_planta_ubicacion int, id_monitoreo int ) 
returns integer deterministic 
begin 
insert into plantas_enfermas(estado, tipo_enfermedad, nombre_enfermedad, descripcion, fecha_entrada, fecha_salida, numero_surco_ubicacion, numero_planta_ubicacion, id_monitoreo)
values(estado, tipo_enfermedad, nombre_enfermedad, descripcion, fecha_entrada, fecha_salida, numero_surco_ubicacion, numero_planta_ubicacion, id_monitoreo);
return last_insert_id();
end //
delimiter ;
select añadir_planta_enferma('Enferma', 'virus', 'mildiu', 'Hongo que afecta a las hojas', now(), null,2,8,1);



-- 7. Esta función le permite al usuario registrar un nuevo daño.
delimiter // 
create function cambiar_estado_herramienta(id int, estado2 varchar(50))
returns integer deterministic
begin
update herramientas set estado= estado2 where id_herramienta= id;
return last_insert_id();
end //
delimiter ;
select cambiar_estado_herramienta(2,'Dañado');

-- 8. Esta función le permite al usuario registrar un nuevo monitoreo.

delimiter // 
create function añadir_monitoreo(fecha_monitoreo  date, descripcion_resultado varchar(50), observaciones varchar(150), frecuencia  varchar(50), id_cuidado_cultivo int, id_empleado int)
returns integer deterministic
begin 
insert into monitoreos(fecha_monitoreo, descripcion_resultado , observaciones , frecuencia, id_cuidado_cultivo , id_empleado )
values(fecha_monitoreo, descripcion_resultado, observaciones, frecuencia, id_cuidado_cultivo, id_empleado );
return 1;
end // 
delimiter ;

select añadir_monitoreo(now(), 'Observacion de Mildiu en algunas plantas', 'Aplicacion de fungicida en plantas afectadas', 'Mensual', 1,1);

-- 9.	Esta función le permite al usuario añadir un nuevo empleado.
delimiter // 
create function añadir_empleado(nombre1 varchar(50),nombre2 varchar(50),apellido1 varchar(50),apellido2 varchar(50),cedula varchar(50), telefono varchar(50),correo_electronico varchar(50),fecha_ingreso date,fecha_salida date, estado varchar(50),fecha_nacimiento date,id_finca int,id_cargo int)
returns integer deterministic
begin 
insert into empleados(nombre1,nombre2,apellido1,apellido2,cedula, telefono,correo_electronico,fecha_ingreso,fecha_salida, estado,fecha_nacimiento,id_finca,id_cargo)
values(nombre1,nombre2,apellido1,apellido2,cedula, telefono,correo_electronico,fecha_ingreso,fecha_salida, estado,fecha_nacimiento,id_finca,id_cargo);

return 1;
end //
delimiter ;

select añadir_empleado('Camilo', 'Antonio', 'vega', 'Rodrigues', '109999233', '123454434', 'camilo35@gmail.com',now(), null, 'Activo', '1999-05-12', 1,2);

-- 10.	Esta función le permite al usuario cambiar la frecuencia de pagos en el cargo.
delimiter // 
create function editar_frecuencia_pago(id int, frecuencia_pago2 varchar(50))
returns integer deterministic
begin 
update cargos set frecuencia_pago= frecuencia_pago2 where id_cargo=id;
return last_insert_id();
end //
delimiter ;

select editar_frecuencia_pago(1, 'semanal');

-- 11.	Esta función le permite al usuario añadir una nueva bonificación.

delimiter //
create function crearBonificacion(porcentajeI decimal(10,2), descripcionI varchar (150)
, estadoI varchar(50), tipoI varchar(50))
returns integer deterministic
begin 
	insert into bonificacion_descuento (porcentaje,descripcion,estado,tipo)
    values (porcentajeI,descripcionI,estadoI,tipoI);
    return last_insert_id();
end;
// delimiter ;

select crearBonificacion(12.00,'Bonificación por cumplimiento de metas','Inactiva','Bonificacion');

-- 12.	Esta función le permite al usuario añadir un nuevo descuento.
delimiter //
create function crearDescuento(porcentaje decimal(10,2), descripcion varchar(150),
estado varchar(50), tipo varchar(50))
returns integer deterministic
begin 
	insert into bonificacion_descuento (porcentaje,descripcion,estado,tipo)
	values (porcentaje,descripcion,estado,tipo);
	return last_insert_id();
end;
// delimiter ;

select crearDescuento(15, 'Descuento por mejor comprador', 'Inactiva', 'Descuento');

-- 13.	Esta función le permite al usuario añadir un nuevo registro de pagos.
delimiter //
create function registroPagos(fecha date, total decimal (10,2), id_empleado int,
id_bono_o_descuento int)
returns integer deterministic
begin 
	insert into pagos_empleados(fecha_pago,total_pagado,id_empleado,id_bonificacion_descuento)
    values (fecha, total, id_empleado ,id_bono_o_descuento);
    return last_insert_id();
end;
// delimiter ;

select registroPagos('2024-11-26',840.00,1,11);

-- 14.	Esta función le permite al usuario eliminar un método de pago.
delimiter //
create function eliminar_metodoPago(id int)
returns int deterministic
begin 
	delete from metodo_pago 
    where id_metodo_pago=id;
    return 1;
end;
// delimiter ;

select eliminar_metodoPago(100);

-- 15.	Esta función le permite al usuario añadir un nuevo método de pago.
delimiter //
create function crearMetodoPago(tipo varchar(50), fecha_pago date)
returns int deterministic
begin 
	insert into metodo_pago (tipo, fecha_pago)
    values (tipo, fecha_pago);
    return last_insert_id();
end;
// delimiter ;

select crearMetodoPago('Bancolombia','2024-11-26');

-- 16.	Esta función le permite al usuario cambiar la descripción del problema en la entidad proceso.
delimiter //
create function cambiarDescripcionProceso(id int,descripcion varchar(200))
returns int deterministic
begin
	update procesos
    set descripcion_problema= descripcion where id=id_proceso;
    return last_insert_id();
end;
// delimiter ;

select cambiarDescripcionProceso(17,'Problema con el motor de molienda');

-- 17.	Esta función le permite al usuario cambiar el registro de la fecha de vencimiento del agroquímico. 
delimiter //
create function cambiarFechaVencimientoAgroquimico(id int, fecha date)
returns int deterministic
begin 
	update agroquimicos
    set fecha_verncimiento= fecha where id=id_agroquimico;
    return last_insert_id();
end;
// delimiter ;

select cambiarFechaVencimientoAgroquimico(1,'2024-11-26');

-- 18.	Esta función le permite al usuario cambiar el stock del agroquímico.
delimiter //
create function cambiarStockAgroquimico(id int, stock int)
returns int deterministic
begin 
	update agroquimicos
    set stock= stock where id=id_agroquimico;
    return last_insert_id();
end;
// delimiter ;

select cambiarStockAgroquimico(4,0);

-- 19.	Esta función le permite al usuario cambiar el stock de las herramientas.
delimiter //
create function cambiarStockHerramientas (id int, stock int)
returns int deterministic
begin
	update herramientas
    set stock= stock where id= id_herramienta;
    return last_insert_id();
end;
// delimiter ;

select cambiarStockHerramientas(25,10);

-- 20.	Esta función le permite al usuario cambiar el precio del producto
delimiter //
create function cambiarPrecioProducto(id int, precio decimal(10,2))
returns int deterministic
begin 
	update productos
    set precio= precio where id= id_producto;
    return last_insert_id();
end;
// delimiter ;

select cambiarPrecioProducto(1,'25.00');