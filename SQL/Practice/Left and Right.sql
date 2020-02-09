select right(website,3) as ext, count(*)
from accounts
group by ext
order by ext

select left(name,1), count(*)
from accounts
group by 1 
order by 1