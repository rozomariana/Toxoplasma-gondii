nohup bash descargasfastq.sh \&

tail -f nohup.out



\#Cuando ya se gaurdo bien todo, cree las carpetas para cada muestra y movi las muestras en cada posición

use una replica técnica de la muestra 120dpi3 (muestra 2) y la pase a 120dpi\_4 como si fuera una muestra biológica

(base) \[bio.pt@caldas01 muestra3]$ mv 120DPI\_3\_SRR9667927\_1.fastq.gz 120DPI\_4\_SRR9667927\_1.fastq.gz

(base) \[bio.pt@caldas01 muestra3]$ mv 120DPI\_3\_SRR9667927\_2.fastq.gz 120DPI\_4\_SRR9667927\_2.fastq.gz



luego para revisar la calidad use fastqc:

salloc -N 1 -n 4 -p dev

module load fastqc

fastqc \*.fastq.gz

\#Para las carpetas de 120DPI (por cada carepta que tenia para cada muestat se generaron archivos del fastqc.html los movía aprte para no confuncirme cuando ya haga los filtros:

mkdir fastqcbefore

(base) \[bio.pt@caldas01 muestra3]$ mv \*.html fastqcbefore/



Lo anterior lo hice por cada carpeta.



\#!/bin/bash

\#SBATCH -p normal

\#SBATCH -N 1

\#SBATCH -n 4

\#SBATCH -t 02:00:00

\#SBATCH -o salida\_.out

\#SBATCH -e error\_.err

\#SBATCH --mail-user=mariana.rozor@urosario.edu.co

\#SBATCH --mail-type=ALL



module load fastqc

fastqc \*.fastq.gz









\#Para las muestras de 28 dpi use para mu muestra 2:

el forwars y revers de la primera corrida de  la muestra biológica 3 de 28 dpi

(base) \[bio.pt@caldas01 muestra3]$ cp \*28DPI\_3\_SRR9667919\*  /home/bio.pt/data/marianarozor/proyect

o/archivos/28DPI/muestra2/



renombre los archivos:

(base) \[bio.pt@caldas01 muestra2]$ mv 28DPI\_3\_SRR9667919\_1.fastq.gz 28DPI\_2\_SRR9667919\_1.fastq.gz

(base) \[bio.pt@caldas01 muestra2]$ mv 28DPI\_3\_SRR9667919\_2.fastq.gz 28DPI\_2\_SRR9667919\_2.fastq.gz

(base) \[bio.pt@caldas01 muestra2]





\#REALICE EL FASTQC BEFORE PARA CADA UNA DE LAS MUESTRAS.



\# me toco descargar un archivo yo:

wget -c https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR966/007/SRR9667917/SRR9667917\_1.fastq.gz -O 28DPI\_1\_SRR9667917\_1.fastq.gz



\### mover el archivo que no se porque no se descargo: de la carpeta original a la copia de 28dpi:

cp 28DPI\_1\_SRR9667917\_1.fastq.gz /home/bio.pt/data/marianarozor/proyecto/archivos/28DPI/muestra1



module load fastqc

fastqc 28DPI\_1\_SRR9667917\_1.fastq.gz









\#PARA DESCARGAR TODOS LOS ARCHIVOS .HTML ORGANIZADOS POR CARPETAS :



\#Desde la terminal de mi computador

rsync -rvm -e 'ssh -i bio.pt.pem -p 53841' \\

&#x20; --include='\*/' \\

&#x20; --include='\*fastqcbefore/\*\*\*' \\

&#x20; --include='\*.html' \\

&#x20; --exclude='\*' \\

&#x20; bio.pt@loginpub-hpc.urosario.edu.co:/home/bio.pt/data/marianarozor/proyecto/archivos/ \\

&#x20; /mnt/c/Users/Mariana\\ Rozo/Downloads/





\# que significa cada cosa:

Estructura de ejecución y conexión

rsync -rvm

Esta es la base del programa. La letra r permite que el código viaje a través de todas tus subcarpetas. La letra v te muestra en pantalla el nombre de los archivos que se están bajando para que sepas que el proceso avanza. La letra m es la que limpia el resultado, pues evita que se descarguen carpetas que no tengan archivos html dentro.



\-e 'ssh -i bio.pt.pem -p 53841'

Esta parte configura la seguridad. Le indica al programa que debe usar tu llave privada llamada bio.pt.pem para entrar al servidor. También le dice que debe usar el puerto 53841, que es la entrada específica para el clúster de la universidad.



Reglas de filtrado inteligente

\--include='\*/'

Es la orden de exploración. Le dice al comando que tiene permiso de entrar en cualquier nivel de carpetas, como 120DPI o 28DPI, para buscar lo que necesitas.



\--include='fastqcbefore/' e --include='\*.html'

