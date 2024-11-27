use FincaCacao;
-- consultas
use fincaCacao; 
-- 1.	Cantidad de cacao producido en un año especifico.
select sum(cantidad) from cosecha where fecha_cosecha between'2024-01-01' and '2024-12-31';

-- 2.	Promedio de producción de cacao del cultivo.
select avg(cantidad) from cosecha 
inner join cultivo on cosecha.id_cultivo=cultivo.id_cultivo;

-- 3.	Productos disponibles en el inventario.
select nombre from productos where not stock is null or stock=0;

-- 4.	Listar los empleados que se encuentran trabajando en la finca.
select * from empleados;
select nombre1, apellido1 from empleados where estado='activo';

-- 5.	Listar los empleados que están de vacaciones.
select nombre1, nombre2 from empleados
inner join vacaciones on empleados.id_empleado= vacaciones.id_empleado where fecha_llegada= now();

-- 6.	Total de horas trabajadas por los empleados sin contar el almuerzo.
select nombre1,apellido1, sum(timestampdiff(hour,hora_entrada,hora_salida)) from horarios_empleados
inner join empleados on horarios_empleados.id_empleado=empleados.id_empleado
group by 1,2;

-- 7.	Promedio de salario de los empleados en la finca.
select nombre1, apellido1, avg(total_pagado)promedio_salario from pagos_empleados
inner join empleados on pagos_empleados.id_empleado=empleados.id_empleado
group by 1,2;

-- 8.	Listar los empleados que trabajan y trabajaron en la finca.
select * from empleados;

-- 9.	Listar las herramientas que tengan algún daño.
select categoria, tipo from herramientas where estado='dañado';

-- 10.	Listar las herramientas que se encuentren en buen estado.
select categoria, tipo from herramientas where estado='bien';

-- 11.	Listar las maquinas que se encuentran en mal estado.
select categoria, tipo from maquinaria where estado ='en mantenimiento';

-- 12.	Listar las maquinas que están disponibles.
select categoria, tipo from maquinaria where estado ='operativa';

-- 13.	Listar los procesos por los que pasa el cacao para crear un producto.
select distinct caracteristicas,productos.nombre from procesos 
inner join productos where producto_esperado=productos.nombre;

-- 14.	Listar los tipos de agroquímicos de la finca.
select distinct tipo from agroquimicos;

-- 15.	Listar los tipos de agroquímicos disponibles.
select distinct tipo from agroquimicos where not stock=0 or null;

--  16.	Promedio de cosecha.
select avg(cantidad) as promedioCosecha from cosecha;

-- 17.	Listar todas las herramientas utilizadas en las cosechas.
select distinct tipo from cosecha
inner join herramientas on cosecha.id_herramienta= herramientas.id_herramienta;

-- 18.	Listar las cosechas que tuvieron algún problema y el motivo.
select descripcion_problema from cosecha where problema_cosecha= 1;

-- 19.	Calcular cuantas cosechas tuvieron problemas. 
select count(*) from cosecha where problema_cosecha=1;

-- 20.	Cual es el promedio de la cantidad de fertilizante o insecticida aplicada al cultivo.
select a.id_agroquimico, a.nombre_marca, a.tipo, medida_dosis from agroquimicos a inner join cuidado_cultivo c on c.id_agroquimico=a.id_agroquimico where tipo='fertilizante' or tipo='insecticida';
-- 21.	Cuantas plantas están enfermas.
select * from plantas_enfermas;

--  22.	Listar las plantas que se encuentran enfermas, con el tipo de enfermedad, el nombre de la enfermedad, y la ubicación de la planta.

select id_planta_enferma, tipo_enfermedad, nombre_enfermedad, numero_surco_ubicacion, numero_planta_ubicacion, id_monitoreo from plantas_enfermas;

-- 23.	Cuantas plantas murieron
select count(*) as plantas_muertas from plantas_enfermas where estado='muerta';

-- 24.	Cual es la enfermedad más común.
select tipo_enfermedad, count(*) as cantidad from plantas_enfermas group by tipo_enfermedad order by cantidad desc limit 1;


-- 25.	Cual es el lote donde más se han enfermado las plantas.
select l.id_lote, count(p.id_planta_enferma) as 'cantidad_enfermedades' from plantas_enfermas p 
inner join monitoreos m on p.id_monitoreo=m.id_monitoreo 
inner join cuidado_cultivo c on m.id_cuidado_cultivo=c.id_cuidado_cultivo 
inner join lotes l on c.id_lote=l.id_lote group by l.id_lote order by cantidad_enfermedades desc limit 1;

