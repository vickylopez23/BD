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
