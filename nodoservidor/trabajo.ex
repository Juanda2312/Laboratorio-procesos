defmodule TrabajoGrado do
  defstruct fecha: Date.utc_today(),
            titulo: "",
            descripcion: "",
            autores: []

  def crear(fecha, titulo, descripcion, autores) do
    %TrabajoGrado{
      fecha: fecha,
      titulo: titulo,
      descripcion: descripcion,
      autores: autores
    }
  end

  def ingresar(mensaje) do
    mensaje
    |> Util.mostrar_mensaje()

    fecha = "Ingrese la fecha del trabajo de grado:" |> Util.ingresar(:fecha)
    titulo = "Ingrese el título del trabajo de grado:" |> Util.ingresar(:texto)
    descripcion = "Ingrese la descripción del trabajo de grado:" |> Util.ingresar(:texto)
    autores = "Ingrese los autores del trabajo de grado:" |> Autor.ingresar(:autores)

    crear(fecha, titulo, descripcion, autores)
  end

  def ingresar(mensaje, :trabajos) do
    mensaje
    |> ingresar([], :trabajos)
  end

  def ingresar(mensaje, lista, :trabajos) do
    trabajo = mensaje |> ingresar()
    nueva_lista = lista ++ [trabajo]

    mas_trabajos =
      "\n¿Desea ingresar más trabajos de grado? (s/n):"
      |> Util.ingresar(:boolean)

    case mas_trabajos do
      true -> mensaje |> ingresar(nueva_lista, :trabajos)
      false -> nueva_lista
    end
  end

  def escribir_csv(trabajos, nombre_archivo) do
    trabajos
    |> Enum.map(&convertir_trabajo_linea_csv/1)
    |> Enum.join("\n")
    |> (&("fecha,titulo,descripcion,autores\n" <> &1)).()
    |> (&File.write(nombre_archivo, &1)).()
  end

  defp convertir_trabajo_linea_csv(trabajo) do
    autores_str =
      trabajo.autores
      |> Enum.map(fn a ->
        "#{a.nombre}-#{a.apellidos}-#{a.cedula}-#{a.programa}-#{a.titulo_profesional}"
      end)
      |> Enum.join("|")

    "#{Date.to_string(trabajo.fecha)},#{trabajo.titulo},#{trabajo.descripcion},#{autores_str}"
  end

  def leer_csv(nombre_archivo) do
    nombre_archivo
    |> File.stream!()
    |> Stream.drop(1)
    |> Enum.map(&convertir_cadena_trabajo/1)
  end

  defp convertir_cadena_trabajo(cadena) do
    [fecha, titulo, descripcion, autores_str] =
      cadena
      |> String.trim()
      |> String.split(",", parts: 4, trim: true)

    {:ok, fecha} = Date.from_iso8601(fecha)

    autores =
      if autores_str == "" do
        []
      else
        String.split(autores_str, "|")
        |> Enum.map(fn a ->
          [nombre, apellidos, cedula, programa, titulo_profesional] = String.split(a, "-")
          Autor.crear(nombre, apellidos, cedula, programa, titulo_profesional)
        end)
      end

    crear(fecha, titulo, descripcion, autores)
  end
end