select * from plantas_enfermas;
-- 26.	Listar todos los monitoreos de una planta que murió.
select m.id_monitoreo, count(m.id_monitoreo) as cantidad_monitoreo from monitoreos m inner join plantas_enfermas p on p.id_monitoreo=m.id_monitoreo where p.estado= 'muerta' group by 1;

-- 27. Listar las plantas enfermas desde la más reciente a la más antigua, con el nombre de la enfermedad, fechas, y ubicación de la planta.
select * from plantas_enfermas where estado='Enferma' order by fecha_entrada desc;

-- 28. Listar el empleado con mayor número de monitoreos.
select e.id_empleado, e.nombre1, e.nombre2, e.apellido1, e.apellido2, count(m.id_monitoreo) as 'cantidad_monitoreos' 
from empleados e inner join monitoreos m on e.id_empleado=m.id_empleado 
group by e.id_empleado order by cantidad_monitoreos desc limit 1;

-- 29.	Listar el lote con mayor número de monitoreos.
select l.id_lote, l.ancho, l.largo, l.unidad_de_medida, count(m.id_monitoreo) as 'cantidad_monitoreos'
from lotes l inner join cuidado_cultivo c on l.id_lote=c.id_lote inner join monitoreos m on c.id_cuidado_cultivo=m.id_cuidado_cultivo 
group by l.id_lote
order by cantidad_monitoreos desc limit 1;

-- 30.	Listar el agroquímico mas utilizado en el cuidado del cultivo y cuantos quedan disponibles.
select a.nombre_marca, a.stock, count(c.id_agroquimico) as cantidad_utilizada 
from agroquimicos a inner join cuidado_cultivo c on a.id_agroquimico= c.id_agroquimico
group by a.id_agroquimico order by cantidad_utilizada desc limit 1;

-- 31.	Listar los tipos de cuidado.
select tipo_cuidado from cuidado_cultivo;

-- 32.	Calcular el precio total de compra por cada agroquímico.

select a.nombre_marca, sum(c.cantidad * c.costo) as precio_total_compra
from agroquimicos a inner join compras c on a.id_compra=c.id_compra
group by a.id_agroquimico;


-- 33.	Calcular el total de compra de los agroquimicos.
select sum(c.cantidad * c.costo) as precio_total_compra_agroquimicos
from agroquimicos a inner join compras c on a.id_compra=c.id_compra;


-- 34.Listar los agroquímicos no disponibles con el número del proveedor.
select id_agroquimico, a.nombre_marca, a.tipo, a.categoria, a.descripcion, p.telefono as telefono_proveedor from agroquimicos a inner join compras c on a.id_compra= c.id_compra inner join proveedores p on c.id_proveedor=p.id_proveedor;

-- 35.	Listar los métodos de aplicación de cada agroquímico con la unidad de medida.
select id_agroquimico, nombre_marca, metodo_aplicacion, unidad_de_medida from agroquimicos;

-- 36.	calcular la cantidad de plantas por lote.
select id_lote,cantidad_de_plantas from lotes;

-- 37.	Listar los tipos de maquinaria que hay en la finca que se encuentran operativas.
select tipo from maquinaria;

-- 38.	Listar las máquinas en mal estado.
select * from maquinaria where estado='en mantenimiento';

--  39.	Listar las máquinas en buen estado.
select tipo from maquinaria where estado='operativa';

-- 40.	Listar el tipo de maquina con su categoría y el tipo de combustible que se usa ordenadas de forma alfabeticamente por el tipo.
select tipo, categoria, tipo_combustible from maquinaria order by 1 asc;

-- 41.	Cual es el combustible más utilizado.
select tipo_combustible, count(tipo_combustible) as 'cantidad_combustible'  from maquinaria group by 1 order by cantidad_combustible desc limit 1;

-- 42	Cual es la máquina mas utilizada en los procesos.
select tipo, count(tipo)as 'cantidad_maquina' from maquinaria group by 1 order by cantidad_maquina desc limit 1;

-- 43.	Cual es el promedio de duración de cada proceso.
select avg(timestampdiff(day,fecha_fin, fecha_inicio)) as promedio_dias_procesos from procesos ;

