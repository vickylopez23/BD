// Top 10 de usuarios con mayor cantidad de comentarios, mostrando Nombre, Email y Cantidad de Comentarios

use("mflix")

db.comments.aggregate([ //agregamos el pipeline
    {
        $group: { //agrupamos por email
            _id: "$email",
            name: { //tomamos el nombre
                $first: "$name"
            },
            total: { //contamos
                $sum: 1
            },
        }
    },
    {
        $sort: { //ordenamos de mayor a menor
            total: -1
        }
    },
    {
        $limit: 10 //limitamos a 10
    },
    {
        $project: { //proyectamos
            _id: 0,
            "Nombre": "$name", //renombramos el campo
            "Email": "$_id", //renombramos el campo
            "Cantidad de Comentarios": "$total" //renombramos el campo
        }
    }
])