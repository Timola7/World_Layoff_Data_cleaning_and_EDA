##data cleaning
select * from layoffs;
# step 1: remove duplicates
# standardize the data, consistency and same format
# remove null or blank values
# remove unnnecessary columns

# create a copy of the intended table, dont work on the raw data
create table layoffs_copy
like layoffs;

select * from layoffs_copy;

# insert the values into the copy table
insert into layoffs_copy
select* from layoffs;

select * from layoffs_copy;

#duplicate checking
#use row number to create a columns that counts row that were repeated
select *, row_number() 
over(partition by country, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_copy;

with duplicate_cte as(
	select *, row_number() 
over(partition by country, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_copy)
select * from duplicate_cte
where row_num > 1;

#check the presented "duplicates" because some of the values might not actuallly be duplicates if not all columns 
# were used in your row_number() 
select * from layoffs_copy
where company = "Casper";

#create another copy of the copy taht actually contains a a real row_num COLUMN to be able to delete the duplicate row

CREATE TABLE `layoffs_copy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_copy2;

insert into layoffs_copy2
select *, row_number() 
over(partition by country, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_copy;

select * from layoffs_copy2
where row_num >1;
select * from layoffs_copy2
where company = "Casper";

DELETE from layoffs_copy2
where row_num >1;

#STANDARDIZING DATA, DATA QUALITY ISSUES, SPACES SYMBOLS THAT SHOULDNT BE WHERE THEY ARE
# SPACE ISSUES
select * from layoffs_copy2
order by company;
#TRIM EXTRA SPACES
SELECT company, trim(company)
from layoffs_copy2
order by company;

update layoffs_copy2
set company = trim(company);

# check for synonymic vakues in columns e.g crypto and cryptocurrency
select distinct industry
from layoffs_copy2
order by industry;

select * from layoffs_copy2
where industry like "Crypto%"
order by industry;

update layoffs_copy2
set industry = "Crypto"
where industry like "Crypto%"; 

#case of united states and united states.
select distinct country
from layoffs_copy2;
select distinct country, trim(trailing "." from country)
from layoffs_copy2;

update layoffs_copy2
set country = trim(trailing "." from country)
where country like "United States%";

#ensure columns are in the right format e.g the date column should be in date format
select `date`, str_to_date(`date`, "%m/%d/%Y")
FROM layoffs_copy2;

UPDATE layoffs_copy2
set `date` = str_to_date(`date`, "%m/%d/%Y");
select* from layoffs_copy2;

#now to change the date format completely or "officially" such that in table info it shows as such
# only do this on copies of the raw table and not the table itself
alter table layoffs_copy2
modify column `date` date;

#nulls and blanks
#nulls
select* from layoffs_copy2;
select* from layoffs_copy2
where total_laid_off is null and percentage_laid_off is null;


# in some cases like industry you could have some missing values which could just be added
select distinct industry
from layoffs_copy2
order by 1;
select  * from layoffs_copy2
where industry is null or industry = "";
#check if any of the rows with null values have populated ones
select * from layoffs_copy2
where company = "Airbnb";

#create a query for both null and populated rows with some common columns
select * from layoffs_copy2 t1
join layoffs_copy2 t2
on t1.company = t2.company
where t1.industry is null or t1.industry = "" and t2.industry is not null
order by t1.company;

#set nulls to blank
update layoffs_copy2
set industry = null
where industry = "";

select * from layoffs_copy2 t1
join layoffs_copy2 t2
on t1.company = t2.company
where t1.industry is null or t1.industry = "" and t2.industry is not null
order by t1.company;

#update the nulls rows with the comman value
update layoffs_copy2 t1
join layoffs_copy2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

#where total laid off and percentage laid off is null is not that useful in these data, so could be deleted
delete from layoffs_copy2
where total_laid_off is null and percentage_laid_off is null;
select * from layoffs_copy2
where total_laid_off is null and percentage_laid_off is null;

#now we can delete or drop the extra coumn we used for duplicate detection
select * from layoffs_copy2;

alter table layoffs_copy2
drop column row_num;