-- 44.	Listar el área de la finca donde se realiza cada proceso.
select p.caracteristicas, af.nombre from procesos p inner join areas_finca af on p.id_area_finca=af.id_area_finca;

-- 45.	Listar los procesos con problemas y la descripción del problema.
select id_proceso, caracteristicas, problema_proceso, descripcion_problema from procesos where problema_proceso= 1;

-- 46.	Cual fue el proceso con mayor número de problemas.
select id_proceso, caracteristicas,count(problema_proceso) as 'cantidad_problemas' from procesos where problema_proceso= 1 group by 1,2 order by cantidad_problemas desc limit 1 ;

-- 47.	Cual es el número de problemas de cada proceso.
select id_proceso, count(problema_proceso) as cantidad_problemas, descripcion_problema from procesos where problema_proceso= 1 group by 1;

-- 48.	Listar los agroquímicos que faltan por pagar.
select a.id_agroquimico, a.nombre_marca, a.tipo, a.categoria, c.deuda from agroquimicos a inner join compras c on c.id_compra= a.id_compra where c.deuda>0;

-- 49.	Listar las 3  compras que tengan una deuda mas alta
select id_compra, nombre_producto, cantidad, costo, deuda from compras order by deuda desc limit 3;

-- 50.	Calcular el total de las deudas por compras.
select id_compra, sum(deuda) as total_deuda from compras group by 1;

-- 50.	Calcular el total de las deudas por compras.
select sum(deuda) from compras;

-- 51.	Cual fue la compra mas reciente y el agroquímico que se compró.
select tipo, fecha_compra from compras 
inner join agroquimicos on compras.id_agroquimicos= agroquimicos.id_agroquimicos
order by 1 desc limit 1;

-- 52.	Calcular las horas de trabajo del empleado sin contar el almuerzo.
select  nombre1, apellido1, 
(timestampdiff(hour, hora_entrada, hora_salida)-1) as horas_trabajo
from horarios_empleados
inner join empleados on horarios_empleados.id_empleado=empleados.id_empleado
group by 1,2,3;

-- 53.	Listar el cargo de cada empleado y el sueldo.
select nombre1, apellido1, nombre, salario  from empleados
inner join cargos on empleados.id_cargo=cargos.id_cargo;

-- 54.	Listar los empleados que han sido despedidos.
select nombre1, apellido1, estado from empleados where estado='despedido';

-- 55.	Quien es el empleado más antiguo de la finca, el cargo y el total de pagos que ha recibido.
select nombre1, apellido1, fecha_ingreso, sum(total_pagado)as total_Pagos from empleados 
inner join pagos_empleados on empleados.id_empleado=pagos_empleados.id_empleado 
group by 1,2,3 order by fecha_ingreso asc limit 1;

-- 56.	Quien fue el empleado que duro menos tiempo trabajando en la finca.
select nombre1, apellido1, timestampdiff(day, fecha_ingreso,fecha_salida)dias_trabajo from empleados 
where not fecha_salida is null 
order by 3 asc limit 1;

-- 57.	Quien es el empleado más viejo y el cargo que ejerce.
select nombre1, apellido1, timestampdiff(year, fecha_nacimiento, now())as edad, nombre from empleados 
inner join cargos on empleados.id_cargo = cargos.id_cargo
order by 3 desc limit 1;

-- 58.	Quien es el empleado más joven y el cargo que ejerce.
select nombre1, apellido1, timestampdiff(year, fecha_nacimiento, now())as edad, nombre from empleados 
inner join cargos on empleados.id_cargo = cargos.id_cargo
order by 3 asc limit 1;

-- 59.	Calcular el total de pagos de cada empleado.
select nombre1, apellido1, sum(total_pagado) from empleados 
inner join pagos_empleados on empleados.id_empleado= pagos_empleados.id_empleado
group by 1,2;

-- 60.	Calcular el número de pagos de cada empleado.
select nombre1, apellido1, count(total_pagado)as totalPagos from empleados 
inner join pagos_empleados on empleados.id_empleado= pagos_empleados.id_empleado
group by 1,2;

-- 61.	Calcular el promedio del total pagado a los empleados.
select nombre1, apellido1, avg(total_pagado)as promedioPagado from empleados 
inner join pagos_empleados on empleados.id_empleado= pagos_empleados.id_empleado
group by 1,2;