Aquí defines el objetivo. Estas líneas le dicen al programa que busque específicamente las carpetas llamadas fastqcbefore y que dentro de ellas solo seleccione los archivos que terminan en punto html. Esto incluye tanto el reporte Forward como el Reverse.



\--exclude='\*'

Es el filtro de ahorro. Esta instrucción le prohíbe al programa descargar cualquier cosa que no hayamos incluido antes. Gracias a esto, el comando ignora los archivos de secuenciación fastq y los archivos comprimidos zip, que son muy pesados y harían la descarga muy lenta.



Ubicación de archivos

bio.pt@loginpub-hpc.urosario.edu.co:/home/bio.pt/.../archivos/

Esta es la ruta de origen. Es la dirección exacta dentro del clúster donde están guardados los resultados de tus análisis de transcriptómica.



/mnt/c/Users/Mariana\\ Rozo/Downloads/

Esta es la ruta de destino. Indica que todo lo que se descargue debe guardarse en la carpeta de descargas de tu usuario en Windows. Al terminar, verás tus archivos organizados por carpetas de tratamiento y muestra tal como estaban en el servidor.





\#Se analiza solo el html que salela otra capreta comprimida pues e slo mismo pero están las magenes y demás....

¿Por qué salen 2 archivos?

R1 (Forward): Es la lectura en el sentido 5' -> 3'.



R2 (Reverse): Es la lectura del extremo opuesto del mismo fragmento.



Importancia: Tienes que revisar ambos. Es muy común que la calidad del R2 (Reverse) sea un poco más baja que la del R1 al final de la lectura debido al desgaste de los reactivos en el secuenciador. Si solo miras uno, podrías ignorar problemas en la mitad de tus datos.







\#### Corigiendo con Rcorrector :



\_1 : Forward  left

\_2 : Reverse  right



. ¿Forwards es igual a Right?No, por lo general es al revés.Forward (Forward Primer): Se considera el primer de la izquierda (Left) o el inicio de la secuencia.Reverse (Reverse Primer): Se considera el primer de la derecha (Right).



28DPI\_3\_SRR9667919\_

28DPI\_3\_SRR9667920\_





nano nombres\_archivos.txt

nano Rcorrector.sh

\#!/bin/bash

\#SBATCH -p normal

\#SBATCH -N 1

\#SBATCH -n 8

\#SBATCH -t 00:00:20

\#SBATCH -o salida\_corrector.out

\#SBATCH -e error\_corrector.err

\#SBATCH --mail-user=mariana.rozor@urosario.edu.co

\#SBATCH --mail-type=ALL



mkdir -p resultR\_corrector

module load perl

for line in $(cat nombres\_archivos.txt)

do

perl /opt/ohpc/pub/apps/rcorrector/run\_rcorrector.pl -t 8 -1 ${line}1.fastq.gz -2 ${line}2.fastq.gz \\

\-od ./resultR\_corrector

done

rm -f tmp\_\*







Hice esto por cada muestra.





sacct

scontrol show job 303167

scontrol show job 303166

&#x20; #

\#Para crear el archivo con todos los nombres

find . -name "nombres\_archivos.txt" -exec cat {} + > lista\_completa\_nombres.txt



\#!/bin/bash

\#SBATCH -p normal

\#SBATCH -n 8

\#SBATCH -t 10:00:00

\#SBATCH -o salida\_filtrado.out

\#SBATCH -e error\_filtrado.err

\#SBATCH --mail-user=mariana.rozor@urosario.edu.co

\#SBATCH --mail-type=ALL



module load python/2.7.15



TRATAMIENTOS=("28DPI" "120DPI")



for trat in "${TRATAMIENTOS\[@]}"

do

&#x20;   cd "$trat"

&#x20;   for line in $(cat lista\_completa\_nombres.txt)

&#x20;   do

&#x20;       for dir\_muestra in muestra\*/

&#x20;       do

&#x20;           if \[ -d "${dir\_muestra}resultR\_corrector" ]; then

&#x20;               cd "$dir\_muestra"



&#x20;               mkdir -p filtrado\_final



&#x20;               python2 /opt/ohpc/pub/apps/TranscriptomeAssemblyTools/FilterUncorrectabledPEfastq.py \\

&#x20;               -1 "resultR\_corrector/${line}\_1.cor.fq.gz" \\

&#x20;               -2 "resultR\_corrector/${line}\_2.cor.fq.gz"



&#x20;               mv unfixrm\_${line}\_1.cor.fq.gz filtrado\_final/

&#x20;               mv unfixrm\_${line}\_2.cor.fq.gz filtrado\_final/



&#x20;               cd ..

&#x20;           fi

&#x20;       done

&#x20;   done

&#x20;   cd ..

done





\# trimgalote o trimomatic??

trimgalore:

