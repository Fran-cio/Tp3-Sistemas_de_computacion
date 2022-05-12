# Tp3-Sistemas de computacion
## UEFI y coreboot
* ¿Qué es UEFI? ¿como puedo usarlo? Mencionar además una función a la que podría llamar usando esa dinámica.

Las siglas **UEFI** vienen de Unified *Extensible Firmware Interface*. Esta interfaz especial es, por así decirlo, como un sistema operativo en miniatura que se encarga de arrancar la mainboard o placa base del ordenador y los componentes de hardware relacionados con ella.
*UEFI* suele considerarse un sucesor directo de *BIOS*. Sin embargo, la especificación UEFI no establece cómo programar un firmware totalmente, sino que se limita a describir la interfaz entre el firmware y el sistema operativo. Por este motivo, la especificación UEFI no sustituye realmente el sistema tradicional de entrada y salida, es decir, el *Basic Input/Output System* (BIOS), que es la base del bootfirmware de un ordenador.

Referencia: [UEFI: interfaz de alto rendimiento para iniciar tu ordenador](https://www.ionos.es/digitalguide/servidores/know-how/uefi-unified-extensible-firmware-interface/)

* ¿Menciona casos de bugs de UEFI que puedan ser explotados?

Los casos mas nombrados no se si son bugs de UEFI como tal pero si la afectan, se trata del error *CVE-2017-5703*, el cual afecta la funcion de *SPI* de intel. Esto permite al atacante borrar UEFI (o BIOS) del sistema. 

Referencia: 
[Bug en Intel SPI permite alterar la BIOS/UEFI](https://blog.segu-info.com.ar/2018/04/bug-en-intel-spi-permite-alterar-la.html)


* ¿Qué es Converged Security and Management Engine (CSME), the Intel
Management Engine BIOS Extension (Intel MEBx).?


* ¿Qué es coreboot ? ¿Qué productos lo incorporan ?¿Cuales son las ventajas de
su utilización?