-- 62.	Listar los pagos del empleado con su fecha.
select nombre1, nombre2, fecha_pago from empleados
inner join pagos_empleados on empleados.id_empleado= pagos_empleados.id_empleado;

-- 63.	Calcular el número de compras por cada cliente
select  nombre1, apellido1, count(ventas.id_cliente) from ventas
inner join clientes on ventas.id_cliente=clientes.id_cliente
group by 1,2;

-- 64.	Calcular el promedio de compra por cada cliente.
select  clientes.id_cliente,nombre1, apellido1, avg(precio_a_pagar)as promedioTotalCompra from ventas
inner join clientes on ventas.id_cliente=clientes.id_cliente
group by 1;

-- 65.	Cual es el producto más vendido y mostrar si está disponible.
select nombre, count(ventas.id_producto)as totalVentas, stock from ventas 
inner join productos on ventas.id_producto= productos.id_producto
group by 1,3 order by 2 desc limit 1;

-- 66.	Quien es el empleado con mayor número de ventas.
select nombre1, apellido1, count(ventas.id_empleado)as totalVentas from empleados
inner join ventas on empleados.id_empleado= ventas.id_empleado
group by 1,2 order by 3 desc limit 1;

-- 67.	Quien es el cliente con mayor número de compras.
select nombre1, apellido1, count(ventas.id_cliente) from clientes
inner join ventas on clientes.id_cliente=ventas.id_cliente
group by 1,2 order by 3 desc limit 1;

-- 68.	Quien es el cliente con menor número de compras.
select nombre1, apellido1, count(ventas.id_cliente) from clientes
inner join ventas on clientes.id_cliente=ventas.id_cliente
group by 1,2 order by 3 asc limit 1;

-- 69.	Listar las ventas que tuvieron problemas en el envío y el porqué.
select id_venta, descripcion_problema from ventas 
inner join registro_envio on ventas.id_venta= registro_envio.id_registro_envio
where problema_envio=1;

-- 70.	Cuál es el método de transporte más utilizado en el envío.
select tipo, count(id_transporte) from registro_envio 
inner join maquinaria on registro_envio.id_transporte= maquinaria.id_maquinaria
group by 1 order by 2 desc limit 1;

-- 71.	Listar los métodos de transporte que hay en la finca.
select tipo from maquinaria where categoria='transporte';

-- 72.	Calcular el número de ventas que no tuvieron problemas en el envío.
select count(ventas.id_venta) from ventas 
inner join registro_envio on ventas.id_envio= registro_envio.id_registro_envio
where problema_envio = 0;

-- 73.	Calcular el número de ventas que tuvieron problemas con el envío.
select count(ventas.id_venta) from ventas 
inner join registro_envio on ventas.id_envio= registro_envio.id_registro_envio
where problema_envio = 1;

-- 74.	Quien es el empleado con mayores problemas de envío.
select nombre1, apellido1, count(registro_envio.id_empleado) from empleados
inner join registro_envio on empleados.id_empleado= registro_envio.id_empleado
where problema_envio=1
group by 1,2 order by 3 desc limit 1;

-- 75.	Listar cuanto tiempo duró en llegar cada pedido.
select id_registro_envio, timestampdiff(day,fecha_salida,fecha_llegada) 
from registro_envio;

-- 76.	Cual fue la venta con mayor tiempo en tránsito.
select id_venta, timestampdiff(day,fecha_salida,fecha_llegada)as dias  from ventas
inner join registro_envio on ventas.id_envio= registro_envio.id_registro_envio
group by 1 order by 2 desc limit 1;

-- 77.	Cuál es el método de pago más común.
select tipo, count(registro_envio.id_metodo_pago) from registro_envio
inner join metodo_pago on registro_envio.id_metodo_pago= metodo_pago.id_metodo_pago
group by 1 order by 2 desc;

-- 78.	Listar los productos vencidos.
select nombre from productos
where fecha_vencimiento < now();

-- 79.	Quien es el cliente más antiguo.
select nombre1,apellido1, timestampdiff(day, fecha_registro,now()) 
from clientes order by 3 desc limit 1;

-- 80.	Listar los descuentos disponibles.
select id_bonificacion_descuento, descripcion from bonificacion_descuento
where tipo='descuento' and estado='activo';

-- 81.	Listar las bonificaciones disponibles.
select id_bonificacion_descuento, descripcion from bonificacion_descuento
where estado='activo' and tipo= 'bonificacion';

