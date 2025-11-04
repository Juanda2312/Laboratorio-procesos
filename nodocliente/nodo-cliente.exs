defmodule NodoCliente do
  @nombre_servicio_local :servicio_respuesta
  @servicio_local {@nombre_servicio_local, :nodocliente@cliente}
  @nodo_remoto :nodoservidor@localhost
  @servicio_remoto {:servicio_trabajo_grados, @nodo_remoto}

  def main() do
    Util.mostrar_mensaje("PROCESO PRINCIPAL")
    @nombre_servicio_local
    |> registrar_servicio()
    establecer_conexion(@nodo_remoto)
    |> iniciar_produccion()
  end

  defp registrar_servicio(nombre_servicio_local), do: Process.register(self(), nombre_servicio_local)

  defp establecer_conexion(nodo_remoto) do
    Node.connect(nodo_remoto)
  end

  defp iniciar_produccion(false), do: Util.mostrar_error("No se pudo conectar con el nodo servidor")

  defp iniciar_produccion(true) do
    Util.mostrar_mensaje("Comandos disponibles:
    -lista
    -autores (ingresar titulo)
    -fin")
    loop_usuario()
  end

  def loop_usuario()do
    comando = "Ingrese el comando:"
    |>Util.ingresar(:texto)
    |>String.trim()
    |>String.downcase()

    cond do
      comando == "fin" ->
        send(@servicio_remoto, {@servicio_local, :fin})
      comando == "lista"->
        send(@servicio_remoto, {@servicio_local, :lista})
        recibir_respuestas()
        loop_usuario()
      String.starts_with?(comando, "autores") ->
        titulo = comando |> String.replace_prefix("autores ", "") |> String.trim() |> String.downcase()
        send(@servicio_remoto, {@servicio_local, {:autores,titulo}})
        recibir_respuestas()
        loop_usuario()
      true ->
        Util.mostrar_error("Comando desconocido")
        loop_usuario()
    end
  end

  defp recibir_respuestas() do
    receive do
      respuesta ->
        Util.mostrar_mensaje("\t -> \"#{respuesta}\"")
    after
      2000 -> # opcional: timeout en ms por si algo falla
        Util.mostrar_error("Tiempo de espera agotado al recibir respuesta.")
    end
  end

end
NodoCliente.main()
