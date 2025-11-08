# proyecto_conde_ceramicas

## Descipcion

Sistema de gestión integral para talleres cerámicos que permite administrar inventario de materiales (esmaltes, arcillas, materias primas), gestionar recetas de producción, planificar hornadas y generar reportes de stock. Desarrollado en Flutter para facilitar el control operativo diario de Conde Cerámica.

## 🚀 Instalación

### Requisitos
- Flutter SDK (3.0 o superior)
- Android Studio / VS Code
- Dart SDK

### Pasos

1. **Clonar el repositorio**
[git clone ](https://github.com/RenatoIzq/proyecto_conde_ceramicas.git)

2. **Instalar dependencias**
´flutter pub get´

3. **Ejecutar la aplicación**
´flutter run´ o a traves del ./lib/main.dart

4. **En caso de fallo**
En caso de fallo utilizar ´flutter clean´ y e instalar dependencias nuevamente

## 🎨 Decisiones de Diseño

### Organización del código
El proyecto está dividido en carpetas claras: páginas principales, modelos de datos, ventanas emergentes y componentes reutilizables. Esto facilita encontrar y modificar cualquier parte de la aplicación.

### Ventanas emergentes para acciones
En lugar de cambiar de pantalla para cada acción (agregar, editar, ver detalles), usamos ventanas emergentes. Esto hace que la navegación sea más rápida y el usuario no pierda el contexto de dónde estaba.

### Botones y barras de búsqueda reutilizables
Se crearon componentes que se usan en varias páginas (como botones de acción y barras de búsqueda). Esto ahorra tiempo de desarrollo y garantiza que todo se vea igual en toda la app.

### Estados claros con colores
El inventario usa colores para mostrar el estado del stock: verde para disponible, amarillo para bajo, y rojo para agotado. Esto permite identificar problemas de un vistazo.

### Tablas con scroll independiente
Solo las tablas tienen scroll, no toda la página. Esto mejora la experiencia porque los títulos y filtros permanecen visibles mientras navegas por los datos.

### Reportes automáticos
Los reportes se generan automáticamente revisando el inventario actual. No hay que calcular manualmente qué materiales están bajos de stock.

### Calendario visual para hornadas
El calendario muestra las hornadas planificadas con colores según su proposito, facilitando ver de forma rápida la programación de producción.

## 📁 Estructura de Proyecto

```
proyecto_conde_ceramicas/
├── lib/
│   ├── main.dart
│   ├── pages/
│   │   ├── bienvenida_page.dart
│   │   ├── inventario_page.dart
│   │   ├── recetas_page.dart
│   │   ├── hornadas_page.dart
│   │   └── reporte_page.dart
│   ├── model/
│   │   ├── inventario_model.dart
│   │   ├── receta_model.dart
│   │   └── hornada_model.dart
│   ├── dialogs/
│   │   ├── inventario_add_dialog.dart
│   │   ├── inventario_edit_dialog.dart
│   │   ├── inventario_detail_dialog.dart
│   │   ├── receta_add_dialog.dart
│   │   ├── receta_edit_dialog.dart
│   │   ├── receta_detail_dialog.dart
│   │   ├── generic_delete_dialog.dart
│   │   ├── delete_dialog.dart
│   │   └── hornada_add_dialog.dart
│   ├── components/
│   │   ├── action_button.dart
│   │   ├── search_filter_bar.dart
│   │   └── report_section.dart
│   └── themes/
│       └── themes.dart
├── images/
│   ├── CONDECERAMICA_Mesa de trabajo 1
│   ├── condeceramicalogo
│   └── CONDECERAMICA-02.png
├── pubspec.yaml
└── README.md
```

## 👤 Autor

Hecho por Renato Izquierdo Conde
Proyecto de gestión para Conde Cerámica