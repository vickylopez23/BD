
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

