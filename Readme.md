# Gestión de una finca de producción de cacao

## Descripción 
El proyecto gestion de una finca de produccion de cacao tiene como finalidad automatizar y gestionar todos los aspectos de una finca agricola que produce cacao y subproductos del mismo, desde el control del cultivo, el monitoreo de plantas y maquinarias, hasta la gestion de compras, ventas y agroquimicos. La base de datos se centra en optimizar la producción y el mantenimiento de la finca, proporcionando un sistema eficiente para la gestion de recursos que se requieren en una finca.

### Funcionalidades Implementadas:
1. **control de cultivos y lotes**: permite el seguimiento y control de los cultivos sembrados, su salud y condiciones de crecimiento.
2. **monitoreo de plagas y enfermedades**: registra el estado de las plantas ypermite tener un control plagas o enfermedades que ataquen el cultivo.

3. **gestión de compras y Agroquimicos**: controla la compra de insumos como agroquimicos y herramientas.

4. **Mantenimiento de maquinaria y herramientas**: Registra los daños, reparaciones y el estado de la maquinaria y las herramientas utilizadas en la finca.

5. **Gestión de empleados**: mantiene un registro detallado de los empleados, sus cargos, salarios y vacaciones.

6. **gestion de ventas y envios**; controla las ventas realizadas de los productos junto con los envios realizados.

## Requisitos del sistema
Para ejecutar este proyecto, se necesita tener el siguiente sofware:

1. **MySQL** versión 8.0.
2. **MySQL Workbench** para ejecutar los scripts sql.

## Instalación y configuración
1. Abre MySQL Worbench 
2. conectate a tu servidor MySQL.
3. Ejecute el archivo ddl.sql para crear la estructura de la base de datos.
4. Ejecute el archivo dml.sql para realizar las inserciones de datos.
5. Ejecute el archivo dql_select.sql para realizar las cunsultas.
6. Ejecute el archivo dql_procedimientos.sql para realizar los procedimientos almacenados.
7. Ejecute el archivo dql_funciones.sql para realizar las funciones.
8. Ejecute el archivo dql_triggers.sql para realizar los triggers.
9. Ejecute el archivo dql_eventos.sql para realizar los eventos.

## Estructura de la base de Datos
La base de datos esta conformada por varias tablas interconcetadas para facilitar el control y la gestión de la finca. A continuacion se muestra un resumen de las tablas o entidades y sus propositos:

* **cultivo**: Almacena información sobre las plantas sembradas en la finca.

* **Lotes**: contiene información de las secciones en las que se divide el cultivo en partes mas pequeñas para un mejor manejo de las labores.

* **empleados**: Registra los empleados, sus cargos y salarios.

* **compras**: Registra las compras de insumos y productos agricolas.

* **agroquimicos**: Contiene información sobre los agroquimicos utilizados en el cuidado del cultivo.

* **maquinaria**: Almacena los detalles sobre la maquinaria utilizada en la finca.

* **herramientas**: Almacena los detalles sobre las herramientas utilizadas en la finca.

* **daños**: Registra las herramientas y maquinaria que se hayan dañado y sus reparaciones.

* **monitoreos**: Realiza un seguimiento del estado de las plantas, detectando plagas o enfermedades.

* **plantas_enfermas**: Registra los detalles de las plantas que se encuentran enfermas junto son su ubicacion.

## Relaciones entre tablas:

- Las tablas **empleados** y **monitoreos** están relacionadas a traves del identificador del empleado que realiza el monitoreo.

- **agroquimicos** y **compras** están conectadas por la relación de compra de agroquimicos

- **maquinaria** y **daños** estan vinculadas por la maquinaria que sufre daños.

- **proveedores** y **compras** estan conectadas por la relacion del proveedor al cual se le realiza la compra.
- herramientas y daños estan vinculadas por las herramientas que sufren daños.

- **cargos** y **empleados** estan relacionadas por la relacion del cargo que tiene cada empelado.

- **empleados** y **vacaciones** estan relacionadas por las vacaiones que tienen cada empleado.

## Ejemplos de consultas

* **consulta 1** : Obtener el promedio de producción de cacao del cultivo.

```sql

select avg(cantidad) from cosecha 
inner join cultivo on cosecha.id_cultivo=cultivo.id_cultivo;

```

* **consulta 2**: Obtener el total de horas trabajadas de los empleados sin contar las horas de almuerzo.
```sql

select nombre1,apellido1, sum(timestampdiff(hour,hora_entrada,hora_salida)) from horarios_empleados
inner join empleados on horarios_empleados.id_empleado=empleados.id_empleado
group by 1,2;

```

