-- file: models/my_first_model.sql
select
  userId,
  count(*) as post_count,
  current_timestamp as last_updated_timestamp
from {{ source('adrez_poc','data') }}
group by userId
