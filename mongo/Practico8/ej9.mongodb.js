
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
