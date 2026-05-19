NotesMP3Tweak
=================

Plantilla mínima para portar el estilo de UI de MP3 en Notas a iOS 16.3.

Compilar en iPhone (requiere Theos instalado en el iPhone):

1. Instala Theos en el iPhone (por ejemplo via APT, kitl, o guías de Theos on-device).
2. Copia la carpeta del proyecto al iPhone, por ejemplo `/var/root/NotesMP3Tweak`.
3. En el iPhone, abre una terminal y ve a la carpeta del proyecto.

Comandos:
```sh
cd /var/root/NotesMP3Tweak
make package install
```

Esto construirá e instalará el paquete y reiniciará la app Notes.

Notas:
- El código aplica heurísticas (busca labels con ".mp3" y modifica la celda). Puede necesitar ajustes según clases internas de Notas.
- Si quieres, puedo adaptar el hook a clases específicas si compartes logs de `class-dump` o `cycript` desde tu dispositivo.
