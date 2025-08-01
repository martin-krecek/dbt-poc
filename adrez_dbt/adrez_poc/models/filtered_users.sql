{{ config(materialized='table') }}

-- file: models/filtered_users.sql
select
  userId,
  count(*) as post_count
from {{ source('adrez_poc','data') }}
where userId in (1, 2)
group by userId 