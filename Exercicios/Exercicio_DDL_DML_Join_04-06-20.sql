use exercicioConstraints

--	Adicionar User
INSERT INTO users 
VALUES ('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com');

--	Adicionar Project
INSERT INTO projects
VALUES ('Atualizacao de Sistemas', 'Modificacao de Sistemas Operacionais nos PCs', '09-12-2014');

--	Consultar: 
--	1) Id, Name e Email de Users, Id, Name, Description e Data de Projects, 
--dos usuários que participaram do projeto Name Re-folha
SELECT users.id, users.name, users.email, projects.id, projects.name, projects.description, projects.date FROM users 
INNER JOIN users_has_projects 
ON users_has_projects.users_id = users.id
INNER JOIN projects 
ON users_has_projects.projects_id = projects.id
WHERE projects.name = 'Re-folha'
ORDER BY users.name ASC

--	2) Name dos Projects que não tem Users
SELECT p.name AS 'Nome Projeto' FROM projects p
LEFT OUTER JOIN users_has_projects uhp
ON uhp.projects_id = p.id
WHERE uhp.users_id IS NULL;

--	3) Name dos Users que não tem Projects
SELECT u.name AS 'Nome Funcionario' FROM users_has_projects uhp
RIGHT OUTER JOIN users u
ON u.id = uhp.users_id
WHERE uhp.projects_id IS NULL;
