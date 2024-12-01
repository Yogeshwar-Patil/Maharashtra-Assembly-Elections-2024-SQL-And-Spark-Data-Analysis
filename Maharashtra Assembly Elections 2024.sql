-- Maharashtra Assembly Elections 2024
-- SQL Data Analysis

--	Data Cleaning
-- Renaming Columns for better understanding

ALTER TABLE maha_results_2024 RENAME COLUMN "AC_No" TO Constituency_No;
ALTER TABLE maha_results_2024 RENAME COLUMN "AC_Name" TO Constituency_Name;
ALTER TABLE maha_results_2024 RENAME COLUMN "Sl_no" TO serial_no;
ALTER TABLE maha_results_2024 RENAME COLUMN "candidate" TO candidate_name;
ALTER TABLE maha_results_2024 RENAME COLUMN "EVM_Votes" TO EVM_Votes;
ALTER TABLE maha_results_2024 RENAME COLUMN "Total_Votes" TO total_votes;
ALTER TABLE maha_results_2024 RENAME COLUMN "Vote_Share_in_percent" TO Vote_Share_in_percent;

-- 1.	Count the Total Constituencies: Find the total number of constituencies in the dataset
select 
	count(distinct constituency_no) as total_constituencies 
from maha_results_2024 ;

-- 2.	List All Parties: Retrieve list of all parties in the dataset.
select 
	distinct party as party_name 
from maha_results_2024;

-- 3.	Candidate with the Highest Votes in a Constituency: Display the candidate with the highest Total_Votes for each constituency_no.
with cte as (
	select 
		constituency_no,
		constituency_name,
		candidate_name,
		Total_Votes,
		dense_rank() over(partition by constituency_no order by Total_Votes desc) as rnk
	from maha_results_2024
)
select 
	constituency_no,
	constituency_name,
	candidate_name,
	Total_Votes
from cte
where rnk = 1;

-- 4.	Average Vote Share: Calculate the average Vote_Share_in_percent across all candidates.
select 
	round(avg(Vote_Share_in_percent),2) as average_vote_share_in_percent 
from maha_results_2024;

-- 5.	Total Postal Votes by Party: Summarize the total Postal_Votes for each party.
select 
	party,
	sum(Postal_Votes) as total_postal_votes
from maha_results_2024
group by party;


-- 6.	Winning Candidate Per Constituency: Identify the candidate with the maximum Total_Votes in each constituency.
with cte as (
	select 
		constituency_no,
		constituency_name,
		candidate_name,
		Total_Votes,
		party,
		dense_rank() over(partition by constituency_no order by Total_Votes desc) as rnk
	from maha_results_2024
)
select 
	constituency_no,
	constituency_name,
	candidate_name,
	Total_Votes,
	party
from cte
where rnk = 1;
	
-- 7.	Votes from EVM: Show the total EVM_Votes cast across all constituencies.
select sum(EVM_Votes) as total_EVM_votes from maha_results_2024;

-- 8.	Vote Share Above 50%: List candidates who have a Vote_Share_in_percent greater than 50.
select  
	candidate_name,
	constituency_no,
	constituency_name,
	Total_Votes,
	Vote_Share_in_percent
from maha_results_2024
where Vote_Share_in_percent > 50;

-- 9.	Constituencies with No Postal Votes: Find constituencies where Postal_Votes are zero.
select 
	distinct constituency_no, 
	constituency_name  
from maha_results_2024 
where Postal_Votes = 0;

-- 10.	Count Candidates per Party: Display the total number of candidates for each party.
select 
	party,
	count(candidate_name) as no_of_candidates
from maha_results_2024
group by party
order by no_of_candidates desc;


--11.	Top 3 Parties Based on Total Votes: Retrieve the top 3 parties with the highest sum of Total_Votes.
select 
	party,
	sum(total_votes) as total_votes 
from maha_results_2024 mr
group by party
order by total_votes desc
limit 3;

-- 12. for each party from total_no_of_candidates how many candidates are won ?
WITH candidate_ranks AS (
    SELECT 
        constituency_no,
        constituency_name,
        candidate_name,
        Total_Votes,
        party,
        DENSE_RANK() OVER (PARTITION BY constituency_no ORDER BY Total_Votes DESC) AS rnk
    FROM maha_results_2024
)
SELECT 
    party,
    COUNT(*) AS total_no_of_candidates,
    COUNT(CASE WHEN rnk = 1 THEN 1 END) AS no_of_winning_candidates
