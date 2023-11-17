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