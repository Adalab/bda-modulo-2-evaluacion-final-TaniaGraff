/* 
Ejercicios Evaluación Final Módulo 2 
TANIA GRAFF | PROMO A PART TIME
-- Base de datos Sakila --
*/

USE sakila;

/* 
-- Ejercicio 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
*/

#Utilizo la cláusula DISTINCT para seleccionar los valores únicos de la columna title. 
#Podría usar un ORDER BY para ordernar los títulos pero ya aparecen ordenados de manera alfabética. 

SELECT 
DISTINCT title
FROM film;

/* 
-- Ejercicio 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
*/

#Utilizo el operador de comparación WHERE para encontrar todos los títulos de las películas, donde el rating sea igual a PG-13.

SELECT 
film_id, 
title, 
rating
FROM film
WHERE rating = 'PG-13'
ORDER BY film_id;

/* 
-- Ejercicio 3. Encuentra el título y la descripción de todas las películas que contengan la palabra
"amazing" en su descripción.
*/

#Utilizo la cláusula LIKE para encontrar todos los títulos de películas que en su descripción incluya la palabra "amazing".
#Incluyo los % delante y detrás de la palabra porque no se especifica la posición del texto en el que ha de aparecer la palabra "amazing".

SELECT 
title,
description
FROM film
WHERE description LIKE '%amazing%';

/* 
-- Ejercicio 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
*/

#Utilizo el operador de condición WHERE para filtrar los resultados y encontrar todos los títulos de las películas cuya duración supera los 120 minutos.

SELECT 
title,
length
FROM film
WHERE length > 120
ORDER BY length;

/* 
-- Ejercicio 5. Recupera los nombres de todos los actores.
*/

#Utilizo la cláusula SELECT para recuperar los nombres y apellidos de todos los actores.
#Ordeno los resultados alfabéticamente, por el nombre.

SELECT 
first_name, 
last_name
FROM actor
ORDER BY first_name;

/* 
-- Ejercicio 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
*/

#Vuelvo a utilizar el operador de filtro o cláusula LIKE para encontrar los actores que tengan 'Gibson' en su apellido.

SELECT 
first_name,
last_name
from actor
WHERE last_name LIKE '%Gibson%';

/* 
-- Ejercicio 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
*/

#Utilizo la cláusula BETWEEN junto al operador de condición WHERE para encontrar a los actores cuyos id se encuentran entre el 10 y el 20 (ambos incluídos).

SELECT 
actor_id,
first_name, 
last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

/* 
-- Ejercicio 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en
cuanto a su clasificación.
*/

#Utilizo la cláusula NOT IN para obtener todos los títulos de las películas salvo los que están clasificados como 'R' y 'PG-13'.

SELECT
title,
rating
FROM film
WHERE rating NOT IN ('R', 'PG-13');

/* 
-- Ejercicio 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la
clasificación junto con el recuento.
*/

#Utilizo la función agregada COUNT(film_id) para contar todas las películas que hay asocidadas a cada clasificación. 
#No utilizo la cláusula DISTINCT porque estoy contando el total de películas en base a su id único.
#Renombro el resultado utilizando AS para crear una columna temporal con el recuento.
#Agrupo los resultados utilizando la sentencia GROUP BY ya que he utilizado una función agregada.

#SEUDOGÓDIGO
#film -> rating, COUNT(film_id)

SELECT
rating,
COUNT(film_id) AS film_count
FROM film
GROUP BY rating;

/* 
-- Ejercicio 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del
cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
*/

#Para hacer esta query necesito unir dos tablas, la de customer y rental. 
#Utilizo un INNER JOIN para resolverlo y mostrar solo los clientes que han alquilado películas.
#Uno las dos tablas por la columna común de customer_id.

#SEUDOCÓDIGO
#customer -> customer_id, first_name, last_name
#rental -> COUNT(rental_id), customer_id

SELECT
customer.customer_id,
customer.first_name,
customer.last_name,
COUNT(rental.rental_id) AS film_rental_count
FROM customer
JOIN rental
ON customer.customer_id = rental.customer_id
GROUP BY 
customer.customer_id,
customer.first_name,
customer.last_name;

/* 
-- Ejercicio 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de
la categoría junto con el recuento de alquileres.
*/

