/*agregar dos nuevas calificaciones al restaurante cuyo id es "50018608". A continuación se especifican las calificaciones a agregar en una sola consulta.  

{
	"date" : ISODate("2019-10-10T00:00:00Z"),
	"grade" : "A",
	"score" : 18
}

{
	"date" : ISODate("2020-02-25T00:00:00Z"),
	"grade" : "A",
	"score" : 21
}

*/

use("restaurantdb") 
db.restaurants.find( //busca el restaurante con ese id
    {
        "grades": { //busca en el array grades
            $elemMatch: { //chequea que al menos un elemento cumpla con las condiciones
                "score": { //chequea que el score este entre 70 y 90
                    $gt: 70, //mayor a 70
                    $lte: 90 //menor o igual a 90
                },
                "date": { //chequea que la fecha este entre 2014 y 2015
                    $gte: new Date("2014-01-01"), //mayor o igual a 2014
                    $lt: new Date("2016-01-01") //menor a 2016
                }
            }
        },
    },
    {
        "_id": 0, //proyecta los campos que se piden
        "restaurant_id": 1, //proyecta el id del restaurante
        "grades": 1 //proyecta el array grades
    }
)