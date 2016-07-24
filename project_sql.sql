CREATE DATABASE motors;
USE motors;

CREATE TABLE customer
(custid char(8) not null primary key,
Custfname varchar(20) not null, 
cardholder varchar(3) not null,
Custage integer default 0,
Custincome integer default 0,
Index(custid));

CREATE TABLE cardholder
(cardid char(8) not null primary key,
timespan decimal(12,2) default 0 , 
custid char(8) not null,
WOM_communication char(8) not null,
Benifits_avail varchar(30) not null,
Rating integer default 0,
satisfaction varchar(8) not null,
FOREIGN KEY (custid) REFERENCES customer(custid)
);


CREATE TABLE models
( modelid char(8) not null primary key,
duration decimal(12,2) default 0 ,
custid char(8) not null,
Custmodel char(30) not null, 
model_type varchar(30) not null,
purpose varchar(30) not null,
feature_like varchar(30) not null,
FOREIGN KEY (custid) REFERENCES customer(custid));


CREATE TABLE service
(serviceid char(8) not null primary key,
service_from varchar(30) not null ,
reason char(30) not null,
modelid char(8) not null,
satisfaction char(30) not null,
FOREIGN KEY (modelid) REFERENCES models(modelid));

CREATE TABLE service_satisfaction
(reason char(30) not null ,
serviceid char(8) not null,
modelid char(8) not null,
primary key(serviceid,modelid),
FOREIGN KEY (modelid) REFERENCES models(modelid));


CREATE TABLE service_disatisfaction
(reason char(30) not null ,
serviceid char(8) not null,
modelid char(8) not null,
primary key(modelid,serviceid),
FOREIGN KEY (modelid) REFERENCES models(modelid));

CREATE TABLE Price
(custmodel char(30) not null primary key ,
cost_price decimal(12,2) default 0,
Selling_price decimal(12,2) default 0) ;


--  Objectives of the Program 
/*A careful study of the passport program would reveal the following points as the objectives of the company in launching this program. 
• To develop a closer and meaningful relationship with the customer. 
• To reward the customers during every point of interaction. 
• To encourage customers to use the authorized service stations of the company. 
• To motivate existing customers to recommend Hero Honda motorcycles to their friends/ relatives. 
• To focus its advertising efforts on a clear targeted group. 
• To enable the customers to have a direct contact/ channel with the company*/

-- Q1 to see which age group to focus and advertising accordingly
select concat(round((a.p/e.tot)*100,2),'%')as 'Above18 and up to 25 Years',
concat(round((b.p/e.tot)*100,1),'%') as 'Above 25 up to 30',
concat(round((c.p/e.tot)*100,1),'%') as'Above 30 up to 50',
concat(round((d.p/e.tot)*100,1),'%') as'Above 50'
from(
select count(Custage) as p
from customer
where custage between 18 and 25) a,
(select count(Custage) as p
from customer
where custage between 26 and 30) b,
(select count(Custage) as p
from customer
where custage between 31 and 49) c,
(select count(Custage) as p
from customer
where custage>=50) d,
(select count(custage) tot from customer ) e;

/* OBSERVATION
Most of the respondents fall in the category between 25 to 30 years, 
followed by the category between 25 to 30 years.
It can be observed that most of the respondents, 
i.e. more than seventy percent of them belonged to the age group between 18 to 30 years. */

-- Q2 Profile of Monthly Income of Respondents 
select concat(round((a.p/e.tot)*100,2),'%')as 'Up to Rs.5000 ',
concat(round((b.p/e.tot)*100,1),'%') as 'Above Rs.5000 up to Rs.10,000 ',
concat(round((c.p/e.tot)*100,1),'%') as'Above Rs.10,000 up to Rs.15,000',
concat(round((d.p/e.tot)*100,1),'%') as'Above Rs.15,000'
from(
select count(custincome) as p
from customer
where custincome <=5000) a,
(select count(Custincome) as p
from customer
where custincome between 5001 and 10000) b,
(select count(Custincome) as p
from customer
where custincome between 10001 and 15000) c,
(select count(Custincome) as p
from customer
where custincome>15000) d,
(select count(custincome) tot from customer ) e;

/* OBSERVATION
Observation Most of the respondents (43%) fall under the income category of above  Rs.15000/- per month, 
followed by the income category of Above Rs.10,000 up to Rs.15,000 (accounting for 31%), 
It can be observed that more than fifty percent of the respondents belonged to the income category 
between Rs.10000 and above   */	
 
-- Q3 Motor Cycle Models Used by Respondents
 select count(custmodel) as 'No. of Responses ',custmodel as  'MOTOR CYCLE MODEL',
 (count(custmodel)/a.m)*100 as 'percentage(%)'
 from models,(select count(CUSTMODEL) m
 FROM models) a
 group by custmodel;
 
 /* OBSERVATION
Splendor is obviously the leading model with a 38% share of respondent, 
Splendor is the largest selling motor cycle in the world   */

-- Q4
select model_type,count(model_type) as 'no.  of responses',
 round((count(model_type)/a.m)*100,2) as 'percentage(%)'
from models,
(select  count(model_type) m from models) a
group by model_type;

 /* OBSERVATION
It is quite obvious from the inspection of data that most of the respondents (78%) are using new (first hand) 
Hero Honda motor cycles. It is notable in this context that the demand drivers for two- wheelers included 
factors like increased availability of cheap consumer financing and a growing need for personal transportation. */


