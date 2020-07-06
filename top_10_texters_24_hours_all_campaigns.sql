SELECT
  u.first_name,u.last_name,c.title ,COUNT (m.id) AS Voters
FROM
  public.assignment a,
  public.user u,
  public.campaign_contact cc,
  public.campaign c,
  public.message m
WHERE
a.user_id = u.id AND
a.id = cc.assignment_id AND
cc.id = m.campaign_contact_id AND
cc.campaign_id = c.id AND
m.is_from_contact = 'f' AND m.CREATED_AT > CURRENT_TIMESTAMP - interval '1 day'
GROUP BY
u.id,u.last_name,u.first_name,c.title, u.email
ORDER BY
  Voters DESC
LIMIT 10
