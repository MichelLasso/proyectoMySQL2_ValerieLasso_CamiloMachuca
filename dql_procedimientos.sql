use fincaCacao


-- procedimiento / procedures
-- 1.	Procedimiento para obtener los productos vendidos por cliente y el total de compra y el empleado que realizo la venta.
delimiter //
create procedure productos_Vendidos_empleado()
begin
	select e.nombre1 as nombre_empleado,c.nombre1, c.apellido1, p.nombre, sum(precio_a_pagar) from ventas v
    inner join clientes c on v.id_cliente=c.id_cliente
    inner join productos p on v.id_producto=p.id_producto
    inner join empleados e on e.id_empleado=v.id_empleado
    group by 1,2,3,4;
end;
// delimiter ;

call productos_Vendidos_empleado();


-- 2. Procedimiento para calcular el total de la deuda de las compras
delimiter //
create procedure calcular_deuda_compras()
begin 
declare total_deuda decimal(10,2);
select sum(deuda) into total_deuda from compras;

select concat('el total es:', total_deuda) as total_deuda;
end //
delimiter ;
call calcular_deuda_compras();

-- 3.Procedimiento para cambiar el estado de compra cuando el producto 
-- sea pagado y registrarlo en la tabla correspondiente.
delimiter //
create procedure cambiar_estado_compra(in id int)
begin
if (select deuda from compras where id_compra=id)= 0 then

update compras set estado = 'Pagado' where id_compra=id;
end if;
end //
delimiter ;
call cambiar_estado_compra(1);

-- 4.	Procedimiento para calcular el tiempo que duró en producción cada producto.
delimiter // 
create procedure tiempo_produccion()
begin
declare tiempo_produccion int;

select p.id_producto, p.nombre as nombre_producto, datediff(pr.fecha_fin, pr.fecha_inicio)as dias_produccion
from productos p inner join procesos pr on p.id_proceso=pr.id_proceso;
end //
delimiter ;
call tiempo_produccion();

-- 5. Procedimiento para cambiar el estado de la maquinaria cuando sea reparada 
-- y registrarlo en la tabla correspondiente.
delimiter //
create procedure cambiar_estado_maquinaria(in id int)
begin
if exists( select * from daños where id_maquina= id and fecha_reparacion_terminada is not null) then
update maquinaria set estado='Reparada' where id_maquinaria=id;
end if;
end //
delimiter ;
call cambiar_estado_maquinaria(1);


-- 6.	Procedimiento para generar reportes de empleados con salarios y cargos
delimiter //
create procedure reporte_empleados()
begin
select e.id_empleado,e.nombre1,e.apellido1, c.nombre as cargo, c.salario, a.nombre as area 
from empleados e inner join cargos c on e.id_cargo=c.id_cargo 
inner join areas_finca a on c.id_area_finca=a.id_area_finca order by c.salario desc;
end //
delimiter ;

call reporte_empleados();

-- 7.Procedimiento para asignar herramientas a un área.
delimiter //
create procedure añadir_herramienta_area(in id_herramienta int, in id_area int)
begin
update herramientas set id_area_finca= id_area where id_herramienta= id_herramienta;
end //
delimiter ;

call añadir_herramienta_area(1,2);

-- 8. procedimiento para sacar el informe de la cosecha realizada por un empleado
delimiter //
create procedure informe_cosecha_empleado(in id int)
begin 
select c.id_cosecha, c.fecha_cosecha, c.cantidad, c.unidad_de_medida, c.descripcion_problema as problema_cosecha,
h.tipo as herramienta_utilizada from cosecha c inner join herramientas h 
on c.id_herramienta=h.id_herramienta
where c.id_empleado= id order by c.fecha_cosecha desc;
end // 
delimiter ;
call informe_cosecha_empleado(4);

-- 9 procedimiento para cambiar el stock de una herramienta segun la cantidad que tenga dañadas
delimiter // 
create procedure actualizar_stock_herramienta(in id int, in cantidad_dañada int)
begin
update herramientas set stock= stock-cantidad_dañada where id_herramienta=id;
end //
delimiter ;
call actualizar_stock_herramienta(2,2);

-- 
-- 10.	Procedimientos para obtener los empleados con los cargos que más pagos han recibido y si se encuntra activo.
delimiter //
create procedure cargos_Empleados_activos()
begin
	select nombre1, apellido1, nombre, estado, count(total_pagado) from empleados
    inner join cargos on empleados.id_cargo=cargos.id_cargo
    inner join pagos_empleados on empleados.id_empleado= pagos_empleados.id_empleado
    group by 1,2,3,4 order by 5 desc;
end;
// delimiter ;

call cargos_Empleados_activos();


-- 11.	Procedimiento para obtener el total de compras realizadas en la finca con detalles del producto comprado.
delimiter //
create procedure registroCompras()
begin 
	select nombre_producto, sum(costo) from compras
    group by 1;
end;
// delimiter ;

