# suma

## About

suma is an open source hardware Eurorack mixer module by [piruetas](https://piruetas.xyz), part of popusintes. It sums three inputs, each with its own potentiometer, into one output, using a TL072 dual op amp (rev-a also had an inverted output, removed in rev-b). The board is made in KiCad 10 with its own local symbol, footprint and 3D model libraries, included in each revision's `bibliotecas/` folder, and the panel is made in OpenSCAD with the shared modules from [popusintes-cajas-paneles](https://github.com/piruetasxyz/popusintes-cajas-paneles), included as a git submodule in `terceros/`. Hardware is licensed under CERN-OHL-P-2.0, and the panel and documentation under CC-BY-SA-4.0 (see [LICENSE.md](./LICENSE.md)). Documentation, schematic, board render and bill of materials (in Spanish): <https://piruetas.xyz/suma/>.

## Acerca de

Mezclador eurorack de [piruetas](https://piruetas.xyz), parte de popusintes, hecho en KiCad y publicado como hardware de código abierto.

Documentación, esquemático, placa y Bill of materials: <https://piruetas.xyz/suma/>.

## Características

- 3 entradas (jacks de 3.5 mm), cada una con su potenciómetro.
- 1 salida: la suma de las entradas (rev-a tenía además una salida con la suma invertida, que rev-b ya no lleva).
- Amplificador operacional dual TL072.
- Alimentación por header Eurorack de 10 pines (2x05), ±12V, con diodos Schottky de protección contra polaridad inversa.
- Placa de 25 × 100 mm, 2 capas.

## Revisiones

- `v0.1 rev-a`: diseñada y fabricada en octubre 2026. No funciona tal como viene armada (ver errores abajo).
- `v0.1 rev-b`: en desarrollo. Corrige las huellas de los diodos y de los potenciómetros, quita la salida invertida (J6 y R8), tiene la placa ruteada de nuevo y agrega el panel.

### Errores conocidos de rev-a

El esquemático está bien; los errores están en las huellas.

- **Diodos D1 y D2 montados al revés.** El símbolo tiene el cátodo (K) en el pin 1, pero la serigrafía de la huella `SOD-123FL_L2.8-W1.8-LS3.7-R-RD` marca el cátodo en el pad 2, y JLCPCB los montó siguiendo la serigrafía. Los diodos quedan en inverso, el TL072 solo recibe la corriente de fuga de los Schottky y los rieles caen a unos ±1.5 V en vez de ±11.7 V. Resultado: la salida sale muy baja (~1 Vpp en vez de 5 Vpp) y deformada.
- **Potenciómetros al revés.** La huella `POT_TH_Alps_RK09K_Single_Vertical` tiene los pads 1 y 3 intercambiados respecto a la huella estándar de KiCad. Girando en sentido horario el cursor va hacia GND (silencio), y en antihorario hacia la entrada (volumen máximo).

Para comprobarlo en una placa: con el módulo alimentado, medir el pin 8 y el pin 4 de U1 (o C1 y C2) respecto a GND. Si da ~±1-2 V en vez de ~±11.7 V, los diodos están al revés.

Arreglo de las placas rev-a ya armadas:

- Desoldar D1 y D2 y soldarlos girados 180°. Para probar rápido, también se pueden puentear con un cable (se pierde la protección contra polaridad inversa).
- Los potenciómetros no tienen arreglo limpio: esas placas funcionan al revés (antihorario = más volumen).

### Simulación

rev-a y rev-b se pueden simular en KiCad (Inspeccionar → Simulador → Ejecutar). Los modelos están en `bibliotecas/spice/`: el TL072 (macro-modelo aproximado; para más precisión reemplazar por el modelo oficial de TI), el 1N5817, y modelos de los conectores para no agregar fuentes al esquemático. J4 se comporta como una fuente de ±12 V, J1-J3 como osciladores senoidales (J1: 5 Vpp a 220 Hz; J2 y J3 en 0 V; se cambian con `amplitud` y `frecuencia` en Sim.Params) y las salidas (J5 y J6 en rev-a, solo J5 en rev-b) como la entrada de 100k de otro módulo. La posición de cada potenciómetro se cambia con `pos` en Sim.Params (1 = horario completo, según el esquemático).

La simulación muestra el circuito tal como está en el esquemático (que funciona: 4.95 Vpp con el potenciómetro al máximo). Para reproducir cómo quedó armada rev-a, cambiar Sim.Pins de D1 y D2 a `1=A 2=K` e invertir `pos` en los potenciómetros.

El PCB de rev-a no se actualizó con los campos de simulación, para que siga siendo igual a lo fabricado. Por eso el DRC con paridad de esquemático muestra 12 avisos de campos `Sim.*` faltantes, que no afectan al circuito.

### Pendientes para rev-b

Ya está hecho en [hardware/suma-v-0-rev-b](./hardware/suma-v-0-rev-b):

- Biblioteca propia `popusintes` ([bibliotecas/popusintes.pretty](./hardware/suma-v-0-rev-b/bibliotecas/popusintes.pretty) y [bibliotecas/popusintes.3dshapes](./hardware/suma-v-0-rev-b/bibliotecas/popusintes.3dshapes)), autocontenida con sus modelos 3D, con dos huellas corregidas:
  - `Diodo_SOD-123FL`: misma geometría y serigrafía que la huella de EasyEDA, con los pads 1 y 2 intercambiados para que el pad 1 (cátodo, K) quede del lado de la barra. Así la serigrafía, los números de pad y la huella de JLCPCB coinciden, y la rotación en el CPL sigue en 0.
  - `Potenciometro_Alpha_RD901F_Vertical`: misma geometría que la huella BYOM (que calza bien con los potenciómetros), con los pads 1 y 3 intercambiados: visto de frente con las patas hacia abajo, pad 1 = pata izquierda (antihorario), pad 3 = pata derecha (horario).
- Sin salida invertida: se quitaron J6 y R8.
- Placa ruteada de nuevo: DRC sin errores, sin conexiones pendientes y sin diferencias con el esquemático.
- Todo renombrado de rev-a a rev-b, incluida la carpeta de salida de los gerbers (`../suma-v-0-rev-b-fab/`), para no pisar los archivos de rev-a.
- Panel en [panel/suma-v-0-rev-b](./panel/suma-v-0-rev-b), con los agujeros de los potenciómetros y jacks en las mismas posiciones que la placa.

Falta:

- [ ] Opcional: acercar C2 al pin 4 de U1 (−12 V); hoy está a unos 10 mm.
- [ ] Simular rev-b en KiCad antes de mandarla a fabricar.
- [ ] Revisar el texto de la serigrafía en un computador con las fuentes del proyecto instaladas antes de generar los gerbers.
- [ ] Generar gerbers, BOM y CPL de rev-b (`hardware/suma-v-0-rev-b-fab` y `hardware/suma-v-0-rev-b-pcba`).
- [ ] En el pedido de JLCPCB, revisar en la vista previa de montaje que la banda de D1 y D2 quede en el pad 1, el izquierdo, del lado de la barra de la serigrafía.
- [ ] Antes de imprimir el panel, confirmar que queda bien de izquierda a derecha visto de frente (potenciómetros a la izquierda, jacks a la derecha), por ejemplo con un panel ya impreso de relo, que usa la misma convención. Después exportar el `.stl`.
- [ ] Actualizar [kicad-retrata.yml](./kicad-retrata.yml) y [docs](./docs) para que apunten a rev-b.
- [ ] Revisar otros módulos de popusintes que usen las mismas huellas de EasyEDA y BYOM: atenu rev-a usa la huella BYOM del potenciómetro con el mismo cableado que suma, así que tiene el mismo error.

## Estructura del repositorio

- [hardware/suma-v-0-rev-a](./hardware/suma-v-0-rev-a): proyecto de KiCad (esquemático y placa), los archivos fuente del diseño.
- [hardware/suma-v-0-rev-a/bibliotecas](./hardware/suma-v-0-rev-a/bibliotecas): símbolos, huellas y modelos 3D usados por el proyecto. Van en el repositorio para que el proyecto de KiCad se abra sin instalar bibliotecas adicionales.
- [hardware/suma-v-0-rev-a-fab](./hardware/suma-v-0-rev-a-fab): gerbers y archivos de taladrado para fabricar la placa.
- [hardware/suma-v-0-rev-a-pcba](./hardware/suma-v-0-rev-a-pcba): lista de componentes y archivo de posiciones para armado en JLCPCB.
- [hardware/suma-v-0-rev-b](./hardware/suma-v-0-rev-b): proyecto de KiCad de rev-b (en desarrollo). Sus [bibliotecas](./hardware/suma-v-0-rev-b/bibliotecas) incluyen la biblioteca propia `popusintes` con las huellas corregidas del diodo y del potenciómetro, y los modelos SPICE en `spice/`.
- [panel/suma-v-0-rev-b](./panel/suma-v-0-rev-b): archivos fuente de OpenSCAD del panel, con los agujeros de los potenciómetros y jacks de la placa rev-b. Se abre [suma.scad](./panel/suma-v-0-rev-b/suma.scad); la versión grabada en el panel está en [versiones.scad](./panel/suma-v-0-rev-b/versiones.scad).
- [terceros/popusintes-cajas-paneles](https://github.com/piruetasxyz/popusintes-cajas-paneles): submódulo de git con las constantes eurorack y las funciones y módulos de OpenSCAD compartidos entre las cajas y paneles de popusintes. Para clonar el repositorio con el submódulo: `git clone --recursive https://github.com/piruetasxyz/suma.git`, o `git submodule update --init` si ya estaba clonado.
- [docs](./docs): documentación, publicada en <https://piruetas.xyz/suma/>. Las capturas del esquemático y de la placa, y la tabla de Bill of materials, las genera [kicad-retrata](https://github.com/piruetasxyz/kicad-retrata) en cada push (ver [kicad-retrata.yml](./kicad-retrata.yml)).
- [LICENSES](./LICENSES): textos completos de las licencias.

## Fabricación

Como es hardware de código abierto, los archivos fuente de KiCad, los archivos de fabricación de [hardware/suma-v-0-rev-a-fab](./hardware/suma-v-0-rev-a-fab), los de armado de [hardware/suma-v-0-rev-a-pcba](./hardware/suma-v-0-rev-a-pcba) y la [Bill of materials](https://piruetas.xyz/suma/#bill-of-materials-v01-rev-a) están publicados para que cualquiera pueda estudiar, modificar y fabricar el diseño. piruetas no da soporte para unidades fabricadas o armadas por terceros.

## Créditos

- Aarón Montoya-Moraga: investigación, esquemático, PCB, fabricación y documentación.

## Licencia

suma es (c) 2026 piruetas SpA / Aarón Montoya-Moraga.

- Hardware (`hardware/`): [CERN-OHL-P-2.0](./LICENSES/CERN-OHL-P-2.0.txt).
- Panel (`panel/`): [CC-BY-SA-4.0](./LICENSES/CC-BY-SA-4.0.txt).
- Documentación (`docs/`): [CC-BY-SA-4.0](./LICENSES/CC-BY-SA-4.0.txt).
- Biblioteca compartida (`terceros/popusintes-cajas-paneles`): submódulo con su propia licencia, MIT.
- El nombre, logo y marca de piruetas no están cubiertos por estas licencias: ver [LicenseRef-piruetas-branding](./LICENSES/LicenseRef-piruetas-branding.txt).

Ver [LICENSE.md](./LICENSE.md) para los detalles. El repositorio sigue la especificación [REUSE](https://reuse.software/).
