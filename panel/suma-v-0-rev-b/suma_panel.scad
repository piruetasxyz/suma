// suma_panel.scad
// agujeros copiados de la placa de esta misma revision
// (../../hardware/suma-v-0-rev-b/suma-v-0-rev-b.kicad_pcb): tres
// potenciometros en la columna izquierda, tres entradas y la salida en
// la columna derecha
//
// la placa (25 x 100 mm) va centrada en el panel, vista de frente, con
// el header de poder arriba. las posiciones son los centros de los
// footprints en kicad (eje de cada potenciometro, barril de cada jack),
// convertidas a porcentajes de layout como en los paneles de
// popusintes-cajas-paneles

include <../../terceros/popusintes-cajas-paneles/comun/comun.scad>
include <./versiones.scad>

// borde de la placa en coordenadas de kicad, en mm
SUMA_PCB_X0 = 30;
SUMA_PCB_Y0 = 30;
SUMA_PCB_ANCHO = 25;
SUMA_PCB_ALTO = 100;

// coordenadas de kicad (y hacia abajo) a porcentajes de layout
function suma_px(x_pcb, ancho) = (x_pcb - SUMA_PCB_X0 + (ancho - SUMA_PCB_ANCHO) / 2) / ancho;
function suma_py(y_pcb, alto) = (y_pcb - SUMA_PCB_Y0 + (alto - SUMA_PCB_ALTO) / 2) / alto;

module suma_panel() {
  ancho = MODULO_ANCHO * SUMA_HP;
  alto  = MODULO_ALTURA_3U;

  // RV1, RV2, RV3
  POTES_X = 37.8;
  POTES_Y = [71.5, 88.05, 104];

  // J1, J2, J3 (entradas) y J5 (salida)
  JACKS_X = 49.5;
  JACKS_Y = [73.5, 89.42, 105.42, 121.42];

  difference() {
    panel_base(ancho, alto);

    union() {
      agujeros_tornillos(ancho, alto, ambos_lados = false);

      for (y = POTES_Y)
        agujero_perilla(ancho, alto, suma_px(POTES_X, ancho), suma_py(y, alto));

      for (y = JACKS_Y)
        agujero_jack(ancho, alto, suma_px(JACKS_X, ancho), suma_py(y, alto));

      grabados_panel(SUMA_TEXTO, VERSION, ancho, alto);
    }
  }
}
