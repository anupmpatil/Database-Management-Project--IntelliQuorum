-- Find all references to publications where --- is first author. 

---Find publications under "Physics" and display the result university wise. 

-- Find the followers of authors whose publication that has maximum citations for a subtopic "Systems"

-- Find a researcher who is very active on Intelliqurom. Being active can be defined by following parameters
   --- 1. Whose publication has maximum citations * 0.3
   ----2. Number of followers			* 0.1
   ----3. Maximum number of profile views       * 0.2
   ----4. Contribution to answers and questions * 0.4
   





--- Find all questions and answers posted under "Artificial Intelligence"
------------------------------------------------------------------------------------
/*
1;"Artificial intelligence'";3

trial 1
update subtopics set name = 'Artificial intelligence' where subtopicid = 1

select q.discussionforumid, s.name as subtopic_name, t.name as topic_name,
       q.question, q.description, a.numberofupvotes as up_voters, a.numberofdownvotes as down_voters,
       u.firstname || ' ' || u.lastname as questioner_name,
       a.answer, a.date as answer_date, a.replierid,
       u.firstname || ' ' || u.lastname as replier_name
from question q 
join subtopics s on q.subtopics_subtopicid = s.subtopicid
join topics t on s.topics_topicid = t.topicid
join researcher r on q.researcher_researcherid = r.researcherid
join answerthread a on a.replierid = r.researcherid
join users u on u.userid = r.researcherid
wher e s.name ilike 'Artificial Intelligence' and(a.question_discussionforumid = q.discussionforumid)

trial 2

select 
  q.discussionforumid,
  q.question,
  q.description,
  a.numberofupvotes,
  a.numberofdownvotes, 
  a.answerid,
  a.immediateparentanswerid,
  --a1.answer as Immediate_answer,
  a.answer,
  a.date as answer_date,
  s.name as subtopic_name, 
  t.name as topic_name,
  q.researcher_researcherid,
  u.firstname || ' ' || u.lastname as questioner_name,
  a.replierid,
  u1.firstname || ' ' || u1.lastname as replier_name
from question q
join answerthread a on a.question_discussionforumid = q.discussionforumid
join subtopics s on q.subtopics_subtopicid = s.subtopicid
join topics t on s.topics_topicid = t.topicid
join researcher r on q.researcher_researcherid = r.researcherid
join users u on u.userid = r.researcherid
join researcher r1 on a.replierid = r1.researcherid
join users u1 on u1.userid = r1.researcherid
--left outer join answerthread a1 on a1.immediateparentanswerid = a1.answerid
where s.name ilike 'Artificial Intelligence'

--select a1.answer from answerthread left outer join answerthread a1 on a1.immediateparentanswerid =  a1.answerid

--and (a.replierid = r.researcherid)


--where q.subtopics_subtopicid = 1

--and q.subtopics_subtopicid = 1

join subtopics s on q.subtopics_subtopicid = s.subtopicid
join topics t on s.topics_topicid = t.topicid
where (a.question_discussionforumid = q.discussionforumid) 
and q.subtopics_subtopicid = 1
*/
select * from answerthread where answerid = 45174

delete stored precedure find_question_answers_subtopicwise
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
create function find_question_answers_subtopicwise (text) 
	returns setof record as $$
with forumdiscussion as
(
select 
  s.name as subtopic_name, 
  t.name as topic_name,
  q.discussionforumid,
  u.firstname || ' ' || u.lastname as questioner_name,
  q.question,
  q.description,
  a.answerid,
  a.answer,
  u1.firstname || ' ' || u1.lastname as replier_name,
  a.date as answer_date,
  a.numberofupvotes as NumberOfUpVotes,
  a.numberofdownvotes as NumberOfDownVotes, 
  a.immediateparentanswerid
from question q
join answerthread a on a.question_discussionforumid = q.discussionforumid
join subtopics s on q.subtopics_subtopicid = s.subtopicid
join topics t on s.topics_topicid = t.topicid
join researcher r on q.researcher_researcherid = r.researcherid
join users u on u.userid = r.researcherid
join researcher r1 on a.replierid = r1.researcherid
join users u1 on u1.userid = r1.researcherid
where s.name ilike $1
)
select
  fd.subtopic_name, 
  fd.topic_name,
  fd.discussionforumid,
  fd.questioner_name,
  fd.question,
  fd.description,
  fd.answerid,
  fd.answer,
  fd.replier_name,
  fd.answer_date,
  fd.NumberOfUpVotes,
  fd.NumberOfDownVotes, 
  fd.immediateparentanswerid,
  ans.answer
