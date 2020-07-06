SELECT
    c.title AS title,
    o.name,
    texters::int,
    texts_sent::int,
    replies::dec,
    (replies::decimal / texts_sent)  AS reply_rate,
    total_texts::dec,
    opt_outs::int,
    (opt_outs::decimal / texts_sent)  AS opt_out_rate,
    /* cost per texter = $1 / 30 days (est), total_texts at .015 assumes typical text is two 'message segments', see https://www.twilio.com/blog/2017/03/what-the-heck-is-a-segment.html#segment  */
    round(((texters / 30) + ((total_texts * .015)*1.15)), 2) AS costid
FROM pa_spoke.campaign AS c
INNER JOIN pa_spoke.organization AS o ON o.id = c.organization_id
INNER JOIN (
    SELECT
        campaign_id,
        COUNT (DISTINCT m.assignment_id) AS texters,
        COUNT(DISTINCT (
          CASE WHEN m.is_from_contact = 'false' THEN m.id END
        )) AS texts_sent,
        COUNT(DISTINCT (
          CASE WHEN m.is_from_contact = 'true' THEN m.id END
        )) AS replies,
        COUNT(DISTINCT m.id) AS total_texts,
        COUNT(DISTINCT o.id) AS opt_outs
    FROM pa_spoke.assignment a
    INNER JOIN pa_spoke.message m ON m.assignment_id = a.id
    LEFT JOIN pa_spoke.opt_out o ON o.assignment_id = a.id
    GROUP BY 1)
AS m ON m.campaign_id = c.id
WHERE campaign_id >= 0
ORDER BY 1,2
