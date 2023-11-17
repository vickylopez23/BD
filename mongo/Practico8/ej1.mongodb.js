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