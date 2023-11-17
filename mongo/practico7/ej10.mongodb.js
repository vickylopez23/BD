//Listar el id del restaurante (restaurant_id) y las calificaciones de los restaurantes
// donde al menos una de sus calificaciones haya sido realizada entre 2014 y 2015 inclusive, 
//y que tenga una puntuación (score) mayor a 70 y menor o igual a 90.

use("restaurantdb")

db.restaurants.find(
  {
      grades: { //grandes es un array
          $elemMatch: { //elemMatch chequea que al menos un elemento cumpla con las condiciones
              date: {"$gte": ISODate("2014-01-01"), "$lte": ISODate("2015-01-31") },  //chequea que la fecha este entre 2014 y 2015
              score: {"$gt": 70, "$lte": 90} //chequea que el score este entre 70 y 90
          } 
      }
  },
  {restaurant_id:1, grades: 1} //proyecta los campos que se piden, se que es 1 porque es un array y no se puede proyectar un array

)