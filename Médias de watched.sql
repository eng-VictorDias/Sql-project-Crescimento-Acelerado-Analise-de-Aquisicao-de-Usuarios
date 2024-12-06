-- Médias de watched que possuam porcentagem maior que 0.5, agrupadas por idioma
select     language as Idioma,
     avg(watched_percentage) as 'Porcentagem’
from leads_demo_watched_details
where watched_percentage > 0.5 
group by language
