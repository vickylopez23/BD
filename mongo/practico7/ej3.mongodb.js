//Listar el nombre, email, texto y fecha de los comentarios que la película con id (movie_id) 
//ObjectId("573a1399f29313caabcee886") recibió entre los años 2014 y 2016 inclusive. Listar ordenados por fecha. 
//Escribir una nueva consulta (modificando la anterior) para responder ¿Cuántos comentarios recibió?
// Listar el nombre, email, texto y fecha de los comentarios que la película con id (movie_id) ObjectId("573a1399f29313caabcee886") recibió entre los años 2014 y 2016 inclusive. Listar ordenados por fecha. Escribir una nueva consulta (modificando la anterior) para responder ¿Cuántos comentarios recibió?
use("mflix")

var coms = db.comments.find(
    {
        movie_id: ObjectId("573a1399f29313caabcee886"), //busca los comentarios de la pelicula con ese id
        date: { 
            $gte: new Date("2014-01-01"), //busca los comentarios entre esas fechas
            $lt: new Date("2017-01-01") 
        }
    },
    {
        "name": 1, //proyecta los campos que se piden
        "email": 1,
        "text": 1,
        "date": 1
    }
).sort( //ordena por fecha
    {
        "date": 1 
    }
)


var len_coms = db.comments.find(
    {
        movie_id: ObjectId("573a1399f29313caabcee886"), //busca los comentarios de la pelicula con ese id
        date: {
            $gte: new Date("2014-01-01"),
            $lt: new Date("2017-01-01")
        }
    },
    {
        "name": 1,
        "email": 1,
        "text": 1,
        "date": 1
    }
).sort( //ordena por fecha
    {
        "date": 1
    }
).count() //cuenta los comentarios

console.log(coms) //muestra los comentarios
console.log("hay", len_coms, "comentarios") //muestra la cantidad de comentarios