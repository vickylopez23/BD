/*
  Parte I

*/

/*


/*

3. Especificar en la colección theaters las siguientes reglas de validación: 
   El campo theaterId (requerido) debe ser un int y location (requerido) debe ser un object con:
   a. un campo address1 (requerido) que sea un object con campos street, city, state y zipcode todos de tipo string y requeridos
   b. un campo geo (no requerido) que sea un object con un campo type, con valores posibles “Point” o null y 
   coordinates que debe ser una lista de 2 doubles
   Por último, estas reglas de validación no deben prohibir la inserción o actualización de documentos que no las cumplan sino 
   que solamente deben advertir.
*/

db.runCommand({
  collMod: "theaters",
  validator: { 
    $jsonSchema: {
      bsonType: "object",
      required: [ "theaterId", "location" ],
      properties: {
        theaterId: {
          bsonType: "int",
          description: "must be an integer and is required"
        },
        location: {
          bsonType: "object",
          required: [ "address" ],
          properties: {
            address: {
              bsonType: "object",
              required: [ "street1", "city", "state", "zipcode" ],
              properties: {          
                street1: {
                  bsonType: "string",
                  description: "must be a string and is required"
                },
                city: {
                  bsonType: "string",
                  description: "must be a string and is required"
                },
                state: {
                  bsonType: "string",
                  description: "must be a string and is required"
                },
                zipcode: {
                  bsonType: "string",
                  description: "must be a string and is required"
                }
              }
            },
            geo: {
              bsonType: "object",
              properties: {
                type: {
                  enum: [ "Point", null ],
                  description: "can only be one of the enum values"
                },
                coordinates: {
                  bsonType: "array",
                  description: "must be a array",
                  minItems: 2,
                  maxItems: 2,
                  items: {
                    bsonType: "double"
                  }
                }
              }
            }  
          }        
        },
      }
    } 
  },
  validationLevel: "moderate",
  validationAction: "warn"
})


// Success validation

db.theaters.insertOne({
  "theaterId" : NumberInt(1000),
  "location" : {
    "address" : {
      "street1" : "340 W Market",
      "city" : "Bloomington",
      "state" : "MN",
      "zipcode" : "55425"
    },
    "geo" : {
      "type" : "Point",
      "coordinates" : [
        -93.24565,
        44.85466
      ]
    }
  }
})


/*

5. Crear una colección userProfiles con las siguientes reglas de validación: 
   Tenga un campo user_id (requerido) de tipo “objectId”, un campo language (requerido) 
   con alguno de los siguientes valores [ “English”, “Spanish”, “Portuguese” ] y 
   un campo favorite_genres (no requerido) que sea un array de strings sin duplicados.

*/

db.createCollection(
  "userProfiles", {
    validator: { 
      $jsonSchema: {
        bsonType: "object",
        required: [ "user_id", "language" ],
        properties: {
          user_id: {
            bsonType: "objectId",
            description: "must be an strobjectIding and is required"
          },
          language: {
            enum: ["English", "Spanish", "Portuguese"],
            description: "can only be one of the enum values and is required"
          },
          favorite_genres: {
            bsonType: "array",
            description: "must be a array",
            uniqueItems: true,
            items: {
              bsonType: "string"
            }
          }
        }
      } 
    },
    validationLevel: "strict"
  } 
)


// Success validation

db.userProfiles.insertOne(
  {
    user_id: ObjectId(),
    language: "English",
    favorite_genres: ["Documentary"]
  }
)

/*

8. Dado el siguiente diagrama que representa los datos de un blog de artículos

Se pide 

b. Crear un modelo de datos en mongodb aplicando las estrategias “Modelo de datos anidados” y Referencias y considerando las siguientes queries.

Query 1: Listar título y url, tags y categorías de los artículos dado un user_id
Query 2: Listar título, url y comentarios que se realizaron en un rango de fechas.
Query 3: Listar nombre y email dado un id de usuario

*/

/*
En primer lugar para cada query identifico las entidades y sus relaciones necesarias para responder la query (sin usar $lookup).
Y decido la estrategia de modelado de datos que voy a aplicar. 

Query 1: Listar título y url, tags y categorías de los artículos dado un user_id

Identificar entidades: articles, tags y categories
Identificar relaciones: Many-To-Many  (articles y categories; articles y tags) 
Decidir si aplicar Embed o References?: Embed en ambas relaciones

Query 2: Listar título, url y comentarios que se realizaron en un rango de fechas.

Identificar entidades: articles y comments
Identificar relaciones: One-To-Many  (articles y comments) 
Decidir si aplicar Embed o References?: Embed

Query 3: Listar nombre y email dado un id de usuario
Identificar entidades: users
Identificar relaciones: 
Decidir si aplicar Embed o References?: References
*/

// Luego creo el modelo de datos en MongoDB ilustrado con algunos inserts de ejemplos

db.articles.insertOne( {
  _id: "1", 
  user_id: "1",
  title: "some title",
  date: ISODate("..."),
  text: "description",
  url: "some url",
  categories: [ "some category" ],
  tags: [ "some tag name" ],
  comments:  [ {
    _id: "1",
    user_id: "1",
    date: ISODate("..."),
    text: "some comment"
  } ]
} )

db.users.insertOne( {
  _id: "1", 
  name: "Some name",
  email: "some@example.org"
} )

/*
Por último creo las queries para verificar que mi modelo de datos responde las queries (sin usar $lookup)
*/

//Query 1: 
db.articles.find( { user_id: 1 }, { title:1, url:1, tags: 1, categories: 1, _id: 0 } )

//Query 2: 
db.articles.find( 
  { comments: { $elemMatch: { date: { $gte: ISODate("..."), $lte: ISODate("...") } } } }, 
  { title: 1, url: 1, comments: { $elemMatch: { date: { $gte: ISODate("..."), $lte: ISODate("...") } } }, _id: 0 } 
)

//Query 3: 
db.users.find( { user_id: 1 }, { name: 1, email: 1, _id: 0 } )


