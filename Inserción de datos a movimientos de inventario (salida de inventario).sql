declare @desde date='20251201' 
declare @hasta date='20251201' 
insert into movimien (concepto,numero,tipo,fecha,idarticulo,cantidad,cod_unidad,bodega,costo_compra, 
factor,costo_prom,totalcosto2,entransito,precio,idgrupo,idsubgrupo,proveedor,feccreo,usrcreo, NLote) 
select a.tipofact,a.numero,'S',a.fecha,idarticulo,cantidad,cod_unidad,bodega,0,factor,costo,costo*cantidad,0, 
precio,idGrupo,idSubGrupo,codProveedor,b.fechaUserCreo,b.usercreo, a.nlote 
from detafac as a inner join facturas as b on a.tipofact=b.tipofact and a.numero=b.numero  
where a.tipofact+ a.numero in(select tipofact+numero 
FROM            facturas INNER JOIN 
                         conceptos ON facturas.tipofact = conceptos.concepto 
WHERE  ((facturas.tipofact + facturas.numero) NOT IN 
(SELECT  concepto + numero AS Expr1 
FROM  datamov)) AND (ISNULL(conceptos.Es_Cotizacion, 0) = 0) AND (ISNULL(facturas.anulado, 0) = 0) AND (facturas.fecha IN 
(SELECT   Fecha 
FROM  dbo.FnRangoFechas(@desde, @hasta) AS FnRangoFechas_1)) and a.tipofact = 'CCF' and a.numero = '000230') 
insert into datamov ( tipo,fecha,fechadoc,total,generado,concepto,numero,bodega,codproveedor,usrcreo,feccreo) 
select 'S',fecha,fecha,valortot,1,tipofact,numero,1,'',usercreo,fechaUserCreo from facturas where tipofact+numero in(select tipofact+numero 
FROM            facturas INNER JOIN 
                         conceptos ON facturas.tipofact = conceptos.concepto 
WHERE        ((facturas.tipofact + facturas.numero) NOT IN 
(SELECT        concepto + numero AS Expr1 
FROM            datamov)) AND (ISNULL(conceptos.Es_Cotizacion, 0) = 0) AND (ISNULL(facturas.anulado, 0) = 0) AND (facturas.fecha IN 
(SELECT Fecha 
FROM dbo.FnRangoFechas(@desde, @hasta) AS FnRangoFechas_1)) and isnull((select isnull(despachado,0) from Factura_Despacho where idfactura=facturas.idfactura),0)=0 
) and facturas.tipofact = 'CCF' and facturas.numero = '000230'  