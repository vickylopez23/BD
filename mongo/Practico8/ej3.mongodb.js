//Cantidad de películas dirigidas por "Louis Lumière". 
//Se puede responder sin pipeline de agregación, realizar ambas queries.

use ("mflix")

db.movies.find({
    "directors":"Louis Lumière"
}).count()

db.movies.aggregate([
    {
        $match:{
            "directors":"Louis Lumière"
        }
    }
    ,{
        $count:"cantidad"
    }
])