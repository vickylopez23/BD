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