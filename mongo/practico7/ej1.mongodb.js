// 1- Insertar 5 nuevos usuarios en la colección users. Para cada nuevo usuario creado,
//  insertar al menos un comentario realizado por el usuario en la colección comments.
use('mflix')

//esto inseerta 5 usuarios en la coleccion users
db.users.insertMany(
  [
    {
      'name': 'name 1',
      'email': 'name_1@example.com',
      'password': 'example123'
  },
  {
      'name': 'name 2',
      'email': 'name_2@example.com',
      'password': 'example123'
  },
  {
      'name': 'name 3',
      'email': 'name_3@example.com',
      'password': 'example123'
  },
  {
      'name': 'name 4',
      'email': 'name_4@example.com',
      'password': 'example123'
  },
  {
      'name': 'name 5',
      'email': 'name_5@example.com',
      'password': 'example123'
  }

  ]
)
var users =db.users.find({'name':/^name/}) //busca los usuarios que empiecen por name

users.foreach(user => { //para cada usuario
  db.comments.insertOne({ //inserta un comentario
    "name": user.name,//con el nombre del usuario
    "email": user.email,//con el email del usuario
    "movie_id":new ObjectId("5a"),//con un id de pelicula
    "text": "text example",//con un texto
    "date":new Date()
  })


}
  )