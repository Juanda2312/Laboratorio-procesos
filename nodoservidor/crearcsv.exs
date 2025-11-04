defmodule CrearTrabajos do
  def main do
    Util.mostrar_mensaje("=== CREAR TRABAJOS DE GRADO ===")

    trabajos =
      "Ingrese los trabajos de grado:"
      |> TrabajoGrado.ingresar(:trabajos)

    TrabajoGrado.escribir_csv(trabajos, "trabajos.csv")

    Util.mostrar_mensaje("\n✅ Se guardaron correctamente los trabajos en: trabajos.csv")
  end
end
CrearTrabajos.main()