#Para hacer esta query necesito unir cuatro tablas, la de rental, con inventory, inventory con film_category y film_category con category para encontrar el nombre de las categorías. 
#Utilizo INNER JOINS para unir las tablas porque solo necesito obtener el nombre de las categorías que tengan una película alquilada asociada.

#SEUDOCÓDIGO
#rental -> COUNT(rental_id), inventory_id
#inventory -> inventory_id, film_id
#film_category -> film_id, category_id
#category -> category_id, name

SELECT
category.name AS category_name,
COUNT(rental.rental_id) AS film_rental_count
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN inventory
ON film_category.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
GROUP BY category.name;

/* 
-- Ejercicio 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla
film y muestra la clasificación junto con el promedio de duración.
*/

#Utilizo la función agregada AVG para econtrar la media de duración (length) de cada una de las categorías del rating.
#Al utilizar la función agregada AVG, incluyo la sentencia GROUP BY para agrupar los resultados en función de su clasificación.

#SEUDOCÓDIGO
#film -> AVG(length), rating

SELECT
rating,
AVG(length) AS film_average_duration
FROM film
GROUP BY rating;

/* 
-- Ejercicio 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian
Love".
*/

#En este caso utilizo una subconsulta para filtrar el nombre y apellido de los actores que aparecen en la película que lleva por titulo 'Indian Love'.
#En la subconsulta uno por el film_id la tabla de film_actor (donde se incluye el id de cada actor) con la de film (donde se incluye el título de cada película).

#SEUDOCÓDIGO
#actor -> actor_id, first_name, last_name
#film_actor -> actor_id, film_id
#film -> film_id, title = 'Indian Love'

SELECT 
actor.first_name, 
actor.last_name
FROM actor
WHERE actor.actor_id IN (
	SELECT film_actor.actor_id
	FROM film_actor
	JOIN film 
    ON film_actor.film_id = film.film_id
	WHERE film.title = 'Indian Love'
    )
ORDER BY actor.first_name;

/* 
-- Ejercicio 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su
descripción.
*/

#Vuelvo a utilizar el operador de filtro o cláusula LIKE para encontrar el título de las películas que contengan la palabra 'dog' o 'cat' en su descipción.

#SEUDOCÓDIGO
#film -> title, description LIKE '%dog%' OR '%cat%')

SELECT
title,
description
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

/* 
-- Ejercicio 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
*/

#Utilizo una subconsulta para filtrar a los actores por su id, y mostrar aquellos actores cuyo id no esté presente en la tabla film_actor.alter
#La query no me devuelve ningún resultado, así que entiendo que todos los id de actores de la tabla actor, están presentes en la tabla film_actor.

#SEUDOCÓDIGO
#actor -> actor_id, first_name, last_name
#film_actor -> actor_id NOT IN 

SELECT
actor.first_name,
actor.last_name
FROM actor
WHERE actor.actor_id NOT IN(
	SELECT actor_id
	FROM film_actor
    );

#Para comprobar que el resultado de la consulta anterior es correcto hago una nueva consulta, en la que selecciono el total de id de la tabla actor y lo comparo con el total de actor_id que aparecen en la tabla film_actor.
#Ambos coinciden, validando el resultado de mi primera consulta.

SELECT
    (SELECT COUNT(actor_id) FROM actor) AS total_actors,
    (SELECT COUNT(DISTINCT actor_id) FROM film_actor) AS actors_in_film_actor;
    
/* 
-- Ejercicio 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
*/

#Utilizo la cláusula BETWEEN junto al operador de condición WHERE para encontrar los títulos de las películas que se han lanzado entre 2005 y 2010.

#SEUDOCÓDIGO
#film -> title, release_year (BETWEEN 2005 AND 2010)

SELECT
title,
release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

/* 
-- Ejercicio 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
*/

#Realizo una subconsulta para filtrar los id de las películas que se encuentran en la categoría 'Family'.
#En la subconsulta uno dos tablas, la de film_category con category, ya que es en esta tabla donde encontramos los nombres de las categorías.

#SEUDOCÓDIGO
#film -> title, film_id
#film_category -> film_id, category_id
#category -> category_id, name

SELECT
film.title
FROM film
WHERE film.film_id IN (
        SELECT film_category.film_id
        FROM film_category
        JOIN category 
        ON film_category.category_id = category.category_id
        WHERE category.name = 'Family'
    );
    
/* 
-- Ejercicio 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
*/

