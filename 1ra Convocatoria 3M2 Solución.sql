

/*
  
   1ra Convocatoria de Base de Datos II 3M2 IS
   Nombre: ___________________________________


1. Instalar la BD Neptuno
2. Realizar un Esquema en estrella orientado a la venta de productos de la empresa. 
    a. Identificar las dimensiones posibles y tabla de hechos. 15pts*/
/* Tablas Dimensionales: Producto, Pedido, Fechas*/
-- Nota: La tabla Categoría es válida si se toma como dimensión, 
--pero en este caso está inmersa en la dimensión del producto.
Alter view DimProductos
as
select 
p.idproducto,
p.nombreProducto,
po.nombreCompañia as Proveedor,
po.telefono,
c.nombrecategoria as Categoria,
--p.cantidadPorUnidad as [Cantidad x Unidad],
--p.precioUnidad as [Precio x Unidad],
--p.unidadesEnExistencia as Existencias
p.unidadesEnPedido as [Unidades en Pedido]  -- Esta la solución del inciso 3 de Power BI
--p.nivelNuevoPedido as [NivelNuevo Pedido],
--p.suspendido Nota:Estos valores no son necesarios como valores en la dimensión producto.

from Productos p
inner join proveedores po on po.idProveedor = p.idProveedor 
inner join categorias c on c.idcategoria = p.idCategoria
-- Dimensión Pedido
Create view DimPedido
as
Select p.IdPedido,
       c.NombreCompañia as [Nombre Empresa],
	   c.Ciudad as [Ciudad Empresa],
	   e.Nombre + ' '+e.Apellidos as [Nombre Empleado],
	   e.ciudad as [Ciudad Empleado],
	   ce.nombreCompañia,
	   p.CiudadDestinatario,
	   p.PaisDestinatario
        
from Pedidos p
     inner join clientes c on c.idCliente = p.IdCliente
	 inner join Empleados e on e.IdEmpleado = p.IdEmpleado
	 inner join compañiasdeenvios ce on ce.idCompañiaEnvios = p.FormaEnvio

	 -- Dimensión Fecha
Create view Dimfecha
as
select distinct
FechaPedido as FechaId,
               year(FechaPedido) as Año,
			   month(FechaPedido) as NoMes,
			   day(FechaPedido) as NoDia,
			   datepart(qq, FechaPedido) as Trimestre,
			   DATENAME(MONTH,FechaPedido) as NombreMes,
			   DATENAME(WEEKDAY, FechaPedido) NombreDia
from Pedidos


/*
	b. Identifcar todos los valores de medida posible para la tabla de hechos. 15pts.*/
	Create view HechosPedido
as
Select 
-- LLaves de las dimensiones
p.IdPedido,
p.FechaPedido,
dpro.idproducto,
-- Valores de Medida
SUM(dd.cantidad) as Cantidad,
sum((dd.preciounidad * dd.cantidad) * (1 - dd.descuento)) as Recaudación
from detallesdepedidos dd
     inner join Pedidos p on p.IdPedido = dd.idpedido
	 inner join DimProductos dpro on dpro.idproducto = dd.idproducto
	 Group by
	 p.IdPedido,
     p.FechaPedido,
     dpro.idproducto

	/*
3. Utilizando el esquema estrella en Power BI mostrar mediante visulizaciones:
    a. Cantidades vendidas por categoría filtradas por año. 10pts.
	b. Recaudación de ventas y cantidad vendida filtrada por producto y año. 10pts.
	c. Realizar una vista que muestre los 5 productos más vendidos filtrados 
	   por año y mes. 10pts. Ver solución archivo Power BI

4. Crear un acceso SQL  llamado AdminNeptuno, establezca a su criterio 
   que permisos debería tener dicho acceso en caso de que este sea el usuario que
   conectará al Sistema de Información para realizar transacciones en la Base de Datos. 5pts.*/
       Create login AdminNeptuno with password = 'miconvocatoria2023'
	   go
	   Use Neptuno
	   go
	   sp_adduser AdminNeptuno, AdminNeptuno
	   go
	   Grant select, update, insert to AdminNeptuno
	   
	    
/*
5. Crear un inicio de Sesión que conecte únicamente a las vistas del cubo 
   del inciso 2. 5pts.   */

       Create login AdminCubo with password = 'miconvocatoria2023'
	   go
	   Use Neptuno
	   go
	   sp_adduser AdminCubo, AdminCubo
	   go
	   Grant select on DimFecha to AdminCubo
	   Grant select on DimPedido to AdminCubo
	   Grant select on DimProductos to Admincubo
	   Grant select on HechosPedido to Admincubo
   /*
   

 Nota: Ubique las respuestas en el Item correspondiente a excepto el Item 3 
       el cual se deberá presentar en POWER BI. Finalizado el examen, subir 
	   los archivos a plataforma (archivo SQL y archivo power BI)
   

*/