//Listar el título, idiomas (languages), géneros, fecha de lanzamiento (released) y
// número de votos (“imdb.votes”) de las películas de géneros Drama y Action 
//(la película puede tener otros géneros adicionales), que solo están disponibles en un único idioma y
// por último tengan un rating (“imdb.rating”) mayor a 9 o bien tengan una duración (runtime) de al menos 180 minutos. 
//Listar ordenados por fecha de lanzamiento y número de votos.

use ("mflix")
db.movies.find(
    {
        "genres":{$all:["Drama","Action"]}, //chequea que tenga esos generos
        "languages":{$size:1}, //chequea que tenga un solo idioma
        $or:[ //chequea que tenga un rating mayor a 9 o una duracion mayor a 180
            {"imdb.rating":{$gt:9}},
            {"runtime":{$gt:180}}
        ]
    },
    {
        "title":1, //proyecta los campos que se piden
        "languages":1,
        "genres":1,
        "released":1,
        "imdb.votes":1
    }
).sort({"released":1,"imdb.votes":1}) //ordena por fecha de lanzamiento y numero de votos
