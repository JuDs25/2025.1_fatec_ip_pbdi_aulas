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