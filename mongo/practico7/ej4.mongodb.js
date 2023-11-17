//Listar el nombre, id de la película, texto y 
//fecha de los 3 comentarios más recientes realizados por el usuario con email patricia_good@fakegmail.com. 

use("mflix")

db. comments.find(
    {
        email: "patricia_good@fakegmail.com" //busca los comentarios de ese email
    },
    {
        "name": 1, //proyecta los campos que se piden
        "movie_id": 1,
        "text": 1,
        "date": 1
    }
).sort( //ordena por fecha
    {
        "date": -1 //ordena por fecha descendente
    }
).limit(3) //limita a 3
    