SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor_full_name,
    f.title AS film_title,
    c.name AS film_category,
    f.description,
    f.release_year,
    f.rating
FROM 
    actor a
-- Join to get actor-film relationships
JOIN film_actor fa ON a.actor_id = fa.actor_id
-- Join to get film details
JOIN film f ON fa.film_id = f.film_id
-- Join to get film categories
JOIN film_category fc ON f.film_id = fc.film_id
-- Join to get category names
JOIN category c ON fc.category_id = c.category_id
ORDER BY 
    a.last_name, a.first_name, f.title;
