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