/*----------------------------------------------------------------------------------------------------------------------------
													Caso 1 (10 puntos):
							Con la base de datos Northwind, cree los siguientes scripts:
*/------------------------------------------------------------------------------------------------------------------------------

USE Northwind
GO

/*-------------------------- 
Pregunta 1: Un script que permita saber las ventas realizadas por categoría de producto. Este
resultado debe ser el resultado sumarizado y obtener una tabla que tenga la
forma: (3 puntos)
*/--------------------------

SELECT *
FROM Categories

SELECT *
FROM Products

SELECT *
FROM [Order Details]

SELECT A.CategoryID , A.CategoryName , B.ProductName , SUM(C.UnitPrice * C.Quantity) as "ProductSales"
FROM Categories as A
LEFT JOIN Products as B ON A.CategoryID=B.CategoryID
LEFT JOIN [Order Details] as C ON B.ProductID=C.ProductID
GROUP BY A.CategoryID, A.CategoryName, B.ProductName
GO

/*-------------------------- 
Pregunta 2: Un script que permita tener en el resultado un campo adicional para identificar si
existen ordenes con productos discontinuados. Una vez identificados, plantee un
script que permita cambiar a todos los productos discontinuados de regreso a
continuados. Tenga en consideración los campos que deben usar. (2 puntos)
*/--------------------------

SELECT *
from Products 
WHERE Discontinued=1
GO

SELECT *
FROM (SELECT A.OrderID, A.ProductID, B.ProductName, CASE WHEN B.Discontinued=1 THEN 'Orden Descontinuada' ELSE 'Orden Continuada' END as Condicion
FROM [Order Details] AS A
INNER JOIN Products AS B ON A.ProductID=B.ProductID	
GROUP BY A.OrderID, A.ProductID, B.ProductName, B.Discontinued) AS TB
WHERE Condicion='Orden Descontinuada'
GO

UPDATE Products
SET Discontinued=1
WHERE Discontinued=0

/*-------------------------- 
Pregunta 3: Cree un script que permita saber qué productos en qué ordenes presentan un
precio distinto al de la tabla Productos. Recuerde lo que se vio en la tabla
dbo.OrderDetales y dbo.Products. (5 puntos)
*/--------------------------

SELECT *
FROM(SELECT A.OrderID , A.ProductID, B.ProductName, A.UnitPrice as UP_ORDER,B.UnitPrice as UP_PROD, CASE WHEN A.UnitPrice!=B.UnitPrice THEN 'Precios Distintos' ELSE 'Precios Iguales' END Condicion_Precios
FROM [Order Details] AS A
LEFT JOIN Products AS B ON A.ProductID=B.ProductID) AS TB2
WHERE UP_ORDER!=UP_PROD
GROUP BY OrderID,ProductID,ProductName,UP_ORDER,UP_PROD,Condicion_Precios
ORDER BY UP_ORDER DESC
GO
