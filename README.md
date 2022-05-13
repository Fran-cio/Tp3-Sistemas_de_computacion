# Tp3-Sistemas de computacion
## UEFI y coreboot
### ¿Qué es UEFI? ¿como puedo usarlo? Mencionar además una función a la que podría llamar usando esa dinámica.

Las siglas **UEFI** vienen de Unified *Extensible Firmware Interface*. Esta interfaz especial es, por así decirlo, como un sistema operativo en miniatura que se encarga de arrancar la mainboard o placa base del ordenador y los componentes de hardware relacionados con ella.
*UEFI* suele considerarse un sucesor directo de *BIOS*. Sin embargo, la especificación UEFI no establece cómo programar un firmware totalmente, sino que se limita a describir la interfaz entre el firmware y el sistema operativo. Por este motivo, la especificación UEFI no sustituye realmente el sistema tradicional de entrada y salida, es decir, el *Basic Input/Output System* (BIOS), que es la base del bootfirmware de un ordenador.

Dependiendo el equipo, la forma de acceder va a variar.

Las funciones que brindan van desde hacer Recoverys, Diagnosticos de sistema, elegir dispositivos de booteo y el modo.

> Referencia: [UEFI: interfaz de alto rendimiento para iniciar tu ordenador](https://www.ionos.es/digitalguide/servidores/know-how/uefi-unified-extensible-firmware-interface/)

### ¿Menciona casos de bugs de UEFI que puedan ser explotados?

Los casos mas nombrados no se si son bugs de UEFI como tal pero si la afectan, se trata del error *CVE-2017-5703*, el cual afecta la funcion de *SPI* de intel. Esto permite al atacante borrar UEFI (o BIOS) del sistema. 

> Referencia: [Bug en Intel SPI permite alterar la BIOS/UEFI](https://blog.segu-info.com.ar/2018/04/bug-en-intel-spi-permite-alterar-la.html)


### ¿Qué es Converged Security and Management Engine (CSME), the Intel
Management Engine BIOS Extension (Intel MEBx).?

Su función principal a grosso modo es el proporcionar un entorno de ejecución aislado y protegido desde el host a modo de software que se ejecuta directamente en la CPU mediante un firmware que para esta última es totalmente transparente.

*CSME* tiene tres roles principales que se definen varias características del sistema:

- Chasis
  - Arranque seguro de la plataforma
  - Overclocking
  - Carga del microcódigo en los motores PCH y CPU HW
- seguridad
  - Ejecución aislada y confiable de los servicios de seguridad (TPM, DRM y DAL)
- Manejabilidad
  - Gestión de la plataforma en una red fuera de banda (AMT)

*Intel MEBx* se trata del predecesor de de *CSME*, este fue cambiado en 2017 a raiz de numerosos problemas de seguridad, los cuales, requieren la frabriacion del anteriormente nombrado sucesor.

> Referencia: [Intel CSME pc](https://hardzone.es/reportajes/que-es/intel-csme-pc/)
### ¿Qué es coreboot ? ¿Qué productos lo incorporan ?¿Cuales son las ventajas de su utilización?
A lo largo de los anios, ha habido una tendencia a mover todos los elementos de la computadora a software libre, esta es la iniciativa de Coreboot.
Mas que tecnica, su creacion responde a una necesidad etica anteriormente nombrada, y posee el apoyo de diversas empresas y corporaciones, entre ellos, la FSF, AMD, tambien fabricantes coom Gigabyte, MSI y ademas es patrocinado por Google, ni mas ni menos.

Esta es cargar casi cualquier sistema operativo, y tiene la caracteristica de ser tremendamente eficiente, ya que luego de 16 comandos, el equipo ya entra en modo de 32 bits, haciendolo aun mas rapido.

> Referencia:  [Coreboot](https://es.wikipedia.org/wiki/Coreboot)


---

## Desafío: Linker
### ¿Que es un linker? ¿que hace?
A grandes rasgos, el linker es el programa encargado de tomar todos los archivos *objeto* (.o) generados por el **compilador** (o ya presentes en una biblioteca), combinarlos y crear un *ejecutable*.

La mayoría de las veces se utilizan diversos archivos a la hora de crear un programa. Esto es lo mismo que decir que un programa de ordenador está compuesto por diferentes **módulos**. Cada uno de estos módulos se compila de forma independiente y dispone de una referencia simbólica. Así pues, una vez compilados, el linker podrá crear un "único" archivo, unificando todos los archivos objeto gracias a sus referencias simbólicas.

> Referencia: [¿Que es un linker?](https://ia-notes.com/2021/05/24/que-es-el-linker/)

### ¿Que es la dirección que aparece en el script del linker?¿Porqué es necesaria? 
Es donde la BIOS va a estar colocando el codigo fuente de ese ejecutable. Tengo entendido que el linker calcula la direccion donde colocarla, y esa resulta ser la primera posicion donde colocar el programa para que sea lo primero en ejecutarse << **CHEQUEAR** >>

### Compare la salida de objdump con hd, verifique donde fue colocado el programa dentro de la imagen. << **EN LA PC LO HAGO** >>

### Grabar la imagen en un pendrive y probarla en una pc y subir una foto << **EN LA PC LO HAGO** >>

### ¿Para que se utiliza la opción --oformat binary en el linker?
> *--oformat=output-format*
> 
> *ld* may be configured to support more than one kind of object file. **If your *ld* is configured this way, you can use the --oformat option to specify the binary format for the output object file.** Even when *ld* is configured to support alternative object formats, you don't usually need to specify this, as *ld* should be configured to produce as a default output format the most usual format on each machine. output-format is a text string, the name of a particular format supported by the BFD libraries. (You can list the available binary formats with objdump -i.) The script command "OUTPUT_FORMAT" can also specify the output format, but this option overrides it.

Es decir, es posible especificar el formato de salida del archivo, en particular, a binario. 

---
## Desafío final: Modo protegido (Parte practica)
### Crear un código assembler que pueda pasar a modo protegido (sin macros).

### ¿Cómo sería un programa que tenga dos descriptores de memoria diferentes, uno para cada segmento (código y datos) en espacios de memoria diferenciados?

### Cambiar los bits de acceso del segmento de datos para que sea de solo lectura, intentar escribir, ¿Que sucede? ¿Que debería suceder a continuación? (revisar el teórico) Verificarlo con gdb.

### En modo protegido, ¿Con qué valor se cargan los registros de segmento? ¿Porque? 
