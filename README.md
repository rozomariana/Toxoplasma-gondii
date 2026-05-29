# Análisis de expresión diferencial de genes de *Toxoplasma gondii* ME49 durante la infección crónica temprana y tardía

¡Bienvenidos a este repositorio! Aquí se consolida el código, los flujos de trabajo bioinformáticos y los resultados derivados del proyecto de investigación enfocado en la dinámica transcripcional de la etapa crónica de *Toxoplasma gondii*. 

Este espacio ha sido diseñado para garantizar la reproducibilidad de los análisis moleculares y bioinformáticos empleados en el estudio.

---

## 📝 Contexto del Proyecto

La toxoplasmosis es una zoonosis de distribución mundial causada por el parásito protozoo intracelular obligado *Toxoplasma gondii*. Durante la fase crónica de la infección, el parásito se diferencia en bradizoítos encapsulados en quistes tisulares, localizados principalmente en el tejido nervioso y muscular del hospedero. Tradicionalmente se ha considerado a esta etapa como metabólicamente inactiva o silente; sin embargo, evidencias recientes sugieren una regulación dinámica y compleja a lo largo del tiempo.

El objetivo principal de este proyecto es evaluar y comparar el perfil de expresión génica diferencial (DEG) global de *Toxoplasma gondii* ME49 *in vivo* en dos puntos temporales críticos de la fase crónica: la **infección crónica temprana (28 días post-infección - DPI)** y la **infección crónica tardía (120 días post-infección - DPI)**. A través de este análisis transcriptómico se busca identificar los cambios regulatorios y las variaciones funcionales que permiten la persistencia a largo plazo y la evasión de la respuesta inmune por parte del parásito.

---

## 🔗 Enlaces Rápidos del Proyecto

*   **Artículo Completo:** Accede al manuscrito y texto principal en [Google Docs](https://docs.google.com/document/d/1AW5XsEjp8kAaacoqrTNV1todCkHhk2zSJ5NVpu3jNuw/edit?pli=1&tab=t.0).
*   **Código y Pipeline:** Encuentra el paso a paso documentado en la [Wiki del Repositorio](https://github.com/rozomariana/Toxoplasma-gondii/wiki).

---

## 📊 Resultados y Figuras Principales

A continuación se presentan los archivos correspondientes a las figuras analíticas del proyecto y la matriz completa de expresión diferencial:

*   **[Figura 1. Análisis de Componentes Principales (PCA)](https://github.com/rozomariana/Toxoplasma-gondii/blob/main/PCA_28DPI_120DPI.pdf):** Evaluación de la variabilidad global y el agrupamiento de las muestras correspondientes a los días 28 y 120 post-infección.
*   **[Figura 2. Gráfico de Volcán (Volcano Plot)](https://github.com/rozomariana/Toxoplasma-gondii/blob/main/Volcano_28DPI_120DPI.pdf):** Visualización de la significancia estadística frente al cambio en el nivel de expresión (*Fold Change*) de los genes sobreexpresados y subexpresados.
*   **[Figura 3. Mapa de Calor (Heatmap Top 100)](https://github.com/rozomariana/Toxoplasma-gondii/blob/main/Heatmap_top100_28DPI_120DPI.pdf):** Perfil de expresión y agrupamiento jerárquico de los 100 genes más significativamente diferenciados entre ambas condiciones.
*   **[Suplementario 1. Tabla de Expresión Diferencial Completa](https://github.com/rozomariana/Toxoplasma-gondii/blob/main/DEG_resultados_completos_120DPI_vs_28DPI.csv):** Matriz de datos en formato CSV que contiene todos los resultados del análisis de expresión diferencial (valores de *Log2 Fold Change*, *p-value* y *p-adjusted*) para la comparación 120 DPI vs. 28 DPI.
