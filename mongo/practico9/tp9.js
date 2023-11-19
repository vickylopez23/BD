
use ("mflix")

//ejercicio 1
//Especificar en la colección users las siguientes reglas de validación: El campo name (requerido) debe ser un string con un máximo de 30 caracteres, email (requerido) debe ser un string que matchee 
//con la expresión regular: "^(.*)@(.*)\\.(.{2,4})$" , password (requerido) debe ser un string con al menos 50 caracteres.


// db.users.find()
//runCommand es un método de la shell de mongo que permite ejecutar comandos de la base de datos
db.runCommand({ 
    collMod: "users", //collMod es el comando que permite modificar las colecciones
    validator: { //validator es el comando que permite validar los campos de la colección
        $jsonSchema: { //$jsonSchema es el comando que permite especificar el esquema de validación
            bsonType: "object", //bsonType es el comando que permite especificar el tipo de dato del campo
            required: ["name", "email", "password"],    //required es el comando que permite especificar que el campo es requerido
            properties: { //properties es el comando que permite especificar las propiedades del campo
                name: { //name es el comando que permite especificar el nombre del campo
                    bsonType: "string", //bsonType es el comando que permite especificar el tipo de dato del campo
                    maxLength: 30 //maxLength es el comando que permite especificar la longitud máxima del campo
                },
                email: { //email es el comando que permite especificar el nombre del campo
                    bsonType: "string", //bsonType es el comando que permite especificar el tipo de dato del campo
                    pattern: "^(.*)@(.*)\\.(.{2,4})$" //pattern es el comando que permite especificar la expresión regular del campo
                },
                password: { //password es el comando que permite especificar el nombre del campo
                    bsonType: "string", //bsonType es el comando que permite especificar el tipo de dato del campo
                    minLength: 50 //minLength es el comando que permite especificar la longitud mínima del campo
                }
            }
        }
    }
})

//ejercicio 2
// Obtener metadata de la colección users que garantice que las reglas de validación fueron correctamente aplicadas

//use("mflix")
db.getCollectionInfos({name: "users"})//getCollectionInfos es el comando que permite obtener información de la colección

//ejercicio 3
/**
Especificar en la colección theaters las siguientes reglas de validación: El campo theaterId (requerido) debe ser un int y location (requerido) debe ser un object con:
un campo address (requerido) que sea un object con campos street1, city, state y zipcode todos de tipo string y requeridos
un campo geo (no requerido) que sea un object con un campo type, con valores posibles “Point” o null y coordinates que debe ser una lista de 2 doubles
Por último, estas reglas de validación no deben prohibir la inserción o actualización de documentos que no las cumplan sino que solamente deben advertir.
 */

// db.theaters.find()
db.getCollectionInfos({name: "theaters"})

db.runCommand({
    collMod: "theaters", //collMod es el comando que permite modificar las colecciones
    validator: { //validator es el comando que permite validar los campos de la colección
        $jsonSchema: { 
            bsonType: "object", //bsonType es el comando que permite especificar el tipo de dato del campo
            required: [ //required es el comando que permite especificar que el campo es requerido
                "theaterId", 
                "location", 
            ],
            properties: { //properties es el comando que permite especificar las propiedades del campo
                theaterId: { //theaterId es el comando que permite especificar el nombre del campo
                    bsonType: "number" //bsonType es el comando que permite especificar el tipo de dato del campo
                },
                location: { //location es el comando que permite especificar el nombre del campo
                    bsonType: "object",
                    required: ["address"],
                    properties: {
                        address: {
                            bsonType: "object",
                            required: ["street1", "city", "state", "zipcode"],
                            properties: {
                                street1: {
                                    bsonType: "string",
                                },
                                city: {
                                    bsonType: "string",
                                },
                                state: {
                                    bsonType: "string",
                                },
                                zipcode: {
                                    bsonType: "string",
                                },

                            }
                        },
                        geo: {
                            bsonType: "object",
                            properties: {
                                type: {
                                    enum: ["Point", null] 
                                },
                                coordinates: {
                                    bsonType: ["array"],
                                    items: {
                                        bsonType: "double",
                                    }
                                }
                            }
                        }
                    }
                },
                
            },
        }
    },
    validationLevel: "moderate", //validationLevel es el comando que permite especificar el nivel de validación
    validationAction: "warn" //validationAction es el comando que permite especificar la acción de validación
})

//ejercicio 4

/**Especificar en la colección movies las siguientes reglas de validación: El campo title (requerido) es de tipo string, year (requerido) int con mínimo en 1900 y máximo en 3000, y que tanto cast, directors, countries, como genres sean arrays de strings sin duplicados.
Hint: Usar el constructor NumberInt() para especificar valores enteros a la hora de insertar documentos. Recordar que mongo shell es un intérprete javascript y en javascript los literales numéricos son de tipo Number (double).
 */

db. movies.find() //movies es el nombre de la colección
db.getCollectionInfos({name: "movies"})

