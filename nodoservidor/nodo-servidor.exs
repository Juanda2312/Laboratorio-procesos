defmodule NodoServidor do
  @nombre_servicio_local :servicio_trabajo_grados

  def main() do
    Util.mostrar_mensaje("SERVIDOR INICIADO")
    registrar_servicio(@nombre_servicio_local)
    procesar_mensajes()
  end


  defp registrar_servicio(nombre_servicio_local), do: Process.register(self(), nombre_servicio_local)
  defp procesar_mensajes() do
    receive do
      {productor, mensaje} ->
      respuesta = procesar_mensaje(mensaje)
      send(productor, respuesta)
      # Llama recursivamente para seguir recibiendo mensajes
      if respuesta != :fin, do: procesar_mensajes()
    end
  end
  defp procesar_mensaje(:fin), do: :fin
  defp procesar_mensaje(:lista) do
    trabajos = TrabajoGrado.leer_csv("trabajos.csv")

    trabajos
    |> Enum.map(fn trabajo ->
      "📘 Título: #{trabajo.titulo}\n" <>
      "🗓 Fecha: #{trabajo.fecha}\n" <>
      "📝 Descripción: #{trabajo.descripcion}\n"
    end)
    |> Enum.join("\n──────────────────────────────\n")
  end


  defp procesar_mensaje({:autores, titulo})do
    obtener_trabajo(TrabajoGrado.leer_csv("trabajos.csv"),titulo)
  end
defp obtener_trabajo([], _), do: "No se encontró el trabajo."

  defp obtener_trabajo([trabajo | resto], titulo) do
    if String.downcase(String.trim(trabajo.titulo)) == String.downcase(String.trim(titulo)) do
      autores =
        trabajo.autores
        |> Enum.map(fn a ->
          "#{a.nombre} #{a.apellidos} (#{a.cedula}) - #{a.programa}, #{a.titulo_profesional}"
        end)
        |> Enum.join("\n")

      "Autores del trabajo \"#{trabajo.titulo}\":\n" <> autores
    else
      obtener_trabajo(resto, titulo)
    end
  end

  defp procesar_mensaje(mensaje), do: "El comando \"#{mensaje}\" es desconocido."

end
NodoServidor.main()
