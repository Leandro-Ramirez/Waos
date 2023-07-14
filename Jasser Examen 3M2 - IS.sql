--   Realizar una vista de datos que muestre un resumen de recaudaciones de datos para las dos empresas.
--   (ServiPlus y Seguros_Sa) Dicho resumen será para las ventas del mes anterior vs el mes actual.
--   Estructura:
--Nombre Empresa /  Recaudación / TipoServicio
--   TipoServicio: 
--   Monto X Servicios de Matenimiento
--   Monto X Repuestos
--   Monto X Pólizas
--   Monto X Gastos de Hospitalización
--   Monto X Consultas

Use Serviplus

Create View Recaudaciones_Empresas
As
Select 'Serviplus' 
As [Nombre Empresa],
(Select Sum(dm.Precio) 
From Serviplus.dbo.Detalle_Mantenimiento dm
Inner Join Serviplus.dbo.Mantenimiento m On m.IdMantenimiento = dm.IdMantenimiento
Where Month(m.FechaIngreso) = Month(DateAdd(Month, -1, GetDate()))) 
As Recaudacion, 'Monto X Servicios' 
As TipoServicio

Union
Select 'Serviplus' 
As [Nombre Empresa],
(Select Sum(dr.Precio*dr.Cantidad) 
From Serviplus.dbo.Detalle_Repuesto dr
Inner Join Serviplus.dbo.Detalle_Mantenimiento dm On dm.IdDetalleMantenimiento = dr.IdDetalleMantenimiento
Inner Join Serviplus.dbo.Mantenimiento m On m.IdMantenimiento = dm.IdMantenimiento
Where Month(m.FechaIngreso) = Month(DateAdd(Month, -1, GetDate()))) 
As Recaudacion, 'Monto X Repuestos' 
As TipoServicio

Union
Select 'Seguros SA' 
As [Nombre Empresa],
(Select Sum(p.Costo) 
From Seguros_SA.dbo.Poliza p
Where Month(p.FechaEmision) = Month(DateAdd(Month, -1, GetDate()))) 
As Recaudacion, 'Monto X Polizas' 
As TipoServicio

Union
Select 'Seguros SA' 
As [Nombre Empresa],
(Select Sum(dh.Costo) 
From Seguros_SA.dbo.DetalleHospitalizacion dh
Where Month(dh.Fecha) = Month(DateAdd(Month, -1, GetDate()))) 
As Recaudacion, 'Monto X Gastos de Hospitalizacion' 
As TipoServicio

Union
Select 'Seguros SA' 
As [Nombre Empresa],
(Select Sum(c.GastoFijo + c.GastoFijo) 
From Seguros_SA.dbo.Consulta c
Where Month(c.Fecha) = Month(DateAdd(Month, -1, GetDate()))) 
As Recaudacion, 'Monto X Consultas' 
As TipoServicio
  
Select * From Serviplus.dbo.Recaudaciones_Empresas

-- 3. 5pts. Cargar un Inicio de Sesión SQL para visualizar únicamente la información del inciso 2.

Create Login Visualizador 
With Password = '123456'

Use Serviplus

Exec sp_adduser Visualizador, Visualizador

Grant Select On Recaudaciones_Empresas To Visualizador

-- 4. 5 pts. Realizar una vista en Power BI y muestre la información del inciso 2.
-- 5. 5 pts. En mongoDB cargar el archivo Personas.csv.
--Crear la BD Empresa
--use Empresa
--Crear la colección Personas
--db.createCollection("Personas")
--Cargar el archivo Personas.cvs en la colección.
--Mostrar:
--Cantidad de Personas
--db.Personas.countDocuments()
--Cantidad de Personas que tienen un peso entre 80 y 100
--db.Personas.find({peso : {$gte: 80,$lte: 100}}).count()
--Mostrar los 5 trabajadores con el mayor ingreso.
--db.Personas.find().sort({ingreso: -1}).limit(5)