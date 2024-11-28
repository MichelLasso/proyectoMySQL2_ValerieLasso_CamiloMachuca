use fincaCacao  
-- 1.Triguer para cambiar el estado en una maquinaria
delimiter // 
create trigger cambio_estado_maquinaria
after update on maquinaria
for each row
begin 
	insert into daños (tipo, descripcion, fecha_daño, id_maquina)
    values ('maquinaria', concat('se cambio a:', new.estado), now(), new.id_maquinaria);
end //
delimiter ;
-- select * from daños;

-- 2.Trigger para cambiar el stock de productos despues de una venta
delimiter //
create trigger cambiar_stock_producto
after insert on ventas
for each row
begin
update productos
set stock= stock - new.cantidad_producto
where id_producto= new.id_producto;
end //
delimiter ;
select * from ventas;

-- 3.trigger para actualizar el salario de los empleados una vez otorgado el bono

delimiter //
create trigger cambiar_salario_bono
after insert on pagos_empleados
for each row
begin
	if new.id_bonificacion_descuento is not null then
    update empleados
    set estado = 'Bono realizado'
    where id_empleado = new.id_empleado;
    end if;
    end //
    delimiter ;
    
    
-- 4.trigger para registrar el problema de un envio.

delimiter //
create trigger registrar_problema_envio
before update on registro_envio
for each row
begin
	if new.problema_envio= 1 then
    set new.descripcion_problema= concat('Problema en el envio: ', now());
    end if;
end //
delimiter ;

-- 5.trigger para actualizar el stock de un agroquimico despues de una compra.
-- select nombre_marca from agroquimicos;
-- select * from compras;
delimiter //
create trigger actualizar_stock_agroquimico
after insert on compras
for each row
begin 
	if exists (select * from agroquimicos where nombre_marca= new.nombre_producto) then
    update agroquimicos
    set stock = stock - new.cantidad
    where nombre_marca = new.nombre_producto;
    end if;
end // 
delimiter ;

-- drop trigger actualizar_stock_agroquimico;

-- 6.trigger que impide que el precio de un producto se actualice a un valor negativo
delimiter // 
create trigger validacion_precio_producto
before update on productos
for each row
begin
	if new.precio < 0 then
    signal sqlstate '45000' set message_text = 'El precio no puede ser negativo';
    end if;
end //
delimiter ;


-- 7.trigger para actualizar el stock de un producto si se llega a eliminar una venta entonces se recupera la cantidad inicial que tenia el producto
delimiter //
create trigger recuperar_stock_producto
after delete on ventas
for each row
begin 
	update productos
    set stock = stock + OLD.cantidad_producto
    where id_producto= OLD.id_producto;
    
end //
delimiter ;

-- 8.triguer para actualizar el estado de una herramienta si ya fue reparada

delimiter //
create trigger actualizar_estado_herramienta
after update on daños
for each row
begin 
if new.fecha_reparacion_terminada is not null then
	update herramientas
	set estado= 'Bien'
	where id_herramienta= new.id_herramienta;
end if;
end //
delimiter ;
-- drop trigger actualizar_estado_herramienta;

-- 9.triguer para registrar las herramientas que cambien
-- del estado bian a dañado automaticamente se crea el registro en la tabla daños

delimiter //
create trigger registrar_herramienta_dañada
after update on herramientas
for each row
begin 
if new.estado= 'Dañado' then
insert into daños(tipo, descripcion, fecha_daño,id_herramienta)
values('herramienta', 'herramienta dañada', now(), new.id_herramienta);
end if;
end //
delimiter ;
-- select * from ventas;


-- 10. triguer para verificar el limite de stock antes de realizar una compra
delimiter // 
create trigger verificar_cantidad_stock
before insert on ventas
for each row
begin 
if  stock > cantidad_producto then
    signal sqlstate '45100' set message_text = 'la cantidad del producto excede el stock actual disponible del producto';
    end if;
end //
delimiter ;
select * from clientes;

