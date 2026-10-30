extends Node3D

# UNIVERSIDAD DE ORIENTE (UNIVO) - CIUDAD UNIVERSITARIA
# Prototipo 3D Avanzado con Nodos CSG

var player: CharacterBody3D
var camera: Camera3D
var mouse_sensitivity := 0.002
var camera_pitch := -0.15

func _ready():
	print("Iniciando carga mejorada de Ciudad Universitaria UNIVO...")
	
	# 1. Crear el entorno (Luz y Cielo)
	crear_entorno()
	
	# 2. Construir la universidad (Terreno, Edificios, Aceras y Vegetación)
	construir_campus_univo()
	
	# 3. Crear el jugador
	crear_jugador()
	
	# 4. Crear interfaz visual (HUD)
	crear_hud()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print("¡Bienvenidos a la UNIVO!")

# ==========================================
# ENTORNO E ILUMINACIÓN
# ==========================================
func crear_entorno():
	var luz = DirectionalLight3D.new()
	luz.name = "Sol_SanMiguel"
	luz.rotation_degrees = Vector3(-55, -35, 0)
	luz.light_energy = 1.3
	luz.shadow_enabled = true
	add_child(luz)

	var entorno = WorldEnvironment.new()
	var ambiente = Environment.new()
	ambiente.background_mode = Environment.BG_COLOR
	ambiente.background_color = Color(0.45, 0.75, 0.95) # Cielo más vivo
	ambiente.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	ambiente.ambient_light_color = Color(0.9, 0.9, 0.9)
	ambiente.ambient_light_energy = 0.7
	entorno.environment = ambiente
	add_child(entorno)

# ==========================================
# CONSTRUCCIÓN DEL CAMPUS UNIVO
# ==========================================
func construir_campus_univo():
	var mapa = Node3D.new()
	mapa.name = "Campus_Ciudad_Universitaria"
	add_child(mapa)

	# TERRENO PRINCIPAL (Grama verde)
	var terreno = CSGBox3D.new()
	terreno.name = "Terreno"
	terreno.size = Vector3(180, 1, 180)
	terreno.position = Vector3(0, -0.5, 0)
	terreno.use_collision = true
	terreno.material_override = crear_material(Color(0.2, 0.55, 0.25)) 
	mapa.add_child(terreno)

	# PLAZA CENTRAL Y PARQUEO (Asfalto/Concreto)
	var plaza = CSGBox3D.new()
	plaza.name = "Plaza_Central"
	plaza.size = Vector3(45, 1.02, 90)
	plaza.position = Vector3(0, -0.48, 10)
	plaza.use_collision = true
	plaza.material_override = crear_material(Color(0.35, 0.35, 0.35))
	mapa.add_child(plaza)

	# ACERAS / PASARELAS PEATONALES
	crear_edificio_csg(mapa, izquierda_o_acera("Acera_Oeste"), Vector3(-24, -0.4, 10), Vector3(3, 0.05, 90), Color(0.75, 0.75, 0.75))
	crear_edificio_csg(mapa, izquierda_o_acera("Acera_Este"), Vector3(24, -0.4, 10), Vector3(3, 0.05, 90), Color(0.75, 0.75, 0.75))

	# EDIFICIO ADMINISTRATIVO (Frente a la plaza central)
	crear_edificio_csg(mapa, "Edificio_Administrativo", Vector3(0, 4, -45), Vector3(34, 8, 16), Color(0.92, 0.92, 0.92))
	
	# PABELLÓN DE AULAS A (Derecha)
	crear_edificio_csg(mapa, "Aulas_A", Vector3(40, 6, -10), Vector3(16, 12, 45), Color(0.85, 0.85, 0.8))
	
	# PABELLÓN DE AULAS B (Izquierda)
	crear_edificio_csg(mapa, "Aulas_B", Vector3(-40, 6, -10), Vector3(16, 12, 45), Color(0.85, 0.85, 0.8))

	# EDIFICIO BIBLIOTECA (Color ladrillo característico)
	crear_edificio_csg(mapa, "Biblioteca", Vector3(-40, 5, 45), Vector3(26, 10, 22), Color(0.68, 0.28, 0.18)) 

	# JARDINERÍA / ÁRBOLES SIMULADOS ALREDEDOR
	for i in range(-3, 4):
		crear_arbol(mapa, Vector3(28, 0, i * 20))
		crear_arbol(mapa, Vector3(-28, 0, i * 20))