-- Q5  What is your main purpose of using the Hero Honda Motor Cycle? 
select purpose,count(purpose) as responses,round((count(purpose)/a.m)*100,2) as 'percentage(%)'
from models,(select  count(purpose) m from models) a
group by purpose;

/* OBSERVATION
It is obvious from the above data that majority of the respondents use Hero Honda motor cycles
to commute to work */


-- Q6 What do you like most about Hero Honda Motor Cycle
select feature_like,count(feature_like) responses,round((count(purpose)/a.m)*100,2) as 'percentage(%)'
from models,(select  count(feature_like) m from models) a
group by feature_like;


/* OBSERVATION
Mileage is the feature that is most liked by respondents,
In this context it may be observed that Hero Honda is the first company in India to introduce a four stroke fuel efficient engine.
The company had initially positioned the motor cycle as a fuel efficient vehicle 
that could give a mileage of eighty kilometers per liter.  */

-- Q7 Name of the cardholder customers(not expired) and benefits avail by them and are highly satisfied and least satisfied.
select b.Custfname,b.Benifits_avail,b.Rating
 from 
(select a.Custfname,a.custid,Benifits_avail,Rating
from cardholder,(
select custid,Custfname
from customer
where cardholder='yes') a
where 
a.custid=cardholder.custid)b
where 
b.Rating in (
(select min(rating)
from(
select a.Custfname,a.custid,Benifits_avail,Rating
from cardholder,(
select custid,Custfname
from customer
where cardholder='yes') a
where 
a.custid=cardholder.custid)b),(select max(rating)
from(
select a.Custfname,a.custid,Benifits_avail,Rating
from cardholder,(
select custid,Custfname
from customer
where cardholder='yes') a
where 
a.custid=cardholder.custid)b));

/* OBSERVATION
point of contact to take reviews..free service need to be improved and people like gifts */

-- Q8 profit and revenue wise model
select price.custmodel,qty*Selling_price as revenue,
concat(round(((Selling_price-cost_price)/cost_price)*100,2),'%')as profit from
price,
(select Custmodel,count(Custmodel) qty
from models
group by Custmodel) a
where a.custmodel=price.custmodel;


-- max revenue is generated by splender but profit by ambition
-- Q9 top most valuable customers by revenue
select a.Custfname,a.revenue 
from
(select custfname,models.custid,sum(Selling_price) as revenue
from price,models,customer
where models.custmodel=price.custmodel
and customer.custid=models.custid
group by custid)a
where 
a.revenue =(
select max(revenue) from
(
select custfname,models.custid,sum(Selling_price) as revenue
from price,models,customer
where models.custmodel=price.custmodel
and customer.custid=models.custid
group by custid) a);

-- Q 10 revenue generated by customers who are card holders and who are not
select cardholder,sum(Selling_price) as revenue,
round((sum(Selling_price) *100) / (select sum(Selling_price) as revenue
from price,models,customer
where models.custmodel=price.custmodel
and customer.custid=models.custid),2) as 'percentage(%)'
from 
price,models,customer
where models.custmodel=price.custmodel
and customer.custid=models.custid
group by cardholder;

-- observation
-- (increase in revenue due to card program)

-- Q11) a) service from authorized and other centres with reason
select service_from,round((count(service_from)*100/(select count(service_from) from service)),2) as 'percentage(%)',reason
from service
group by service_from,reason;

-- OBSERVATION -- more than 70% of service is from honda

-- b) reason for service from outside and inside
select service_from,percent as 'max percentage(%)',reason 
from
(select service_from,
round((count(service_from)*100/(select count(service_from) from service)),2) as percent,reason
from service
group by service_from,reason) a
where (service_from,percent) in
 ((select a.service_from,max(a.percent)  
 from(
select service_from,
round((count(service_from)*100/(select count(service_from) from service)),2) as percent,reason
from service
group by service_from,reason) a
where a.service_from='Any other'),
(select a.service_from,max(a.percent)  
 from(
select service_from,
round((count(service_from)*100/(select count(service_from) from service)),2) as percent,reason
from service
group by service_from,reason)a
where a.service_from='Hero Honda'));

-- OBSERVATION
 /*HERO HONDA
 Free service offered by the company happens to be the dominating factor for majority of the respondents’
 decision to choose company authorized service center, but this factor is closely followed
 by the faith in Company’s authorized service centre.
 
 ANY OTHER
  These responses indicate that geographic distribution of service centers is important 
  in terms of providing accessibility to the customers, 
  and the importance of quality of the skills offered by the service personnel.   */
  
  -- c) reason for satisfaction
  select reason,count(reason) as responses
  from service_satisfaction
  where (serviceid, modelid) in
  (select serviceid, modelid 
  from service
  where service_from='Hero Honda'
  and satisfaction >= 5)
  group by reason ;
  
  /* The main reason for satisfaction is the service offered by the skilled mechanics of the company
  authorized service centers, followed by on time delivery of the motor cycle. This observation indicates
  that the perceptions of customers about the skills of the mechanics (service personnel) are quite important
  in determining the satisfaction of the customers.*/
  
  -- d) reason for dissatisfaction
  select reason,count(reason) as responses
  from service_disatisfaction
  where (serviceid, modelid) in
  (select serviceid, modelid 
  from service
  where service_from='Hero Honda'
  and satisfaction < 5)
  group by reason ;
  
  /* The main reason for dissatisfaction is attributed to the factor that the motor cycle is not
  thoroughly checked for the problems at the company owned show room, 
  the responses that state, “Vehicle is not checked thoroughly
   customers are not satisfied as the very basic purpose of servicing a vehicle is not achieved*/
  
  
  
 