zcat unfixrm\_archivo\_1.cor.fq.gz | head -n 2 | tail -n 1 | wc -c

para definir longitud actual y saber que valor de parámetro debo usar



Regla de oro según el análisis (para Toxoplasma)

Para Expresión Diferencial de Exones (DEU):

Este es tu caso. Necesitas lecturas largas para que "crucen" la unión entre un exón y otro. Si la lectura es muy corta (ej. 20bp), no sabrás a qué exón pertenece.



Recomendación: Un --length de 50 es lo ideal si tus lecturas son de 100bp o 150bp. Si pones menos de 36bp, el mapeador (STAR o HISAT2) tendrá problemas para asignar la lectura a un lugar único del genoma.



Si tus lecturas originales son cortas (ej. 50bp o 75bp):

En este caso, no puedes pedirle 50. Deberías usar un tercio o la mitad de la longitud original.



Recomendación: Usa --length 36.



3\. El equilibrio entre Calidad y Cantidad

Si eres muy estricto (ej. --length 80): Perderás mucha información, porque muchas lecturas buenas quedarán un poco más cortas tras quitar los adaptadores y el programa las descartará.



Si eres muy relajado (ej. --length 20): Mantendrás casi todos los datos, pero las lecturas cortas causarán "multimapeo" (la lectura encaja en 10 partes distintas del genoma de Toxoplasma) y el análisis de exones no servirá





trimomatic es mejor en mi proyecto porque:

Trimmomatic (v0.39)

Algoritmos de Trimming Avanzados (MAXINFO): A diferencia de Trim Galore (que es un envoltorio de cutadapt), Trimmomatic ofrece el modo Maximum Information. Este algoritmo no solo corta por un umbral rígido de calidad, sino que realiza un balance estadístico entre la longitud de la lectura y la probabilidad de error. Esto es crucial en muestras de bradizoítos donde la cantidad de material puede ser limitada; MAXINFO conserva la mayor cantidad de información útil para el mapeo sin ser excesivamente agresivo.Gestión Estricta de Lecturas Emparejadas (Paired-End): Trimmomatic fue diseñado específicamente para mantener la sincronía entre los archivos R1 y R2 de forma nativa. Al procesar tus muestras de BioProject PRJNA511234, garantiza que si una lectura se descarta o se acorta drásticamente, su pareja sea tratada correctamente (generando archivos "unpaired"), evitando errores en el alineamiento posterior con el genoma de Mus musculus o T. gondii.Control Total sobre Adaptadores Nextera XT: Dado que tus datos provienen de una HiSeq 2500 con kits Nextera XT, Trimmomatic te permite definir manualmente la ruta al archivo de adaptadores (ILLUMINACLIP:NexteraPE-PE.fa) y ajustar la sensibilidad de la búsqueda. Mientras que Trim Galore intenta automatizar esto, Trimmomatic te da la seguridad de que estás eliminando exactamente las secuencias contaminantes de ese kit específico con una precisión que ha sido validada en múltiples estudios de ensamblaje y variantes.







\# DCIDI USAR TRIMOTATIC Y DECIDI QUE NO USARE  LA REPLICA TECNICA REPETIDA SINO QUE USARE SOLO 2 REPLICAS BIOLOGICAS TOCA JUSTIFICAR BIEN EL PORQUE N=2 ES SUFICIENTE EN DESEQ Y PUE ARGUMENTARLE A LA PROFE QUE NO USARE ESO PROQUE PUEDE INFLUIR QUE NO SE EUCNTRAN VARIACIONES EN LOS VALORE DE DESEWQ Y ME DARIAN FALSOS POSITIVOS ALGO ASI...

ACA ESTA EL ARGUMENTO:

Usar un $n=2$ real en lugar de un $n=3$ artificial es una necesidad metodológica porque los modelos estadísticos de DESeq2 y DEXSeq dependen de la estimación de la dispersión (la variabilidad natural entre réplicas biológicas) para determinar qué cambios en la expresión son significativos. Si duplicas una muestra para "inventar" una tercera réplica, estarías introduciendo datos con variabilidad cero, lo que colapsa el modelo estadístico al subestimar la dispersión real del experimento; esto reduce artificialmente el error estándar y genera p-valores falsamente bajos (falsos positivos). En ciencia, es preferible trabajar con el mínimo de réplicas permitiendo que el software utilice su algoritmo de shrinkage para compensar la baja cantidad de muestras, garantizando que los genes o exones identificados como diferencialmente expresados en tus bradizoítos de Toxoplasma sean biológicamente robustos y no un artefacto de una duplicación técnica que invalide la integridad de toda tu investigación.













\#AHORA SI EL TRABAJO CON EL GEMONA DE REFERNCIA.... VOY A USAR UNO MAS ACTUALZIADO A COMPARACION DEL QUE USARON EN EL ARTCIULO QUE YO ME ESTOY GUIANDO... ( AUNQUE DEBO REVISAR BIEN LA VERSION QUE ELOS USARON Y COMPARALA CON LA MIA QUE ES ESTA:):



