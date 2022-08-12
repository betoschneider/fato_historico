--esta consulta faz fotografias mensais
--dos registros na tabela marcos
select base.dt_referencia
    ,base.id_entrega
    ,base.valor_tecnico
    ,base.valor_comercial
from (--consulta com join e o numero da linha de cada calendario.dt e marcos.id_entrega
    select row_number() over(partition by calendario.dt, marcos.id_entrega order by marcos.id_entrega asc, marcos.dt_marco desc) as sequencia
        ,calendario.dt as dt_referencia
        ,marcos.id_entrega
        ,marcos.dt_marco
        ,marcos.valor_tecnico
        ,marcos.valor_comercial
    from (--range de datas: da menor para a maior data da tabela marcos
        select (select min(dt_marco) from marcos) + level - 1 dt
        from dual
        connect by level <= (
        (select max(dt_marco) from marcos) - (select min(dt_marco) from marcos) + 1
        ) 
        ) calendario
    left join marcos --tabela com valores e datas intervaladas
        on to_char(calendario.dt, 'dd') = 01 --join apenas no primeiro dia do mês
        and calendario.dt >= marcos.dt_marco
                
    where marcos.id_marco is not null --despresa valores nulos
    ) base
where base.sequencia = 1 --apenas o top 1