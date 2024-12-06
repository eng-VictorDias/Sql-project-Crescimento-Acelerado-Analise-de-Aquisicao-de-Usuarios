-- Quantidade de pessoas por tipo de graduação agrupadas por tipo e ordenadas
select     count(lead_id), current_education
from leads_basic_details
group by current_education
order by count(lead_id)
