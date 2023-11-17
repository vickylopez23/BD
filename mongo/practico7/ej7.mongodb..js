//Actualizar los valores de los campos texto (text) y fecha (date) del comentario cuyo id 
//es ObjectId("5b72236520a3277c015b3b73")
// a "mi mejor comentario" y fecha actual respectivamente.

use ("mflix")

db.comments.updateOne(
    {
        "_id":ObjectId("5b72236520a3277c015b3b73") //busca el comentario con ese id
    }
    ,
    {
        $set: { //actualiza los campos
            "text": "nope", //actualiza el texto
            "date": new Date() //actualiza la fecha
        }
    }
)

