-- using database
use india_census;

-- rename the tables
RENAME TABLE growth_sratio TO Data1;
RENAME TABLE population TO Data2;

-- How data look 
select * from data1;
select * from data2;

-- number of rows into our data set
select count(*) from india_census.Data1;
select count(*) from india_census.Data2;

-- dataset for Maharashtra and Goa
select * from Data1 where  state in ('Maharashtra','Goa');

-- population of india
select sum(population) AS Total_Population from data2;

-- Average growth by state
select state,round(avg(Growth),2) as avg_growth from data1
group by state;

-- Average Sex_ratio by state
select state, round(avg(Sex_ratio)) as avg_Sex_Ratio from data1 
group by state
order by avg_Sex_Ratio DESC ;

-- Avg Literacy rate
select State , round(avg(Literacy)) as Avg_Literacy_rate
from data1 
group by state
having Avg_Literacy_rate >= 90
order by Avg_Literacy_rate;

-- top 3 state showing highest growth ratio
select state,round(avg(Growth),2) as avg_growth from data1
group by state
order by avg_growth desc
limit 3;

-- top 3 states having lowest sex ratio
select state, round(avg(Sex_ratio)) as avg_Sex_Ratio from data1 
group by state
order by avg_Sex_Ratio  
limit 3;

-- letter starting with letter a
select distinct state, Growth from data1 where state like 'a%' ;

-- joining both table
select d1.state,d1.District,d1.Sex_Ratio, d2.Population
from data1 as d1
join data2 as d2 on d1.District = d2.District;

-- calculating percentage of population male and female
select d1.state,d1.District,d1.Sex_Ratio, d2.Population, round((1000/(Sex_Ratio+1000))*100,2) as malepercentage , 
(select 100-malepercentage )as femalepercentage
from data1 as d1
join data2 as d2 on d1.District = d2.District;

-- top and bottom  3 states Literacy rate
SELECT top_states.state AS top_state, top_states.top_literacy,
       low_states.state AS low_state, low_states.low_literacy
FROM (
    SELECT state, ROUND(AVG(Literacy)) AS top_literacy,
           ROW_NUMBER() OVER (ORDER BY ROUND(AVG(Literacy)) DESC) AS top_rank
    FROM data1
    GROUP BY state
) AS top_states
JOIN (
    SELECT state, ROUND(AVG(Literacy)) AS low_literacy,
           ROW_NUMBER() OVER (ORDER BY ROUND(AVG(Literacy)) ASC) AS low_rank
    FROM data1
    GROUP BY state
) AS low_states
ON top_states.top_rank = low_states.low_rank
WHERE top_states.top_rank <= 3 AND low_states.low_rank <= 3;

-- population in previous census
SELECT d1.state, d1.District, d1.Growth, d2.population, (d2.population / ((d1.Growth / 100) + 1)) AS previous_population
FROM data1 AS d1
JOIN data2 AS d2 ON d1.District = d2.District;

-- Removing % symbol from Growth column
UPDATE data1
SET Growth = REPLACE(Growth, '%', '');

-- top 3 districts from each state with highest literacy rate
select a.* from
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from data1) a
where a.rnk in (1,2,3) order by state




















