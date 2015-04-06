-- Table: answerthread

-- DROP TABLE answerthread;

CREATE TABLE answerthread
(
  question_discussionforumid integer NOT NULL,
  answerid integer NOT NULL,
  immediateparentanswerid integer,
  answer character varying(3000),
  date date,
  numberofupvotes integer,
  numberofdownvotes integer,
  replierid integer NOT NULL,
  CONSTRAINT answerthread_pkey PRIMARY KEY (answerid),
  CONSTRAINT fk_answerthread_ans_id FOREIGN KEY (immediateparentanswerid)
      REFERENCES answerthread (answerid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_answerthread_question_id FOREIGN KEY (question_discussionforumid)
      REFERENCES question (discussionforumid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_replier_id FOREIGN KEY (replierid)
      REFERENCES researcher (researcherid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE answerthread
  OWNER TO postgres;

-- Index: fki_replier_id

-- DROP INDEX fki_replier_id;

CREATE INDEX fki_replier_id
  ON answerthread
  USING btree
  (replierid);

----------------------------------------------------------------------------------------
-- 135960 rows
----------------------------------------------------------------------------------------

-- Table: country

-- DROP TABLE country;

CREATE TABLE country
(
  countryid integer NOT NULL,
  name character varying(50),
  CONSTRAINT country_pkey PRIMARY KEY (countryid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE country
  OWNER TO postgres;
  
----------------------------------------------------------------------------------------
-- 268 rows
----------------------------------------------------------------------------------------

-- Table: department

-- DROP TABLE department;

CREATE TABLE department
(
  departmentid integer NOT NULL,
  deparmentname character varying(100) NOT NULL,
  departmentmajor integer NOT NULL,
  universityid integer NOT NULL,
  CONSTRAINT department_pkey PRIMARY KEY (departmentid, universityid),
  CONSTRAINT fk_department_major_id FOREIGN KEY (departmentmajor)
      REFERENCES topics (topicid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT fk_uni_dept_id FOREIGN KEY (universityid)
      REFERENCES university (universityid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE department
  OWNER TO postgres;

-- Index: fki_department_major_id

-- DROP INDEX fki_department_major_id;

CREATE INDEX fki_department_major_id
  ON department
  USING btree
  (departmentmajor);

-- Index: fki_uni_dept_id

-- DROP INDEX fki_uni_dept_id;

CREATE INDEX fki_uni_dept_id
  ON department
  USING btree
  (universityid);
  
-------------------------------------------------------------
-- 756280 rows
-------------------------------------------------------------

-- Table: department_has_projects

-- DROP TABLE department_has_projects;

CREATE TABLE department_has_projects
(
  universityid integer NOT NULL,
  departmentid integer NOT NULL,
  projectid integer NOT NULL,
  CONSTRAINT department_has_projects_pkey PRIMARY KEY (universityid, departmentid, projectid),
  CONSTRAINT fk_department_has_projects FOREIGN KEY (departmentid, universityid)
      REFERENCES department (departmentid, universityid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_dept_project_id FOREIGN KEY (projectid)
      REFERENCES projects (projectid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE department_has_projects
  OWNER TO postgres;

-- Index: fki_dept_project_id

-- DROP INDEX fki_dept_project_id;

CREATE INDEX fki_dept_project_id
  ON department_has_projects
  USING btree
  (projectid);

------------------------------------------------------------------------------------
--50 rows
------------------------------------------------------------------------------------

-- Table: journal

-- DROP TABLE journal;

CREATE TABLE journal
(
  journalid integer NOT NULL,
  name character varying(500),
  CONSTRAINT journal_pkey PRIMARY KEY (journalid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE journal
  OWNER TO postgres;

-------------------------------------------------------------------
-- 1532 rows
-------------------------------------------------------------------

-- Table: personalweblink

-- DROP TABLE personalweblink;

CREATE TABLE personalweblink
(
  linkid integer NOT NULL,
  url character varying(200) NOT NULL,
  CONSTRAINT personalweblink_pkey PRIMARY KEY (linkid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE personalweblink
  OWNER TO postgres;
  
---------------------------------------------------------------------
-- 850062 rows
---------------------------------------------------------------------

-- Table: profilestats

-- DROP TABLE profilestats;

CREATE TABLE profilestats
(
  researcherid integer NOT NULL,
  visitorid integer NOT NULL,
  visitingdate date,
  CONSTRAINT fk_researcher_id FOREIGN KEY (researcherid)
      REFERENCES users (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_visitor_id FOREIGN KEY (visitorid)
      REFERENCES users (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE profilestats
  OWNER TO postgres;

-- Index: fki_researcher_id

-- DROP INDEX fki_researcher_id;

CREATE INDEX fki_researcher_id
  ON profilestats
  USING btree
  (researcherid);

-- Index: fki_visitor_id

-- DROP INDEX fki_visitor_id;

CREATE INDEX fki_visitor_id
  ON profilestats
  USING btree
  (visitorid);
----------------------------------------------------------------
-- 899998 rows
----------------------------------------------------------------

-- Table: projects

-- DROP TABLE projects;

CREATE TABLE projects
(
  projectid integer NOT NULL,
  name character varying(1000),
  synopsis character varying(2000),
  CONSTRAINT projects_pkey PRIMARY KEY (projectid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE projects
  OWNER TO postgres;

--------------------------------------------------------------
-- 50 rows
--------------------------------------------------------------

  -- Table: publications

-- DROP TABLE publications;

CREATE TABLE publications
(
  publicationid integer NOT NULL,
  title character varying(500),
  date date,
  subtopicid integer NOT NULL,
  projectid integer,
  abstract character varying(5000),
  journalid integer NOT NULL,
  publicationviews integer,
  numberofcitations integer,
  CONSTRAINT publications_pkey PRIMARY KEY (publicationid),
  CONSTRAINT fk_publications_journal_id FOREIGN KEY (journalid)
      REFERENCES journal (journalid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_publications_projects_id FOREIGN KEY (projectid)
      REFERENCES projects (projectid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE publications
  OWNER TO postgres;

--------------------------------------------------------------------------
--100766 rows
--------------------------------------------------------------------------

-- Table: publications_has_reference_to_publications

-- DROP TABLE publications_has_reference_to_publications;

CREATE TABLE publications_has_reference_to_publications
(
  publications_publicationid integer NOT NULL,
  publications_referencepublicationid integer NOT NULL,
  CONSTRAINT publications_has_reference_to_publications_pkey PRIMARY KEY (publications_publicationid, publications_referencepublicationid),
  CONSTRAINT fk_publications_id FOREIGN KEY (publications_publicationid)
      REFERENCES publications (publicationid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_referenced_publication_id FOREIGN KEY (publications_referencepublicationid)
      REFERENCES publications (publicationid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE publications_has_reference_to_publications
  OWNER TO postgres;

-------------------------------------------------------------------------------------------
--281144 rows
-------------------------------------------------------------------------------------------

-- Table: publications_has_references

-- DROP TABLE publications_has_references;

CREATE TABLE publications_has_references
(
  referenceid integer NOT NULL,
  publicationid integer NOT NULL,
  CONSTRAINT publications_has_references_pkey PRIMARY KEY (referenceid, publicationid),
  CONSTRAINT fk_ref_id FOREIGN KEY (referenceid)
      REFERENCES publications (publicationid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_reference_id FOREIGN KEY (referenceid)
      REFERENCES reference (referenceid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE publications_has_references
  OWNER TO postgres;

-------------------------------------------------------------------------------------------
--78128 rows
-------------------------------------------------------------------------------------------

-- Table: publicationstats

-- DROP TABLE publicationstats;

CREATE TABLE publicationstats
(
  researcherid integer NOT NULL,
  publicationid integer NOT NULL,
  visitdate date NOT NULL,
  fulltextrequests integer,
  CONSTRAINT fk_publication_id FOREIGN KEY (publicationid)
      REFERENCES publications (publicationid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_researcherid FOREIGN KEY (researcherid)
      REFERENCES researcher (researcherid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE publicationstats
  OWNER TO postgres;

-- Index: fki_researcherid

-- DROP INDEX fki_researcherid;

CREATE INDEX fki_researcherid
  ON publicationstats
  USING btree
  (researcherid);

--------------------------------------------------------------------
-- 100766 rows
--------------------------------------------------------------------

-- Table: question

-- DROP TABLE question;

CREATE TABLE question
(
  discussionforumid integer NOT NULL,
  researcher_researcherid integer NOT NULL,
  subtopics_subtopicid integer NOT NULL,
  subtopics_topics_topicid integer NOT NULL,
  question character varying(1000),
  description character varying(2000),
  numberofupvotes integer,
  numberofdownvotes integer,
  CONSTRAINT question_pkey PRIMARY KEY (discussionforumid),
  CONSTRAINT fk_discussionforum_researcher_id FOREIGN KEY (researcher_researcherid)
      REFERENCES researcher (researcherid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_discussionforum_subtopics_id FOREIGN KEY (subtopics_subtopicid, subtopics_topics_topicid)
      REFERENCES subtopics (subtopicid, topics_topicid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE question
  OWNER TO postgres;
 
-----------------------------------------------------------------------------------------------
-- 13596 rows
-----------------------------------------------------------------------------------------------

-- Table: reference

-- DROP TABLE reference;

CREATE TABLE reference
(
  referenceid integer NOT NULL,
  type character varying(45),
  text character varying(45),
  CONSTRAINT reference_pkey PRIMARY KEY (referenceid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE reference
  OWNER TO postgres;
  
-------------------------------------------------------------------------
-- 100000 rows
-------------------------------------------------------------------------

-- Table: researcher

-- DROP TABLE researcher;

CREATE TABLE researcher
(
  researcherid integer NOT NULL,
  universityid integer,
  departmentid integer,
  achievements character varying(1000),
  specialization_id integer,
  major integer,
  CONSTRAINT researcher_pkey PRIMARY KEY (researcherid),
  CONSTRAINT fk_university_id FOREIGN KEY (universityid)
      REFERENCES university (universityid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_user_id FOREIGN KEY (researcherid)
      REFERENCES users (userid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researcher
  OWNER TO postgres;

-- Index: fki_university_id

-- DROP INDEX fki_university_id;

CREATE INDEX fki_university_id
  ON researcher
  USING btree
  (universityid);

-------------------------------------------------------------------
--299999 rows
-------------------------------------------------------------------

-- Table: researcher_follows_subtopics

-- DROP TABLE researcher_follows_subtopics;

CREATE TABLE researcher_follows_subtopics
(
  researcher_researcherid integer NOT NULL,
  subtopics_subtopicid integer NOT NULL,
  subtopics_topics_topicid integer NOT NULL,
  CONSTRAINT pk_researcher_follower PRIMARY KEY (researcher_researcherid, subtopics_subtopicid, subtopics_topics_topicid),
  CONSTRAINT researcher_follows_subtopics_subtopics_subtopicid_fkey FOREIGN KEY (subtopics_subtopicid, subtopics_topics_topicid)
      REFERENCES subtopics (subtopicid, topics_topicid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT researcher_id_fk FOREIGN KEY (researcher_researcherid)
      REFERENCES researcher (researcherid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researcher_follows_subtopics
  OWNER TO postgres;

-- Index: fki_subtopic_id_fk

-- DROP INDEX fki_subtopic_id_fk;

CREATE INDEX fki_subtopic_id_fk
  ON researcher_follows_subtopics
  USING btree
  (subtopics_subtopicid);

-----------------------------------------------------------------------
-- 794760 rows
-----------------------------------------------------------------------

-- Table: researcher_has_followers

-- DROP TABLE researcher_has_followers;

CREATE TABLE researcher_has_followers
(
  researcherid integer NOT NULL,
  followerid integer NOT NULL,
  CONSTRAINT researcher_has_followers_pkey PRIMARY KEY (researcherid, followerid),
  CONSTRAINT follower_id_fk FOREIGN KEY (followerid)
      REFERENCES researcher (researcherid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT researcher_id FOREIGN KEY (researcherid)
      REFERENCES researcher (researcherid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researcher_has_followers
  OWNER TO postgres;

--------------------------------------------------------------------------------
-- 599999 rows
--------------------------------------------------------------------------------

-- Table: researcher_has_personalweblink

-- DROP TABLE researcher_has_personalweblink;

CREATE TABLE researcher_has_personalweblink
(
  linkid integer NOT NULL,
  researcherid integer NOT NULL,
  CONSTRAINT researcher_has_personalweblink_pkey PRIMARY KEY (linkid, researcherid),
  CONSTRAINT fk_linkid FOREIGN KEY (linkid)
      REFERENCES personalweblink (linkid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_researcher_weblink_id FOREIGN KEY (researcherid)
      REFERENCES researcher (researcherid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researcher_has_personalweblink
  OWNER TO postgres;

-- Index: fki_researcher_weblink_id

-- DROP INDEX fki_researcher_weblink_id;

CREATE INDEX fki_researcher_weblink_id
  ON researcher_has_personalweblink
  USING btree
  (researcherid);

----------------------------------------------------------------------------------
-- 894281 rows
----------------------------------------------------------------------------------

-- Table: researcher_has_publications

-- DROP TABLE researcher_has_publications;

CREATE TABLE researcher_has_publications
(
  researcher_researcherid integer NOT NULL,
  publications_publicationid integer NOT NULL,
  publication_rank integer,
  isadvisor boolean,
  CONSTRAINT research_pub_composite_pk PRIMARY KEY (researcher_researcherid, publications_publicationid),
  CONSTRAINT publication_id_fk1 FOREIGN KEY (publications_publicationid)
      REFERENCES publications (publicationid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT researcher_id_fk_pub FOREIGN KEY (researcher_researcherid)
      REFERENCES researcher (researcherid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researcher_has_publications
  OWNER TO postgres;

-- Index: fki_researcher_id_fk_pub

-- DROP INDEX fki_researcher_id_fk_pub;

CREATE INDEX fki_researcher_id_fk_pub
  ON researcher_has_publications
  USING btree
  (researcher_researcherid);

-----------------------------------------------------------------------------
-- 203832 rows
-----------------------------------------------------------------------------

CREATE TABLE subtopics
(
  subtopicid integer NOT NULL,
  name character varying(100),
  topics_topicid integer NOT NULL,
  CONSTRAINT subtopics_pkey PRIMARY KEY (subtopicid, topics_topicid),
  CONSTRAINT topics_id_fk FOREIGN KEY (topics_topicid)
      REFERENCES topics (topicid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE subtopics
  OWNER TO postgres;
------------------------------------------------------------------------------
-- 599 rows
------------------------------------------------------------------------------

-- Table: topics

-- DROP TABLE topics;

CREATE TABLE topics
(
  topicid integer NOT NULL,
  name character varying(100),
  CONSTRAINT topics_pkey PRIMARY KEY (topicid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE topics
  OWNER TO postgres;

-----------------------------------------------------------------------------
-- 74 
-----------------------------------------------------------------------------

-- Table: university

-- DROP TABLE university;

CREATE TABLE university
(
  universityid integer NOT NULL,
  name character varying(200) NOT NULL,
  address character varying(500),
  countryid integer,
  statename character varying(50),
  CONSTRAINT university_pkey PRIMARY KEY (universityid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE university
  OWNER TO postgres;

---------------------------------------------------------------------
-- 10220 rows
---------------------------------------------------------------------


-- Table: users

-- DROP TABLE users;

CREATE TABLE users
(
  userid integer NOT NULL,
  firstname character varying(50) NOT NULL,
  lastname character varying(50),
  birthdate date,
  professionalemailid character varying(100) NOT NULL,
  languages character varying(100),
  personalemailid character varying(100),
  countryid integer NOT NULL,
  major integer,
  CONSTRAINT users_pkey PRIMARY KEY (userid),
  CONSTRAINT fk_country_idx FOREIGN KEY (countryid)
      REFERENCES country (countryid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL
)
WITH (
  OIDS=FALSE
);
ALTER TABLE users
  OWNER TO postgres;

-- Index: fki_country_idx

-- DROP INDEX fki_country_idx;

CREATE INDEX fki_country_idx
  ON users
  USING btree
  (countryid);

----------------------------------------------------------------
-- 299999 rows
----------------------------------------------------------------
