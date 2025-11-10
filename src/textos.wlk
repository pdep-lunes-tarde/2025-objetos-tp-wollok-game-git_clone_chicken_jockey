import personaje.*
import tp.configurar_juego
import colores.*

class Texto {
    method position() = game.center()

    method text()

    method textColor() = negro.color()

    method debo_retroceder() = false

    method chocaste_con_pj() {}
}

object puntuacion {
    method position() = new Position(x = 3, y = configurar_juego.alto() - 1)

    method text() = "Puntuación: " + pj.puntuacion_actual()

    method textColor() = negro.color()
}

object nivel {
    method position() = new Position(x = 3, y = configurar_juego.alto() - 2)

    method text() = "Nivel: " + pj.nivel()

    method textColor() = negro.color()
}

object vida {
    method position() = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 1)

    method text() = "Vida: " + pj.vida()

    method textColor() = negro.color()
}

object game_over {
    method position() = game.center()

    method text() = "GAME OVER\nPRESIONA 'R' PARA REINICIAR"

    method textColor() = negro.color()
}

object you_win {
    method position() = game.center().up(2)

    method text() = "YOU WIN\n\nPRESIONA 'R' PARA REINICIAR"

    method textColor() = negro.color()
}

object tiempo {
    var property tiempo = 0

    method position() = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 2)

    method text() = "Tiempo: " + tiempo

    method textColor() = negro.color()

    method aumentarTiempo() {
        tiempo += 1
    }

    method reiniciate() {
        tiempo = 0
    }
}

object controles {
    method position() = game.center()

    method text() = "Movimiento: Flechas\nAtaque: WASD"

    method textColor() = negro.color()
}

object texto_menu {
    method position() = game.center()

    method text() = "Empezar juego: 'ENTER'\n\nControles: 'C'\n\nFacilidad: 'F'"

    method textColor() = negro.color()
}

object volver_atras {
    method position() = new Position(x = 2, y = 1)

    method text() = "Back: 'B'"

    method textColor() = negro.color()
}

object texto_estadisticas {
    method position() = game.center().down(5)

    method text() = "Enemigos asesinados: " + pj.enemigos_asesinados() + "\nNivel alcanzado: " + pj.nivel() + "\nTiempo sobrevivido: " + tiempo.tiempo() + "\n\nPuntuacion final: " + pj.puntuacion_total()

    method textColor() = negro.color()
}

object texto_facilidad {
    method position() = game.center()

    method text() = "Fácil: 'F'\nMedia: 'M'\nDifícil: 'D'"

    method textColor() = negro.color()
}

object texto_subida_de_nivel {
    method position() = game.center().up(5)

    method text() = "SUBISTE DE NIVEL!\n\nElegí un objeto..."

    method textColor() = negro.color()
}

object text_seleccion_objetos {
    method position() = game.center().left(4)

    method text() = "Presiona '0' para -> \n\nPresiona '1' para -> \n\nPresiona '2' para -> "

    method textColor() = negro.color()
}

object marcador_facilidad {
    var property facilidad = 6
    const posicion_inicial = game.center().left(6).down(2)
    var property position = posicion_inicial.up(facilidad / 2)

    method text() = "Seleccionada --> "

    method textColor() = negro.color()

    method actualizar(nueva_facilidad) {
        self.facilidad(nueva_facilidad / 2)
        position = posicion_inicial
        position = self.position().up(facilidad)
    }
}

class Imagen_corazon {
    var property position

    method image() = "Corazon_16.png"
}

class Imagen_corazon_vacio {
    var property position

    method image() = "Corazon_vacio_16.png"
}
class Vida_enemigos {
    var property color = negro.color()
    const property enemigo
    var property position = enemigo.position().up(1)

    method text() = "Vida: " + enemigo.vida()

    method textColor() = color

    method mover_con_enemigo() {
        position = enemigo.position().up(1)

        if (enemigo.vida() <= 0)
            game.removeVisual(self)
    }

    method chocaste_con_pj() {}

    method fuiste_atacado(x, y) {}
    
    method debo_retroceder() = false
}