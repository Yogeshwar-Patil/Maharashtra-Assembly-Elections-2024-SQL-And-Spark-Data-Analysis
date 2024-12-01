# Maharashtra-Assembly-Elections-2024-SQL-And-Spark-Data-Analysis

## Context of the Data
This dataset reflects the results of the **2024 Maharashtra Assembly Elections**, which determine the members of the legislative assembly (MLAs) in the state.

**Columns:**
- **Constituency_Number** (Integer): The unique identifier for each constituency.
- **Constituency_Name** (String): The name of the constituency.
- **Party** (String): The political party of the candidate.
- **Candidate_Name** (String): The name of the candidate.
- **Total_Votes** (Integer): Total votes received by the candidate.
- **Postal_Votes** (Integer): Votes received via postal ballots.
- **EVM_Votes** (Integer): Votes received via electronic voting machines.
- **Vote_Share_in_Percent** (Float): Percentage of total votes received by the candidate.

### Dataset Link : https://data.opencity.in/dataset/maharashtra-assembly-elections-2024

## Questions

1.	Count the Total Constituencies: Find the total number of constituencies (AC_No) in the dataset
2.	List All Parties: Retrieve a distinct list of all parties (party) in the dataset.
3.	Candidate with the Highest Votes in a Constituency: Display the candidate with the highest Total_Votes for each AC_No.
4.	Average Vote Share: Calculate the average Vote_Share_in_percent across all candidates.
5.	Total Postal Votes by Party: Summarize the total Postal_Votes for each party.
6.	Winning Candidate Per Constituency: Identify the candidate with the maximum Total_Votes in each constituency.
7.	Votes from EVM: Show the total EVM_Votes cast across all constituencies.
8.	Vote Share Above 50%: List candidates who have a Vote_Share_in_percent greater than 50.
9.	Constituencies with No Postal Votes: Find constituencies where Postal_Votes are zero.
10.	Count Candidates per Party: Display the total number of candidates for each party.
11.	Top 3 Parties Based on Total Votes: Retrieve the top 3 parties with the highest sum of Total_Votes.
12. for each party, from total_no_of_candidates how many candidates are won ?
13.	Constituencies with Closest Margins: Find constituencies where the difference in Total_Votes between the top two candidates is less than 100.
14.	Winning Margin for Each Constituency: Calculate the winning margin (difference in votes) for each constituency.
15.	Highest Vote Share by Party: Identify the constituency and candidate where each party received its highest Vote_Share_in_percent.
16.	Votes Percentage in Top 3 Constituencies: For the top 3 constituencies with the highest total votes, calculate each candidate's percentage share of votes.
17.	Party-Wise Vote Share Distribution: Calculate the average Vote_Share_in_percent for each party.
18.	Identify Constituencies with Most Candidates: Find the constituencies with the highest number of candidates.
19.	Postal Votes Contribution by Party: Calculate the percentage contribution of Postal_Votes for each party.
20.	Filter Constituencies by Party Performance: List constituencies where a specific party won (e.g., party = 'XYZ').
21.	Party-Wise Top Performers: Identify the top-performing candidate for each party.
22. Proportional Representation by Votes: Calculate the vote share of each party across all constituencies.
23.	Swing Analysis Between Parties: Compare the vote difference between the top two parties in each constituency.
24.	Overall Turnout Analysis: Determine the total voter turnout (EVM_Votes + Postal_Votes) by constituency.
25. Identify Dominant Parties Per Region: Find regions (group of constituencies) dominated by a single party.
