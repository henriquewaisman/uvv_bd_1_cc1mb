mysql -u root -p
computacao@raiz

CREATE USER henrique IDENTIFIED BY '19812019';

CREATE DATABASE uvv;

GRANT ALL ON *.* TO henrique;

EXIT

mysql -u henrique -p
19812019

USE uvv;


CREATE TABLE funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(50),
                sexo CHAR(1),
                salario DECIMAL(10,2),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento INT NOT NULL,
                PRIMARY KEY (cpf)
);

ALTER TABLE funcionario COMMENT 'References

funcionario through (cpf_gerente)
Referenced By

localizacoes_departamento referencing (numero_departamento)
projeto referencing (numero_departamento)';

ALTER TABLE funcionario MODIFY COLUMN cpf CHAR(11) COMMENT 'CPF do funcionário. Será a PK da tabela.';

ALTER TABLE funcionario MODIFY COLUMN primeiro_nome VARCHAR(15) COMMENT 'Primeiro nome do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN nome_meio CHAR(1) COMMENT 'Inicial do nome do meio.';

ALTER TABLE funcionario MODIFY COLUMN ultimo_nome VARCHAR(15) COMMENT 'Sobrenome do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN endereco VARCHAR(50) COMMENT 'Endereço do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN sexo CHAR(1) COMMENT 'Sexo do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN salario DECIMAL(10, 2) COMMENT 'Salário do funcionário.';

ALTER TABLE funcionario MODIFY COLUMN cpf_supervisor CHAR(11) COMMENT 'CPF do supervisor. Será uma FK para a própria tabela (um auto-relacionamento).';

ALTER TABLE funcionario MODIFY COLUMN numero_departamento INTEGER COMMENT 'Número do departamento do funcionário.';


CREATE TABLE dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                PRIMARY KEY (cpf_funcionario, nome_dependente)
);

ALTER TABLE dependente MODIFY COLUMN cpf_funcionario CHAR(11) COMMENT 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';

ALTER TABLE dependente MODIFY COLUMN nome_dependente VARCHAR(15) COMMENT 'Nome do dependente. Faz parte da PK desta tabela.';

ALTER TABLE dependente MODIFY COLUMN sexo CHAR(1) COMMENT 'Sexo do dependente.';

ALTER TABLE dependente MODIFY COLUMN data_nascimento DATE COMMENT 'Data de nascimento do dependente.';

ALTER TABLE dependente MODIFY COLUMN parentesco VARCHAR(15) COMMENT 'Descrição do parentesco do dependente com o funcionário.';


CREATE TABLE departamento (
                numero_departamento INT NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                PRIMARY KEY (numero_departamento)
);

ALTER TABLE departamento MODIFY COLUMN numero_departamento INTEGER COMMENT 'Número do departamento. É a PK desta tabela.';

ALTER TABLE departamento MODIFY COLUMN nome_departamento VARCHAR(15) COMMENT 'Nome do departamento. Deve ser único.';

ALTER TABLE departamento MODIFY COLUMN cpf_gerente CHAR(11) COMMENT 'CPF do gerente do departamento. É uma FK para a tabela funcionários.';

ALTER TABLE departamento MODIFY COLUMN data_inicio_gerente DATE COMMENT 'Data do início do gerente no departamento.';


CREATE UNIQUE INDEX departamento_idx
 ON departamento
 ( nome_departamento );

CREATE TABLE projeto (
                numero_projeto INT NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INT NOT NULL,
                PRIMARY KEY (numero_projeto)
);

ALTER TABLE projeto MODIFY COLUMN numero_projeto INTEGER COMMENT 'Número do projeto. É a PK desta tabela.';

ALTER TABLE projeto MODIFY COLUMN nome_projeto VARCHAR(15) COMMENT 'Nome do projeto. Deve ser único.';

ALTER TABLE projeto MODIFY COLUMN local_projeto VARCHAR(15) COMMENT 'Localização do projeto.';

ALTER TABLE projeto MODIFY COLUMN numero_departamento INTEGER COMMENT 'Número do departamento. É uma FK para a tabela departamento.';


CREATE UNIQUE INDEX projeto_idx
 ON projeto
 ( nome_projeto );

CREATE TABLE trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INT NOT NULL,
                horas DECIMAL(3,1) NOT NULL,
                PRIMARY KEY (cpf_funcionario, numero_projeto)
);

ALTER TABLE trabalha_em MODIFY COLUMN cpf_funcionario CHAR(11) COMMENT 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';

ALTER TABLE trabalha_em MODIFY COLUMN numero_projeto INTEGER COMMENT 'Número do projeto. Faz parte da PK desta tabela e é uma FK para a tabela projeto.';

ALTER TABLE trabalha_em MODIFY COLUMN horas DECIMAL(3, 1) COMMENT 'Horas trabalhadas pelo funcionário neste projeto.';


CREATE TABLE localizacoes_departamento (
                numero_departamento INT NOT NULL,
                local VARCHAR(15) NOT NULL,
                PRIMARY KEY (numero_departamento, local)
);

ALTER TABLE localizacoes_departamento MODIFY COLUMN numero_departamento INTEGER COMMENT 'Número do departamento. Faz parta da PK desta tabela e também é uma FK para a tabela departamento.';

