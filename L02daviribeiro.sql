
-Tabela Aluno

CREATE TABLE Aluno (
    aluno_id NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    data_nascimento DATE
);

-Tabela Disciplina

CREATE TABLE Disciplina (
    disciplina_id NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    descricao VARCHAR2(255),
    carga_horaria NUMBER
);

-Tabela Matricula

CREATE TABLE Matricula (
    matricula_id NUMBER PRIMARY KEY,
    aluno_id NUMBER,
    disciplina_id NUMBER,
    FOREIGN KEY (aluno_id) REFERENCES Aluno(aluno_id),
    FOREIGN KEY (disciplina_id) REFERENCES Disciplina(disciplina_id)
);

-Tabela Professor


CREATE TABLE Professor (
    professor_id NUMBER PRIMARY KEY,
    nome VARCHAR2(100)
);

-Tabela Turma

CREATE TABLE Turma (
    turma_id NUMBER PRIMARY KEY,
    disciplina_id NUMBER,
    professor_id NUMBER,
    FOREIGN KEY (disciplina_id) REFERENCES Disciplina(disciplina_id),
    FOREIGN KEY (professor_id) REFERENCES Professor(professor_id)
);


-Inserindo dados na tabela.


INSERT INTO Aluno VALUES (1, 'João Silva', TO_DATE('2005-03-15', 'YYYY-MM-DD'));
INSERT INTO Aluno VALUES (2, 'Ana Costa', TO_DATE('2000-08-22', 'YYYY-MM-DD'));

INSERT INTO Disciplina VALUES (1, 'Matemática', 'Matemática Básica', 60);
INSERT INTO Disciplina VALUES (2, 'História', 'História do Brasil', 40);

INSERT INTO Matricula VALUES (1, 1, 1);
INSERT INTO Matricula VALUES (2, 2, 1);
INSERT INTO Matricula VALUES (3, 2, 2);


INSERT INTO Professor VALUES (1, 'Carlos Mendes');
INSERT INTO Professor VALUES (2, 'Lúcia Oliveira');


INSERT INTO Turma VALUES (1, 1, 1);
INSERT INTO Turma VALUES (2, 2, 2);

 -Pacote PKG_ALUNO

CREATE OR REPLACE PACKAGE PKG_ALUNO AS
    PROCEDURE excluir_aluno(p_aluno_id NUMBER);
    PROCEDURE listar_alunos_maiores_18;
    PROCEDURE listar_alunos_por_curso(p_id_curso NUMBER);
END PKG_ALUNO;
/
CREATE OR REPLACE PACKAGE BODY PKG_ALUNO AS
    PROCEDURE excluir_aluno(p_aluno_id NUMBER) IS
    BEGIN
        DELETE FROM Matricula WHERE aluno_id = p_aluno_id;
        DELETE FROM Aluno WHERE aluno_id = p_aluno_id;
    END excluir_aluno;

    PROCEDURE listar_alunos_maiores_18 IS
        CURSOR c_alunos_maiores IS
        SELECT nome, data_nascimento
        FROM Aluno
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) > 18;
    BEGIN
        FOR r_aluno IN c_alunos_maiores LOOP
            DBMS_OUTPUT.PUT_LINE('Nome: ' || r_aluno.nome || ', Data de Nascimento: ' || TO_CHAR(r_aluno.data_nascimento, 'DD/MM/YYYY'));
        END LOOP;
    END listar_alunos_maiores_18;

    PROCEDURE listar_alunos_por_curso(p_id_curso NUMBER) IS
        CURSOR c_alunos_curso IS
        SELECT a.nome
        FROM Aluno a
        JOIN Matricula m ON a.aluno_id = m.aluno_id
        WHERE m.disciplina_id = p_id_curso;
    BEGIN
        FOR r_aluno IN c_alunos_curso LOOP
            DBMS_OUTPUT.PUT_LINE('Nome: ' || r_aluno.nome);
        END LOOP;
    END listar_alunos_por_curso;
