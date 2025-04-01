-- Criando a função de valor aleatório
CREATE OR REPLACE FUNCTION valor_aleatorio_entre (lim_inferior INT, lim_superior
 INT) RETURNS INT AS
 $$
 BEGIN
 RETURN FLOOR(RANDOM() * (lim_superior - lim_inferior + 1) + lim_inferior)::INT;
 END;
 $$ LANGUAGE plpgsql;

-- IGNORANDO ITERAÇÕES CONTINUE
-- DO $$
-- DECLARE
--     contador INT:= 0;
-- BEGIN
--     LOOP
--         contador:= contador + 1;
--         EXIT WHEN contador > 100; -- para o loop inteiro
--         IF contador % 7 = 0 THEN -- ignore os múltiplos de 7
--             CONTINUE; -- para apenas o loop atual
--         END IF;
--         CONTINUE WHEN contador % 11 = 0; -- ignore os múltiplos de 11
--         RAISE NOTICE '%', contador;
--     END LOOP;
-- END;
-- $$

-- DO $$
-- DECLARE
--     contador INT := 1;
-- BEGIN
--     LOOP
--         RAISE NOTICE '%', contador;
--         contador := contador + 1;
--         IF contador > 10 THEN
--             EXIT;
--         END IF;
--     END LOOP;
-- END;
-- $$

-- EXIT / WHEN
-- DO $$
-- DECLARE
--     contador INT:= 1;
-- BEGIN
--     LOOP
--         RAISE NOTICE '%', contador;
--         contador:= contador + 1;
--         EXIT WHEN contador > 10;
--     END LOOP;
-- END;
-- $$

-- DO $$
-- BEGIN
--     -- esse é um loop infinito, não execute!
--     LOOP
--         RAISE NOTICE 'Um loop simples...';
--     END LOOP;
-- END;
-- $$

-- CRIANDO TABELA
CREATE TABLE tb_aluno(
    cod_aluno SERIAL PRIMARY KEY,
    nota INT
);

-- INSERINDO DADOS NA TABELA
DO $$
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO tb_aluno
        (nota)
        VALUES
        (valor_aleatorio_entre (0,10)); -- precisa rodar a função -- já rodei
    END LOOP;
END;
$$

-- VERIFICAR TODOS OS DADOS DA TABELA
SELECT * FROM tb_aluno;

-- ITERAR SOBRE OS RESULTADOS DE UMA TABELA
-- RECORD - representar a linha de uma tabela independente da estrutura
DO $$
DECLARE
    aluno RECORD;
    media NUMERIC(10,2):= 0;
    total_alunos INT;
BEGIN
    FOR aluno IN 
        SELECT * FROM tb_aluno
    LOOP
        RAISE NOTICE 'Nota do aluno %: %', 
        aluno.cod_aluno, aluno.nota;
        media:= media + aluno.nota;
    END LOOP;
    SELECT COUNT (*) FROM tb_aluno INTO total_alunos;
    RAISE NOTICE 'Média: %', media / total_alunos;
END;
$$

-- DECLARAÇÃO DE VETORES
DO $$
DECLARE
    valores INT []:= ARRAY [
        valor_aleatorio_entre(1,10),
        valor_aleatorio_entre(1,10),
        valor_aleatorio_entre(1,10),
        valor_aleatorio_entre(1,10),
        valor_aleatorio_entre(1,10)
    ];
    valor INT;
    soma INT:= 0;
BEGIN
-- iteração com FOREACH
    FOREACH valor IN ARRAY valores LOOP
        RAISE NOTICE 'Valor da vez: %', valor;
        soma:= soma + valor; -- acumulador
    END LOOP;
    RAISE NOTICE 'Soma: %', soma;
END;
$$

-- FOREACH com fatias (slice)
DO $$
DECLARE
    vetor INT[]:= ARRAY[1, 2, 3];
    matriz INT[]:= ARRAY[ -- construção de matriz - vetor de vetor
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
    ];
    var_aux INT;
    vet_aux INT[];
BEGIN
    RAISE NOTICE 'SLICE %, vetor', 0; -- escalar
    FOREACH var_aux IN ARRAY vetor LOOP
        RAISE NOTICE '%', var_aux;
    END LOOP;

    RAISE NOTICE 'SLICE %, vetor', 1;
    FOREACH vet_aux SLICE 1 IN ARRAY vetor LOOP
        RAISE NOTICE '%', vet_aux;
    END LOOP;

    RAISE NOTICE 'SLICE %, matriz', 0;
    FOREACH var_aux IN ARRAY matriz LOOP
        RAISE NOTICE '%', var_aux;
    END LOOP;

    RAISE NOTICE 'SLICE %, matriz', 1;
    FOREACH vet_aux SLICE 1 IN ARRAY matriz LOOP
        RAISE NOTICE '%', vet_aux;
    END LOOP;

    RAISE NOTICE 'SLICE %, matriz', 2; -- O número do Slice é quantidade de dimensões, no caso dessa matriz é de dimensão 2
    FOREACH vet_aux SLICE 2 IN ARRAY matriz LOOP
        RAISE NOTICE '%', vet_aux;
    END LOOP;
END;
$$

-- TRATAMENTO DE ERROS
-- Exemplo:
DO $$
BEGIN
    RAISE NOTICE '%', 1 / 0;
    RAISE NOTICE 'Acabou...'; -- não executa se o primeiro der erro
END;
$$
-- 

DO $$
BEGIN
    RAISE NOTICE '%', 1 / 0;
    RAISE NOTICE 'Acabou...'; -- não executa se o primeiro der erro
    EXCEPTION
        WHEN division_by_zero THEN
            RAISE NOTICE 'Não divida por zero';
END;
$$