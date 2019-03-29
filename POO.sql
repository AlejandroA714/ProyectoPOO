create database POO;

use POO;

create table departamento(
	id int primary key auto_increment,
    codigo varchar(20) unique,
    nombre varchar(50) not null unique,
    descripcion varchar(100) not null default 'Sin descripcion'
);

/*Procedimiento para la insercion de departamentos*/
delimiter $$
create procedure insertar_departamento (v_nombre varchar(50),v_descripcion varchar(100))
begin
	declare v_aux varchar(15);
    declare v_id int;
    if(length(v_descripcion) = 0) then
		insert into departamento(nombre,descripcion) values (v_nombre,default);
	else 
		insert into departamento(nombre,descripcion) values (v_nombre,v_descripcion);
    end if;
    set v_id = (select id from departamento where nombre = v_nombre);
    set v_aux = concat('D',UPPER(substr(v_nombre,1,3)), cast(v_id as char(4)));
    update departamento set codigo = (v_aux) where id = v_id ;
end$$
delimiter ;
call insertar_departamento('Ventas','');
call insertar_departamento('Ventas2','Este departamento lleva el control de las ventas de la empresa');

/*Procedimiento para la actualizacion de departamentos*/
delimiter $$
create procedure actualizar_departamento (v_id int, v_nombre varchar(50),v_descripcion varchar(100))
begin
	if(length(v_descripcion) = 0) then
		update departamento set codigo=concat('D',UPPER(substr(v_nombre,1,3)),v_id), nombre = v_nombre, descripcion = default where id = v_id;
	else 
		update departamento set codigo=concat('D',UPPER(substr(v_nombre,1,3)),v_id), nombre = v_nombre, descripcion = v_descripcion where id = v_id;
    end if;
end$$
delimiter ;
call actualizar_departamento (2,'Nuevo','');

/*Procedimiento para la eliminacion de departamentos*/
delimiter $$
create procedure eliminar_departamento (v_id int)
begin
	delete from departamento where id = v_id;
end$$
delimiter ;
call eliminar_departamento (1);

/*Procedimiento para mostrar departamentos*/
delimiter $$
create procedure mostrar_departamento ()
begin
	select D.codigo, D.nombre, D.descripcion  from departamento D;
end$$
delimiter ;
call mostrar_departamento ();

/*Procedimiento para buscar departamentos*/
delimiter $$
create procedure buscar_departamento(v_buscar varchar(50))
begin
	select D.codigo, D.nombre, D.descripcion  from departamento D where D.codigo LIKE concat('%',v_buscar,'%') OR D.nombre LIKE concat('%',v_buscar,'%');
end$$
delimiter ;
call buscar_departamento('vent');




create table rol(
	id int primary key auto_increment,
    rol varchar(25) not null unique,
    descripcion varchar(100) not null default 'Sin descripcion'
);

/*Procedimiento para la insercion de roles*/
delimiter $$
create procedure insertar_rol (v_rol varchar(25),v_descripcion varchar(100))
begin
	if(length(v_descripcion) = 0) then
		insert into rol(rol,descripcion) values (v_rol,default);
	else 
		insert into rol(rol,descripcion) values (v_rol,v_descripcion);
    end if;
end$$
delimiter ;
call insertar_rol('Jefe','Este departamento lleva el control de las ventas de la empresa');

/*Procedimiento para la actualizacion de departamentos*/
delimiter $$
create procedure actualizar_rol (v_id int, v_rol varchar(25),v_descripcion varchar(100))
begin
	if(length(v_descripcion) = 0) then
		update rol set rol = v_rol, descripcion = default where id = v_id;
	else 
		update rol set rol = v_rol, descripcion = v_descripcion where id = v_id;
    end if;
end$$
delimiter ;
call actualizar_rol (1,'Nuevo2','');

/*Procedimiento para la eliminacion de departamentos*/
delimiter $$
create procedure eliminar_rol (v_id int)
begin
	delete from rol where id = v_id;
end$$
delimiter ;
call eliminar_rol (1);

/*Procedimiento para mostrar departamentos*/
delimiter $$
create procedure mostrar_rol ()
begin
	select R.rol, R.descripcion  from rol R;
end$$
delimiter ;
call mostrar_rol ();

