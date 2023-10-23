-- Create the schema for the audio recording review app

-- We have a bunch of fields that automatically capture the date
-- Here's the trigger function that does this
create or replace function trigger_set_date_updated()
RETURNS TRIGGER AS $$
BEGIN
  NEW.date_updated = current_date;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

drop table if exists audiorecs
;
create table audiorecs (
	id			bigserial primary key
	, title		varchar(255)
	, composer	varchar(255)
	, performer	varchar(255)
	, soloist	varchar(255)
	, director	varchar(255)
	, genre		varchar(255)
	, recdate	date
	, location	varchar(255)
	, notes		varchar(255)
	, date_created	date default current_date
	, date_updated	date default current_date
)
;
drop trigger if exists audiorecs_updated on audiorecs
;
create trigger audiorecs_updated
before update on audiorecs
for each row
execute procedure trigger_set_date_updated()
;

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

drop table if exists reviews
;
create table reviews (
	id				bigserial primary key
	, audiorec_id	bigint
	, release_id	bigint
	, reviewer_id	bigint
	, ratesound		int
	, rateperf		int
	, notes			text
	, date_created	date default current_date
	, date_updated	date default current_date
)
;
drop trigger if exists reviews_updated on reviews
;
create trigger reviews_updated
before update on reviews
for each row
execute procedure trigger_set_date_updated()
;

drop table if exists reviewers
;
create table reviewers (
	id				bigserial primary key
	, initials		varchar(10)
	, lastname		varchar(255)
	, firstname		varchar(255)
	, equipment		text
	, misc			text
	, preferences	text
	, date_created	date default current_date
	, date_updated	date default current_date
)
;
drop trigger if exists reviewers_updated on reviewers
;
create trigger reviewers_updated
before update on reviewers
for each row
execute procedure trigger_set_date_updated()
;
-- Functions to return the total row counts of various tables
create or replace function tot_reviews() returns int as $$
    begin
        return (SELECT count(*) FROM reviews);
    end;
$$ LANGUAGE plpgsql
;
create or replace function tot_audiorecs() returns int as $$
    begin
        return (SELECT count(*) FROM audiorecs);
    end;
$$ LANGUAGE plpgsql
;
create or replace function tot_reviewers() returns int as $$
    begin
        return (SELECT count(*) FROM reviewers);
    end;
$$ LANGUAGE plpgsql
;
