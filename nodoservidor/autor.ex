defmodule Autor do
  defstruct nombre: "", apellidos: "", cedula: "", programa: "", titulo_profesional: ""

  def crear(nombre, apellidos, cedula, programa, titulo_profesional) do
    %Autor{
      nombre: nombre,
      apellidos: apellidos,
      cedula: cedula,
      programa: programa,
      titulo_profesional: titulo_profesional
    }
  end

  def ingresar(mensaje) do
    mensaje
    |> Util.mostrar_mensaje()

    nombre = "Ingrese el nombre del autor:" |> Util.ingresar(:texto)
    apellidos = "Ingrese los apellidos del autor:" |> Util.ingresar(:texto)
    cedula = "Ingrese la cédula:" |> Util.ingresar(:entero) |> to_string()
    programa = "Ingrese el programa académico:" |> Util.ingresar(:texto)
    titulo_profesional = "Ingrese el título profesional:" |> Util.ingresar(:texto)

    crear(nombre, apellidos, cedula, programa, titulo_profesional)
  end

  def ingresar(mensaje, :autores) do
    mensaje
    |> ingresar([], :autores)
  end

  defp ingresar(mensaje, lista, :autores) do
    autor = mensaje |> ingresar()

    nueva_lista = lista ++ [autor]

    mas_autores =
      "\n¿Desea ingresar más autores? (s/n):"
      |> Util.ingresar(:boolean)

    case mas_autores do
      true ->
        mensaje |> ingresar(nueva_lista, :autores)

      false ->
        nueva_lista
    end
  end
end