ALTER TABLE localizacoes_departamento MODIFY COLUMN local VARCHAR(15) COMMENT 'Localização do departamento. Faz parte da PK desta tabela.';


ALTER TABLE funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE uvv.funcionario MODIFY COLUMN primeiro_nome varchar(15) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Primeiro nome do funcionário.';
ALTER TABLE uvv.funcionario MODIFY COLUMN ultimo_nome varchar(15) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Sobrenome do funcionário.';
ALTER TABLE uvv.funcionario MODIFY COLUMN numero_departamento int(11) NOT NULL COMMENT 'Número do departamento do funcionário.';
ALTER TABLE uvv.departamento MODIFY COLUMN nome_departamento varchar(15) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Nome do departamento. Deve ser único.';
ALTER TABLE uvv.departamento MODIFY COLUMN cpf_gerente char(11) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'CPF do gerente do departamento. É uma FK para a tabela funcionários.';
ALTER TABLE uvv.projeto MODIFY COLUMN nome_projeto varchar(15) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Nome do projeto. Deve ser único.';
ALTER TABLE uvv.projeto MODIFY COLUMN numero_departamento int(11) NOT NULL COMMENT 'Número do departamento. É uma FK para a tabela departamento.';
ALTER TABLE uvv.trabalha_em MODIFY COLUMN horas decimal(3,1) NOT NULL COMMENT 'Horas trabalhadas pelo funcionário neste projeto.';

insert into funcionario (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, numero_departamento)
values ('Jorge', 'E', 'Brito', '88866555576', '1937-11-10', 'Rua do Horto, 35, São Paulo, SP', 'M', '55000', '1');

insert into funcionario (primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
values ('Jennifer', 'S', 'Souza', '98765432168', '1941-06-20', 'Av. Arthur de Lima, 54, Santo André, SP', 'F', '43.000', '88866555576', '4'),
('Fernando', 'T', 'Wong', '33344555587', '1955-12-05', 'Rua das Lapa, 34, São Paulo, SP', 'M', '40000', '88866555576', '5'),
('Alice', 'J', 'Zelaya', '99988777767', '1968-01-19', 'Rua Souza Lima, 35, Curitiba, PR', 'F', '25000', '98765432168', '4'),
('André', 'V', 'Pereira', '98798798733', '1969-03-29', 'Rua Timbira, 35, São Paulo, SP', 'M', '25000', '98765432168', '4'),
('Ronaldo', 'K', 'Lima', '66688444476', '1962-09-15', 'Rua Rebouças, 65, Piracicaba, SP', 'M', '38000', '33344555587', '5'),
('Joice', 'A', 'Leite', '45345345376', '1972-07-31', 'Av. Lucas Obes, 74, São Paulo, SP', 'F', '25000', '33344555587', '4'),
('João', 'B', 'Silva', '12345678966', '1965-01-09', 'Rua das Flores, 751, São Paulo, SP', 'M', '30000', '33344555587', '5');

insert into departamento (nome_departamento, numero_departamento, cpf_gerente, data_inicio_gerente)
values ('Pesquisa', '5', '33344555587', '1988-05-22'),
('Administração', '4', '98765432168', '1995-01-01'),
('Matriz', '1', '88866555576', '1981-06-19');

insert into localizacoes_departamento (numero_departamento, local) 
values ('1', 'São Paulo'),
('4', 'Mauá'),
('5', 'Santo André'),
('5', 'Itu'),
('5', 'São Paulo');

insert into projeto (numero_projeto, nome_projeto, local_projeto, numero_departamento)
values ('1', 'ProdutoX', 'Santo André', '5'),
('2', 'ProdutoY', 'Itu', '5'),
('3', 'ProdutoZ', 'São Paulo', '5'),
('10', 'Informatização', 'Mauá', '4'),
('20', 'Reorganização', 'São Paulo', '1'),
('30', 'Novosbenefícios', 'Mauá', '4');

insert into dependente (cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
values ('33344555587', 'Alicia', 'F', '1986-04-05', 'Filha'),
('33344555587', 'Tiago', 'M', '1983-10-25', 'Filho'),
('33344555587', 'Janaína', 'F', '1958-05-03', 'Esposa'),
('98765432168', 'Antonio', 'M', '1942-02-28', 'Marido'),
(12345678966, 'Michael', 'M', '1988-01-04', 'Filho'),
(12345678966, 'Alicia', 'F', '1988-12-30', 'Filha'),
(12345678966, 'Elizabeth', 'F', '1967-05-05', 'Esposa');

insert into trabalha_em (cpf_funcionario, numero_projeto, horas)
values('12345678966', '1', '32.5'),
('12345678966', '2', '7.5'),
('66688444476', '3', '40.0'),
('45345345376', '1', '20.0'),
('45345345376', '2', '20.0'),
('33344555587', '2', '10.0'),
('33344555587', '3', '10.0'),
('33344555587', '10', '10.0'),
('33344555587', '20', '10.0'),
('99988777767', '30', '30.0'),
('99988777767', '10', '10.0'),
('98798798733', '10', '35.0'),
('98798798733', '30', '5.0'),
('98765432168', '30', '20.0'),
('98765432168', '20', '15.0'),
('88866555576', '20', '0');