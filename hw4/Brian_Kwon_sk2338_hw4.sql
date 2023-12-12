# 1. Find maximal departure delay in minutes for each airline. Sort results from smallest to largest maximum delay. 
# Output airline names and values of the delay.
select i.name as airline, max(DepDelayMinutes) as max_delay
from al_perf as a
inner join L_AIRLINE_ID as i on a.DOT_ID_Reporting_Airline = i.ID
group by DOT_ID_Reporting_Airline
order by max_delay;
# 17 rows returned

# 2. Find maximal early departures in minutes for each airline. Sort results from largest to smallest. Output airline names.
select i.name as airline, min(DepDelay) as max_early
from al_perf as a
inner join L_AIRLINE_ID as i on a.DOT_ID_Reporting_Airline = i.ID
group by DOT_ID_Reporting_Airline
order by max_early;
# 17 rows returned


# 3. Rank days of the week by the number of flights performed by all airlines on that day (1 is the busiest). 
# Output the day of the week names, number of flights and ranks in the rank increasing order.
select i.Day, count(*) as count, rank() over (order by count(*) desc) as d_rank 
from al_perf as a
inner join L_WEEKDAYS as i on a.DayOfWeek = i.Code
group by DayOfWeek
order by d_rank;
# 7 rows returned

# 4. Find the airport that has the highest average departure delay among all airports. Consider 0 minutes delay for flights that departed early. 
# Output one line of results: the airport name, code, and average delay.
select i.Name, c.code, avg(a.DepDelayMinutes) as avg_delay
from al_perf as a
inner join L_AIRPORT_ID as i on i.ID = a.OriginAirportID
inner join L_AIRPORT as c on i.Name = c.Name
group by i.Name
having avg(a.DepDelayMinutes) = (
    select max(avg_delay)
    from (
        select avg(DepDelayMinutes) as avg_delay
        from al_perf
        group by OriginAirportID
    ) as subquery
);
# 1 row returned

# 5. For each airline find an airport where it has the highest average departure delay. 
# Output an airline name, a name of the airport that has the highest average delay, and the value of that average delay.
create index idx_airport_ID on L_AIRPORT_ID(ID);
select airline, airport, avg_delay
from(
	select i.name as airline, t.name as airport, avg(DepDelay) as avg_delay, rank() over (partition by i.name order by avg(DepDelay) desc) as d_rank
	from al_perf as a
	inner join L_AIRLINE_ID as i on a.DOT_ID_Reporting_Airline = i.ID
	inner join L_AIRPORT_ID as t on a.OriginAirportID = t.ID
	group by i.name, t.name) as subquery
where d_rank = 1;
# 17 rows returned

# 6.A. Check if your dataset has any cancelled flights.
select count(Cancelled)
from al_perf 
where Cancelled = 1;
# 1 row returned. There are 13227 cancelled flights.

# 6.B. If it does, what was the most frequent reason for each departure airport? 
# Output airport name, the most frequent reason, and the number of cancelations for that reason.
select Name, Reason, count
from(
	select i.Name, c.Reason, count(*) as count, rank() over (partition by i.name order by count(*) desc) as c_rank 
	from al_perf as a
	inner join L_AIRPORT_ID as i on a.OriginAirportID = i.ID
	inner join L_CANCELATION as c on a.CancellationCode = c.Code
	group by i.Name, c.Reason
	order by i.Name, c.Reason) as subquery
where c_rank = 1;
# 325 rows returneds

# 7. Build a report that for each day, output the average number of flights over the preceding 3 days.
select FlightDate, avg(f_count) over (order by FlightDate rows 3 preceding) as f_count_3
from(
	select FlightDate, count(*) as f_count
	from al_perf
	group by FlightDate) as subquery;
# 31 rows returned