/*
    Parte I

*/

/*

5. Listar el título, idiomas (languages), géneros, fecha de lanzamiento (released) y número de votos (imdb.votes) 
   de las películas de géneros Drama y Action (la película puede tener otros géneros adicionales), 
   que solo están disponibles en un único idioma y por último tengan un rating (imdb.rating) mayor a 9 o bien tengan 
   una duración (runtime) de al menos 180 minutos. Listar ordenados por fecha de lanzamiento y número de votos.

*/

db.movies.find(
    {
        genres: {$all: ["Drama", "Action"]}, 
        languages: {$size: 1}, 
        $or: [{"imdb.rating": {$gt: 9}},{runtime: {$gte: 180}}]
    },
    {title: 1, languages: 1, genres: 1, released: 1, "imdb.votes": 1}
)
.sort({released: -1, "imdb.votes": 1})


/*

6. Listar el id del teatro (theaterId), estado (location.address.state), ciudad (location.address.city), 
   y coordenadas (location.geo.coordinates) de los teatros que se encuentran en alguno de los estados "CA", "NY", "TX" y 
   el nombre de la ciudades comienza con una ‘F’. Listar ordenados por estado y ciudad.

*/

db.theaters.find (
    {
        "location.address.state": {$in : ["CA", "NY", "TX"]}, 
        "location.address.city": /^F/ 
    },
    {theaterId:1, "location.address.state": 1, "location.address.city": 1, "location.geo.coordinates": 1, _id: 0}
)
.sort({"location.address.state": 1, "location.address.city": 1})


/*

7. Actualizar los valores de texto (text) y fecha (date) del comentario cuyo id es ObjectId("5b72236520a3277c015b3b73") 
   a "This is a great comment" y fecha actual respectivamente. 

*/

db.comments.updateOne(
    {
        _id: ObjectId("5b72236520a3277c015b3b73")
    },
    {
        $set: {text: "This is a great comment"},
        $currentDate: { "date": true }
    }
)



/*
    Parte II

*/


/*

10. Listar el id del restaurante (restaurant_id) y las calificaciones de los restaurantes donde al menos una 
    de sus calificaciones haya sido realizada entre 2014 y 2015 inclusive, y que tenga una puntuación (score) 
    mayor a 70 y menor o igual a 90.

*/

db.restaurants.find(
    {
        grades: {
            $elemMatch: {
                date: {"$gte": ISODate("2014-01-01"), "$lte": ISODate("2015-01-31") }, 
                score: {"$gt": 70, "$lte": 90}
            } 
        }
    },
    {restaurant_id:1, grades: 1}
)

