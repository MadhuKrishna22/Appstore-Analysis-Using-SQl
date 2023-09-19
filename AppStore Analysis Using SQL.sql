create table apple_store_description as 

SELECT * from appleStore_description1

union all 

SELECT * from appleStore_description2

union all 

SELECT * from appleStore_description3

union all 

SELECT * from appleStore_description4


**EXPLORATORY DATA ANALYSIS**

--Check the number of unique apps in both table applestoreAppleStore--

SELECT COUNT(DISTINCT id) as unique_id
from AppleStore

SELECT COUNT(DISTINCT id) as unique_id
from apple_store_description

--check for any missing values in keyfields--

SELECT COUNT(*) as missing_values 
from AppleStore
where track_name is NULL or user_rating is NULL or prime_genre is NULL



SELECT COUNT(DISTINCT id) as unique_id
from apple_store_description
where app_desc is NULL


--Find out the number of apps per genre--AppleStore

select  prime_genre,COUNT(*) as Numapps
from  AppleStore
GROUP by prime_genre
order by Numapps DESC

--Get an overview of the app's rating--

select min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore

--Get the distribution of app purchase--

SELECT
      (price/2) *2 as priceBinStart,
      ((price/2)*2)+2 as PriceBinEnd,
      COUNT(*) as numapps
from AppleStore

GROUP by PriceBinStart
ORDER by PriceBinStart


**DATA ANALYSIS**

--Determine whether paid apps have higher ratings than free apps--

SELECT case 
			when price > 0 then 'Paid'
            else 'free'
            end as app_type,
            avg(user_rating) as avg_rating
from AppleStore
group by app_type

--Check if apps with more supported languages have higher ratings--

SELECT case 
			when lang_num < 10 then '<10 language'
            when lang_num BETWEEN 10 and 30  then '10-30 languages'
            else '>30 languages'
            end as language_bucket,
            avg(user_rating) as avg_ratings
from AppleStore
group by language_bucket
order by avg_ratings DESC

--check genres with low ratings--

SELECT prime_genre,
					avg(user_rating) as avg_ratings
from AppleStore
GROUP by prime_genre
ORDER by user_rating ASC
limit 10


--Check if there is correlation between the length of the description and the user ratings--

SELECT CASE
			when length(b.app_desc) < 500 then 'Short'
            when length(b.app_desc) between 500 and 1000 then 'Medium'
            else 'Long'
            end as Description_length_bucket,
            avg(user_rating) as avg_rating
            
from 
	AppleStore as A
join 
	apple_store_description as b 
on 
	a.id=b.id
    
group by description_length_bucket
order by avg_rating desc

--Check the Top-rated apps for each  genre--

SELECT
		prime_genre,
        track_name,
        user_rating
from (
  		SELECT
  		prime_genre,
        track_name,
        user_rating,
  		RANK() OVER (PARTITION BY prime_genre ORDER by user_rating desc, rating_count_tot DESC) as rank
        from AppleStore
        ) as a
WHERE
a.rank=1

  

