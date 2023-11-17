//Listar el título, año, actores (cast), directores y rating de las 10 películas con mayor rating (“imdb.rating”) de la década del 90.
// ¿Cuál es el valor del rating de la película que tiene mayor rating? (Hint: Chequear que el valor de “imdb.rating” sea de tipo “double”).

db.movies.find(
    {
        "imdb.rating":{$type:"double"}, //chequea que el rating sea double
        "year":{$gte:1990,$lt:2000} //chequea que el año sea entre 1990 y 2000
    },
    {
        "title":1, //proyecta los campos que se piden
        "year":1,   
        "cast":1,
        "directors":1,
        "imdb.rating":1
    }
).sort({"imdb.rating":-1}).limit(10) //ordena por rating descendente y limita a 10
