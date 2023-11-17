//Actualizar el valor de la contraseña del usuario cuyo email es joel.macdonel@fakegmail.com a "some password". 
//La misma consulta debe poder insertar un nuevo usuario en caso que el usuario no exista. 
//Ejecute la consulta dos veces. ¿Qué operación se realiza en cada caso?  (Hint: usar upserts). 



use("mflix")

db.users.find(
    {"email":"joel.macdonel@fakegmail.com"} //busca el usuario con ese email
)

use("mflix")
db.users.findOneAndUpdate( //busca el usuario con ese email y actualiza la contraseña
    {
        "email": "joel.macdonel@fakegmail.com" //busca el usuario con ese email
    },
    { 
        $set: {  //actualiza la contraseña
            "password": "some password" 
        } 
    },
    {
        upsert: true,//si no existe lo crea
    }
)