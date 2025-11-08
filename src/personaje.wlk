import textos.*
import tp.configurar_juego
import objetos.*

object pj {
    var property position = game.center()
    var property vida = 3
    var property puntuacion_actual = 0
    var property puntuacion_total = 0 
    var property danio = 1
    var property nivel = 0
    var property enemigos_asesinados = 0
    var property invulnerable = false
    var atacando = false
    var property ultima_posicion = position
    const cofres = []
    const escudos = []
    const objetos_especiales = []

    var property image = "Soldado_idle.png"

    method movete_a(nueva_direccion){
        const posicion_candidata = nueva_direccion.siguientePosicion(position)

        if (self.es_movimiento_valido(posicion_candidata)) {
            ultima_posicion = position
            position = posicion_candidata
            objetos_especiales.forEach({ objeto => objeto.efecto_por_movimiento() })
        }
    }

    method es_movimiento_valido(posicion_candidata) = (self.esta_en_rango_del_tablero(posicion_candidata)) &&
                                                      (game.getObjectsIn(posicion_candidata).isEmpty() || !game.getObjectsIn(posicion_candidata).first().debo_retroceder()) 

    method esta_en_rango_del_tablero(posicion_candidata) =  (posicion_candidata.x() >= 0) &&
                                                            (posicion_candidata.x() < configurar_juego.ancho()) &&
                                                            (posicion_candidata.y() >= 0) &&
                                                            (posicion_candidata.y() < configurar_juego.alto())

    method centrate() {
        position = game.center()
        image = "Soldado_idle.png"
    }

    method animacion_ataque(direccion) {
        const duracion_total = 500
        const duracion_frame = duracion_total.div(4)
        atacando = true
        game.schedule(duracion_total, { atacando = false })

        game.schedule(0, { image = "Soldado_ataque_0.png" })

        if (direccion != null) {
            const pos = direccion.siguientePosicion(position)
            const imagen0 = "Soldado_efecto_ataque_" + direccion.nombre() + "_0.png"
            const imagen1 = "Soldado_efecto_ataque_" + direccion.nombre() + "_1.png"

            game.schedule(duracion_frame, {
                const efecto0 = new Imagen_efecto_ataque(position = pos, image = imagen0)
                efecto0.aparece()
                game.schedule(duracion_frame, { game.removeVisual(efecto0) })
            })

            game.schedule(duracion_frame * 2, {
                const efecto1 = new Imagen_efecto_ataque(position = pos, image = imagen1)
                efecto1.aparece()
                game.schedule(duracion_frame, { game.removeVisual(efecto1) })
            })
        }

        game.schedule(duracion_frame * 3, { image = "Soldado_ataque_3.png" })
        game.schedule(duracion_frame * 4, { image = "Soldado_idle.png" })
    }

    method posicion_menu() {
        self.centrate()
        position = position.left(9)
    }

    method atacar_a(direccion){
        const poscicion_a_atacar = direccion.siguientePosicion(position)

        const lista_enemigo = game.getObjectsIn(poscicion_a_atacar)
        if(!lista_enemigo.isEmpty())
            lista_enemigo.first().fuiste_atacado(self, direccion.siguientePosicion(poscicion_a_atacar))
        if (!atacando)
            self.animacion_ataque(direccion)
    }
    
    method sumar_puntuacion(puntos_a_sumar) {
        puntuacion_actual += puntos_a_sumar
        puntuacion_total += puntos_a_sumar
        if (puntuacion_actual >= 5)
            self.subir_nivel()
        if (nivel >= 3)
            configurar_juego.gane()
    }

    method cofres() = cofres

    method subir_nivel() {
        const cofre = new Cofre()
        configurar_juego.aparecer_cofre(cofre)
        cofres.add(cofre)
    }

    method mataste_un_ogro() {
        configurar_juego.agregar_objeto_aleatorio()
        self.sumar_puntuacion(1)
        configurar_juego.reducir_cantidad_enemigos()
        enemigos_asesinados += 1
    }

