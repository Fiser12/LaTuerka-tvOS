# La Tuerka para tvOS

## Objetivo del desarrollo
El objetivo de este desarrollo es dar un puente sencillo al programa de La Tuerka de cara al salón de la gente. Me gustaría realizar el desarrollo para Android TV pero no tengo demasiado tiempo.
Considero que las limitaciones impuestas para poder fundar una cadena por TDT dañan la libertad de prensa y lo mismo con el hecho de que no sea televisión a la carta. Considero esto una plataforma de código que pueda utilizarse como base para que otras pequeñas cadenas tengan una oportunidad de llegar a la televisión y romper así el oligopolio informativo.

## Funcionamiento
El programa hace uso de libxml2.2 para hacer las descargas de la web, junto con TFHpple. Con esto procesa la web de público para descargarse los videos y cargar los datos. Dada la cantidad de datos hace uso de una caché local solo para las imagenes. No es muy buena idea, porque existe un límite de almacenamiento local impuesto por apple de 200 megas, pero como no lo he subido aun no lo he tenido en cuenta. Me hubiera gustado implementar un paginador con una pequeña caché local para la primera página de las imagenes y una base de datos para no tener que procesar la web cada vez. El código es reutilizable para una app de iOS.
