================================================================================
PROYECTO FINAL - ANÁLISIS DE SEÑALES
Universidad San Francisco de Quito
================================================================================

CONTENIDO DEL PROYECTO
----------------------

Archivos MATLAB (.m):
  - filtros_ideales.m                : Análisis de filtros ideales (pasabajos, pasabanda, pasaaltos)
  - filtro_primer_orden_60Hz.m       : Filtro de 1er orden para atenuar señal de 60 Hz
  - filtro_segundo_orden_120Hz.m     : Filtro de 2do orden para atenuar señal de 120 Hz
  - butterworth_3kHz_6kHz.m          : Diseño Butterworth (fp=3kHz, fs=6kHz)
  - butterworth_6kHz_7kHz.m          : Diseño Butterworth (fp=6kHz, fs=7kHz)

Documento LaTeX:
  - final-project.tex                : Documento principal del proyecto (684 líneas)

Otros:
  - proeycto_final.pdf               : Enunciado del proyecto
  - Oppenheim Segnales y Sistemas.pdf: Libro de referencia


EJECUCIÓN DE CÓDIGO MATLAB
---------------------------

Requisitos:
  - MATLAB R2018b o superior
  - Signal Processing Toolbox

Instrucciones:
  1. Abrir MATLAB
  2. Navegar al directorio del proyecto: cd('/home/user/Downloads/proyecto-señales')
  3. Ejecutar cualquier script:
     >> run('filtros_ideales.m')
     >> run('filtro_primer_orden_60Hz.m')
     >> run('filtro_segundo_orden_120Hz.m')
     >> run('butterworth_3kHz_6kHz.m')
     >> run('butterworth_6kHz_7kHz.m')

Los scripts generan:
  - Gráficas en pantalla
  - Archivos PNG con las figuras
  - Resultados numéricos en la consola


COMPILACIÓN DEL DOCUMENTO LaTeX
--------------------------------

El documento requiere los siguientes paquetes LaTeX:
  - babel (spanish), inputenc, fontenc
  - amsmath, amssymb, siunitx
  - geometry, graphicx, caption
  - booktabs, hyperref, fancyhdr
  - enumitem, listings, xcolor
  - circuitikz, tikz, tabularray

Compilación usando Nix:

  Opción 1 - Shell interactivo:
    bash -c 'nix shell nixpkgs#texliveFull --extra-experimental-features "nix-command flakes"'
    # Dentro del shell:
    pdflatex final-project.tex
    pdflatex final-project.tex  # Segunda pasada para referencias

  Opción 2 - Comando directo:
    nix shell nixpkgs#texliveFull --extra-experimental-features "nix-command flakes" \
      --command pdflatex final-project.tex

  Opción 3 - Compilación completa (con bibliografía):
    nix shell nixpkgs#texliveFull --extra-experimental-features "nix-command flakes" \
      --command bash -c 'pdflatex final-project.tex && pdflatex final-project.tex'

Nota: Se requieren DOS pasadas de pdflatex para resolver correctamente las referencias
      cruzadas y el índice de contenidos.


ESTRUCTURA DEL DOCUMENTO
-------------------------

1. Portada y datos generales
2. Resumen
3. Objetivos (general y específicos)
4. Marco teórico
5. Metodología
6. Desarrollo del proyecto:
   - Fase lineal y no lineal en sistemas LTI
   - Retardo de grupo
   - Diagramas de Bode
   - Análisis de filtros ideales
   - Filtro pasabajos de primer orden (60 Hz)
   - Filtro pasabajos de segundo orden (120 Hz)
   - Definiciones de parámetros de diseño
   - Diseño Butterworth caso 1 (3 kHz / 6 kHz)
   - Diseño Butterworth caso 2 (6 kHz / 7 kHz)
   - Sistemas físicos como filtros
7. Resultados y análisis
8. Conclusiones
9. Referencias (formato APA 7ma edición)
10. Anexos (código MATLAB)


CARACTERÍSTICAS DEL DOCUMENTO
------------------------------

- Estilo académico, tercera persona
- Sin viñetas (excepto donde es idiomático)
- Ecuaciones numeradas fuera del texto
- Placeholders para imágenes (ejecutar MATLAB para generar)
- Código con syntax highlighting
- Tablas usando tabularray
- Referencias en formato APA 7ma edición
- Total: 684 líneas, 32 subsecciones


GENERACIÓN DE FIGURAS
----------------------

Las figuras se generan ejecutando los scripts de MATLAB.
Los placeholders en el documento indican:
  [Placeholder: Descripción de la figura]

Para reemplazar los placeholders:
  1. Ejecutar el script MATLAB correspondiente
  2. Verificar que se generó el archivo PNG
  3. Editar final-project.tex y reemplazar el placeholder con:
     \includegraphics[width=0.9\textwidth]{nombre_archivo.png}


REFERENCIAS ACADÉMICAS
----------------------

El documento incluye referencias a:
  - Oppenheim, Willsky & Nawab (1997) - Signals and Systems
  - Ogata (2010) - Modern Control Engineering
  - Butterworth (1930) - On the theory of filter amplifiers
  - Lyons (2011) - Understanding Digital Signal Processing
  - Parks & Burrus (1987) - Digital Filter Design
  - Proakis & Manolakis (2007) - Digital Signal Processing

Todas las referencias están en formato APA 7ma edición.


NOTAS IMPORTANTES
-----------------

1. El documento está completo y listo para compilar
2. Los placeholders de imágenes deben reemplazarse con las figuras generadas
3. Se recomienda compilar dos veces para resolver todas las referencias
4. Los scripts MATLAB son independientes y autocontenidos
5. El documento usa siunitx para unidades (configurado en español)


AUTORES
-------

Paul Anchapaxi (00338260)
Steven Merino (0333621)

Profesor: Luis Procel Moya
Asignatura: Señales y Sistemas
Fecha: 9 de diciembre del 2025

================================================================================
