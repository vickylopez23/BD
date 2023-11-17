//Remover todos los comentarios realizados por el usuario cuyo email 
//es victor_patel@fakegmail.com durante el año 1980.

use("mflix")

db.comments.deleteMany(
    {
        "email": "victor_patel@fakegmail.com", //busca los comentarios de ese email
        "date": {
            $gte: new Date("1980-01-01"), //busca los comentarios entre esas fechas
            $lt: new Date("1981-01-01")     //busca los comentarios entre esas fechas
        }
    }
)

