set search_path to company;
create table employee (
	employee_id int primary key,
	first_name varchar(20) not null,
	last_name varchar(20) not null,
	birth_date date,
	sex varchar(1),
	salary decimal(10,2),
	super_id int,
	branch_id int
);

create table branch (
	branch_id int PRIMARY KEY,
	branch_name varchar(40),
	manager_id int, 
	mng_str_date date,
	FOREIGN KEY(manager_id) REFERENCES employee (employee_id) ON DELETE SET NULL
);

alter table employee 
add foreign key (branch_id)
references branch(branch_id)
on delete set null;

alter table employee 
add foreign key (super_id)
references branch(branch_id)
on delete set null;

create table client  (
	client_id int primary key,
	client_name varchar(50),
	branch_id int,
	foreign key (branch_id) references branch(branch_id) on delete set null
);

create table works_with(
	employee_id int,
	client_id int,
	total_sales int,
	primary key(employee_id,client_id),
	foreign key(employee_id) references employee(employee_id) on delete cascade,
	foreign key (client_id) references client(client_id) on delete cascade
);

create table branchsupplier( 
	branch_id int,
	supplier_name varchar(40),
	supply_type varchar(40),
	primary key (branch_id, supplier_name),
	foreign key (branch_id)references branch(branch_id) on delete cascade
);


--inserting data into the tables
INSERT INTO employee VALUES(100, 'Matthew', 'Kings', '1967-11-17', 'M', 250000, NULL, NULL);--we are setting null because branch doesnt exist at this point

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

select * from branch;

--now that branch has data we are updating branch_|id which we set to null to a value 1
UPDATE employee
SET branch_id = 1
WHERE employee_id = 100;

update employee
set super_id = 100
where employee_id = 101;

select * from employee;

delete  
from employee 
where employee_id = 101;

--we earlier made a mistake and told super_id to reference branch(branch_id) 
--this is what we are correcting at this point to reference the correct on

SELECT conname 
FROM pg_constraint 
WHERE conrelid = 'employee'::regclass;

ALTER TABLE employee DROP CONSTRAINT employee_super_id_fkey;

ALTER TABLE employee 
ADD FOREIGN KEY (super_id)
REFERENCES employee(employee_id)
ON DELETE SET NULL;

INSERT INTO employee VALUES(101, 'Jane', 'Levin', '1961-05-11', 'F', 110000, 100, 1);

--members of another branch scraton
INSERT INTO employee VALUES(102, 'Peter', 'Jane', '1964-03-15', 'M', 75000, 100, NULL);

insert into branch values (2, 'Scranton', 102, '1992-04-06');

update employee 
set branch_id = 2
where employee_id = 102;

ins

insert into employee values (103, 'Angotho', 'Alex', '1971-06-25', 'F', 63000, 102, 2),
							(104, 'Ken', 'Network', '1980-02-05', 'F', 55000, 102, 2),
							(105, 'Stanley', 'wabypass', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Joshua', 'Ndevs', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

update employee
set branch_id = 3
where employee_id = 106;

--adding more employees 
insert into employee values (107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3),
                            (108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

-- adding BRANCH SUPPLIERs
INSERT INTO branchsupplier VALUES(2, 'Twiga', 'Food'),
								(2, 'Unilever', 'Utensils'),
								(3, 'Karatasi', 'Paper'),
								(2, 'Kaps  Forms & Labels', 'Custom Forms'),
								(3, 'Unilever', 'Utensils'),
								(3, 'Twiga', 'Food'),
								(3, 'Kaps  Forms & Labels', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Alliance Highschool', 2),
                         (401, 'Country Club', 2),
                         (402, 'FedEx', 3),
                         (403, 'John Daly Law, LLC', 3),
                         (404, 'Scranton Whitepages', 2),
                         (405, 'Times Newspaper', 3),
                         (406, 'FedEx', 2);

-- inserting values into WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000),
                             (102, 401, 267000),
                             (108, 402, 22500),
                             (107, 403, 5000),
                             (108, 403, 12000),
                             (105, 404, 33000),
                             (107, 405, 26000),
                             (102, 406, 15000),
                             (105, 406, 130000);

-- finding all employees
select * from employee;

--finding all employees ordered by salary
select *
from employee
order by salary;

-- all employees ordered by sex and first name 
select * 
from employee
order by sex, first_name;

--finding all empoyees but limiting the results to he first 5 employees
select * 
from employee
limit 5;

--finding first and last names of all employees
select first_name, last_name
from employee;

--find first_name and last_name but this time we will give them aliases AKA forename and surname
select first_name as Fore_name, Last_name as Surname
from employee
order by first_name;

--find all the genders in the table
select distinct sex 
from employee;


--finding the number of employees in the table
select count(employee_id)
from employee;

--finding all employees with supervisors
select count(super_id)
from employee;

--all employees who are female and born after 1970
select count(employee_id)
from employee
where sex = 'F'and birth_date > '1970-12-31';

--finding average salary of male employees
select avg(salary)
from employee
where sex = 'M';

--sum of all salary
select sum(salary)
from employee;

--number of employees by sex
select count(sex), sex
from employee
group by sex;


--total sales by each sales person
select sum(total_sales), employee_id
from works_with
group by employee_id;

-- how much each client spent on the sales
select sum(total_sales), client_id
from works_with
group by client_id;

--wild cards using like keyword

--find client who are an llc (any number of characters can exist before llc)
select *
from client 
where client_name like '%LLC';

select  * from employee; 

select * from branchsupplier 
where supplier_name like '% Labels%';

select * from client
where client_name like '%school%';

--employee born in october
select *
from employee 
where extract (month from birth_date) = 10;

--union (you must be seeking result from same number of columns with same data type)
--list of employees and branch name
select first_name
from employee;

select branch_name
from branch;

--this combines them in a single column without order and names if first_name because it was the first select statement
select first_name
from employee
union
select branch_name
from branch;

--finding client_name and supplier _name together with their branch _id
select client_name, client.branch_id
from client 
union
select supplier_name, branchsupplier.branch_id
from branchsupplier;

--jions in SQL (combining information from different tables)
insert into branch values (4, 'buffalo', null,null);
select * from branch;

-- find all branches and the names of their managers this is inner join
select employee.employee_id, employee.first_name, branch.branch_name
from employee
join branch
on employee.employee_id = branch.manager_id;


-- find all branches and the names of their managers left join
select employee.employee_id, employee.first_name, branch.branch_name
from employee
left join branch --this includes all from employee table because it is the table on the left
on employee.employee_id = branch.manager_id;

-- find all branches and the names of their managers right join
select employee.employee_id, employee.first_name, branch.branch_name
from employee
right join branch --this includes all from branch table because it is the table on the right
on employee.employee_id = branch.manager_id;

-- find all branches and the names of their managers full join
select employee.employee_id, employee.first_name, branch.branch_name
from employee
full join branch --this includes all from all tables in the code
on employee.employee_id = branch.manager_id;

-- sub queries
--find names of all employees who have sold over 30000 to a single client

select employee.first_name, employee.last_name
from employee
where employee.employee_id in (
	select works_with.employee_id from works_with 
	where works_with.total_sales > 30000
);

--find all clients who are handled by the branch that Peter Manages assume you know peters ID
select * from branch;
select client.client_name 
from client
where client.branch_id = (
	select branch.branch_id
	from branch
	where branch.manager_id = 102
	limit 1
);







  
















