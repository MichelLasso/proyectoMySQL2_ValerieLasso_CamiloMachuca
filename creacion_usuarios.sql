-- usuarios 
-- 1 usuario administrador general
create user 'Administrador_Finca'@'localhost' identified by '2532';
grant all privileges on fincacacao.* to 'administrador_finca'@'localhost';

show grants for current_user();

-- drop user 'Administrador_Finca'@'localhost';
-- 2 usuario gestor de operaciones
create user 'Gestor_Operaciones'@'localhost' identified by '1234';

grant select, insert, update, delete on fincacacao.cultivo to 'Gestor_Operaciones'@'localhost';
grant select, insert, update, delete on fincacacao.lotes to 'Gestor_Operaciones'@'localhost';
grant select, insert, update, delete on fincacacao.cosecha to 'Gestor_Operaciones'@'localhost';
grant select , insert, update, delete on fincacacao.procesos to 'Gestor_Operaciones'@'localhost';
grant select on fincacacao.areas_finca to 'Gestor_Operaciones'@'localhost';
grant select on fincacacao.maquinaria to 'Gestor_Operaciones'@'localhost';
grant select on fincacacao.herramientas to 'Gestor_Operaciones'@'localhost';
grant select on fincacacao.empleados to 'Gestor_Operaciones'@'localhost';
grant select on fincacacao.agroquimicos to 'Gestor_Operaciones'@'localhost';

-- 3. usuario contador
create user 'Contador'@'localhost' identified by 'contador112';

grant select on fincacacao.ventas to 'Contador'@'local@host';
grant select on fincacacao.registro_envio to 'Contador'@'local@host';
grant select on fincacacao.empleados to 'Contador'@'local@host';
grant select on fincacacao.clientes to 'Contador'@'local@host';
grant select on fincacacao.productos to 'Contador'@'local@host';
grant select on fincacacao.daños to 'Contador'@'local@host';

-- 4. usuario gestor de inventario
create user 'Gestor_inventario'@'localhost' identified by 'inventa345';

grant select , update on fincacacao.agroquimicos to 'Gestor_inventario'@'localhost';
grant select, update on fincacacao.herramientas to 'Gestor_inventario'@'localhost';
grant select, update on fincacacao.productos to 'Gestor_inventario'@'localhost';
grant select, update on fincacacao.maquinaria to 'Gestor_inventario'@'localhost';

-- 5 usuario ágronomo
create user 'Agrónomo'@'localost' identified by '12000';

grant select , update, delete, insert on fincacacao.plantas_enfermas to 'Agrónomo'@'localost';
grant select on fincacacao.procesos to 'Agrónomo'@'localost';
grant select on fincacacao.agroquimicos to 'Agrónomo'@'localost';
grant select on fincacacao.herramientas to 'Agrónomo'@'localost';
grant select on fincacacao.areas_finca to 'Agrónomo'@'localost';
grant select on fincacacao.empleados to 'Agrónomo'@'localost';
grant select , update, delete, insert on fincacacao.monitoreos to 'Agrónomo'@'localost';
grant select on fincacacao.cultivo to 'Agrónomo'@'localost';
grant select on fincacacao.cuidado_cultivo to 'Agrónomo'@'localost';
grant select on fincacacao.lotes to 'Agrónomo'@'localost';