from forumdiscussion fd
left outer join answerthread ans on fd.immediateparentanswerid = ans.answerid
$$ language SQL

-------------------------------------------------------------------------------------
-- Write a stored procedure
create function find_question_answers_subtopic_wise (text) 
	returns setof record as $$

select 
  s.name as subtopic_name, 
  t.name as topic_name,
  q.discussionforumid,
  u.firstname || ' ' || u.lastname as questioner_name,
  q.question,
  q.description,
  a.answerid,
  a.answer,
  u1.firstname || ' ' || u1.lastname as replier_name,
  a.date as answer_date,
  a.numberofupvotes as NumberOfUpVotes,
  a.numberofdownvotes as NumberOfDownVotes, 
  a.immediateparentanswerid
from question q
join answerthread a on a.question_discussionforumid = q.discussionforumid
join subtopics s on q.subtopics_subtopicid = s.subtopicid
join topics t on s.topics_topicid = t.topicid
join researcher r on q.researcher_researcherid = r.researcherid
join users u on u.userid = r.researcherid
join researcher r1 on a.replierid = r1.researcherid
join users u1 on u1.userid = r1.researcherid
where s.name ilike $1

$$ language SQL
------------------------------------------------------------------------------------
-- execute query
select * from find_question_answers_subtopicwise ('Artificial intelligence')
	as
	(
		subtopic_name character varying(100),
		topic_name character varying(100),
		discussionforumid integer,
		questioner_name character varying(1000),
		question character varying(1000),
		description character varying(2000),		
		answerid integer,
		answer character varying(3000),	
		replier_name character varying(1000),
		answer_date date,			
		numberofupvotes integer,
		numberofdownvotes integer,
		immediateparentanswerid integer,
		replyanswer varchar
	)

-----------------------------------------------------------------------------------------------------
-- Find all references to publications where --- is first author. 
"PHYLLIS BERGER"

-- find only reference publications
with authors_publications as
(
select --*
	r.researcherid,
	u.firstname || ' ' || u.lastname as author_name,
	rhp.publications_publicationid as publication_id,
	pub.title
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join publications pub on pub.publicationid = rhp.publications_publicationid
where rhp.publication_rank = 1 and (u.firstname ilike 'PHYLLIS') and (u.lastname ilike 'BERGER')
)
select ap.researcherid, ap.author_name, ap.publication_id, ap.title,
       pp.publications_referencepublicationid as reference_publication_id,
       p.title as reference_title
from authors_publications ap
join publications_has_reference_to_publications pp
	on pp.publications_publicationid = ap.publication_id
join publications p on p.publicationid = pp.publications_referencepublicationid
----------------------------------------------------------------------------------------

-- Find only other references (non publication references)

with authors_publications as
(
select --*
	r.researcherid,
	u.firstname || ' ' || u.lastname as author_name,
	rhp.publications_publicationid as publication_id,
	pub.title
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join publications pub on pub.publicationid = rhp.publications_publicationid
where rhp.publication_rank = 1 and (u.firstname ilike 'PHYLLIS') and (u.lastname ilike 'BERGER')
)
select ap.researcherid, ap.author_name, ap.publication_id, 
       ap.title, 
       ref.referenceid,
       r.type as reference_type,
       r.text as reference_name
from authors_publications ap
left outer join publications_has_references ref on ref.publicationid = ap.publication_id
left outer join reference r on ref.referenceid = r.referenceid



