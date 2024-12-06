-- Média de idade desconsiderando erros de idades superiores a 100
select     avg(age)
from leads_basic_details
where age < 100