# Función auxiliar para nombres de aceras
func izquierda_o_acera(nombre: String) -> String:
	return nombre

# Función para esculpir edificios rápidamente
func crear_edificio_csg(padre: Node, nombre: String, pos: Vector3, tamano: Vector3, color: Color):
	var edificio = CSGBox3D.new()
	edificio.name = nombre
	edificio.size = tamano
	edificio.position = pos
	edificio.use_collision = true
	edificio.material_override = crear_material(color)
	padre.add_child(edificio)

# Crear árboles sencillos usando CSG (Tronco + Follaje)
func crear_arbol(padre: Node, pos: Vector3):
	var arbol_nodo = Node3D.new()
	arbol_nodo.position = pos
	padre.add_child(arbol_nodo)

	var tronco = CSGCylinder3D.new()
	tronco.radius = 0.4
	tronco.height = 3.0
	tronco.position = Vector3(0, 1.5, 0)
	tronco.use_collision = true
	tronco.material_override = crear_material(Color(0.45, 0.3, 0.15))
	arbol_nodo.add_child(tronco)

	var hojas = CSGSphere3D.new()
	hojas.radius = 1.8
	hojas.position = Vector3(0, 3.5, 0)
	hojas.use_collision = true
	hojas.material_override = crear_material(Color(0.15, 0.45, 0.2))
	arbol_nodo.add_child(hojas)

# Función para asignar materiales
func crear_material(color: Color) -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.85
	return mat

# ==========================================
# INTERFAZ DE USUARIO (HUD)
# ==========================================
func crear_hud():
	var canvas = CanvasLayer.new()
	canvas.name = "HUD"
	add_child(canvas)

	var label = Label.new()
	label.text = "UNIVERSIDAD DE ORIENTE (UNIVO) - Campus 3D\n[W, A, S, D]: Moverse | [ESPACIO]: Saltar | [MOUSE]: Explorar | [ESC]: Liberar Cursor"
	label.offset_left = 25
	label.offset_top = 25
	
	# Estilo básico para que resalte en pantalla
	label.add_theme_color_override("font_color", Color(1, 1, 1))
	label.add_theme_font_size_override("font_size", 16)
	canvas.add_child(label)

# ==========================================
# JUGADOR Y CONTROLES
# ==========================================
func crear_jugador():
	player = CharacterBody3D.new()
	player.name = "Estudiante"
	player.position = Vector3(0, 2, 45) # Aparece en la entrada principal
	add_child(player)

	var forma = CapsuleShape3D.new()
	forma.radius = 0.4
	forma.height = 1.7
	var colision = CollisionShape3D.new()
	colision.shape = forma
	player.add_child(colision)

	camera = Camera3D.new()
	camera.position = Vector3(0, 0.6, 0)
	camera.fov = 75
	player.add_child(camera)
	camera.make_current()

func _unhandled_input(event):
	if player == null or camera == null: return
	
	# Rotar cámara con el ratón
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		player.rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pitch -= event.relative.y * mouse_sensitivity
		camera_pitch = clamp(camera_pitch, -1.4, 1.4)
		camera.rotation.x = camera_pitch

	# Liberar el ratón con la tecla ESC
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Capturar el ratón al hacer clic en la ventana
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if player == null: return

	var direccion := Vector2.ZERO
	if Input.is_key_pressed(KEY_W): direccion.y -= 1
	if Input.is_key_pressed(KEY_S): direccion.y += 1
	if Input.is_key_pressed(KEY_A): direccion.x -= 1
	if Input.is_key_pressed(KEY_D): direccion.x += 1

	var movimiento = (player.transform.basis * Vector3(direccion.x, 0, direccion.y)).normalized()
	var velocidad := 7.0

	player.velocity.x = movimiento.x * velocidad
	player.velocity.z = movimiento.z * velocidad

	# Gravedad
	if not player.is_on_floor():
		player.velocity.y -= 20.0 * delta
	else:
		player.velocity.y = 0

	# Salto
	if Input.is_key_pressed(KEY_SPACE) and player.is_on_floor():
		player.velocity.y = 7.0

	player.move_and_slide()
