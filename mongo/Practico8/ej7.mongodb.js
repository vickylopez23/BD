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