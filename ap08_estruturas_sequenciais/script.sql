-- para comentar de forma unificada -> Ctrl + ;
DO $$
DECLARE
    n1 NUMERIC (5, 2);
    n2 INT;
    limite_inferior INT:= 5;
    limite_superior INT := 17;
BEGIN
    -- 0 <= n1 < 1 (real) [0,1) -> similar a isso
    n1 := random(); -- gerando num aleatório
    RAISE NOTICE 'n1: %', n1;
    -- 1 <= n1 < 10 (real) [1,10) -> similar a isso
    -- percentual de 90% de 9, mas não é 9, chega até 8,99999....
    n1 := 1 + random() * 9;
    RAISE NOTICE '%', n1;
    -- random () * 10 dá até 9,9999, então a expressão random() * 10 + 1 dá 10,9999
    n2 := random() * 10 + 1;
    -- intervalo de 01 a 10 -- floor -- chão, é de 1 a 10, para 0,42 o floor é 0, para 1,30 o floor é 1..
    n2 := floor(random() * 10 + 1)::INT;
    RAISE NOTICE 'n2: %', n2;
    -- inferior e o superior + 1
    -- random é de 0 a 1, exceto 1, nunca será 100%
    n2 := floor(random() * (limite_superior - limite_inferior + 1 ) + limite_inferior)::INT;
    RAISE NOTICE 'Intervalo qualquer: %', n2;
END;
$$

-- Variáveis
-- DO -- faça
-- $$
-- DECLARE -- através da declaração das variáveis
--     v_codigo INTEGER := 1;
--     v_nome_completo VARCHAR(200) := 'João';
--     v_salario NUMERIC (11, 2) := 20.5;
-- BEGIN -- BEGIN começar -- print
--     RAISE NOTICE 'Meu código é %, me chamo % e meu salário é %.', v_codigo, -- RAIZE NOTICE plantar anuncio 
--     v_nome_completo, v_salario; 
-- END; -- finalizar
-- $$


--placeholders de expressão em strings
-- DO
-- $$
-- BEGIN
--     RAISE NOTICE '% + % = %', 2, 2, 2 + 2;
-- END;
-- $$

-- -- CREATE DATABASE "2025_fatec_pbdi_juliaa"
-- -- DO
-- -- $$
-- -- BEGIN
-- --     RAISE NOTICE "Meu primeiro bloquinho anônimo";
-- -- END;
-- CREATE DATABASE "20251_fatec_ipi_pbdi_juliaa"
-- -- $$