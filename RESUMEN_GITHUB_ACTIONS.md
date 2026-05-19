# Resumen: GitHub Actions para NotesMP3Tweak

## Estado actual
- Workflow creado y corregido: `.github/workflows/build.yml`
- El workflow compila el tweak en macOS-latest usando Theos
- Genera un archivo `.deb` y lo sube como artefacto (sin requerir secretos para descarga)

## Cómo usarlo
1. Asegúrate de haber aplicado el parche o tener los cambios en tu rama:
   ```sh
   git apply workflow_fix.patch   # si lo descargaste
   git add .github/workflows/build.yml
   git commit -m "fix workflow: ensure make package runs in NotesMP3Tweak directory"
   git push origin main
   ```

2. Ejecuta el workflow en GitHub:
   - Ve a tu repo → pestaña **Actions**
   - Selecciona "Build and (optional) Deploy NotesMP3Tweak"
   - Haz clic en **Run workflow**

3. Descarga el resultado:
   - Cuando finalice, entra en la ejecución
   - En "Artifacts", descarga `notesmp3tweak-deb`
   - Este contiene el archivo `.deb` listo para instalar

4. Instala en tu iPhone (jailbreak con Dopamine):
   - Transfiere el `.deb` a tu iPhone (correo, iCloud, etc.)
   - Ábrelo con Sileo, Zebra o tu gestor de paquetes
   - Instala y parece automáticamente la app Notas (`killall -9 Notes` en el Makefile)

## Próximos pasos de ajuste (opcional)
Si necesitas cambiar colores, tamaños o textos:
- Edita `Tweak.xm` directamente o indícame los valores exactos:
  - Color del botón play (actualmente: `UIColor colorWithRed:1.0 green:0.2 blue:0.5 alpha:1.0`)
  - Tamaño del botón (actualmente: 52 puntos)
  - Texto del subtítulo (actualmente: @"Audio Recording")
  - Color de fondo (actualmente: `[UIColor colorWithWhite:0.15 alpha:1.0]`)
  - Radio de esquina (actualmente: 16.0)

Para hacerlo más robusto frente a actualizaciones de iOS:
- Ejecuta en tu iPhone: `class-dump Notes > /tmp/notes_dump.txt`
- Comparte las líneas relevantes (buscando "MP3", "audio", "recording", etc.)
- Con esas reemplazaré la heurística actual por hooks directos a clases específicas

## Notas importantes
- El tweak actual usa una heurística: busca cualquier `UILabel` que contenga ".mp3" para aplicar el estilo
- Esto funciona en iOS 16.3 pero podría requerir ajuste si cambia la UI de Notas en futuras versiones
- Para usar el despliegue automático vía SSH en el workflow, necesitarías configurar secretos:
  - `DEVICE_SSH_HOST`: IP de tu iPhone
  - `DEVICE_SSH_USER`: normalmente `root` o `mobile`
  - `DEVICE_SSH_KEY`: tu clave privada SSH
  - `DEVICE_SSH_PORT`: normalmente 22
  Pero esto es opcional; descargar el artefacto e instalar manualmente es igual de válido.