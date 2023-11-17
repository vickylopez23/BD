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