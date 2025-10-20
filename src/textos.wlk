import personaje.*
import tp.configurar_juego

object puntuacion {
    method position() = new Position(x = 2, y = configurar_juego.alto() - 1)

    method text() = "Puntuacion: " + pj.puntuacion()

    method textColor() = paleta.negro()
}

object paleta {
    var property negro = "000000"
}

object nivel {
    method position() = new Position(x = 2, y = configurar_juego.alto() - 2)

    method text() = "Nivel: " + pj.nivel()

    method textColor() = paleta.negro()

}

object vida {
    method position() = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 1)

    method text() = "Vida: " + pj.vida()

    method textColor() = paleta.negro()
}

object game_over {
    method position() = game.center()

    method text() = "GAME OVER\nPRESIONA 'R' PARA REINICIAR"

    method textColor() = paleta.negro() 
}

object you_win {
    method position() = game.center()

    method text() = "YOU WIN"

    method textColor() = paleta.negro()
}

object tiempo {
    var property tiempo = 0

    method position() = new Position(x = configurar_juego.ancho() - 3, y = configurar_juego.alto() - 2)

    method text() = "Tiempo: " + tiempo

    method textColor() = paleta.negro()

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

    method textColor() = paleta.negro()
}

object texto_menu {
    method position() = game.center()

    method text() = "Empezar juego: 'ENTER'\nControles: 'C'\nFacilidad: 'F'"

    method textColor() = paleta.negro() 
}

object volver_atras {
    method position() = new Position(x = 2, y = 1)

    method text() = "Back: 'B'"

    method textColor() = paleta.negro()
}

object texto_estadisticas {
    method position() = game.center().down(5)

    method text() = "Enemigos asesinados: " + pj.enemigos_asesinados() + "\nNivel alcanzado: " + pj.nivel() + "\nTiempo sobrevivido: " + tiempo.tiempo() + "\n\nPuntuacion final: " + (pj.puntuacion() + pj.nivel() * 3)

    method textColor() = paleta.negro()
}

object texto_facilidad {
    method position() = game.center()

    method text() = "Facil: 'F'\nMedia: 'M'\nDificil: 'D'"

    method textColor() = paleta.negro()
}

object texto_subida_de_nivel{
    method position() = game.center()

    method text() = "SUBISTE DE NIVEL! \n\nElegi una estadistica \n\nDanio: D \n Vida: V \n Velocidad: S "

    method textColor() = paleta.negro() 
}

object marcador_facilidad {
    var property facilidad = 6
    const posicion_inicial = game.center().left(6).down(2)
    var property position = posicion_inicial.up(facilidad / 2)

    method text() = "Seleccionada -->"

    method textColor() = paleta.negro()

    method actualizar(nueva_facilidad){
        self.facilidad(nueva_facilidad / 2)
        position = posicion_inicial
        position = self.position().up(facilidad)
    }
}

/*object imagen_subida_de_nivel {
    const property position = new Position(x=0, y=0)

    method image() = "Fondo_subida_de_nivel.jpg"
}*/

class Imagen_corazon{
    var property position

    method image() = "Corazon_16.png"
}

class Imagen_corazon_vacio{
    var property position

    method image() = "Corazon_vacio_16.png"
}
class Vida_enemigos{
    const property enemigo
    var property position = enemigo.position().up(1)

    method text() = "Vida: " + enemigo.vida()

    method textColor() = paleta.negro()

    method mover_con_enemigo() {
        position = enemigo.position().up(1)

        if (enemigo.vida() <= 0) {
            game.removeVisual(self)
        }
    }
    method chocaste_con_pj() {
      
    }
    method fuiste_atacado(x,y){

    }
}