db.runCommand({
    collMod: "movies", //collMod es el comando que permite modificar las colecciones
    validator: { //validator es el comando que permite validar los campos de la colección
        $jsonSchema: {
            bsonType: "object", //bsonType es el comando que permite especificar el tipo de dato del campo
            required: [ //required es el comando que permite especificar que el campo es requerido
                "title", 
                "year", 
                "cast", 
                "directors", 
                "countries", 
                "genres"
            ],
            properties: { //properties es el comando que permite especificar las propiedades del campo
                title: { //title es el comando que permite especificar el nombre del campo
                    bsonType: "string" //bsonType es el comando que permite especificar el tipo de dato del campo
                },
                year: { //year es el comando que permite especificar el nombre del campo
                    bsonType: "int", //bsonType es el comando que permite especificar el tipo de dato del campo
                    minimum: 1900, //minimum es el comando que permite especificar el valor mínimo del campo
                    maximum: 3000 //maximum es el comando que permite especificar el valor máximo del campo
                },
                cast: { //cast es el comando que permite especificar el nombre del campo
                    bsonType: "array", //bsonType es el comando que permite especificar el tipo de dato del campo
                    uniqueItems: true, //uniqueItems es el comando que permite especificar que los elementos del array no se repitan
                    items: { //items es el comando que permite especificar los elementos del array
                        bsonType: "string" //bsonType es el comando que permite especificar el tipo de dato del campo
                    }
                },
                directors: { //directors es el comando que permite especificar el nombre del campo
                    bsonType: "array", //bsonType es el comando que permite especificar el tipo de dato del campo
                    uniqueItems: true, //uniqueItems es el comando que permite especificar que los elementos del array no se repitan
                    items: { //items es el comando que permite especificar los elementos del array
                        bsonType: "string" //bsonType es el comando que permite especificar el tipo de dato del campo
                    }
                },
                countries: { //countries es el comando que permite especificar el nombre del campo
                    bsonType: "array", //bsonType es el comando que permite especificar el tipo de dato del campo
                    uniqueItems: true, //uniqueItems es el comando que permite especificar que los elementos del array no se repitan
                    items: { //items es el comando que permite especificar los elementos del array
                        bsonType: "string" //bsonType es el comando que permite especificar el tipo de dato del campo
                    }
                },
                genres: { //genres es el comando que permite especificar el nombre del campo
                    bsonType: "array", //bsonType es el comando que permite especificar el tipo de dato del campo
                    uniqueItems: true, //uniqueItems es el comando que permite especificar que los elementos del array no se repitan
                    items: { //items es el comando que permite especificar los elementos del array
                        bsonType: "string" //bsonType es el comando que permite especificar el tipo de dato del campo
                    }
                }
            }
        }
    },
    validationLevel: "moderate", //validationLevel es el comando que permite especificar el nivel de validación
    validationAction: "warn" //validationAction es el comando que permite especificar la acción de validación

})

//ejercicio 5}
// Crear una colección userProfiles con las siguientes reglas de validación:
// Tenga un campo user_id (requerido) de tipo “objectId”, un campo language (requerido) con alguno de los
// siguientes valores [ “English”, “Spanish”, “Portuguese” ] y un campo favorite_genres (no requerido)
// que sea un array de strings sin duplicados.

db.crateCollection ("userProfiles",{
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["user_id", "language"],
            properties: {
                user_id: {
                    bsonType: "objectId"
                },
                language: {
                    enum: ["English", "Spanish", "Portuguese"]
                },
                favorite_genres: {
                    bsonType: "array",
                    uniqueItems: true,
                    items: {
                        bsonType: "string"
                    }
                }
            }
        }
    }
})


//Identificar los distintos tipos de relaciones (One-To-One, One-To-Many) en las colecciones movies y comments. Determinar si se usó documentos anidados o referencias en cada relación y justificar la razón.

// Hay una realación muchos a uno de comments a movies por referecía (a travéz de movie_id en comments)
// Hay una relación uno a uno entre movies y imdb por anidamiento (imdb está anidado en movies)

use("shop")

// Colecciones
db.createCollection("book", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["book_id", "title", "author", "price", "category"],
      properties: {
        book_id: {
          bsonType: "objectId"
        },
        title: {
          bsonType: "string"
        },
        author: {
          bsonType: "string"
        },
        price: {
          bsonType: "double"
        },
        category: {
          bsonType: "string"
        }
      }
    }
  }
})

db.createCollection("orders", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: [
        "order_id", "delivery_name", "delivery_address", "cc_name", "cc_number", "cc_expiry", "detalls"
      ],
      properties: {
        order_id: {
          bsonType: "objectId"
        },
        delivery_name: {
          bsonType: "string"
        },
        delivery_address: {
          bsonType: "string"
        },
        cc_name: {
          bsonType: "string"
        },
        cc_number: {
          bsonType: "string"
        },
        cc_expiry: {
          bsonType: "string"
        },
        detalls: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["book_id", "title", "author", "quantity", "price"],
            properties: {
              book_id: {
                bsonType: "objectId"
              },
              title: {
                bsonType: "string"
              },
              author: {
                bsonType: "string"
              },
              quantity: {
                bsonType: "int"
              },
              price: {
                bsonType: "double"
              }
            }
          }
        }
      }
    }
  }
})

// Querys
// I. Listar el id, titulo, y precio de los libros y sus categorías de un autor en particular
db.book.aggregate([
  {
    $match: {
      author: "Haskell Curry"
    }
  },
  {
    $project: {
      book_id: 1,
      title: 1,
      price: 1,
      category: 1
    }
  }
])

// II. Cantidad de libros por categorías
db.book.aggregate([
  {
    $group: {
      _id: "category",
      amount: { $count: { } }
    }
  }
])

// III.
// Listar el nombre y dirección entrega y el monto total (quantity * price) de sus
// pedidos para un order_id dado.
db.orders.aggregate([
  {
    $match: {
      order_id: ObjectId(679769)
    }
  },
  {
    $unwind: "$detlls"
  },
  {
    $project: {
      delivery_name: 1,
      delivery_address: 1,
      total: { $multiply: ["$detalls.quantity", "$detalls.price"] }
    }
  },
  {
    $group: {
      _id: "$_id",
      delivery_name: { $first: "$delivery_name" },
      delivery_address: { $first: "$delivery_address" },
      total: { $sum: "$total" }
    }
  }
])
