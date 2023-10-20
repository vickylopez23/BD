
/*

8. Título, año y cantidad de comentarios de las 10 películas con más comentarios.

*/

db.comments.aggregate([
    {
        $group: {
            _id: "$movie_id",
            count: {$sum: 1}
        }
    },
    {
        $sort: {count: -1}
    },
    {
        $limit: 10
    },
    {
        $lookup: {
            from: 'movies',
            localField: '_id',
            foreignField: '_id',
            as: 'movies'
        }
    },
    {
        $addFields: {
            movie: {$first: "$movies"}
        }
    },
    {
        $project: {
            title: "$movie.title",
            year: "$movie.year",
            count: 1,
            _id: 0
        }
    }
])


/*

9. Crear una vista con los 5 géneros con mayor cantidad de comentarios, junto con la cantidad de comentarios.

*/

pipeline = [
    {
        $lookup: {
          from: 'comments',
          localField: '_id',
          foreignField: 'movie_id',
          as: 'comments'
        }
    },
    {
        $match: { 
            $expr: { 
                $gt:[ { $size: "$comments"}, 0 ]
            } 
        }
    },
    {
        $project: {
            genres:1,
            comments_count: { $size: "$comments" },
            _id: 0
        }
    },
    {
        $unwind: "$genres"
    },
    {
        $group: {
            _id: "$genres",
            comments_total_count: { $sum: "$comments_count" }
        }
    },
    {
        $sort: { comments_total_count: -1 }
    },
    {
        $limit: 5
    },
    {
        $project: {_id:0,  genre: "$_id", comments_total_count: 1}
    }
]

db.createView("top5genres", "movies", pipeline)

db.top5genres.find({}).pretty()


/*

10. Listar los actores (cast) que trabajaron en 2 o más películas dirigidas por "Jules Bass". 
    Devolver el nombre de estos actores junto con la lista de películas (solo título y año) 
    dirigidas por “Jules Bass” en las que trabajaron. 
    Hint1: addToSet
    Hint2: {'name.2': {$exists: true}} permite filtrar arrays con al menos 2 elementos, entender por qué.
    Hint3: Puede que tu solución no use Hint1 ni Hint2 e igualmente sea correcta

*/

db.movies.aggregate([
    {
        $match: {
            directors: "Jules Bass",
        }
    },
    {
        $unwind: "$cast"
    },
    {
        $group: {
            _id: "$cast",
            movies: {
                $addToSet: {
                    title: "$title",
                    year: "$year"
                }    
            }
        }
    },
    {
        $match: {
            $expr: {$gte: [{$size: "$movies"}, 2]}
        }
    },
    {
        $project: {
            "actor": "$_id",
            movies: 1,
            _id: 0
        }
    }
])

/*

12. Listar el id y nombre de los restaurantes junto con su puntuación máxima, mínima y la suma total. Se puede asumir que el restaurant_id es único.

d. Resolver con find.
*/

db.restaurants.find(
  { },
  {
    restaurant_id: 1,
    name: 1,
    max_score: { $max: "$grades.score" },
    min_score: { $min: "$grades.score" },
    total_score: {    
      $reduce: {
        input: "$grades.score",
        initialValue: 0,
        in: { $add : ["$$value", "$$this"] }
      }
    },
    _id: 0
  }
)

