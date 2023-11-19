use("supplies");

//ejercicio 1
/**Buscar las ventas realizadas en "London", "Austin" o "San Diego"; a un customer con edad mayor-igual a 18 años que tengan productos que hayan salido al menos 1000 y estén etiquetados (tags) como de tipo "school" o "kids" (pueden tener más etiquetas).
Mostrar el id de la venta con el nombre "sale", la fecha (“saleDate"), el storeLocation, y el "email del cliente. No mostrar resultados anidados. 
 */

db.sales.aggregate([
  {
    $match: {
      storeLocation: {
        $in: ["London", "Austin", "San Diego"],
      },
      "customer.age": {
        $gte: 18,
      },
      "items.price": {
        $gte: 1000,
      },
      "items.tags": {
        $in: ["school", "kids"],
      },
    },
  },
  {
    $project: {
      _id: 1,
      saleDate: 1,
      storeLocation: 1,
      "customer.email": 1,
    },
  },
]);

//ejercicio 2

/*Buscar las ventas de las tiendas localizadas en Seattle, donde el método de compra sea ‘In store’ o ‘Phone’
 y se hayan realizado entre 1 de febrero de 2014 y 31 de enero de 2015 (ambas fechas inclusive). 
 Listar el email y la satisfacción del cliente, y el monto total facturado, 
 donde el monto de cada item se calcula como 'price * quantity'. 
 Mostrar el resultado ordenados por satisfacción (descendente), 
 frente a empate de satisfacción ordenar por email (alfabético). 
*/

db.sales.aggregate([
  {
    $match: {
      storeLocation: "Seattle",
      $or: [{ purchaseMethod: "In store" }, { purchaseMethod: "Phone" }],
      saleDate: {
        $gte: ISODate("2014-02-01"),
        $lte: ISODate("2015-01-31"),
      },
    },
  },
  {
    $unwind: "$items", // Descompongo
  },
  {
    $group: {
      _id: {
        email: "$customer.email",
        satisfaction: "$customer.satisfaction",
      },
      total: {
        //calculo el total de cada item
        $sum: { $multiply: ["$items.price", "$items.quantity"] },
      },
    },
  },
  {
    $project: {
      _id: 0,
      email: "$_id.email",
      satisfaction: "$_id.satisfaction",
      total: 1,
    },
  },
  {
    $sort: {
      satisfaction: -1,
      email: 1,
    },
  },
]);

//EJERCICIO 3
//Crear la vista salesInvoiced que calcula el monto mínimo, monto máximo, monto total y monto promedio facturado por año y mes.
//Mostrar el resultado en orden cronológico. No se debe mostrar campos anidados en el resultado.
//hacer que me de negativo

db.createView("salesInvoiced", "sales", [
  {
    $group: {
      _id: {
        //agrupo por año y mes
        year: { $year: "$saleDate" },
        month: { $month: "$saleDate" },
      }, //calculo el minimo, maximo, total y promedio
      min: { $min: "$total" },
      max: { $max: "$total" },
      total: { $sum: "$total" },
      avg: { $avg: "$total" },
    },
  },
  {
    $project: {
      //proyecto para que no me muestre campos anidados
      _id: 0,
      year: "$_id.year",
      month: "$_id.month",
      min: 1,
      max: 1,
      total: 1,
      avg: 1,
    },
  },
  {
    $sort: { year: 1, month: 1 }, //ordeno por año y mes
  },
]);

//ejercicio 4
//Mostrar el storeLocation, la venta promedio de ese local, el obj a cumplir de ventas (dentro de la colección storeObjectives) y la diff entre el promedio y el obj de todos los locales.
//utilizar join y tiene que dar negativo entre el promedio y el obj
db.sales.aggregate([
  {
    $unwind: "$items", //DESCOMPONGO LOS ITEMS PRIMERO PARA PODER CALCULAR
  },
  {
    $group: {
      _id: "$storeLocation", //LOCAL
      total: {
        $sum: { $multiply: ["$items.price", "$items.quantity"] }, //POR CADA ITEM CALCULO EL TOTAL
      },
      count: { $sum: 1 },
    },
  },
  {
    $addFields: {
      avg: { $divide: ["$total", "$count"] }, //HAGO EL PROMEDIO
    },
  },
  {
    $lookup: {
      from: "storeObjectives",//HAGO JOIN
      localField: "_id",
      foreignField: "_id",
      as: "objective",
    },
  },
  {
    $unwind: "$objective", //DESCOMPONGO EL OBJ
  },
  {
    $project: {//EVITO CAMPOS ANIDADOS
      _id: 0,
      storeLocation: "$_id",
      ventaProm: "$avg",
      obj: "$objective.objective", 
      diff: { $subtract: ["$avg", "$objective.objective"] }, 
    },
  },
]);

//ejercicio 5
/**Especificar reglas de validación en la colección sales utilizando JSON Schema. 
Las reglas se deben aplicar sobre los campos: saleDate, storeLocation, purchaseMethod, y  customer ( y todos sus campos anidados ). Inferir los tipos y otras restricciones que considere adecuados para especificar las reglas a partir de los documentos de la colección. 
Para testear las reglas de validación crear un caso de falla en la regla de validación y un caso de éxito (Indicar si es caso de falla o éxito)
 */

db.runCommand({
  collMod: "sales",
  validationLevel: "strict",
  validationAction: "error",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["saleDate", "storeLocation", "purchaseMethod", "customer"],
      properties: {
        _id: {
          bsonType: "objectId",
        },
        saleDate: {
          bsonType: "date",
        },
        storeLocation: {
          bsonType: "string",
        },
        purchaseMethod: {
          bsonType: "string",
        },
        customer: {
          bsonType: "object",
          required: ["age", "email"],
          properties: {
            age: {
              bsonType: "int",
            },
            email: {
              bsonType: "string",
            },
          },
        },
      },
    },
  },
});

//caso de test exitoso

db.sales.insertOne({
  saleDate: ISODate("2020-10-10"),
  storeLocation: "London",
  purchaseMethod: "In store",
  customer: {
    age: 17,
    email: "saliobien@gmail.com", //es un email valido
  },
});

//caso de test fallido que no tiene email
// db.sales.insertOne({
//   saleDate: ISODate("2020-10-10"),
//   storeLocation: "London",
//   purchaseMethod: "In store",
//   customer: {
//     age: 17
//   },
// });