    method fuiste_atacado(enemigo) {
        if (escudos == [] && vida > 0) {
            vida -= enemigo.danio()
            barra_de_vida.restar_vida()

            if (vida <= 0)
                self.moriste()

            self.animacion_fuiste_atacado()
        }

        self.eliminar_escudo()
    }

    method moriste() {
        const duracion_total = 1000
        const duracion_frame = duracion_total.div(3)
        
        game.schedule(duracion_frame, { image = "Soldado_muerte_0.png" })
        game.schedule(duracion_frame * 2, { image = "Soldado_muerte_1.png" })
        game.schedule(duracion_frame * 3, { image = "Soldado_muerte_2.png" })
        game.schedule(duracion_frame * 4, {configurar_juego.perdi()})     
    }

    method animacion_fuiste_atacado() {
        const duracion_total = 500
        const duracion_frame = duracion_total.div(2)

        game.schedule(0, { image = "Soldado_lastimado_0.png" })
        game.schedule(duracion_frame, { image = "Soldado_lastimado_1.png" })
        game.schedule(duracion_frame * 2, { image = "Soldado_idle.png" })
    }
    
    method recibir_vida() {
        if (vida < 3) {
            vida += 1
            barra_de_vida.sumar_vida()
        }
    }

    method aumentar_danio() {
        danio += 1
    }

    method dar_escudo() {
        const escudo = new Escudo()

        escudo.position(new Position(x = configurar_juego.ancho() - 5 + escudos.size(), y = configurar_juego.alto() - 1))
        escudos.add(escudo)
        configurar_juego.mostrar_objeto(escudo)
    }

    method eliminar_escudo() {
        if (!escudos.isEmpty()) {
            game.removeVisual(escudos.last())
            escudos.remove(escudos.last())
        }
    }

    method agregar_objeto_especial(objeto) {
        objeto.efecto_unico()
        objetos_especiales.add(objeto)
    }

    method reiniciate() {
        vida = 3
        puntuacion_actual = 0
        puntuacion_total = 0
        enemigos_asesinados = 0
        danio = 1
        nivel = 0
        self.centrate()
        atacando = false
        image = "Soldado_idle.png"
        cofres.clear()
        objetos_especiales.clear()
        escudos.clear()
    }

    method debo_retroceder() = false

    method retrocede(otro) {
        position = ultima_posicion
    }
}

object barra_de_vida {
    var property corazones = [new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 2, y = configurar_juego.alto() - 1)),
                              new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 1)),
                              new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 4, y = configurar_juego.alto() - 1))]
    var property corazones_vacios = [new Imagen_corazon_vacio (position = new Position(x = configurar_juego.ancho() - 2, y = configurar_juego.alto() - 1)),
                                     new Imagen_corazon_vacio (position = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 1)),
                                     new Imagen_corazon_vacio (position = new Position(x = configurar_juego.ancho() - 4, y = configurar_juego.alto() - 1))]

    method restar_vida() {
        game.removeVisual(corazones.last())
        corazones.remove(corazones.last())
    }

    method sumar_vida() {      
        const nuevo_corazon = new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 2 - corazones.size(), y = configurar_juego.alto() - 1))
        configurar_juego.mostrar_objeto(nuevo_corazon)
        corazones.add(nuevo_corazon)
    }

    method reiniciate() {
        corazones = [new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 2, y = configurar_juego.alto() - 1)),
                     new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 1)),
                     new Imagen_corazon (position = new Position(x = configurar_juego.ancho() - 4, y = configurar_juego.alto() - 1))]
    }
}

class Imagen_efecto_ataque {
    var property position
    var property image

    method aparece() {
        game.addVisual(self)
    }

    method debo_retroceder() = false

    method chocaste_con_pj() {}

    method fuiste_atacado(a, b) {}
}