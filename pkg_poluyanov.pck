CREATE OR REPLACE PACKAGE pkg_poluyanov
AS
PROCEDURE make_agr_budget_fin;
PROCEDURE make_country_final;
PROCEDURE make_country_final_agr;
END pkg_poluyanov;
/
CREATE OR REPLACE PACKAGE BODY pkg_poluyanov
AS

PROCEDURE make_agr_budget_fin
  is
  begin
  
  EXECUTE IMMEDIATE 'truncate table poluyanov_va_budget_fin DROP STORAGE';   
  
insert into poluyanov_va_budget_fin (c_name, c_sum)
select t1.c_name, sum(t1.c_price)
from poluyanov_va_budget t1
group by c_name
order by 1;

commit;

END make_agr_budget_fin;

                    PROCEDURE make_country_final
                    is
                    begin
                    EXECUTE IMMEDIATE 'truncate table country_final DROP STORAGE';

                    insert into country_final
                    (
                    c_name
                    ,c_full_name
                    ,c_continent
                    ,c_location
                    ,c_af
                    ,c_reserve
                    ,c_people)
                    SELECT
                        c.c_name,
                        c.c_full_name,
                        c.c_continent,
                        c.c_location,
                        af.c_af,
                        af.c_reserve,
                        p.c_people
                    FROM country c
                    JOIN population p on c.c_name = p.c_name
                    JOIN af on c.c_name = af.c_name
                    order by 1;
                    commit;
                    EXECUTE IMMEDIATE 'truncate table country DROP STORAGE';
                    EXECUTE IMMEDIATE 'truncate table population DROP STORAGE';
                    EXECUTE IMMEDIATE 'truncate table af DROP STORAGE'; 
                    END make_country_final;
                    
                    PROCEDURE make_country_final_agr
                      is
                    begin
                      EXECUTE IMMEDIATE 'truncate table country_final_agr DROP STORAGE'; 
                      insert into country_final_agr
                    (
                    c_continent
                    ,c_af
                    ,c_reserve_af
                    ,c_total_af
                    ,c_people)
                    SELECT c_continent,
                      sum(c_af),
                      sum(c_reserve),
                      sum (c_af  + c_reserve),
                      sum(c_people)
                    FROM country_final
                    GROUP BY c_continent
                    order by 1, 2 desc;
                    commit;
                    END make_country_final_agr;

END pkg_poluyanov;
/
