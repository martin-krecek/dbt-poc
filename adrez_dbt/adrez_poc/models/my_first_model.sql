-- file: models/my_first_model.sql
select
  userId,
  count(*) as post_count
from {{ source('adrez_poc','data') }}
group by userId