1. https://www.ncbi.nlm.nih.gov/datasets/genome/GCF\_000006565.2/
2. Source: RefSeq
3. File types: Selecciona Genomic FASTA (.fna) y Annotation GFF3 (.gff) o GTF.



dirección del genoma ("genomic.fna.gz): https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/565/GCF\_000006565.2\_TGA4/GCF\_000006565.2\_TGA4\_genomic.fna.gz



dirección de la anotación: (genomic.gtf.gz): https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/565/GCF\_000006565.2\_TGA4/GCF\_000006565.2\_TGA4\_genomic.gtf.gz



¿Por qué hay tantos archivos parecidos?

Para que no te confundas con los demás de la lista:



Evita el .gbff.gz: Es formato GenBank, es muy pesado y los programas de mapeo no suelen leerlo.



Evita el .gff.gz: Es parecido al GTF, pero el GTF es el estándar de oro para los programas que vas a usar después (como featureCounts o DEXSeq).



Evita el \_rna.fna.gz: Esas son solo las secuencias de los transcriptos sueltos, no el genoma completo. Para mapear con STAR o HISAT2 necesitas el genoma completo (\_genomic.fna.gz).







\#!/bin/bash

\#SBATCH -p normal

\#SBATCH -N 1

\#SBATCH -n 1

\#SBATCH -t 1:00:00

\#SBATCH -o salida\_descarga\_genoma.out

\#SBATCH -e error\_descarga\_genoma.err



DIR\_ORIG=/home/bio.pt/data/marianarozor/proyecto/originalgenoma

DIR\_ARCHIV=/home/bio.pt/data/marianarozor/proyecto/archivos



wget -c -P "$DIR\_ORIG" "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/565/GCF\_000006565.2\_TGA4/GCF\_000006565.2\_TGA4\_genomic.fna.gz"



wget -c -P "$DIR\_ORIG" "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/565/GCF\_000006565.2\_TGA4/GCF\_000006565.2\_TGA4\_genomic.gtf.gz"



cp "$DIR\_ORIG/GCF\_000006565.2\_TGA4\_genomic.fna.gz" "$DIR\_ARCHIV/"



cp "$DIR\_ORIG/GCF\_000006565.2\_TGA4\_genomic.gtf.gz" "$DIR\_ARCHIV/"



echo "Termino"





nohup bash descargasfastq.sh \&

tail -f nohup.out



gunzip \*.gz



\#Analisis de expresion diferenciar

\#Usando las secuencias que ya limpie (temgo que decir la cantidad de read antes y despues de filtrar para el documento)

\# relizare la indexación del genoma, el alineamiento y mapeo



\#Codigo para todo el index\_mapeo:



nano index\_mapeo.sh

\#!/bin/bash

\#SBATCH -p dev

\#SBATCH -N 1

\#SBATCH -n 8

\#SBATCH -t 00:30:00

\#SBATCH -o salida\_index\_toxo.out

\#SBATCH -e error\_index\_toxo.err

\#SBATCH --mail-user=mariana.rozor@urosario.edu.co

\#SBATCH --mail-type=ALL



\#Ruta de donde estan los scribs de HISAT2

APP=/datacnmat01/ciencias/appsbio/conda/envs/appsb/bin



\# Creacion de archivos de sites

$APP/hisat2\_extract\_splice\_sites.py GCF\_000006565.2\_TGA4\_genomic.gtf > splicesites.tsv



\# Creacion de archivos de exones

$APP/hisat2\_extract\_exons.py GCF\_000006565.2\_TGA4\_genomic.gtf > exons.tsv



\# Creación del index

$APP/hisat2-build -p 8 --ss splicesites.tsv --exon exons.tsv GCF\_000006565.2\_TGA4\_genomic.fna GCF\_000006565.2\_TGA4\_genomic\_tran





\#FALTA CORREGIR PARA AJUSTARLO AL PROYECTO

\# Nombres de muestras

ls \*fastq.gz | sed 's/\\.read.\*//' > nombres\_archivos.txt



\# Alineamientos

for line in $(cat nombres\_archivos.txt)

do

$APP/hisat2 -p 8 -x chr22\_genome\_tran \\

\-1 $line.read1.fastq.gz \\

\-2 $line.read2.fastq.gz \\

\-S $line.sam \\

2>> resumen\_aln.txt

done



\# SAM a BAM

for line in $(cat nombres\_archivos.txt)

do

/datacnmat01/ciencias/appsbio/conda/envs/appsb/bin/samtools sort -@ 8 -o $line.bam $line.sam

rm $line.sam

done



rm -f tmp\_\*

