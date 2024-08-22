-- Query para trazer as informações para o texto abaixo:

/*
Durante esse período, integramos mais de xxx mil empresas de transporte e caminhoneiros autônomos à nossa
plataforma, movimentando mais de xxx milhões de toneladas. Junto a VECTOR sempre priorizamos a produtividade
 e valorizamos o tempo de nossos parceiros motoristas.
*/

--Query Transportadoras
 
select 
COUNT(distinct d.Id) as 'Cadastros realizados no mês',
CONCAT(MONTH(dal.RegisteredDate),'/',YEAR(dal.RegisteredDate)) as 'Mês/Ano'
from Carriers d with(Nolock) 
inner join CarrierAuditLogs dal with(Nolock) on dal.CarrierId = d.Id and Action = 2
where dal.RegisteredDate between '2020-01-01' and DATEADD(DAY, 1, EOMONTH (GETDATE (), -1))
group by
CONCAT(MONTH(dal.RegisteredDate),'/',YEAR(dal.RegisteredDate))

--Query Toneladas
 
select 
	sum(tr.Quantity)/1000 as 'TONTransp',
	CONCAT(MONTH(t.DateTrip),'/',YEAR(t.DateTrip)) as 'Mês/Ano'
from 
	Trips t with(nolock) 
	inner join TransportationOrders tr with(nolock) on tr.TransportationOrderNumber = t.TransportationOrder 
where 
	t.DateTrip between '2020-01-01' and DATEADD(DAY, 1, EOMONTH (GETDATE (), -1))
	and t.Status in ('VF','EN')
group by
	CONCAT(MONTH(t.DateTrip),'/',YEAR(t.DateTrip))
UNION 
select 
	SUM(cast(LoadsTotalWeight as float))/1000 as 'TONTransp',
	CONCAT(MONTH(StartDate),'/',YEAR(StartDate)) as 'Mês/Ano'
from TripOffers with(Nolock) 
where 
	StartDate between '2020-01-01' and DATEADD(DAY, 1, EOMONTH (GETDATE (), -1))
	and TripStatusVector in ('VF','EN')
group by
	CONCAT(MONTH(StartDate),'/',YEAR(StartDate))
;