-- events
-- 1. evento que elimina los productos que no sean vendidos durante mas de un año.
delimiter // 
create event eliminar_productoss
on schedule every 1 year
do 
begin
delete from productos where id_producto not in (select id_producto from ventas where fecha_venta>= curdate()- interval 1 year );
end //
delimiter ;


-- 2. evento para cambiar el estado de la maquinaria a en reparacion despues de que se daño
delimiter //
create event cambiar_estado_maquinaria
on schedule every 1 day
do
begin
update maquinaria set estado= 'En reparacion' where id_maquinaria in(select id_maquinaria from daños where fecha_reparacion_terminada is null);
end // 
delimiter ;

-- 3. evento para cambiar el estado de un producto cuando se vence
delimiter //
create event estado_producto_vencido
on  schedule every 1 day
do
 begin
 update productos
 set estado= 'vencido'
 where fecha_vencimiento <= curdate();
 end //
 delimiter ;
 
 -- 4. evento para actualizar el stock automaticamente despues de una venta
 delimiter //
 create event actualizar_stock_ventas
 on schedule every 1 day
 do
 begin
 update productos p
 inner join ventas v on p.id_producto=v.id_producto set p.stock=p.stock - v.cantidad;
 end //
 delimiter ;
 
 
 -- 5. evento para enviar a maquinaria a mantenimiento general
 
 delimiter //
 create event mantenimiento_maquinaria
 on schedule every 3 month
 do
 begin
 update maquinaria set estado='mantenimiento general' where estado='Operativa';
end //
delimiter ;


-- 6. evento para verificar los agroqumicos vencidos

delimiter //
create event verificar_agroquimicos
on schedule every 1 day
do
update agroquimicos set estado= 'Vencido'
where fecha_vencimiento < now();
end //
delimiter ;

-- 7. evento para borrar registros antiguos de envios
delimiter //
create event borrar_registro_envio
on schedule every 1 month
do 
begin
delete from registro_envio where fecha_entrega< date_sub(now(), interval 2 year);
end //
delimiter ;

-- 8.  evento para saber cuando esta bajito el stock de los agroquimicos
delimiter //
create event stock_agroquimicos_bajo
on schedule every 1 day
do 
begin
update agroquimicos set estado='stock bajo'
where stock<10;
end //
delimiter ;


-- 9.  evento para saber cuando esta bajito el stock de las herramientas
delimiter //
create event stock_herramientas_bajo
on schedule every 1 day
do 
begin
update herramientas set estado='stock bajo'
where stock<3;
end //
delimiter ;

-- 10. evento para actualizar el estado de una deuda cada semana mediante se va pagando
delimiter //
create event verificar_estado_deuda
ON schedule every 1 week
do
update compras set estado= case when deuda>0 then 'Pendiente'
else 'pagada'
end //
delimiter 
create table reportes_ventas(
	id int primary key auto_increment,
    total_ventas int,
    producto_mas_vendido int,
    fecha_reporte int
);

-- 11. Se debe generar un reporte semanal de ventas para revisar el rendimiento y los productos más vendidos
create event generarReporteVentas
on schedule every 1 week
starts '2024-10-01 00:00:00'
do
  insert into reportes_ventas(total_ventas, producto_mas_vendido, fecha_reporte)
  select sum(total), 
         (select nombre from ventas 
         inner join productos on ventas.id_producto=productos.id_producto
         group by nombre order by SUM(total) desc limit 1), 
         curdate();

-- 12. mensaje de stock bajo en productos
create table notificaciones (
id int auto_increment primary key,
mensaje varchar(200),
fecha date
);
create event notificacion_stock
on schedule every 1 day
do
insert into notificaciones (mensaje, fecha)
select concat('Stock bajo de productos', nombre, stock)
from productos 
where stock < 20;

-- 13. mensaje de herramientas agotadas
create event herramientas_agotadas
on schedule every 1 day
do 
insert into notificaciones(mensaje, fecha)
select concat('Herramientas agotadas', categoria, tipo)
from herramientas
where stock < 5;

-- 14. Actualizar stock de productos
create event actualizar_productos_stock
on schedule every 1 day
do
update productos 
	inner join ventas on productos.id_producto=ventas.id_producto
	set productos.stock= productos.stock - ventas.cantidad_producto
	where productos.id_producto= ventas.id_producto;

-- 15 actualizar stock de compras
create event stock_compras
on schedule every 1 day
do
update compras
	inner join agroquimicos on compras.id_compra=agroquimicos.id_compra
    set agroquimicos.stock= agroquimicos.stock + compras.cantidad
    where agroquimicos.categoria = compras.nombre_producto;

-- 16 productos caducados
create event productos_vencidos
on schedule every 1 day
do
	select concat('El Productos', nombre, 'esta a punto de caducar')
    from productos
    where fecha_vencimiento<= curdate()+ interval 30 day;

-- 17 eliminar registros antiguos 
create event eliminar_registros_antiguos
on schedule every 1 month
do
delete from compras
where fecha_compra<= curdate()- interval 2 year;

-- 18 evento para actualizar el precio de un producto cada año
create event precio_producto_año
on schedule every 1 year
starts '2023-01-01'
do 
	update productos
	set precio= precio * 1.05
	where nombre='Granos de cacao';


-- 19 Recordatorio del mantenimiento de la maquinaria
delimiter //
create event if not exists
recordatorio_mantenimiento
on schedule every 1 day
starts '2024-01-01 8:00:00'
do
begin 
	declare mensaje varchar(200);
	set mensaje = 'Recordatorio de mantenimiento: Revise el estado de la maquinaria';
	insert into logs(mensaje,fecha)
	values (mensaje,now());
end; 
// delimiter ;

-- 20. mensaje de contratos vencidos
create event contratos_vencidos
on schedule every 1 day
starts '2024-01-01 8:00:00'
do 
	update empleados
    set estado= 'Inactivo'
    where fecha_vencimiento <= now()
