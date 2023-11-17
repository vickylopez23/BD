// 1- Insertar 5 nuevos usuarios en la colección users. Para cada nuevo usuario creado,
//  insertar al menos un comentario realizado por el usuario en la colección comments.
use('mflix')

//esto inseerta 5 usuarios en la coleccion users
db.users.insertMany(
  [
    {
      'name': 'name 1',
      'email': 'name_1@example.com',
      'password': 'example123'
  },
  {
      'name': 'name 2',
      'email': 'name_2@example.com',
      'password': 'example123'
  },
  {
      'name': 'name 3',
      'email': 'name_3@example.com',
      'password': 'example123'
  },
  {
      'name': 'name 4',
      'email': 'name_4@example.com',
      'password': 'example123'
  },
  {
      'name': 'name 5',
      'email': 'name_5@example.com',
      'password': 'example123'
  }

  ]
)
var users =db.users.find({'name':/^name/}) //busca los usuarios que empiecen por name

users.foreach(user => { //para cada usuario
  db.comments.insertOne({ //inserta un comentario
    "name": user.name,//con el nombre del usuario
    "email": user.email,//con el email del usuario
    "movie_id":new ObjectId("5a"),//con un id de pelicula
    "text": "text example",//con un texto
    "date":new Date()
  })


}
  )
  
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

//Listar el nombre, id de la película, texto y 
//fecha de los 3 comentarios más recientes realizados por el usuario con email patricia_good@fakegmail.com. 

use("mflix")

db. comments.find(
    {
        email: "patricia_good@fakegmail.com" //busca los comentarios de ese email
    },
    {
        "name": 1, //proyecta los campos que se piden
        "movie_id": 1,
        "text": 1,
        "date": 1
    }
).sort( //ordena por fecha
    {
        "date": -1 //ordena por fecha descendente
    }
).limit(3) //limita a 3
    
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


//Listar el id del teatro (theaterId), estado (“location.address.state”), 
//ciudad (“location.address.city”), y coordenadas (“location.geo.coordinates”) de 
///los teatros que se encuentran en algunos de los estados "CA", "NY", "TX" 
//y el nombre de la ciudades comienza con una ‘F’. Listar ordenados por estado y ciudad.

use('mflix')

db.theaters.find(
    {
        "location.address.state": { //busca los teatros en esos estados
            $in:["CA", "NY", "TX"] // que esten en esos estados
        },
        "location.address.city": /^F/
    },
    {
        "_id": 0,
        "theaterId": 1,
        "location.address.state": 1,
        "location.address.city": 1,
        "location.geo.coordinates": 1
    }
).sort(
    {
        "location.address.state": 1,
        "location.address.city": 1,
    }
)

//Actualizar los valores de los campos texto (text) y fecha (date) del comentario cuyo id 
//es ObjectId("5b72236520a3277c015b3b73")
// a "mi mejor comentario" y fecha actual respectivamente.

use ("mflix")

db.comments.updateOne(
    {
        "_id":ObjectId("5b72236520a3277c015b3b73") //busca el comentario con ese id
    }
    ,
    {
        $set: { //actualiza los campos
            "text": "nope", //actualiza el texto
            "date": new Date() //actualiza la fecha
        }
    }
)



//Actualizar el valor de la contraseña del usuario cuyo email es joel.macdonel@fakegmail.com a "some password". 
//La misma consulta debe poder insertar un nuevo usuario en caso que el usuario no exista. 
//Ejecute la consulta dos veces. ¿Qué operación se realiza en cada caso?  (Hint: usar upserts). 



use("mflix")

db.users.find(
    {"email":"joel.macdonel@fakegmail.com"} //busca el usuario con ese email
)

use("mflix")
db.users.findOneAndUpdate( //busca el usuario con ese email y actualiza la contraseña
    {
        "email": "joel.macdonel@fakegmail.com" //busca el usuario con ese email
    },
    { 
        $set: {  //actualiza la contraseña
            "password": "some password" 
        } 
    },
    {
        upsert: true,//si no existe lo crea
    }
)

//Remover todos los comentarios realizados por el usuario cuyo email 
//es victor_patel@fakegmail.com durante el año 1980.

use("mflix")

db.comments.deleteMany(
    {
        "email": "victor_patel@fakegmail.com", //busca los comentarios de ese email
        "date": {
            $gte: new Date("1980-01-01"), //busca los comentarios entre esas fechas
            $lt: new Date("1981-01-01")     //busca los comentarios entre esas fechas
        }
    }
)
//Listar el id del restaurante (restaurant_id) y las calificaciones de los restaurantes
// donde al menos una de sus calificaciones haya sido realizada entre 2014 y 2015 inclusive, 
//y que tenga una puntuación (score) mayor a 70 y menor o igual a 90.

use("restaurantdb")