* **consulta 3**: Listar todas las herramientas utilizadas en la cosecha.
```sql

select distinct tipo from cosecha
inner join herramientas on cosecha.id_herramienta= herramientas.id_herramienta;
```

## Procedimientos, Funciones, Triggers y Eventos

### Procedimientos:
* **productosVendidos:** obtiene los productos vendidos por cliente y el total de la compra

```sql

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
```

* **registroCompras:** obtiene el total de las compras realizadas en la finca con detalles del producto comprado.
```sql

delimiter //
create procedure registroCompras()
begin 
	select nombre_producto, sum(costo) from compras
    group by 1;
end;
// delimiter ;

call registroCompras();
```

* **actualizar_stock_herramienta:** procedimiento para cambiar el stock de una herramienta segun la cantidad que tenga dañadas
```sql

delimiter // 
create procedure actualizar_stock_herramienta(in id int, in cantidad_dañada int)
begin
update herramientas set stock= stock-cantidad_dañada where id_herramienta=id;
end //
delimiter ;
call actualizar_stock_herramienta(2,2);
```
## Funciones:

* **añadir_compra:** Esta función le permite al usuario registrar una compra.

```sql

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

```
* **añadir_planta_enferma:** Esta función le permite al usuario registrar una planta enferma.
```sql

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
```

* **cambiar_estado_herramienta:** Esta función le permite al usuario registrar un nuevo daño.
```sql

delimiter // 
create function cambiar_estado_herramienta(id int, estado2 varchar(50))
returns integer deterministic
begin
update herramientas set estado= estado2 where id_herramienta= id;
return last_insert_id();
end //
delimiter ;
select cambiar_estado_herramienta(2,'Dañado');
```

## Triggers:
* **registrar_herramienta_dañada:** triguer para registrar las herramientas que cambien del estado bian a dañado automaticamente se crea el registro en la tabla daños

```sql

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
```

* **verificar_cantidad_stock:** triguer para verificar el limite de stock antes de realizar una compra

```sql

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
```

* **actualizar_estado_herramienta:** triguer para actualizar el estado de una herramienta si ya fue reparada
```sql

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
```
## Eventos:
* **eliminar_productoss:** evento que elimina los productos que no sean vendidos durante mas de un año.

```sql

delimiter // 
create event eliminar_productoss
on schedule every 1 year
do 
begin
delete from productos where id_producto not in (select id_producto from ventas where fecha_venta>= curdate()- interval 1 year );
end //
delimiter ;
```

* **cambiar_estado_maquinaria:** evento para cambiar el estado de la maquinaria a en reparacion despues de que se daño.
```sql

delimiter //
create event cambiar_estado_maquinaria
on schedule every 1 day
do
begin
update maquinaria set estado= 'En reparacion' where id_maquinaria in(select id_maquinaria from daños where fecha_reparacion_terminada is null);
end // 
delimiter ;
```

* **estado_producto_vencido:** evento para cambiar el estado de un producto cuando se vence.
```sql

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
```


# Roles de Usuarios y Permisos
Los roles de usuario definidos en la base de datos incluyen:
1. **Administrador General:**  Este usuario administrar la base de datos completamente: gestión de estructura, datos y usuarios.

2. **Gestor de operaciones:** Este usuario supervisa y gestiona la producción agrícola. Puede administrar procesos relacionados con cultivos y monitorear herramientas y maquinaria sin modificarlos.

3. **Contador:** Este usuario maneja informes financieros y ventas, pero sin la capacidad de alterar datos

4. **Gestor de inventario:** Este usuario gestiona el inventario de herramientas, maquinaria y productos relacionados con la producción con la capacidad de modificarlos.

5. **Agronomo:** Este usuario supervisa y registra enfermedades, plagas y procesos relacionados con el monitoreo de cultivos.

## Crear roles de usuarios y permisos
```sql
CREATE USER 'usuario'@'localhost' IDENTIFIED BY 'contraseña';
GRANT 'Administrador' TO 'usuario'@'localhost';
```
## Contribuciones
Este proyecto fue desarrollado por Camilo Machuca Vega y Valerie Michel Lasso Lizcano como proyecto MySQL:

* **Camilo Machuca:** Diseño parte de la base de datos, creacion de tablas, realizo diagrama logico, diagrama UML, realizo 50 consultas, 10 eventos, 10 funciones, 10 procedimientos, 10 trigger, normalizacion, Readme,  parte del word documentacion.

* **Valerie Lasso:** Diseño parte de la base de datos, realizo inserciones, realizo diagrama conceptual, realizo 50 consultas, 10 eventos, 10 funciones, 10 procedimientos, 10 trigger, 5 usuarios, normalizacion, parte del word documentacion.

