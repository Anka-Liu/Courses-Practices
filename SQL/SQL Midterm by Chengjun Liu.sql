--1.

select concat(s.stffirstname,' ',s.stflastname) as name,
		f.title, s.datehired
from staff as s
join faculty as f
using(staffid)
where (f.title in ('Associate Professor', 'Professor')) and (date_part('year',s.datehired)=1992)

--2.

select concat(s.studfirstname,' ',s.studlastname) as student_name,
		avg(ss.grade) as student_average_grade
from student_schedules as ss
join students as s
using(studentid)
where ss.classstatus=2
group by student_name
order by 2 desc

--3.

select s.subjectcode, s.subjectname
from subjects as s
left join faculty_subjects as fs
using(subjectid)
where staffid is null

--4. 

select concat(s.stffirstname,' ',s.stflastname) as name,
		count(fc.classid)
from staff as s
join faculty_classes as fc
using(staffid)
group by name
having count(fc.classid)>7

--5.

select s.staffid, s.stflastname, s.stffirstname,
		f.title,f.status, s.salary,
		case when f.title = 'Instructor' then round(1.05*s.salary,0)
		when f.title =' Associate Professor' then round(1.04*s.salary,0)
		else round(1.035*s.salary,0)
		end as newsalary
from staff as s
join faculty as f
using(staffid)
where f.status='Full Time'

--6.

select distinct c.categoryid,s.subjectcode,s.subjectname, 
		max(ss.grade) over(partition by s.subjectcode) as subjectmax,
		max(ss.grade) over(partition by c.categoryid) as categorymax
from categories as c
join subjects as s
using(categoryid)
join classes as cl
using(subjectid)
join student_schedules as ss
using(classid)
where ss.classstatus=2
order by 1;

--7.
with dept_score as (
	select d.deptname,f.staffid,avg(fs.proficiencyrating) as score
	from departments as d
	join categories as c
	using(departmentid)
	join faculty_categories as fc
	using(categoryid)
	join faculty as f
	using(staffid)
	join faculty_subjects as fs
	using(staffid)
	group by 1,2
)

select deptname, max(score) as max_score
from dept_score
group by deptname