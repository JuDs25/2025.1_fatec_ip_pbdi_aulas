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

-- 03.06.2025 
CREATE OR REPLACE FUNCTION fn_log_pessoa_insert()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO tb_auditoria
    (cod_pessoa, nome, idade, saldo_antigo, saldo_atual)
    VALUES
    (NEW.cod_pessoa, NEW.nome, NEW.idade, NULL, NEW.saldo);
    RETURN NULL;
END;
$$

SELECT * FROM tb_pessoa;

INSERT INTO tb_pessoa
(nome, idade, saldo) VALUES
('João', 20, 100),
('Pedro', 22, -100),
('Maria', 22, 400);

-- escrever uma function que devolve trigger
-- é uma função de validação de saldo
-- se o saldo for pelo menos zero, deixar a operação acontecer
-- caso contrário, não deixar
-- além disso, exibir o saldo, caso ele seja inválido

CREATE OR REPLACE FUNCTION fn_valida_saldo()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.saldo >= 0 THEN
        RETURN NEW;
    ELSE
        RAISE NOTICE 'O saldo é inválido %', NEW.saldo;
        RETURN NULL;
    END IF;
END;
$$

-- criar um trigger para vincular a função à tabela
-- ele deve executar antes de insert e de update também

CREATE OR REPLACE TRIGGER tg_valida_saldo
BEFORE INSERT OR UPDATE ON tb_pessoa
FOR EACH ROW
EXECUTE FUNCTION fn_valida_saldo();

CREATE TABLE IF NOT EXISTS tb_pessoa(
    cod_pessoa SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    idade INT NOT NULL,
    saldo NUMERIC(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_auditoria(
    cod_auditoria SERIAL PRIMARY KEY,
    cod_pessoa INT NOT NULL,
    idade INT NOT NULL,
    saldo_antigo NUMERIC(10,2),
    saldo_atual NUMERIC(10,2)
);

-- aula que assisti

CREATE OR REPLACE TRIGGER tg_log_pessoa_insert
AFTER INSERT ON tb_pessoa
FOR EACH ROW
    EXECUTE PROCEDURE fn_log_pessoa_insert();

INSERT INTO tb_pessoa(nome, idade, saldo)
VALUES
('Ana', 20, 100),
('Paula', 30, 200),
('Isabela', 20, 500);

SELECT * FROM tb_auditoria;
ALTER TABLE tb_auditoria ADD COLUMN 
    IF NOT EXISTS nome VARCHAR (200) NOT NULL;

-- Trigger updates - alteração de saldos - auditoria
-- Ordem de execução dos triggers - nome - ordem alfabetica
CREATE OR REPLACE FUNCTION fn_log_pessoa_update()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
-- insert na tabela auditoria
-- registrando os dados novos, e incluindo o saldo antigo
    INSERT INTO tb_auditoria
    (cod_pessoa, nome, idade, saldo_antigo, saldo_atual)
    VALUES
    (NEW.cod_pessoa, NEW.nome, NEW.idade, OLD.saldo, NEW.saldo);
    RETURN NEW; -- update com dados novos
END;
$$

UPDATE tb_pessoa
SET saldo = 300
WHERE cod_pessoa = 1

CREATE OR REPLACE TRIGGER tg_log_pessoa_update
AFTER UPDATE ON tb_pessoa
FOR EACH ROW
    EXECUTE PROCEDURE fn_log_pessoa_update();