FROM candidate_ranks
GROUP BY party
ORDER BY no_of_winning_candidates DESC;

-- 13.	Constituencies with Closest Margins: Find constituencies where the difference in Total_Votes between the top two candidates is less than 100.

with cte as (
	select 
		constituency_no, constituency_name, candidate_name, party, total_votes,
		row_number() over(partition by constituency_no, constituency_name order by total_votes desc) as rn
	from maha_results_2024 
)
select 
	c1.constituency_no, c1.constituency_name, c1.candidate_name, c1.party, c1.total_votes, c1.rn, c2.candidate_name, c2.party, c2.total_votes, c2.rn
from cte c1
join cte c2 on c1.constituency_no = c2.constituency_no and c1.rn = 1 and c2.rn = 2
where c1.total_votes - c2.total_votes < 100;

-- 14.	Winning Margin for Each Constituency:
-- Calculate the winning margin (difference in votes) for each constituency.
WITH RankedResults AS (
    SELECT 
        constituency_no,
        constituency_name,
        Total_Votes,
        RANK() OVER (PARTITION BY constituency_no ORDER BY Total_Votes DESC) AS rank
    FROM maha_results_2024
)
SELECT 
    constituency_no,
    constituency_name,
    MAX(CASE WHEN rank = 1 THEN Total_Votes ELSE 0 END) -
    MAX(CASE WHEN rank = 2 THEN Total_Votes ELSE 0 END) AS Winning_Margin
FROM RankedResults
GROUP BY constituency_no, constituency_name;

-- 15.	Highest Vote Share by Prty:
-- Identify the constituency and candidate where each party received its highest Vote_Share_in_percent.

select 
	party, 
	constituency_name, 
	candidate_name, 
	max(vote_share_in_percent)
from maha_results_2024
group by party, constituency_name, candidate_name ;


-- 16.	Votes Percentage in Top 3 Constituencies:
-- For the top 3 constituencies with the highest total votes, calculate each candidate's percentage share of votes.

with top_3_constituencies as (
	select 
		constituency_no, constituency_name,
		sum(total_votes) as total_votes_per_constituency
	from maha_results_2024
	group by constituency_no, constituency_name
	order by total_votes_per_constituency desc 
	limit 3
)
select 
	mr.candidate_name, 
	mr.party, 
	mr.constituency_no, 
	mr.constituency_name, 
	mr.total_votes ,
	(mr.total_votes *100 / tc.total_votes_per_constituency) as vote_percentage
from maha_results_2024 mr
join top_3_constituencies tc on mr.constituency_no = tc.constituency_no;


--	17.	Party-Wise Vote Share Distribution:
--	Calculate the average Vote_Share_in_percent for each party.

select 
	party,
	round(avg(vote_share_in_percent),2) as avg_vote_share
from maha_results_2024
group by party;


--	18.	Identify Constituencies with Most Candidates:
--	Find the constituencies with the highest number of candidates.

select 
	constituency_no , constituency_name ,
	count(candidate_name) as candidates_count
from maha_results_2024
group by constituency_no , constituency_name 
order by candidates_count desc;


--	19.	Postal Votes Contribution by Party:
--	Calculate the percentage contribution of Postal_Votes for each party.

select 
	party,
	round(sum(postal_votes) * 100 / sum(total_votes)::numeric,2) as contribution_of_postal_votes
from maha_results_2024
group by party
order by contribution_of_postal_votes desc;


--	20.	Filter Constituencies by Party Performance:
--	List constituencies where a specific party won (e.g., party = 'XYZ').

select 
	constituency_no, 
	constituency_name, 
	party, 
	total_votes
from maha_results_2024 r1
where total_votes = (select max(total_votes) from maha_results_2024 r2 where r1.constituency_no = r2.constituency_no);


--	21.	Party-Wise Top Performers:
--	Identify the top-performing candidate for each party.

select 
	party,
	candidate_name, 
	constituency_name,
	total_votes 
from maha_results_2024 r1
where total_votes = (select max(total_votes) from maha_results_2024 r2 where r1.party = r2.party)
order by total_votes desc;

-- Optimize Solution -- executes within 1 sec and above query takes 3 secs 
with cte as (
	select 
		party,
		max(total_votes) as votes 
	from maha_results_2024
	group by party
)
select 
	r1.party,
	candidate_name, 
	constituency_name,
	total_votes 
from maha_results_2024 r1
join cte c on r1.party = c.party
where r1.total_votes = votes
order by total_votes desc;