db.restaurants.find(
  {
      grades: { //grandes es un array
          $elemMatch: { //elemMatch chequea que al menos un elemento cumpla con las condiciones
              date: {"$gte": ISODate("2014-01-01"), "$lte": ISODate("2015-01-31") },  //chequea que la fecha este entre 2014 y 2015
              score: {"$gt": 70, "$lte": 90} //chequea que el score este entre 70 y 90
          } 
      }
  },
  {restaurant_id:1, grades: 1} //proyecta los campos que se piden, se que es 1 porque es un array y no se puede proyectar un array

)
/*agregar dos nuevas calificaciones al restaurante cuyo id es "50018608". A continuación se especifican las calificaciones a agregar en una sola consulta.  

{
	"date" : ISODate("2019-10-10T00:00:00Z"),
	"grade" : "A",
	"score" : 18
}

{
	"date" : ISODate("2020-02-25T00:00:00Z"),
	"grade" : "A",
	"score" : 21
}

*/

use("restaurantdb") 
db.restaurants.find( //busca el restaurante con ese id
    {
        "grades": { //busca en el array grades
            $elemMatch: { //chequea que al menos un elemento cumpla con las condiciones
                "score": { //chequea que el score este entre 70 y 90
                    $gt: 70, //mayor a 70
                    $lte: 90 //menor o igual a 90
                },
                "date": { //chequea que la fecha este entre 2014 y 2015
                    $gte: new Date("2014-01-01"), //mayor o igual a 2014
                    $lt: new Date("2016-01-01") //menor a 2016
                }
            }
        },
    },
    {
        "_id": 0, //proyecta los campos que se piden
        "restaurant_id": 1, //proyecta el id del restaurante
        "grades": 1 //proyecta el array grades
    }
)







//Cantidad de cines (theaters) por estado.

use ("mflix")
db.theaters.findOne() //para ver la estructura de la colección
db.theaters.aggregate([ //agregamos el pipeline
    {
      $group: { //agrupamos por estado
        _id: "$location.address.state" ,  //agrupamos por estado
        count: { //contamos
            $sum: 1 //sumamos 1 por cada estado
        }
    }
},
{
    $sort: { //ordenamos de mayor a menor
        count: -1 //de mayor a menor
    }
}
])

//Cantidad de estados con al menos dos cines (theaters) registrados.

use ("mflix")

db.theaters.aggregate([
    {
        $group:{//agrupa por estado
            _id:"$location.address.state",//agrupa por estado
            count:{
                $sum:1//cuenta cuantos hay por estado
            }
        }
    }
    ,{
        $match:{//filtra los que tienen mas de 2
            count:{
                $gte:2
            }
        }
    }
    ,{
        $sort:{//ordena por cantidad
            count:-1
        }

    }
])

//Cantidad de películas dirigidas por "Louis Lumière". 
//Se puede responder sin pipeline de agregación, realizar ambas queries.

use ("mflix")

db.movies.find({
    "directors":"Louis Lumière"
}).count()

db.movies.aggregate([
    {
        $match:{
            "directors":"Louis Lumière"
        }
    }
    ,{
        $count:"cantidad"
    }
])




//Cantidad de películas estrenadas en los años 50 (desde 1950 hasta 1959). 
//Se puede responder sin pipeline de agregación, realizar ambas queries.

use ("mflix")

db.movies.find({
    "year":{$gte:1950,$lte:1959} 
}).count()

db.movies.aggregate([
    {
        $match:{ //filtra por año
            "year":{$gte:1950,$lte:1959}  //filtra por año
        }
    }
    ,{
        $count:"cantidad" //cuenta
    }
])


// Listar los 10 géneros con mayor cantidad de películas (tener en cuenta que
// las películas pueden tener más de un género). Devolver el género y la
// cantidad de películas. Hint: unwind puede ser de utilidad

use ("mflix")

db.movies.aggregate([
    {
        $unwind:"genres" //desenrolla el array de generos
    },
    {
        $group:{ //agrupa por genero
            _id:"$genres", //agrupa por genero
            total:{ //cuenta
                $sum:1 //suma 1 por cada genero
            }
        }
    },
    {
        $sort:{ //ordena de mayor a menor
            total:-1 //de mayor a menor
        }
    },
    {
        $limit:10 //limita a 10
    },
    {
        $project:{
            _id:0,
            genre:"$_id", //renombramos el campo
            total:"$total" //renombramos el campo
        }
    }
])

// Top 10 de usuarios con mayor cantidad de comentarios, mostrando Nombre, Email y Cantidad de Comentarios

use("mflix")

db.comments.aggregate([ //agregamos el pipeline
    {
        $group: { //agrupamos por email
            _id: "$email",
            name: { //tomamos el nombre
                $first: "$name"
            },
            total: { //contamos
                $sum: 1
            },
        }
    },
    {
        $sort: { //ordenamos de mayor a menor
            total: -1
        }
    },
    {
        $limit: 10 //limitamos a 10
    },
    {
        $project: { //proyectamos
            _id: 0,
            "Nombre": "$name", //renombramos el campo
            "Email": "$_id", //renombramos el campo
            "Cantidad de Comentarios": "$total" //renombramos el campo
        }
    }
])



// Ratings de IMDB promedio, mínimo y máximo por año de las películas estrenadas en los años 80 (desde 1980 hasta 1989), ordenados de mayor a menor por promedio del año.

use("mflix")

