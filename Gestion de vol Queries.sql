create database GestVol
use GestVol
--la creation des table
create table pilote(
numPil int identity,
nomPil varchar(15),
prenomPil varchar(15),
adresse varchar(15),
salaire decimal(7,2),
prime decimal(6,2),
constraint pk_pilote primary key(numPil)
)

create table avion(
numAv int identity,
nomAv varchar(4),
capacite int,
localisation varchar(15)
constraint pk_avion primary key(numAv)
)

create table vol(
numVol int,
numPil int,
numAv int,
date_vol date,
heure_dep time(0),
heure_arr time(0),
ville_dep varchar(15),
ville_arr varchar(15),
constraint pk_vol primary key(numVol),
constraint fk_vol_pilote foreign key(numPil) references pilote(numPil),
constraint fk_vol_avion foreign key(numAv) references avion(numAv),
)

--2 -insertion des jeux d'essai
--           table pilote
insert into pilote values('Ali','Kamili','Marrakech',40000,5000)
insert into pilote values('Driss','Kadirii','Marrakech',45000,5000)
insert into pilote values('Nada','Nassiri','Casa',40000,6000)
insert into pilote values('Karim','Nadri','Fes',50000,6000)
insert into pilote values('Soufiane','Fawzi','Tanger',45000,4500)
insert into pilote values('Said','Farah','Safi',45000,5000)
insert into pilote values('Youssef','Kadawi','Agadir',50000,6000)
--            table avion
insert into avion values('A300',300,'Marrakech')
insert into avion values('A300',300,'Marrakech')
insert into avion values('A320',320,'Casa')
insert into avion values('B747',300,'Casa')
insert into avion values('B747',300,'Marrakech')
insert into avion values('B707',400,'Casa')
insert into avion values('A737',300,'Casa')
insert into avion values('B727',250,'Fes')
insert into avion values('B747',350,'Toulouse')
insert into avion values('A300',400,'Casa')
--             table vol
insert into vol values(100,1,2,'2016-03-23','12:00','15:30','Casa','Paris')
insert into vol values(102,6,9,'2016-09-15','15:15','21:30','Casa','Tokyo')
insert into vol values(200,3,3,'2016-11-11','08:25','12:00','Marrakech','Berlin')
insert into vol values(300,4,10,'2016-02-15','11:15','22:30','Casa','NewYork')
insert into vol values(400,2,1,'2016-05-25','15:15','17:00','Fes','Madrid')
insert into vol values(500,5,3,'2016-04-04','16:20','19:00','Casa','Londre')
insert into vol values(600,4,5,'2016-08-15','20:15','23:00','Marrakech','Bruxcelle')
insert into vol values(700,1,6,'2016-07-23','17:15','19:00','Marrakech','Nice')
insert into vol values(800,6,2,'2016-10-10','21:30','23:30','Fes','Rome')
insert into vol values(900,4,1,'2016-06-28','11:25','13:30','Marrakech','Paris')
-- 3-	Afficher les numéros et les capacités des avions localisés à "Marrakech" 
--      ou dont la capacité est inférieure à 300 passagers
select numAv,capacite from avion
where localisation='marrakech' or capacite<300;

-- 4-	Liste des numéros des pilotes qui ne sont pas en service
select numPil from pilote where numPil not in(select numPil from vol);

-- 5-	Les numéros de vols au départ de "Marrakech" effectués par des pilotes Marrakchis
select vol.numPil from vol join pilote
on vol.numPil=pilote.numPil
where adresse='Marrakech' and ville_dep='Marrakech'

-- 6-	Les vols effectués par un avion qui n'est pas localisé à "Fes" 
select numVol from vol join avion
on vol.numAv=avion.numAv
where localisation <> 'Fes'

-- 7-	Les numéros des pilotes assurant plus d'un vol
select numPil from vol 
group by numPil
having count(numPil)>1

-- 8-	La capacité moyenne des avions pour chaque ville ayant plus que 10 avions
select localisation,AVG(capacite) as moyenne from avion
group by localisation
having count(numAv)>10

-- 9-	Les avions localisés dans la même ville que l'avion numéro 102
select * from avion 
where localisation in (select localisation from avion where numAv=102) and numAv<> 102

-- 10-	Le nombre et les capacités MIN et MAX pour chaque ville des avions qui s'y trouve
select localisation,count(numAv) as nombre,min(capacite) as capacite_min,max(capacite) as capacite_max 
from avion group by localisation 

-- 11-	Créer une vue qui permet d’éviter que certains utilisateurs 
-- aient accès aux salaire et prime des pilotes,
create view piloteView 
as select numPil,nomPil,prenomPil,adresse from pilote 
with check option

-- 12-	Pour épargner aux utilisateurs la formulation d’une requête complexe, développer une vue
--     Charge_h pour consulter la charge horaire (nombre d’heures total en vol) des pilotes.
create view Charge_h 
as select numPil,numVol,DATEDIFF(HOUR,heure_dep,heure_arr) as h_total from vol

-- 13-	Créer une requête qui permet de consulter la vue Charge_h
select * from charge_h

-- 14-	Formuler une requête qui donne la liste des pilotes Marrakechi dont la charge excède un 
--  seuil de 40 heures en utilisant la vue Charge_h.
select Charge_h.numPil,h_total from Charge_h join pilote
on Charge_h.numPil=pilote.numPil
where h_total>40

-- 15-	Définir une vue sur PILOTE, permettant la vérification de la contrainte de domaine suivante :
--le salaire d'un pilote est compris entre 3.000 et 5.000.
create view v_salaire 
as select * from pilote
where salaire between 3000 and 5000
select * from v_salaire