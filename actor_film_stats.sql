USE sakila;
WITH rating_counts AS (
    SELECT 
        a.actor_id,
        f.rating,
        COUNT(*) AS rating_count,
        ROW_NUMBER() OVER (PARTITION BY a.actor_id ORDER BY COUNT(*) DESC) AS rating_rank
    FROM 
        actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    GROUP BY a.actor_id, f.rating
),
category_counts AS (
    SELECT 
        a.actor_id,
        c.name AS category,
        COUNT(*) AS category_count,
        ROW_NUMBER() OVER (PARTITION BY a.actor_id ORDER BY COUNT(*) DESC) AS category_rank
    FROM 
        actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY a.actor_id, c.name
)
SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor_full_name,
    COUNT(DISTINCT fa.film_id) AS number_of_films,
    rc.rating AS most_common_rating,
    cc.category AS most_common_category
FROM 
    actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN rating_counts rc ON a.actor_id = rc.actor_id AND rc.rating_rank = 1
LEFT JOIN category_counts cc ON a.actor_id = cc.actor_id AND cc.category_rank = 1
GROUP BY 
    a.actor_id, a.first_name, a.last_name, rc.rating, cc.category
ORDER BY 
    number_of_films DESC, a.last_name, a.first_name;
