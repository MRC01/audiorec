-- Function to return the total row count
create or replace function tot_reviews() returns int as $$
    begin
        return (SELECT count(*) FROM reviews);
    end;
$$ LANGUAGE plpgsql
;
-- Histogram of sound quality ratings
select rating, cast(cast((cast(cnt as float) / tot_reviews()) * 1000 as int) / 10.0 as float) as pct
from (
	select ratesound as rating, count(*) as cnt
	from reviews
	group by 1
) t1
order by 1
;
-- Histogram of performance quality ratings
select rating, cast(cast((cast(cnt as float) / tot_reviews()) * 1000 as int) / 10.0 as float) as pct
from (
	select rateperf as rating, count(*) as cnt
	from reviews
	group by 1
) t1
order by 1
;