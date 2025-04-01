--ddmmaaaa (validar a data)
DO $$
DECLARE
    -- testar
    -- 22/10/2022: válida
    -- 29/02/2020: válida
    -- 29/02/2021 : inválida
    -- 28/02/2021: válida
    -- 31/09/2025 : inválida
    -- 31/06/2025 : inválida
    data INT := 29022025;
    dia INT;
    mes INT;
    ano INT;
    data_valida BOOL := TRUE;
BEGIN
    dia := data / 1000000; -- [22], 102022
    mes := data % 1000000 / 10000; -- [102022] / 10000 = [10] 
    ano := data % 10000; -- 2.210,[2022]
    RAISE NOTICE '%/%/%', dia, mes, ano;
    RAISE NOTICE 'Vejamos se ela é válida...';
    IF ano >= 1 THEN
        CASE
            WHEN mes > 12 OR mes < 1 OR dia < 1 OR  dia > 31 THEN
                data_valida := FALSE;
            ELSE
                IF (mes IN (4, 6, 9, 11)) AND dia > 30 THEN
                    data_valida := FALSE;
                ELSE
                    IF mes = 2 THEN
                        CASE
                            WHEN (ano % 4 = 0 AND ano % 100 <> 0 ) OR ano % 400 = 0 THEN
                                IF dia > 29 THEN
                                    data_valida := FALSE;
                                END IF;
                            ELSE
                                IF dia > 28 THEN
                                    data_valida:= FALSE;
                                END IF;
                        END CASE;
                    END IF;
                END IF;
        END CASE;        
    ELSE
        data_valida:= FALSE;
    END IF;
    CASE
        WHEN data_valida THEN
            RAISE NOTICE 'Data válida';
        ELSE
            RAISE NOTICE 'Data Inválida';
    END CASE;
END;
$$




-- DO $$
-- DECLARE
--     a INT := valor_aleatorio_entre(0,20);
--     b INT := valor_aleatorio_entre(0,20);
--     c INT := valor_aleatorio_entre(0,20);
--     delta NUMERIC (10,2);
--     raizUm NUMERIC(10,2);
--     raizDois NUMERIC(10,2);
-- BEGIN
--     -- ax^2 + bx + c = 0
--     -- unicode - código raiz quadrada
--     -- U& -> linguagem PLPGSQL
--     RAISE NOTICE '%x% + %x + % = 0', a, U&'\00B2', b, c;
--     IF a = 0 THEN
--         RAISE NOTICE 'Não é equação do segundo grau';
--     ELSE
--         delta := b ^ 2 - 4 * a * c; -- ":=" declaração, similar ao "=" do python
--         RAISE NOTICE 'Delta: %', delta;
--         IF delta < 0 THEN
--             RAISE NOTICE 'Não tem raiz';
--         ELSEIF delta = 0 THEN
--             raizUm := -1 * b / (2 * a);
--             RAISE NOTICE 'Teve uma raiz, Essa aqui: %', raizUm;
--         ELSE
--             raizUm := (-1 * b + |/delta) / (2 * a);
--             raizDois := (-1 * b - |/delta) / (2 * a);
--             RAISE NOTICE 'Duas raízes. Observe: % e %', raizUm, raizDois;
--         END IF;
--     END IF;
-- END;
-- $$


-- DO $$
-- DECLARE
--     valor INT := valor_aleatorio_entre(1, 12);
--     mensagem VARCHAR (200);
-- BEGIN
--     RAISE NOTICE 'O valor da vez é %', valor;
--     CASE valor -- Case é inspeccionar 
--         WHEN 1, 3, 5, 7, 9 THEN
--             mensagem := 'Ímpar';
--         WHEN 2, 4, 6, 8, 10 THEN
--             mensagem := 'Par';
--         ELSE
--             mensagem := 'Fora do Intervalo';
--     END CASE;
--     RAISE NOTICE '%', mensagem;
-- END;
-- $$
-- DO $$
-- DECLARE
--     v_valor INT;
-- BEGIN
--     v_valor := valor_aleatorio_entre(1,50);
--     IF v_valor <=20  THEN
--         RAISE NOTICE 'A metade de % é %', v_valor, v_valor / 2::FLOAT;
--     END IF;
-- END;
-- $$


-- CREATE OR REPLACE FUNCTION valor_aleatorio_entre (lim_inferior INT, lim_superior
-- INT) RETURNS INT AS
-- $$
-- BEGIN
-- RETURN FLOOR(RANDOM() * (lim_superior - lim_inferior + 1) + lim_inferior)::INT;
-- END;
-- $$ LANGUAGE plpgsql;



-- EXPLICAÇÃO DA ESTRUTURA -> CASE WHEN THEN
-- CASE
--     WHEN idade < 18 THEN 'Menor de idade'
--     WHEN idade < 60 THEN 'Adulto'
--     ELSE 'Idoso'
-- END AS faixa_etaria

-- Em "português SQLês", seria tipo:

-- Caso seja idade menor que 18, então 'Menor de idade';
-- Quando for menor que 60, então 'Adulto';
-- Senão, 'Idoso'.