-------------------------------------------------------------------------------------------
-- Find both types of references
with authors_publications as
(
select --*
	r.researcherid,
	u.firstname || ' ' || u.lastname as author_name,
	rhp.publications_publicationid as publication_id,
	pub.title
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join publications pub on pub.publicationid = rhp.publications_publicationid
where rhp.publication_rank = 1 and (u.firstname ilike 'PHYLLIS') and (u.lastname ilike 'BERGER')
),
reference_publications as
(
select ap.researcherid, ap.author_name, ap.publication_id, ap.title,
       pp.publications_referencepublicationid as reference_publication_id,
       p.title as reference_title
from authors_publications ap
join publications_has_reference_to_publications pp
	on pp.publications_publicationid = ap.publication_id
join publications p on p.publicationid = pp.publications_referencepublicationid
)
select rp.researcherid, rp.author_name, rp.publication_id, 
       rp.title, rp.reference_publication_id,
       rp.reference_title,
       ref.referenceid,
       r.type as reference_type,
       r.text as reference_name
from reference_publications rp
left outer join publications_has_references ref on ref.publicationid = rp.publication_id
left outer join reference r on ref.referenceid = r.referenceid
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-- helper queries
insert into publications_has_references values(2, 67160)
insert into publications_has_references values(3, 67160)
insert into publications_has_references values(4, 67160)

select* from publications_has_reference_to_publications where 
publications_publicationid = 67160

select * from publications_has_references where publicationid = 67160
----------------------------------------------------------------------------------------------------
-- profile views daily/weekly/monthly for a particular researcher with name xxx

-- between two dates
select 
	r.researcherid,
	u.firstname || ' ' || u.lastname as researcher_name,
	ps.visitorid,
	u1.firstname || ' ' || u1.lastname as visitor_name,
	ps.visitingdate
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join profilestats ps on ps.researcherid = r.researcherid
join users u1 on u1.userid = ps.visitorid
where (u.firstname ilike 'ATKINSON') and (u.lastname ilike 'WILDER')
       and (ps.visitingdate >= ('2012-08-07')::date) and (ps.visitingdate < ('2013-01-10')::date)

-- stored procedure weekly view
create function weekly_stats (text,text,text) 
	returns setof record as $$
select 
	r.researcherid,
	u.firstname || ' ' || u.lastname as researcher_name,
	ps.visitorid,
	u1.firstname || ' ' || u1.lastname as visitor_name,
	ps.visitingdate
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join profilestats ps on ps.researcherid = r.researcherid
join users u1 on u1.userid = ps.visitorid
where (u.firstname ilike $1) and (u.lastname ilike $2)
       and (ps.visitingdate >= ($3)::date) and (ps.visitingdate < (($3)::date + 7))
$$ language SQL

select * from weekly_stats ('ATKINSON', 'WILDER', '2012-10-07')
	as
	(researcherid integer,
	 researcher_name varchar,
	 visitorid integer,
	 visitor_name varchar,
	 visitingdate date
	 )

--- stored procedure monthly view

create function monthly_stats (text,text,text,text) 
	returns setof record as $$
select 
	r.researcherid,
	u.firstname || ' ' || u.lastname as researcher_name,
	ps.visitorid,
	u1.firstname || ' ' || u1.lastname as visitor_name,
	ps.visitingdate
from researcher r
join researcher_has_publications rhp on r.researcherid = rhp.researcher_researcherid
join users u on u.userid = r.researcherid
join profilestats ps on ps.researcherid = r.researcherid
join users u1 on u1.userid = ps.visitorid
where (u.firstname ilike $1) and (u.lastname ilike $2)
       and (date_part('Month',ps.visitingdate)::text = $3) and (date_part('Year',ps.visitingdate)::text = $4)
$$ language SQL

select * from monthly_stats ('ATKINSON', 'WILDER', '10','2012')
	as
	(researcherid integer,
	 researcher_name varchar,
	 visitorid integer,
	 visitor_name varchar,
	 visitingdate date
	 )

------------------------------------------------------------------------------------------------------
---Find publications under "Physics" and display the result university wise. 

