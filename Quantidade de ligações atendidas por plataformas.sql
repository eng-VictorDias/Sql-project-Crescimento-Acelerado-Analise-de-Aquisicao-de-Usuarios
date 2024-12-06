-- Quantidade de ligações atendidas por plataformas ao longo do tempo
select    	 count(leads_interaction_details.lead_id) as 'Qtd.Ligações’ ,    	cast(leads_interaction_details.call_done_date as date) as 'Data’ ,    leads_basic_details.lead_gen_source as 'Plataforma'    
from leads_interaction_details
left join leads_basic_details on leads_interaction_details.lead_id = leads_basic_details.lead_id
where call_status = 'successful’
group by Data, Plataforma