/*Procedimiento para buscar departamentos*/
delimiter $$
create procedure buscar_rol(v_buscar varchar(50))
begin
	select R.rol, R.descripcion  from rol R where R.rol LIKE concat('%',v_buscar,'%') OR R.descripcion LIKE concat('%',v_buscar,'%');
end$$
delimiter ;
call buscar_rol('sin des');
/*
drop procedure buscar_departamento
truncate departamento
*/

/*Ingreso de roles*/
call insertar_rol('Jefe de Area','');


/*Empleado*/
CREATE TABLE Empleado(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL check (nombre NOT LIKE '%[0-9]%'),
    apellidos VARCHAR(50) NOT NULL check (apellidos NOT LIKE '%[0-9]%'),
    email VARCHAR(50) NOT NULL unique check(email LIKE '%_@_%_.__%'),
    contrasenia VARCHAR(50) NOT NULL check(length(contrasenia) > 8),
    idRol INT not null default 3,
    idDepartamento INT not null,
    FOREIGN KEY (idRol) REFERENCES rol(id),
    FOREIGN KEY (idDepartamento) REFERENCES departamento(id)
);


INSERT INTO Empleado VALUES(null,'Alejandro','Alejo','alejandroalejo714@gmail.com','password',1,1);
select * from empleado;



delimiter $$
CREATE PROCEDURE insertar_empleado  (v_nombre VARCHAR(50), v_apellidos VARCHAR(50), v_email varchar(50), v_contrasenia varchar(1), v_rol int, v_depto int)
    BEGIN
		declare v_cnt int;
        declare v_sdepto varchar(50);
		if v_rol = 1 then
			set v_cnt = (select count(*) from empleado where idDepartamento = v_depto and idRol = 1);
            if v_cnt != 0 then
				set v_sdepto = (select nombre from departamento where id = v_depto);
				select concat('Ya existe un jefe para el departamento: ',v_sdepto);
			else
				if v_rol = 0 then
					insert into empleado(nombre,apellidos,email,contrasenia,idRol,idDepartamento) values
					(v_nombre,v_apellidos,v_email,v_contrasenia,default,v_depto);
				else
					insert into empleado(nombre,apellidos,email,contrasenia,idRol,idDepartamento) values
					(v_nombre,v_apellidos,v_email,v_contrasenia,v_rol,v_depto);
				end if;
			end if;
		elseif v_rol = 2 then
			set v_cnt = (select count(*) from empleado where idDepartamento = v_depto and idRol = 2);
            if v_cnt != 0 then
				set v_sdepto = (select nombre from departamento where id = v_depto);
				select concat('Ya existe un jefe de desarrollo para el departamento: ',v_sdepto);
			else
				if v_rol = 0 then
					insert into empleado(nombre,apellidos,email,contrasenia,idRol,idDepartamento) values
					(v_nombre,v_apellidos,v_email,v_contrasenia,default,v_depto);
				else
					insert into empleado(nombre,apellidos,email,contrasenia,idRol,idDepartamento) values
					(v_nombre,v_apellidos,v_email,v_contrasenia,v_rol,v_depto);
				end if;
			end if;
		else
			if v_rol = 0 then
				insert into empleado(nombre,apellidos,email,contrasenia,idRol,idDepartamento) values
				(v_nombre,v_apellidos,v_email,v_contrasenia,default,v_depto);
			else
				insert into empleado(nombre,apellidos,email,contrasenia,idRol,idDepartamento) values
				(v_nombre,v_apellidos,v_email,v_contrasenia,v_rol,v_depto);
			end if;
		end if;
    END $$
delimiter ;



delimiter $$
CREATE PROCEDURE Loguearse  (Usuario VARCHAR(50),Contrasenia VARCHAR(50))
    BEGIN
        SELECT e.Nombre,r.rol AS Rol,d.Nombre AS Departamento
        FROM Empleado e
        INNER JOIN rol r
        ON e.idRol = r.id
        INNER JOIN departamento d
        ON e.idDepartamento = d.id
        WHERE e.Email = Usuario AND e.Contrasenia = Contrasenia; 
    END $$
delimiter ;
CALL Loguearse ('alejandroalejo714@gmail.com','password');