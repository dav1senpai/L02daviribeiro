LO2 - Lista de Exercícios Package
Davi Ribeiro Duarte da Silva -- 183028

Este projeto implementa pacotes PL/SQL para gerenciar Alunos, Disciplinas e Professores em um sistema acadêmico Oracle.

*Pré Requisitos*
1 - Banco de dados Oracle e SQL Developer instalados.

Fim

*Caminho das pedras*
1 - Abra o SQL Developer e conecte-se ao banco de dados.
2 - Carregue o arquivo (L02daviribeiro.sql)  usando File + Open.
3 - Execute o código clicando no ícone de Executar ou pressionando F5.

*Descrição dos Pacotes*

PKG_ALUNO:
1 - excluir_aluno(p_aluno_id): Exclui um aluno e suas matrículas.
2 - listar_alunos_maiores_18: Lista alunos maiores de 18 anos.
3 - listar_alunos_por_curso(p_id_curso): Lista alunos de um curso específico.

PKG_DISCIPLINA:
1 - cadastrar_disciplina(p_nome, p_descricao, p_carga_horaria): Cadastra uma nova disciplina.
2 - listar_total_alunos: Exibe o total de alunos por disciplina (mais de 10 alunos).
3 - listar_media_idade(p_id_disciplina): Calcula a média de idade dos alunos por disciplina.
4 - listar_alunos_disciplina(p_id_disciplina): Lista alunos matriculados em uma disciplina.

PKG_PROFESSOR:
1 - total_turmas(p_professor_id): Retorna o total de turmas de um professor.
2 - professor_disciplina(p_id_disciplina): Retorna o nome do professor responsável pela disciplina.

Contato
dsilva2053@gmail.com para dúvidas ou problemas.



