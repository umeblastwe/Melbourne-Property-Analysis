update [Melbourne housing details]
set type = case
	when type = 'h' then 'house'
	when type = 'u' then 'unit'
	when type = 't' then 'town'
End
Where type in ('h' , 'u' , 't')

set type = case
	when type = 'S' then 'Property Sold'
	when type = 'SP' then 'Property Sold Prior'
	when type = 'SA' then 'Sold After Auction'
End
Where type in ('h' , 'u' , 't')

--Price For 3 Bedrooms
SELECT
	type as Property_Type,
	Price as Price
	From [Melbourne housing details]
	Where suburb = 'Abbotsford'
	And Rooms = '3'
	And Price is not null
Order By price

-- SellerG With Most Properties Sold According to Methods
With top5 as (
	Select 
	SellerG, Count(*) as Total_property_sold
From [Melbourne housing details]
Where Method in ('S' , 'SP' , 'SA' , 'SN')
Group by SellerG
)
Select top 5 *
From top5
Order by Total_property_sold desc

-- Properties sold in Regions
Select distinct(Regionname) as Region_name, 
count (*) as total_properties_sold
From [Melbourne housing details]
Where Method in ('S' , 'SP' , 'SA' , 'SN')
Group by Regionname
Order by total_properties_sold desc

-- Average Price Of House By
-- (Central Business District)
Select 
	Case
	when distance < 5 Then 'Inner Area'
	when distance > 20 Then ' Outter Area'
	Else 'middle Area'
End as Market_Zone,
AVG(cast(Price AS DECIMAL(18,2))) as Avg_Price
From [Melbourne housing details]
Where type in ('house' , 'unit' , 'town')
And price is not null
Group by 
Case 
	when distance < 5 Then 'Inner Area'
	when distance > 20 Then ' Outter Area'
	Else 'middle Area'
End
Order by Avg_Price desc

-- On Avg Extra Price for the room
Select 
Rooms as Rooms,
AVG(cast(Price AS DECIMAL(18,2))) as Avg_Price,
Count (*) as Total_Properties_sold
From [Melbourne housing details]
where Method in ('S','SP','SA', 'SN')
And price is not null
Group by Rooms
Order by Rooms asc

-- Percetnage of properties that made a sale
Select
SUM(CASE WHEN Method IN ('S', 'SP', 'SA', 'SN') 
THEN 1 ELSE 0 END) AS Total_Sold,
SUM(CASE WHEN Method IN ('PI', 'VB', 'SS' , 'PN') 
THEN 1 ELSE 0 END) AS Total_Passed_In,
CAST(SUM(CASE WHEN Method IN ('S', 'SP', 'SA', 'SN') 
THEN 1 ELSE 0 END) * 100.0 / 
COUNT(*) AS DECIMAL(18,2)) AS Clearance_Rate_Percentage
FROM [Melbourne housing details]


-- Top month for sales
Select
	CONVERT(nvarchar(7), Date, 120) AS Year_Month,
	Sum(cast(Price AS DECIMAL(18,2))) as Total_Price
	From [Melbourne housing details]
	Where date is not null
	And Price is not null
	Group by CONVERT(nvarchar(7), Date, 120)
	Order by Total_Price desc

--Council Area With Most Properties Sold According to Methods
With top5 as (
	Select 
	CouncilArea, Count(*) as Total_property_sold
From [Melbourne housing details]
Where Method in ('S' , 'SP' , 'SA' , ' , 'SN')
Group by CouncilArea
)
Select top 5 *
From top5
Order by Total_property_sold desc