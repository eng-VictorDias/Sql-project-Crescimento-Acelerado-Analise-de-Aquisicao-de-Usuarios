select 
    count(lead_id), gender
from leads_basic_details
group by gender
