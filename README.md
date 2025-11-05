Autores: Juan David Tapiero - Jose Manuel Bedoya

Codigo realizado con el fin de cumplir con los requisitos planteados por el seguimiento que dicta lo siguiente

(comunicación entre procesos)Contexto:
La Universidad del Quindío desea desarrollar una aplicación distribuida llamada "Trabajos de Grado APP",
diseñada para consultar los trabajos de grado realizados por los estudiantes (autores) de la institución. La
aplicación estará dividida en dos nodos: uno correspondiente al servidor (encargado de almacenar y responder
solicitudes de datos) y otro correspondiente al cliente (que interactúa con el usuario final).

Requisitos Generales
1. Datos en archivos:
○ Toda la información de trabajos de grado y sus autores se carga de forma manual y permanece en
memoria ( utiliza archivos).
○ Deben existir al menos 3 trabajos de grado y 5 autores en total. Cada trabajo de grado debe estar
asociado a al menos 2 autores.
○ Cada trabajo de grado contiene:
Fecha,Título,Descripción,Lista de autores (identificados por cédula)
○ Cada autor contiene:
Nombre,Apellidos,Cédula,Programa académico,Título profesional

2. Servidor:
○ Expone funciones para:
■ Obtener la lista completa de trabajos de grado.
■ Consultar los autores de un trabajo de grado específico (recibiendo como parámetro el ID o
título del trabajo).

○ Los datos deben cargarse al iniciar el servidor.
3. Cliente:
○ Al iniciar:
■ Solicita al servidor la lista de trabajos de grado y los muestra (puede ser en consola).
○ Luego:
■ El usuario puede seleccionar un trabajo de grado (por índice o título), y se consulta al
servidor por los autores asociados, mostrando sus datos completos.

4. Conexión entre nodos:

○ El cliente se conecta al servidor mediante Node.connect/1.
○ Las llamadas deben implementarse usando spawn o send/receive.

Consideraciones Técnicas
● El proyecto se debe ejecutar desde consola con nodos distribuidos (iex --name), usando cookie común.