db.movies.aggregate([

    {
        $match: { //filtra por año
            year: {
                $gte: 1980, //mayor o igual a 1980
                $lte: 1989 //menor o igual a 1989
            }
        }
    },
    {
        $group: { //agrupa por año
          _id: "$year", 
          minimo: { //minimo
            $min: "$imdb.rating" //minimo
          },
          maximo: {
            $max: "$imdb.rating" //maximo
          },
          promedio: {
            $avg: "$imdb.rating" //promedio
          }
        }
    },
    {
        $sort: { //ordena de mayor a menor
          promedio: -1 //de mayor a menor
        }
    },
    {
        $project: { //proyecta
            year: "$_id", //renombramos el campo
            promedio: 1, //proyectamos
            maximo: 1, //proyectamos
            minimo: 1,
            _id: 0, //en 0 porque no lo queremos
        }
    }
])
// Título, año y cantidad de comentarios de las 10 películas con más comentarios.
db.comments.aggregate([
  {
    $group: {
      _id: "$movie_id", //agrupamos por movie_id
      comments: { $count: {} }, //contamos
    },
  },
  {
    $lookup: { //hacemos un lookup para traer los datos de la colección movies
      from: "movies", //de la colección movies
      localField: "_id", //el campo local es _id
      foreignField: "_id", //el campo foráneo es _id
      as: "movie", //lo llamamos movie
    },
  },
  {
    $project: { //proyectamos
      _id: 0,
      "movie.title": 1, 
      "movie.year": 1,
      comments: 1,
    },
  },
  {
    $sort: { //ordenamos de mayor a menor
      comments: -1, //de mayor a menor
    },
  },
  {
    $limit: 10, //limitamos a 10
  },
]);

// Crear una vista con los 5 géneros con mayor cantidad de
// comentarios, junto con la cantidad de comentarios.

db.createView("commented_genres", "movies", [ //creamos la vista
  {
    $unwind: "$genres", //desenrollamos el array de generos
  },
  {
    $lookup: { //hacemos un lookup para traer los datos de la colección comments
      from: "comments", //de la colección comments
      localField: "_id", //el campo local es _id
      foreignField: "movie_id", //el campo foráneo es movie_id
      as: "comment", //lo llamamos comment
    },
  },
  {
    $group: {
      _id: "$genres", //agrupamos por genero
      count_comments: { $count: {} }, //contamos
    },
  },
  {
    $project: { //proyectamos
      count_comments: 1, //proyectamos el campo count_comments
    },
  },
  {
    $sort: { comments: -1 }, //ordenamos de mayor a menor
  },
  {
    $limit: 5,  //limitamos a 5
  },
]);
use("mflix")
db.movies.aggregate([

    {
        $unwind: "$directors" //desenrollamos el array de directores
    },
    {
        $match: {
          directors: "Jules Bass" //filtramos por director
        }
    },
    {
        $unwind: "$cast" //desenrollamos el array de cast
    },
    {
        $group: { //agrupamos
            _id: "$cast", //por cast
            movies: {
                $addToSet: { //agregamos al array movies
                    title: "$title",
                    year: "$year"
                }
            },
            movies_count: { //contamos
                $sum: 1
            }
        }
    },
    {
        $match: { //filtramos
          movies_count: { //por cantidad de películas
            $gte: 2
          }
        }
    },
    {
        $unwind: "$movies" //desenrollamos el array de movies
    },
    {
        $project: { //proyectamos
            _id: 0,
            actor: "$_id",
            titulo: "$movies.title",
            año: "$movies.year",
        }
    }
])
// Listar los usuarios que realizaron comentarios durante el mismo mes de lanzamiento de la película comentada, mostrando Nombre, Email, fecha del comentario, título de la película, fecha de lanzamiento. HINT: usar $lookup con multiple  condiciones


use("mflix")
db.movies.find()


db.comments.aggregate([ 
    {
        $lookup: { //hacemos un lookup para traer los datos de la colección comments
          from: "movies",
          localField: "movie_id",
          foreignField: "_id",
          as: "movie"
        }
    },
    {
        $unwind: "$movie" //desenrollamos el array de movies
    },
    // {
    //     $match: {
    //         date: {
    //             $gte: "$$movie." <- WTF no hay campo "published", no se puede saber cuando fue lanzada una pelicula!
    //         }
    //     }
    // }


])
// Listar el id y nombre de los restaurantes junto con su puntuación máxima, mínima y la suma total. Se puede asumir que el restaurant_id es único


use("restaurantdb")
db.restaurants.aggregate([

    {
        $unwind: "$grades" //desenrollamos el array de grades
    },
    {
        $group: { //agrupamos
            _id: "$_id", //por _id
            nombre: {$first: "$name"}, //tomamos el primer nombre
            max: {$max: "$grades.score"},
            min: {$min: "$grades.score"}, //tomamos el mínimo
            sum: {$sum: "$grades.score"},   //sumamos
        } 
    },
    {   
        $project: {  //proyectamos
          nombre: "$nombre",
          maximo: "$max",
          minimo: "$min",
          sumatoria: "$sum",

        }
    }

])