with publications_under_topic as
(
select 
	pub.publicationid,
	pub.title,
	pub.subtopicid,
	sub.name as subtopic_name,
	t.topicid,
	t.name as topic_name
from publications pub 
join subtopics sub on sub.subtopicid = pub.subtopicid
join topics t on t.topicid = sub.topics_topicid
where t.name ilike 'Physics'
),
publication_authors as
(
select 
	pt.publicationid, 
	rhp.researcher_researcherid as primary_author_id,
	rhp.publication_rank,
	pt.title, 
	pt.subtopicid, 
	pt.subtopic_name,
	pt.topicid, 
	pt.topic_name
from publications_under_topic pt
join researcher_has_publications rhp on rhp.publications_publicationid = pt.publicationid
where rhp.publication_rank = 1
)
select 
	pa.publicationid, 
	pa.title, 
	pa.primary_author_id,
	us.firstname || ' ' || us.lastname as primary_author_name,
	pa.subtopic_name,
	pa.topic_name,
	r.universityid,
	u.name as university_name
from publication_authors pa
join researcher r on r.researcherid = pa.primary_author_id
join university u on r.universityid = u.universityid
join users us on us.userid = pa.primary_author_id
order by universityid

------------------------------------------------------------------------------------------------------
--- Select all Subtopics with the topic to which they belong.
select s.name as subtopic_name,t.name as topic_name 
from subtopics s join topics t 
on s.topics_topicid=t.topicid
order by t.name


 
--Show all publications under topic Computer Science
select pub.title,pub.abstract,pub.publicationviews,s.name,t.name from 
publications pub join subtopics s on pub.subtopicid=s.subtopicid 
join topics t on  s.topics_topicid=t.topicid
where t.name='Computer Science'




-- Researchers with their total number of publications
--all authors with their publication
with all_first_authors as
(select  u.firstname ||' ' || u.lastname as researchername ,
pub.title from researcher r 
join researcher_has_publications rpub on rpub.researcher_researcherid=r.researcherid
join publications pub on pub.publicationid=rpub.publications_publicationid
join users u on u.userid=r.researcherid
order by researchername)

select count(researchername) as cnt,researchername from all_first_authors
group by researchername
having count(researchername)  =5 



-- Find all references for publications by author Taylor Rowes.

with all_publications_by_author as
(select pub.publicationid from researcher r 
join researcher_has_publications rpub on rpub.researcher_researcherid=r.researcherid
join publications pub on pub.publicationid=rpub.publications_publicationid
join users u on u.userid=r.researcherid
where  (u.firstname ||' ' || u.lastname ) ='TAYLOR ROWE' ),

referencedpublication as
(select publications_referencepublicationid as pubids from publications_has_reference_to_publications
where publications_publicationid in (select * from all_publications_by_author))

select pub.title,pub.abstract,pub.publicationviews,s.name,t.name from 
publications pub join subtopics s on pub.subtopicid=s.subtopicid 
join topics t on  s.topics_topicid=t.topicid join
referencedpublication refpub on pub.publicationid=refpub.pubids

 -- Find number of citations of publications by author OLLIE BOYLE.
with all_publications_by_author as
(select pub.publicationid from researcher r 
join researcher_has_publications rpub on rpub.researcher_researcherid=r.researcherid
join publications pub on pub.publicationid=rpub.publications_publicationid
join users u on u.userid=r.researcherid
where  (u.firstname ||' ' || u.lastname ) ='OLLIE BOYLE' ),

cited as
(select publications_publicationid as pubids from publications_has_reference_to_publications
where publications_referencepublicationid in (select * from all_publications_by_author))
 
select distinct count(*) from 
publications pub join 
cited refpub on pub.publicationid=refpub.pubids


--- Find researcher with maximum citations
-- Working on this

with all_publications_by_author as
(select rpub.publications_publicationid,
       r.researcherid as researcher_id
       from researcher r
       join researcher_has_publications rpub on rpub.researcher_researcherid=r.researcherid),

/*select * from researcher_has_publications where publications_publicationid = 3
select rpub.publications_publicationid,
       r.researcherid as researcher_id
       from researcher r
       join researcher_has_publications rpub on rpub.researcher_researcherid=r.researcherid
       where publications_publicationid=3*/
cited as
(select pp.publications_publicationid as pubids,allp.researcher_id  from publications_has_reference_to_publications pp
 join all_publications_by_author allp on pp.publications_publicationid=allp.publicationid),
 
all_researchers as 
(select  count(*) as count_max,researcher_id from 
publications pub join 
cited refpub on pub.publicationid=refpub.pubids
group by researcher_id)