END PKG_ALUNO;
/


-PKG_DISCIPLINA

CREATE OR REPLACE PACKAGE PKG_DISCIPLINA AS
    PROCEDURE cadastrar_disciplina(p_nome VARCHAR2, p_descricao VARCHAR2, p_carga_horaria NUMBER);
    PROCEDURE listar_total_alunos;
    PROCEDURE listar_media_idade(p_id_disciplina NUMBER);
    PROCEDURE listar_alunos_disciplina(p_id_disciplina NUMBER);
END PKG_DISCIPLINA;
/
CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA AS
    PROCEDURE cadastrar_disciplina(p_nome VARCHAR2, p_descricao VARCHAR2, p_carga_horaria NUMBER) IS
    BEGIN
        INSERT INTO Disciplina (disciplina_id, nome, descricao, carga_horaria)
        VALUES ((SELECT NVL(MAX(disciplina_id), 0) + 1 FROM Disciplina), p_nome, p_descricao, p_carga_horaria);
    END cadastrar_disciplina;

    PROCEDURE listar_total_alunos IS
        CURSOR c_total_alunos IS
        SELECT d.nome AS disciplina, COUNT(m.aluno_id) AS total
        FROM Disciplina d
        JOIN Matricula m ON d.disciplina_id = m.disciplina_id
        GROUP BY d.nome
        HAVING COUNT(m.aluno_id) > 10;
    BEGIN
        FOR r_disciplina IN c_total_alunos LOOP
            DBMS_OUTPUT.PUT_LINE('Disciplina: ' || r_disciplina.disciplina || ', Total de Alunos: ' || r_disciplina.total);
        END LOOP;
    END listar_total_alunos;

    PROCEDURE listar_media_idade(p_id_disciplina NUMBER) IS
        CURSOR c_media_idade IS
        SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, a.data_nascimento) / 12)) AS media
        FROM Aluno a
        JOIN Matricula m ON a.aluno_id = m.aluno_id
        WHERE m.disciplina_id = p_id_disciplina;
    BEGIN
        FOR r_media IN c_media_idade LOOP
            DBMS_OUTPUT.PUT_LINE('Média de Idade: ' || r_media.media);
        END LOOP;
    END listar_media_idade;

    PROCEDURE listar_alunos_disciplina(p_id_disciplina NUMBER) IS
        CURSOR c_alunos_disciplina IS
        SELECT a.nome
        FROM Aluno a
        JOIN Matricula m ON a.aluno_id = m.aluno_id
        WHERE m.disciplina_id = p_id_disciplina;
    BEGIN
        FOR r_aluno IN c_alunos_disciplina LOOP
            DBMS_OUTPUT.PUT_LINE('Aluno: ' || r_aluno.nome);
        END LOOP;
    END listar_alunos_disciplina;
END PKG_DISCIPLINA;
/


-PKG_PROFESSOR

CREATE OR REPLACE PACKAGE PKG_PROFESSOR AS
    FUNCTION total_turmas(p_professor_id NUMBER) RETURN NUMBER;
    FUNCTION professor_disciplina(p_id_disciplina NUMBER) RETURN VARCHAR2;
END PKG_PROFESSOR;
/
CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR AS
    FUNCTION total_turmas(p_professor_id NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_total
        FROM Turma
        WHERE professor_id = p_professor_id;
        RETURN v_total;
    END total_turmas;

    FUNCTION professor_disciplina(p_id_disciplina NUMBER) RETURN VARCHAR2 IS
        v_nome VARCHAR2(100);
    BEGIN
        SELECT p.nome
        INTO v_nome
        FROM Professor p
        JOIN Turma t ON p.professor_id = t.professor_id
        WHERE t.disciplina_id = p_id_disciplina;
        RETURN v_nome;
    END professor_disciplina;
END PKG_PROFESSOR;
/