-- 82.	Listar los descuentos que no están disponibles.
select id_bonificacion_descuento, descripcion from bonificacion_descuento
where tipo='descuento' and estado='inactiva';

-- 83.	Listar las bonificaciones que no están disponibles.
select id_bonificacion_descuento, descripcion from bonificacion_descuento
where estado='inactiva' and tipo= 'bonificacion';

-- 84.	Cual es la bonificación más utilizada.
select bonificacion_descuento.id_bonificacion_descuento, 
count(pagos_empleados.id_bonificacion_descuento)as numeroBonificacionesUsadas 
from pagos_empleados
inner join bonificacion_descuento on pagos_empleados.id_bonificacion_descuento= 
bonificacion_descuento.id_bonificacion_descuento
where tipo='bonificacion' group by 1 order by 2 desc limit 1;

-- 85.	Cual es la diferencia del pago establecido con el pago dado al empleado.
select salario,total_pagado,total_pagado-salario as diferencia from pagos_empleados
inner join empleados on pagos_empleados.id_empleado= empleados.id_empleado
inner join cargos on empleados.id_cargo= cargos.id_cargo;

-- 86.	Listar los empleados que están y estuvieron en receso por enfermedad y la fecha.
select nombre1, apellido1, vacaciones.fecha_salida, fecha_llegada from empleados
inner join vacaciones on empleados.id_empleado= vacaciones.id_empleado
where motivo='descanso medico';

-- 87.	Listar los motivos de vacaciones.
select distinct motivo from vacaciones;

-- 88.	Calcular los días de vacaciones por empleado.
select nombre1, apellido1,timestampdiff(day, vacaciones.fecha_salida,fecha_llegada)as dias
from empleados inner join vacaciones on empleados.id_empleado= vacaciones.id_empleado;

-- 89.	Calcular el número de empleados que hay en la finca.
select count(*) from empleados;

-- 90.	Calcular el número de empleados que hay en cada área.
select areas_finca.nombre, count(empleados.id_empleado) as num_empleados
from empleados inner join cargos on empleados.id_cargo= cargos.id_cargo
inner join areas_finca on cargos.id_area_finca = areas_finca.id_area_finca
group by 1;

-- 91.	Calcular el total pagado por daños.
select sum(costo_reparacion) from daños;

-- 92.	Calcular en días el tiempo que pasó en cada reparación.
select timestampdiff(day, fecha_reparacion, fecha_reparacion_terminada) from daños;

-- 93.	Cuantos proveedores hay.
select count(*) from proveedores;

-- 94.	Cual es el proveedor mas antiguo. 
select nombre1, apellido1, timestampdiff(day,fecha_de_registro, now())dias from proveedores
group by 1,2,3 order by 3 desc limit 1;

-- 95.	Cuantos problemas de cosecha hay en este momento en la finca.
select count(*) from cosecha 
where problema_cosecha=1 and fecha_cosecha>'2024-01-01' 
and fecha_cosecha<now();

-- 96.	Cuales son los lotes que faltan por monitoreo.
select lotes.id_lote from lotes 
inner join cuidado_cultivo on lotes.id_lote=cuidado_cultivo.id_lote
left join monitoreos on cuidado_cultivo.id_cuidado_cultivo= monitoreos.id_cuidado_cultivo
where monitoreos.id_monitoreo is null;

-- 97.	Cuál es el tiempo en días, que tomo cada planta enferma hasta quedar sana.
select numero_planta_ubicacion, timestampdiff(day,fecha_entrada,fecha_salida) from plantas_enfermas
where estado='sana';

-- 98.	Cuanto tiempo duro cada planta que enfermó hasta morir.
select numero_planta_ubicacion, timestampdiff(day,fecha_entrada,fecha_salida) from plantas_enfermas
where estado='murio';

-- 99.	Cual ah sido el costo total de cada herramienta.
select tipo, sum(costo) from herramientas 
inner join compras on herramientas.id_compra = compras.id_compra
group by 1;

-- 100. cuantas vacaciones han tenido los empleados este año
select nombre1, apellido1, vacaciones.fecha_salida, vacaciones.fecha_llegada, count(vacaciones.id_empleado) from empleados 
inner join vacaciones on empleados.id_empleado= vacaciones.id_empleado
where vacaciones.fecha_salida and fecha_llegada>'2024-01-01' and vacaciones.fecha_salida and fecha_llegada<now()
group by 1,2,3,4;
