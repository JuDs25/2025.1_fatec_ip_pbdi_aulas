CREATE TABLE tb_top_youtubers(
 cod_top_youtubers 
	SERIAL PRIMARY KEY,
--rank,youtuber,subscribers,video views,video count,category,started (estrutura csv)
 rank INT,
 youtuber VARCHAR(200),
 subscribers INT,
 video_views INT,
 video_count INT,
 category VARCHAR(200),
 started INT
);

ALTER TABLE tb_top_youtubers
ALTER COLUMN video_views TYPE BIGINT;

SELECT * FROM tb_top_youtubers;

-- Primeiro cursor com anonymous block
 DO $$
--1. declaração do cursor -- esse cursor é unbound (não vinculado), pois quando declaramos não especficamos o SELECT
 DECLARE
 cur_nomes_youtubers REFCURSOR; --para armazenar o nome do youtuber a cada iteração
 v_youtuber VARCHAR(200);
---
--2. abertura do cursor
 BEGIN
 OPEN cur_nomes_youtubers FOR
 SELECT youtuber
 FROM
 tb_top_youtubers;
---
 LOOP
--3. Recuperação dos dados de interesse -- até a variável se tornar falsa
 	FETCH cur_nomes_youtubers INTO v_youtuber;--FETCH (buscar) é uma variável especial que indica
 	EXIT WHEN NOT FOUND; -- FOUND (encontrada)
 	RAISE NOTICE '%', v_youtuber;
 END LOOP;
---
--4. Fechamento do cursos
 CLOSE cur_nomes_youtubers;
 END;
 $$

 -- 2.6 (Cursor não vinculado (unbound) comquery dinâmica: Exibindo os nomes dos
 -- youtubers que começaram a partir de uma no específico) Vejamos como criar um cursor
 -- capaz de operar com uma query qualquer, especificada como uma string

DO $$
DECLARE
	 cur_nomes_a_partir_de REFCURSOR;
	 v_youtuber VARCHAR(200);
	 v_ano INT := 2008;
	 v_nome_tabela VARCHAR(200) := 'tb_top_youtubers';
BEGIN
 	OPEN cur_nomes_a_partir_de FOR EXECUTE
 		format
 		(
 			'
			SELECT
 				youtuber
 			FROM
				 %s
 			WHERE started >= $1
 			'
 			,
 			v_nome_tabela
 		)USING v_ano;
	LOOP
 		FETCH cur_nomes_a_partir_de INTO v_youtuber;
 		EXIT WHEN NOT FOUND;
 		RAISE NOTICE '%', v_youtuber;
 	END LOOP;
 	CLOSE cur_nomes_a_partir_de;
 END;
 $$


-- Cursos vinculado (bound) 
-- concatenar nome e número de inscritos
-- query estática, não dinâmica


DO $$
DECLARE--cursor vinculado (bound)
	 cur_nomes_e_inscritos CURSOR FOR SELECT youtuber, subscribers FROM
	 tb_top_youtubers;	
	 tupla RECORD;
	 resultado TEXT DEFAULT '';
BEGIN
	--2.abertura
	OPEN cur_nomes_e_inscritos;
	FETCH cur_nomes_e_inscritos INTO tupla;
	WHILE FOUND LOOP
		resultado:= resultado || tupla.youtuber || ':' || tupla.subscribers || ',';
-- pular linhar - controlador - atualização
-- 3. Recuperar linhas
	FETCH cur_nomes_e_inscritos INTO tupla;
	END LOOP;
-- 4. Fechamento 
	CLOSE cur_nomes_e_inscritos;
	RAISE NOTICE '%', resultado;
END;
$$

--  (Cursor: Parâmetros nomeados e pela ordem) Um cursor pode receber parâmetros. Eles
-- podem ser especificados por ordem e também por nome. No Bloco de Código 2.8.1
-- exibimos os nomes dos youtubers que começaram a partir de 2010 e que têm, pelo menos,
-- 60 milhões de inscritos. Ilustramos as duas formas de passagem de parâmetro
DO $$
DECLARE
	v_ano INT := 2010;
	v_inscritos INT := 60_000_000;
	v_youtuber VARCHAR(200);
	--1. Declaração cursor - se ele é do tipo cursor ele é vinculado, se não seria REF cursor
	cur_ano_inscritos 
	CURSOR (ano INT, inscritos INT)
	FOR SELECT youtuber FROM
	tb_top_youtubers WHERE
	started >= ano
		AND subscribers >= inscritos;
BEGIN
	-- 2. Abertura de função
	OPEN cur_ano_inscritos (ano := v_ano, 
	inscritos := v_inscritos);
	LOOP
		FETCH cur_ano_inscritos INTO v_youtuber;
	EXIT WHEN NOT FOUND;
	RAISE NOTICE '%', v_youtuber;
	END LOOP;
	-- 4. Fechamento
	CLOSE cur_ano_inscritos;
END;
$$

-- UPDATE E DELETE com cursores

-- remover tuplas em que video_count é desconhecido -> NULL
-- exibir as tuplas remascentes de baixo para cima

SELECT * FROM tb_top_youtubers 
WHERE video_count IS NULL;


DO $$
DECLARE
	--1. Declaração
	cur_delete REFCURSOR;-- não vinculado
	tupla RECORD; -- estrutura complexa composta por mais de um campo
BEGIN
	--2. Abertura
	OPEN cur_delete SCROLL FOR-- quero subir e descer
	SELECT * FROM tb_top_youtubers;
	LOOP
	-- 3. Recuperação de dados
		FETCH cur_delete INTO tupla;
		EXIT WHEN NOT FOUND;
		IF tupla.video_count IS NULL THEN 
			DELETE FROM tb_top_youtubers
			WHERE CURRENT OF cur_delete;
		END IF;
	END LOOP;
-- loop para exibir item a item, de baixo para cima
 	LOOP
	-- 3. Recuperação de dados
 		FETCH BACKWARD FROM cur_delete INTO tupla;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE '%', tupla;
	END LOOP;
	-- 4. Fechamento
	CLOSE cur_delete;
END;
$$














