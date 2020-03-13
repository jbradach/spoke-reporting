SELECT u.id AS user_id,
       u.last_name,
       u.first_name,
       COUNT(m.id) AS message_sent_count
FROM assignment a,
     "user" u,
     message m
WHERE a.user_id = u.id
  AND a.id = m.assignment_id
  AND a.campaign_id = [YOUR_CAMPAIGN_ID]
  AND m.is_from_contact = 'f'
GROUP BY u.id
ORDER BY message_sent_count DESC;
