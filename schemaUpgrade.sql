-- Upgrade prior schema to the new schema
-- STEP 1: make a full copy of the prior database - both schema & data
-- STEP 2: run this script
--
-- Every audiorec becomes a separate release
-- Existing audiorecs having multiple releases will have to be merged afterward
-- For each:
--    keep one master audiorec
--    update releases of all others, changing audiorec_id to the master
--    delete all other audiorecs
--    reviews do not have to be changed

-- Add the new releases table

drop table if exists releases
;
create table releases (
	id			bigserial primary key
	, audiorec_id	bigint
	, label		varchar(255)
	, release	varchar(255)
	, releaseid	varchar(255)
	, reldate	date
	, format	varchar(255)
	, channels	varchar(255)
	, dynrange	varchar(255)
	, notes		varchar(255)
	, date_created	date default current_date
	, date_updated	date default current_date
)
;
drop trigger if exists releases_updated on releases
;
create trigger releases_updated
before update on releases
for each row
execute procedure trigger_set_date_updated()
;

-- Insert release columns from audiorecs into releases

insert into releases
	(id, audiorec_id, label, release, releaseid, reldate, format, channels, dynrange, notes, date_created, date_updated)
select id, id, label, release, releaseid, recdate, format, channels, dynrange, notes, date_created, date_updated
from audiorecs
;

-- Drop release columns from audiorecs table

alter table audiorecs
	drop column label
	, drop column release
	, drop column releaseid
	, drop column format
	, drop column channels
	, drop column dynrange
;

-- Alter the reviews schema so it points to releases instead of audiorecs

alter table reviews rename column audiorec_id to release_id
;

-- Set the autonumber sequence for releases primary key to skip the values already added from audiorec
-- First select max(id) from releases and add 1 to get X
alter sequence releases_id_seq restart with X
;