#Utilizo la función COUNT(DISTINCT) para contar el número de películas diferentes en las que aparece cada actor.
#Incluyo el id del actor por si hubiera actores con el mismo nombre y apellidos.
#Uno la tabla de actor con la de film_actor através del id de actor para relacionar a los actores con las películas.
#Al utilizar la función agregada COUNT necesito utilizar la sentencia GROUP BY.
#Y por último utilizo la sentencia HAVING para que la query sólo me devuelva el nombre y apellidos de aquellos actores que han participado en más de 10 películas.

#SEUDOCÓDIGO
#actor -> actor_id, first_name, last_name
#film_actor -> actor_id, COUNT(DISTINCT film_id)

SELECT
actor.actor_id,
actor.first_name, 
actor.last_name,
COUNT(DISTINCT film_actor.film_id) AS film_count
FROM actor
JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
GROUP BY
actor.actor_id,
actor.first_name,
actor.last_name
HAVING COUNT(DISTINCT film_actor.film_id) > 10;

#También he probado a resolverlo creando una CTE para agrupar a los actores con las películas.
#Y luego filtrar los resultados seleccionado solo aquellos registros que aparecen en más de 10 películas.
	
    WITH ActorsFilms AS (
		SELECT
        actor.actor_id,
        actor.first_name, 
        actor.last_name,
        COUNT(DISTINCT film_actor.film_id) AS film_count
        FROM actor
		JOIN film_actor 
		ON actor.actor_id = film_actor.actor_id
		GROUP BY
        actor.actor_id,
		actor.first_name,
		actor.last_name
        )
SELECT
    first_name,
    last_name,
    film_count
FROM ActorsFilms
WHERE film_count > 10;

/* 
-- Ejercicio 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2
horas en la tabla film.
*/

#Utilizo el operador de comparación WHERE para especificar las dos condiciones que deben cumplir las películas, y así filtrar los resultados.
#Como la duración viene expresada en minutos, utilizo 120 minutos en lugar de 2 horas para filtrar los resultados.

#SEUDOCÓDIGO
#film -> title, rating = 'R', length > 120

SELECT
title, 
rating,
length
FROM film 
WHERE length > 120 AND rating = 'R';

/* 
-- Ejercicio 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120
minutos y muestra el nombre de la categoría junto con el promedio de duración.
*/

#Utilizo una CTE para calcular primero las duración media de las películas por categoría.
#Para realizar la CTE necesito unir tres tablas, la de category con film_category y esta a su vez con film, ya que es en esta tabla donde tengo los registros de la duración (length).
#Y luego hago la consulta para que me devuelva solo aquellos registros que superen los 120 minutos de duración.

#SEUDOCÓDIGO
#film -> film_id, AVG(length) > 120
#film_category -> film_id, category_id
#category -> category_id, name

	WITH CategoryAverages AS (
		SELECT category.name AS category_name,
		AVG(film.length) AS average_length
		FROM film
		JOIN film_category 
		ON film.film_id = film_category.film_id
		JOIN category 
		ON film_category.category_id = category.category_id
		GROUP BY category.name
	)

SELECT
category_name,
average_length
FROM CategoryAverages
WHERE average_length > 120;

/* 
-- Ejercicio 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del
actor junto con la cantidad de películas en las que han actuado.
*/

#Utilizo una CTE para agrupar a los actores por el número de película en las que han actuado.
#En la CTE uno dos tablas, utilizo la función agregada COUNT() para obtener el número de películas diferentes en las que han actuado.
#Incluyo el id de cada actor por si hubiera actores con el mismo nombre y apellidos.
#Al hacer la consulta utilizo el operador de comparación WHERE para filtrar los resultados y obtener los datos de los actores que han actuado en al menos 5 películas.

#SEUDOCÓDIGO
#actor-> actor_id, first_name, last_name
#film_actor -> actor_id, COUNT(film_id) > 5

	WITH ActorsFilms AS (
		SELECT  
        actor.actor_id,
        actor.first_name, 
        actor.last_name,
        COUNT(film_actor.film_id) AS film_count
		FROM actor
		JOIN film_actor 
        ON actor.actor_id = film_actor.actor_id
		GROUP BY
        actor.actor_id,
        actor.first_name,
        actor.last_name
	)

SELECT
    first_name,
    last_name,
    film_count
FROM ActorsFilms
WHERE film_count >= 5;

 /* 
-- Ejercicio 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego
selecciona las películas correspondientes.
*/