call registroCompras();
-- 12.	Procedimiento para obtener un reporte de cosechas con empleado, por cultivo y total de cosechas.
delimiter //
create procedure reporteCosechas()
begin
	select nombre as nombreCultivo, cantidad_de_plantas, nombre1,
    apellido1, count(cantidad) from cosecha
    inner join empleados on cosecha.id_empleado= empleados.id_empleado
    inner join cultivo on cosecha.id_cultivo=cultivo.id_cultivo
    group by 1,2,3,4;
end;
// delimiter ;

call reporteCosechas();
-- 13.	Procedimientos para obtener los empleados con los cargos que más pagos han recibido.
delimiter //
create procedure cargosEmpleados()
begin
	select nombre1, apellido1, nombre, count(total_pagado) from empleados
    inner join cargos on empleados.id_cargo=cargos.id_cargo
    inner join pagos_empleados on empleados.id_empleado= pagos_empleados.id_empleado
    group by 1,2,3 order by 4 desc;
end;
// delimiter ;

call cargosEmpleados();

-- 14.	Procedimiento para obtener los productos vendidos por cliente y el total de compra.
delimiter //
create procedure productosVendidos()
begin
	select nombre1, apellido1, nombre, sum(precio_a_pagar) from ventas
    inner join clientes on ventas.id_cliente=clientes.id_cliente
    inner join productos on ventas.id_producto=productos.id_producto
    group by 1,2,3;
end;
// delimiter ;

call productosVendidos();

-- 15.	Procedimiento para obtener la ubicación de las herramientas y el proceso que realiza.
delimiter //
create procedure ubicacionHerramientas()
begin 
	select tipo, nombre as ubicacion, descripcion from herramientas
    inner join areas_finca on herramientas.id_area_finca= areas_finca.id_area_finca;
end;
// delimiter ;

call ubicacionHerramientas();

-- 16.	Procedimiento para obtener los empleados que no han tenido vacaciones en este año.
delimiter //
create procedure vacacionesEmpleados()
begin
	select nombre1, apellido1,vacaciones.fecha_salida ,fecha_llegada from empleados
    inner join vacaciones on empleados.id_empleado=vacaciones.id_empleado
    where not fecha_llegada >= '2024-01-01' and fecha_llegada <= now();
end;
// delimiter ;

call vacacionesEmpleados();

-- 17.	Procedimiento para calcular el total de pedidos vendidos por cada cliente.
delimiter //
create procedure totalClientes()
begin
	select nombre1, apellido1, count(ventas.id_cliente) from ventas 
    inner join clientes on ventas.id_cliente= clientes.id_cliente
    group by 1,2;
end;
// delimiter ;

call totalClientes();
-- 18.	Procedimiento para obtener las herramientas que no han sido utilizadas.
delimiter //
create procedure herramientas_sin_usao()
begin
	select tipo from herramientas 
    left join areas_finca on herramientas.id_area_finca=areas_finca.id_area_finca where herramientas.id_area_finca is null;
end;
// delimiter ;

call herramientas_sin_usao();

-- 19.	Procedimiento para obtener un informe de las plantas enfermas y los problemas detectados.
delimiter //
create procedure cosechasProblemas()
begin
	select id_planta_enferma, nombre_enfermedad, tipo_enfermedad, plantas_enfermas.fecha_entrada as fecha_enfermedad,
    plantas_enfermas.fecha_salida as fecha_enfermedad_salida, numero_surco_ubicacion,numero_planta_ubicacion, plantas_enfermas.descripcion,
    monitoreos.descripcion_resultado as monitoreoResultado, monitoreos.observaciones as observacionesMonitoreo,
    fecha_cuidado,tipo_cuidado,
    herramientas.tipo as tipoHerramientas,
	agroquimicos.categoria as categoriaAgroquimico,
    agroquimicos.tipo as tipoAgroquimico, cuidado_cultivo.medida_dosis,cuidado_cultivo.unidad_de_medida,
    agroquimicos.metodo_aplicacion from plantas_enfermas 
    inner join monitoreos on plantas_enfermas.id_monitoreo= monitoreos.id_monitoreo
    inner join cuidado_cultivo on monitoreos.id_cuidado_cultivo= cuidado_cultivo.id_cuidado_cultivo
    inner join herramientas on cuidado_cultivo.id_herramienta=herramientas.id_herramienta
    inner join agroquimicos on cuidado_cultivo.id_agroquimico= agroquimicos.id_agroquimico;
end;
// delimiter ;
-- drop procedure cosechasProblemas;
call cosechasProblemas();

-- 20.	Procedimiento para mostrar el horario de los empleados, con la hora de llegada, hora de salida 
-- y organizarlos de manera asendente 
delimiter //
create procedure horarioEmpleados()
begin
	select nombre1, apellido1, time(hora_entrada), time(hora_salida) from empleados
    inner join horarios_empleados on empleados.id_empleado= horarios_empleados.id_empleado
    order by 3 asc;
end;
// delimiter ;

call horarioEmpleados();