select max(count_max) from all_researchers al join 
users u on u.userid=al.researcher_id

-------------------------------------------------------------------------------------------------------------------------

-- Find the followers of authors whose publication has maximum citations for a subtopic "Systems"

-- folowers of Author with maximum citations for a subtopic
with subtopic_publications as
(
select 
	pub.publicationid,
	pub.title,
	pub.subtopicid,
	sub.name
from publications pub
join subtopics sub on pub.subtopicid = sub.subtopicid
and sub.name ilike 'Systems'
)
,
reference_publications as
(
select 
	sp.publicationid,
	sp.title,
	sp.subtopicid,
	sp.name,
	pref.publications_referencepublicationid as reference_pubplication_id
from subtopic_publications sp
join publications_has_reference_to_publications pref on 
	pref.publications_publicationid = sp.publicationid
),
citations as
(
select
	rp.publicationid,
	rp.title,
	rp.subtopicid,
	rp.name,
	rp.reference_pubplication_id,
	rpub.researcher_researcherid as researcher
        from reference_publications rp
	join researcher_has_publications rpub on 
	rp.reference_pubplication_id = rpub.publications_publicationid
),
count_researcher as
(
select  count(*) as count_max,
	researcher 
from citations
group by researcher),
max_researcher as
(
select researcher 
from count_researcher 
where count_max = (select max(count_max) from count_researcher) 
group by researcher
)
select
	mr.researcher as researcher_id,
	u.firstname || ' ' || u.lastname as researcher_name,
	rf.followerid,
	u1.firstname || ' ' || u1.lastname as follower_name
from max_researcher mr
join researcher_has_followers rf on rf.researcherid =  mr.researcher
join users u on u.userid = mr.researcher
join users u1 on u1.userid = rf.followerid

--select * from researcher_has_followers where researcherid = 30514;
--select * from researcher_has_followers where researcherid = 131280;

-- followers for authors of maximum cited publications for a subtopic
with subtopic_publications as
(
select 
	pub.publicationid,
	pub.title,
	pub.subtopicid,
	sub.name
from publications pub
join subtopics sub on pub.subtopicid = sub.subtopicid
and sub.name ilike 'Systems'
)
,reference_publications as
(
select 
	sp.publicationid,
	sp.title,
	sp.subtopicid,
	sp.name,
	pref.publications_referencepublicationid as reference_pubplication_id
	from subtopic_publications sp
	join publications_has_reference_to_publications pref on 
	pref.publications_publicationid = sp.publicationid
)
,count_publications as
(
select  count(*) as count_max,
	reference_pubplication_id
from reference_publications
group by reference_pubplication_id
)
,max_publication as
(
select reference_pubplication_id
from count_publications 
where count_max = (select max(count_max) from count_publications) 
group by reference_pubplication_id
)
,max_author as
(
select 
	mp.reference_pubplication_id,
	rpub.researcher_researcherid as researcher
from max_publication mp
join researcher_has_publications rpub on 
	mp.reference_pubplication_id = rpub.publications_publicationid
)
select
	ma.researcher as researcher_id,
	u.firstname || ' ' || u.lastname as researcher_name,
	rf.followerid,
	u1.firstname || ' ' || u1.lastname as follower_name
from max_author ma
join researcher_has_followers rf on rf.researcherid =  ma.researcher
join users u on u.userid = ma.researcher
join users u1 on u1.userid = rf.followerid




/*
select count(c.researcher) from citations c

select count(*) from citations c
select count(distinct c.researcher) from citations c

select * from citations where researcher = 30514
select * from citations

select c.researcher, count(*) as refval from citations c 
where c.reference_pubplication_id = 30514
group by c.researcher

select count(distinct c.researcher) from citations c

insert into publications_has_reference_to_publications values (10849,30514)

	
where rp.publicationid = 9266	



select * from researcher_has_publications where publications_publicationid = 30514

select * from publications_has_reference_to_publications where publications_publicationid = 9266

select publications_publicationid,
	publications_referencepublicationid,
	count(*)as refcount
 from publications_has_reference_to_publications 
 group by publications_referencepublicationid, publications_publicationid
 */