#Utilizo una subconsulta para encontrar los film_id de las películas que fueron alquiladas por más de 5 días.
#En la subconsulta calculo los días que las películas han estado alquiladas restando los días que separan la fecha de entrega o retorno (return_date) de la de alquiler (rental_date).
#Y luego selecciono los títulos correspondientes de esas películas.

#SEUDOCÓDIGO
#film -> film_id, title
#inventory -> inventory_id, film_id
#rental -> rental_id, rental_date, rental_return, inventory_id

SELECT
film.title
FROM film
WHERE film.film_id IN (
	SELECT inventory.film_id
	FROM inventory
	JOIN rental 
    ON inventory.inventory_id = rental.inventory_id
	WHERE rental.return_date - rental.rental_date > 5
    );
    
/* 
-- Ejercicio 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de
la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado
en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
*/

#Para seleccionar los nombres y apellidos de los actores que no tienen un Id en común con los actores que han actuado en películas de la categoría "Horror" realizo una subconsulta para filtrar los id con la cláusula WHERE.
#En la subconsula uno tres tablas para finalmente poder encontrar el nombre y apellido de todos los actores, menos los que han actuado en alguna película perteneciente a la categoría 'Horror'.

#SEUDOCÓDIGO
#actor -> actor_id, first_name, last_name NOT IN 'Horror'
#film_actor -> actor_id, film_id
#film_category -> film_id, category_id
#category -> category_id, name = 'Horror'

SELECT 
actor.first_name, 
actor.last_name 
FROM actor
WHERE actor.actor_id NOT IN (
    SELECT film_actor.actor_id
    FROM film_actor
    JOIN film_category ON film_actor.film_id = film_category.film_id
    JOIN category ON film_category.category_id = category.category_id
    WHERE category.name = 'Horror'
);


/* 
-- BONUS --
*/

/* 
-- Ejercicio 24. Encuentra el título de las películas que son comedias y tienen una duración mayor
a 180 minutos en la tabla film.
*/

#Para encontrar el título de las películas de la categoría 'Comedy', realizo una subconsulta utilizando el operador de comparación Where.
#De este modo busco los film_id que se encuentran dentro de la categoría comedia.
#Dentro de la subconsulta uno la tabla film con film_category y con category volviendo a utilizar Where para encontrar los registros en los que el nombre de la categoría sea igual a 'Comedy' y la duración sea mayor de 180 minutos.

#SEUDOCÓDIGO
#film -> film_id, title, length > 180
#film_category -> film_id, category_id
#category -> category_id, name = 'Comedy'

SELECT 
film.title
FROM film
WHERE film_id IN (
	SELECT film.film_id
	FROM film
	JOIN film_category 
    ON film_category.film_id = film.film_id 
	JOIN category 
    ON category.category_id = film_category.category_id 
	WHERE category.name = 'Comedy') AND film.length > 180;
    
/* 
-- Ejercicio 25. Encuentra todos los actores que han actuado juntos en al menos una película. La
consulta debe mostrar el nombre y apellido de los actores y el número de películas en las
que han actuado juntos.
*/

#Al utilizar la cláusula SELECT, añado la función CONCAT para unir los registros de las columnas first_name y last_name en una sola, ya que facilita la legibilidad del código.
#Uno la tabla film_actor consigo misma y hago lo mismo con la tabla actor. Luego uno entre sí las tablas a través de los alias para encontrar a las películas en las que han coincidido los actores.
#Utilizo el operador de comparación Where y el símbolo desigual '<>' para evitar que en los resultados los actores se crucen consigo mismo.

#SEUDOCÓDIGO
#actor -> actor_id <> actor_id, first_name, last_name
#film_actor -> actor_id, film_id = film_id
    
SELECT 
CONCAT(actor1.first_name, ' ', actor1.last_name) AS actor_1,
CONCAT(actor2.first_name, ' ', actor2.last_name) AS actor_2,
COUNT(*) AS movies_together_count
FROM film_actor AS film_actor1
JOIN film_actor AS film_actor2 
ON film_actor1.film_id = film_actor2.film_id 
JOIN actor AS actor1 
ON film_actor1.actor_id = actor1.actor_id
JOIN actor AS actor2 
ON film_actor2.actor_id = actor2.actor_id
WHERE actor1.actor_id <> actor2.actor_id
GROUP BY actor_1, actor_2
ORDER BY movies_together_count DESC;












    
    
   
