
# 📊 Crescimento Acelerado: Análise de Aquisição de Usuários

Esse projeto consiste em apoiar o crescimento estratégico de uma empresa de tecnologia educacional (Edtech). A empresa está focada em aumentar significativamente o número de usuários cadastrados em sua plataforma, visando acelerar sua expansão no mercado.

Para isso, você foi encarregado de realizar uma análise detalhada sobre a aquisição de clientes, abrangendo diversas dimensões relacionadas ao comportamento dos usuários. Entender os fatores que impulsionam o crescimento de novos usuários, identificar gargalos no funil de aquisição e fornecer insights acionáveis para estratégias mais eficazes 

Este dashboard, construído no Metabase, apresenta um perfil analítico focado em Geração de Leads e Performance de Marketing/Vendas. Ele cruza dados demográficos com o comportamento de aquisição de clientes durante o primeiro bimestre de 2022.


# Objetivos
Acelerar o crescimento da empresa aumentando o número de usuários cadastrados
# Tarefas do Projeto

    1.  Acessar ambiente Metabase e realizar consultas do banco de dados
    2.	Entendimento dos dados
    3.	Entendimento das tabelas
    4.  Tratamento dos Dados
    5.	Relacionamento entre tabelas
    6.	Criação de Dashboard


## Modelagem e tratamento dos dados
Para transformar dados brutos em um dashboard funcional utilizei o Metabase, para a visisualização e apresentação dos dados, que por sua vez, usa o SQL como linguagem de manipulação, tratamento e modelagem. 

#### Média de Idade

Média de idade desconsiderando erros de idades superiores a 100.


``` 
            select     
                avg(age)
            from leads_basic_details
            where age < 100)
``` 


O código para a Média de Idade não é apenas um cálculo aritmético simples.

A cláusula WHERE age < 100 é uma técnica de limpeza de dados. Em sistemas de cadastro, é comum encontrar erros de preenchimento (como idades "999"). Sem esse filtro, um único erro elevaria a média de 21 anos para um número irreal, distorcendo a compreensão do público-alvo.

#### Segmentação Demográfica (Gênero e Escolaridade)
Estes dois códigos (Quantidade de pessoas por Gênero e por tipo de graduação) seguem a lógica de distribuição de frequência.

O que fazem: Combinam COUNT(lead_id) com GROUP BY.

``` 
            select 
                count(lead_id), gender
            from leads_basic_details
            group by gender

``` 

No caso do Gênero, o agrupamento prepara os dados para um gráfico de pizza/rosca, onde o Metabase calcula automaticamente a porcentagem (55% vs 45%).

Na Escolaridade, o uso de ORDER BY count(lead_id) é fundamental para o gráfico de barras. Isso garante que o visual apresente um "ranking" (do menor para o maior), facilitando a identificação imediata de que o perfil B.Tech é o mais presente.

```
            select
                 count(lead_id), current_education
            from leads_basic_details
            group by current_education
            order by count(lead_id)
```

#### Filtro de Engajamento (Médias de Watched)
Este código para a tabela de idiomas introduz uma camada de regra de negócio.

O que faz: Calcula a média da porcentagem assistida, mas inclui o filtro WHERE watched_percentage > 0.5.
```
            select
                language as Idioma,
                avg(watched_percentage) as 'Porcentagem’
            from leads_demo_watched_details
            where watched_percentage > 0.5 
            group by language

```

Por que foi feito assim: Decidi focar no "Lead Qualificado". Ao descartar quem assistiu menos de 50%, a média resultante reflete o comportamento apenas dos usuários que realmente demonstraram interesse no conteúdo, evitando que "curiosos" baixem a métrica.

#### Inteligência Relacional (Ligações por Plataforma)
Este código utiliza Joins e Normalização.

```
            select    	 
                count(leads_interaction_details.lead_id) as 'Qtd.Ligações’ , cast(leads_interaction_details.call_done_date as date) as 'Data’ ,    leads_basic_details.lead_gen_source as 'Plataforma'    
            from leads_interaction_details
            left join leads_basic_details on leads_interaction_details.lead_id = leads_basic_details.lead_id
            where call_status = 'successful’
            group by Data, Plataforma
```

Utilizei: * LEFT JOIN: Unindo a tabela de interações (ligações) com a tabela básica (origem do lead).

CAST(... as date): Transformando um carimbo de data/hora (timestamp) em apenas data.

WHERE call_status = 'successful': Filtrei apenas o sucesso operacional.

Por que foi feito assim: O Join é necessário porque a informação de "qual plataforma gerou o lead" não está na mesma tabela de "quando ligamos para ele".

O Cast é o que permite que o gráfico de linhas seja contínuo por dia. Se usasse o horário exato, o gráfico ficaria "quebrado" e impossível de ler.

O filtro de sucesso garante que o gráfico mostre a produtividade real da equipe de vendas, e não apenas o volume de tentativas falhas.

## Interpretação técnica dos dados

#### Perfil Demográfico dos Leads

Composição de Gênero: Com uma amostra total de 360 indivíduos, há uma predominância feminina (55%) sobre a masculina (45%). Isso indica que as campanhas estão ressoando levemente mais com o público feminino.

Juventude do Público: A Média de Idade de 21 anos sugere um público muito jovem, provavelmente estudantes ou recém-formados iniciando a carreira profissional.

#### Qualificação por Escolaridade
O gráfico de barras central é um dos mais reveladores para a estratégia do negócio:

Viés Acadêmico: Existe uma correlação direta onde, quanto maior o grau de instrução, maior o volume de leads. O pico está em B.Tech (Bacharelado em Tecnologia), seguido por pessoas que estão ativamente "Procurando emprego" (Looking for Job).

Insight: Isso sugere que o produto ou serviço oferecido é de alto interesse para perfis técnicos ou para quem busca inserção no mercado de trabalho.

#### Engajamento de Conteúdo (Médias de Watched)
A tabela lateral monitora o consumo de vídeo ou aulas por idioma:

Consumo por Idioma: Os leads que falam Telugu (0.76) apresentam um engajamento maior (assistem a mais tempo de conteúdo) do que os de língua Hindi (0.69). Isso pode orientar a priorização de criação de conteúdo ou suporte em dialetos específicos.

#### Dinâmica de Canais e Operação (Ligações Atendidas)
O gráfico de linhas na base do dashboard monitora o volume diário de conversões/atendimento por origem:

Volatilidade Diária: O gráfico mostra picos de atividade intensos seguidos de vales. Picos significativos por volta de 23 de janeiro e 22 de fevereiro.

Dominância de Canais:

SEO e Website (amarelo e laranja): Frequentemente aparecem no topo dos picos, sugerindo que o tráfego orgânico e direto é o mais forte.

Social Media e Email Marketing: Apresentam uma constância menor, mas contribuem para o volume total.

Gap de Dados: Há um período de "platô" ou baixa atividade entre o final de janeiro e meados de fevereiro, o que pode indicar uma pausa em campanhas ou um intervalo na coleta de dados.



## Visualize o dashboard







## Tecnologias Utilizadas


![image](https://img.shields.io/badge/Microsoft_SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![image](https://img.shields.io/badge/Metabase-509EE3?style=for-the-badge&logo=metabase&logoColor=fff)