-- 11. Cuando se agregan o restan cantidades de los productos,
-- es importante asegurar que no haya valores negativos que representen un inventario inexistente
delimiter //
create trigger cacao_cantidad_negativa
before update on productos
for each row
begin 
	if new.stock < 0 then
	signal sqlstate '45000' set message_text = 'La cantidad de productos no puede ser negativa';
end if;
end;
// delimiter ;

-- 12 Evitar la duplicación de empleados
delimiter //
create trigger no_duplicar_empleados
before insert on empleados
for each row
begin
if exists(select * from empleados where cedula= new.cedula) then
signal sqlstate '45000' set message_text = 'la cedula del nuevo empleado ya existe';
end if;
end;
// delimiter ;

-- 13 registrar la cosecha con la fecha actual automaticamente
delimiter //
create trigger fecha_cosecha
before insert on cosecha
for each row
begin
	set new.fecha_cosecha= now();
end;
// delimiter ;
insert into cosecha (cantidad,unidad_de_medida,problema_cosecha,descripcion_problema,id_empleado,id_herramienta,id_cultivo) 
values (100, 'Kilogramos', 0,null,10,32,1);

-- 14. registrar la fecha actual automaticamente en los nuevos registros de compras
delimiter //
create trigger fecha_actual_compras
before insert on compras
for each row
begin
	set new.fecha_compra= now();
end;
// delimiter ;

insert into compras (nombre_producto,cantidad,costo, estado, deuda, id_finca,id_proveedor)
values ('Sistémico',30,30000,'Pagado',0,1,1 );

-- 15. cambiar el estado de la planta cuando la fecha de salida es registrada
delimiter //
create trigger cambiar_estado_planta
after update on plantas_enfermas
for each row
begin
	if new.fecha_salida is not null then
    update plantas_enfermas 
    set estado= 'Sana' where id_plantas_enfermas=new.id_planta_enferma;
    end if;
end;
// delimiter ;

-- 16. registrar automaticamente la fecha del monitoreo
delimiter //
create trigger auto_fecha_monitoreo
before insert on monitoreos
for each row
begin
	set new.fecha_monitoreo= now();
end;
// delimiter ;

INSERT INTO monitoreos (descripcion_resultado, observaciones, frecuencia, id_cuidado_cultivo, id_empleado) 
VALUES ('Observación de Mildiu en algunas plantas', 'Aplicación de fungicida en plantas afectadas', 'Mensual', 1, 1);

-- 17 actualizar stock de productoss
delimiter //
create trigger actu_stock_productos
after insert on compras
for each row
begin
	update productos
    set stock= stock + new.cantidad
    where nombre= new.nombre_producto;
end;
// delimiter ;

-- 18 no se pueden ingresar cantidades negativas en el total de ventas
delimiter //
create trigger total_negativo
before insert on ventas
for each row
begin
	if new.precio_a_pagar < 0 then
	signal sqlstate '45000' set message_text = 'Total de compra es negativo';
    end if;
end;
// delimiter ;

-- 19 Limite para que no se exceda el precio de un producto
delimiter //
create trigger producto_excedido
before insert on productos
for each row
begin
if new.nombre='Granos de cacao'
and new.precio > 50.00 then 
signal sqlstate '45000' set message_text = 'El precio del producto es exagerado';
end if;
end;
// delimiter ;

insert into productos (nombre, empaque, stock, precio, peso, unidad_de_medida, fecha_vencimiento, fecha_produccion, id_proceso) 
values ('Granos de cacao', 'Bolsa de 10kg', 1000, 70.00, 10.00, 'kg', '2025-12-31', '2024-11-05', 1)

-- 20 Pagos que exceden el límite de la tarjeta
delimiter //
create trigger pagos_limite_excedido
before insert on ventas
for each row
begin 
	declare tarjeta decimal(10,2);
    set tarjeta= 10.00;
    if new.precio_a_pagar > tarjeta then
    signal sqlstate '45000' set message_text = 'El pago no puede realizarse. El precio excede el límite de la tarjeta';
	end if;
end;
// delimiter ;
insert into ventas (cantidad_producto, total, precio_a_pagar, id_empleado, id_cliente, id_producto, id_descuento, id_envio) 
values
(5, 125.00, 20.00, 1, 1, 1, 1, 1);