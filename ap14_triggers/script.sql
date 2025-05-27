CREATE TABLE tb_teste_trigger(
    cod_teste_trigger SERIAL PRIMARY KEY,
    texto VARCHAR (200)
);

-- Fuction  - tipo procedure - que dá opção de RETURN
CREATE OR REPLACE FUNCTION fn_antes_de_um_insert() -- talvez não seja uma boa ideia deixar o que a função faz aqui
RETURNS TRIGGER -- devolvo um trigger - indicativo
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Trigger foi chamado antes do INSERT!';
    RETURN NULL; -- imperativo - ordem
END;
$$

-- associar à tabela tb_teste_trigger
CREATE OR REPLACE TRIGGER tg_antes_do_insert
BEFORE INSERT ON tb_teste_trigger
FOR EACH STATEMENT
-- aqui você pode falar FUNCTION ou PROCEDURE (mas não ROOUTINE)
EXECUTE PROCEDURE fn_antes_de_um_insert();

-- teste com insert
INSERT INTO tb_teste_trigger (texto)
VALUES('testando trigger');

-- after insert - NOVA FUNÇÃO
CREATE OR REPLACE FUNCTION fn_depois_de_um_insert() -- talvez não seja uma boa ideia deixar o que a função faz aqui
RETURNS TRIGGER -- devolvo um trigger - indicativo
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Trigger foi chamado depois do INSERT!';
    RETURN NULL; -- imperativo - ordem
END;
$$

-- associar à tabela tb_teste_trigger
CREATE OR REPLACE TRIGGER tg_depois_do_insert
AFTER INSERT ON tb_teste_trigger
FOR EACH STATEMENT
-- aqui você pode falar FUNCTION ou PROCEDURE (mas não ROOUTINE)
EXECUTE PROCEDURE fn_depois_de_um_insert();

-- teste com insert
INSERT INTO tb_teste_trigger (texto)
VALUES('testando trigger');

-- criando um novo trigger - validar as ordens de execução

CREATE OR REPLACE TRIGGER tg_antes_do_insert2
BEFORE INSERT ON tb_teste_trigger
FOR EACH STATEMENT
-- aqui você pode falar FUNCTION ou PROCEDURE (mas não ROOUTINE)
EXECUTE PROCEDURE fn_antes_de_um_insert();

CREATE OR REPLACE TRIGGER tg_depois_do_insert2
AFTER INSERT ON tb_teste_trigger
FOR EACH STATEMENT
-- aqui você pode falar FUNCTION ou PROCEDURE (mas não ROOUTINE)
EXECUTE PROCEDURE fn_depois_de_um_insert();

INSERT INTO tb_teste_trigger (texto)
VALUES('testando trigger');

DELETE FROM tb_teste_trigger;
SELECT * FROM tb_teste_trigger

SELECT * FROM tb_teste_trigger_cod_teste_trigger_seq; -- <nome da tabela>_<codigo chave primária>_<seq> - de sequência
ALTER SEQUENCE tb_teste_trigger_cod_teste_trigger_seq
RESTART WITH 1;

DROP TRIGGER IF EXISTS tg_antes_do_insert2
ON tb_teste_trigger;
DROP TRIGGER IF EXISTS tg_depois_do_insert2
ON tb_teste_trigger;

-- Reajuste
CREATE OR REPLACE TRIGGER tg_antes_de_um_insert
BEFORE INSERT OR UPDATE ON tb_teste_trigger
FOR EACH ROW
-- aqui você pode falar FUNCTION ou PROCEDURE (mas não ROOUTINE)
EXECUTE PROCEDURE fn_antes_de_um_insert('Antes:V1', 'Antes:V2'); -- sempre os parametros são str, se quiser trabalhar com num, internamente eu converto

DROP TRIGGER IF EXISTS tg_antes_do_insert
ON tb_teste_trigger;

CREATE OR REPLACE TRIGGER tg_depois_de_um_insert
AFTER INSERT OR UPDATE ON tb_teste_trigger
FOR EACH ROW
-- aqui você pode falar FUNCTION ou PROCEDURE (mas não ROOUTINE)
EXECUTE PROCEDURE fn_depois_de_um_insert('Depois:V1', 'Depois:V2', 'Depois:V3');

DROP TRIGGER IF EXISTS tg_depois_do_insert
ON tb_teste_trigger;

CREATE OR REPLACE FUNCTION fn_antes_de_um_insert() -- talvez não seja uma boa ideia deixar o que a função faz aqui
RETURNS TRIGGER -- devolvo um trigger - indicativo
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Estamos no trigger BEFORE';
    RAISE NOTICE 'OLD: %', OLD;
    RAISE NOTICE 'NEW: %', NEW;
    RAISE NOTICE 'OLD.texto: %', OLD.texto;
    RAISE NOTICE 'NEW.texto: %', NEW.texto;
    RAISE NOTICE 'TG_NAME: %', TG_NAME;
    RAISE NOTICE 'TG_LEVEL: %', TG_LEVEL;
    RAISE NOTICE 'TG_WHEN: %', TG_WHEN;
    RAISE NOTICE 'TG_TABLE_NAME: %', TG_TABLE_NAME;
    FOR i IN 0..TG_NARGS -1 LOOP
        RAISE NOTICE '%', TG_ARGV[i];
    END LOOP;
    RETURN NEW; -- imperativo - ordem
END;
$$

CREATE OR REPLACE FUNCTION fn_depois_de_um_insert() -- talvez não seja uma boa ideia deixar o que a função faz aqui
RETURNS TRIGGER -- devolvo um trigger - indicativo
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Estamos no trigger AFTER!';
    RAISE NOTICE 'OLD: %', OLD;
    RAISE NOTICE 'NEW: %', NEW;
    RAISE NOTICE 'OLD.texto: %', OLD.texto;
    RAISE NOTICE 'NEW.texto: %', NEW.texto;
    RAISE NOTICE 'TG_NAME: %', TG_NAME;
    RAISE NOTICE 'TG_LEVEL: %', TG_LEVEL;
    RAISE NOTICE 'TG_WHEN: %', TG_WHEN;
    RAISE NOTICE 'TG_TABLE_NAME: %', TG_TABLE_NAME;
    FOR i IN 0..TG_NARGS -1 LOOP
        RAISE NOTICE '%', TG_ARGV[i];
    END LOOP;
    RETURN NEW; -- imperativo - ordem
END;
$$

INSERT INTO tb_teste_trigger(texto)
VALUES('novo teste');

SELECT * FROM tb_teste_trigger;

UPDATE tb_teste_trigger
SET texto = 'texto atualizado'
WHERE cod_teste_trigger IN (2,3);
