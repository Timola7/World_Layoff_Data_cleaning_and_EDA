##exploratory data analysis
# can check maximum layoff
select max(total_laid_off) from layoffs_copy2;

#details of the company with the max layoff
select  *
from layoffs_copy2
where total_laid_off = (select max(total_laid_off) from layoffs_copy2);

#you can check compay that had all their staff laid off and other by the number laid off
select * from layoffs_copy2
where percentage_laid_off = 1
order by total_laid_off desc;

# you can also check companies that had all their staff laid off and other by the funds raised
select * from layoffs_copy2
where percentage_laid_off = 1
order by funds_raised_millions desc;

# you can also check companies and their total laid off and other by the total laid off

select company, sum(total_laid_off)
from layoffs_copy2
group by company
order by 2 desc;

#you can do the sam for industry too
select industry, sum(total_laid_off)
from layoffs_copy2
group by industry
order by 2 desc;

#by country
select country, sum(total_laid_off)
from layoffs_copy2
group by country
order by 2 desc;

## we can do time series too
select year(`date`), sum(total_laid_off)
from layoffs_copy2
group by year(`date`)
order by 1 desc;


select month(`date`) as month, year(date) as year, sum(total_laid_off) from layoffs_copy2 ## i prefer this method for dates
group by month, year; ## only works if you want in seperate columns though

select substring(`date`, 1,7) as month, sum(total_laid_off) from layoffs_copy2
where substring(`date`, 1,7)
group by month
order by 1;

with rolling as ( 
select substring(`date`, 1,7) as `month`, sum(total_laid_off) as total_laid_off from layoffs_copy2
where substring(`date`, 1,7) is not null
group by `month`
order by 1)
select `month`, total_laid_off, sum(total_laid_off) over(order by month) as rolling_total 
from rolling;

with company_year(company, year, total_laid_off) as (
select company, year(`date`), sum(total_laid_off)
from layoffs_copy2
group by company, year(`date`)
)
, company_year_rank as(
select *, dense_rank() over(partition by year order by total_laid_off desc) as layoffrank
from company_year
where year is not null)

select * from company_year_rank
where layoffrank <= 5;

# you can also check the date range
select min(`date`), max(`date`)
from layoffs_copy2;