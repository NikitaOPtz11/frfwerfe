{% set focus_brand_regex = ("'%" + var('focus_brand') + "%'") %}
{% set focus_brand_column_name = ('number_of_' + var('focus_brand')) %}

SELECT
    h3_to_parent(poi_h3_index::h3index, {{ var('grid_resolution') }}) AS h3_index,
    count(poi_id) AS pois_total,
    avg(poi_confidence_google) AS poi_confidence_google_average,
    sum(poi_reviews) AS poi_reviews_total,
    avg(poi_rating) AS poi_rating_average,
    avg(poi_price_level) AS poi_price_level_average,
    sum(poi_opening_time_total) AS poi_opening_time_total,
    sum(poi_popularity_total) AS poi_popularity_total,
    sum(poi_popularity_morning_total) AS poi_popularity_morning_total,
    sum(poi_popularity_noon_total) AS poi_popularity_noon_total,
    sum(poi_popularity_afternoon_total) AS poi_popularity_afternoon_total,
    sum(poi_popularity_evening_total) AS poi_popularity_evening_total,
    count(CASE WHEN poi_closed THEN 1 END) AS poi_closed_total,
    count(CASE WHEN poi_closed_permanently THEN 1 END) AS poi_closed_permanently_total,
    avg(poi_spending_time) AS poi_spending_time_average,
    avg(poi_waiting_time) AS poi_waiting_time_average,
    count(poi_inside_of) AS poi_inside_of_total,
    count(external_poi_id) FILTER ( WHERE external_poi_id LIKE {{ focus_brand_regex }}) AS {{ focus_brand_column_name }},
    count(external_poi_id) FILTER ( WHERE external_poi_id IS NOT NULL AND external_poi_id NOT LIKE {{ focus_brand_regex }}) AS number_of_competitors,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%administration%' OR poi_categories_google LIKE '%administration%') AS poi_category_administration,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%airport%' OR poi_categories_google LIKE '%airport%') AS poi_category_airport,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%apartment%' OR poi_categories_google LIKE '%apartment%') AS poi_category_apartment,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%art_culture%' OR poi_categories_google LIKE '%art_culture%') AS poi_category_art_culture,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%automobile%' OR poi_categories_google LIKE '%automobile%') AS poi_category_automobile,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%beauty%' OR poi_categories_google LIKE '%beauty%') AS poi_category_beauty,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%cafe%' OR poi_categories_google LIKE '%cafe%') AS poi_category_cafe,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%drinks%' OR poi_categories_google LIKE '%drinks%') AS poi_category_drinks,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%education%' OR poi_categories_google LIKE '%education%') AS poi_category_education,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%entertainment%' OR poi_categories_google LIKE '%entertainment%') AS poi_category_entertainment,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%food%' OR poi_categories_google LIKE '%food%') AS poi_category_food,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%groceries%' OR poi_categories_google LIKE '%groceries%') AS poi_category_groceries,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%medical%' OR poi_categories_google LIKE '%medical%') AS poi_category_medical,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%misc%' OR poi_categories_google LIKE '%misc%') AS poi_category_misc,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%office%' OR poi_categories_google LIKE '%office%') AS poi_category_office,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%public_service%' OR poi_categories_google LIKE '%public_service%') AS poi_category_public_service,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%public_transportation%' OR poi_categories_google LIKE '%public_transportation%') AS poi_category_public_transportation,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%recreation%' OR poi_categories_google LIKE '%recreation%') AS poi_category_recreation,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%religious_building%' OR poi_categories_google LIKE '%religious_building%') AS poi_category_religious_building,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%service%' OR poi_categories_google LIKE '%service%') AS poi_category_service,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%shopping%' OR poi_categories_google LIKE '%shopping%') AS poi_category_shopping,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%social_service%' OR poi_categories_google LIKE '%social_service%') AS poi_category_social_service,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%sport%' OR poi_categories_google LIKE '%sport%') AS poi_category_sport,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%tourism%' OR poi_categories_google LIKE '%tourism%') AS poi_category_tourism,
    count(poi_id) FILTER ( WHERE poi_categories_osm LIKE '%wholesaler%' OR poi_categories_google LIKE '%wholesaler%') AS poi_category_wholesaler,
    st_y(h3_to_geo(h3_to_parent(poi_h3_index::h3index, {{ var('grid_resolution') }}))::geometry) AS latitude,
    st_x(h3_to_geo(h3_to_parent(poi_h3_index::h3index, {{ var('grid_resolution') }}))::geometry) AS longitude,
    st_asgeojson(h3_to_geo_boundary_geometry(h3_to_parent(poi_h3_index::h3index, {{ var('grid_resolution') }}))) AS geo_boundary,
    {{ var('grid_resolution') }} AS resolution
FROM {{ ref('poi') }}
GROUP BY h3_to_parent(poi_h3_index::h3index, {{ var('grid_resolution') }})