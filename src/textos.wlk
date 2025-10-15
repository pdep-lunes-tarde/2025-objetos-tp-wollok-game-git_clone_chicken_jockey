import personaje.*
import tp.configJuego

object puntuacion{
    method position() = new Position(x = 2, y = configJuego.alto() - 1)

    method text() = "Puntuacion: " + pj.puntuacion()

    method textColor() = paleta.negro()

}

object paleta{
    const property negro = "000000"
}

object nivel {
    method position() = new Position(x = 2, y = configJuego.alto() - 2)

    method text() = "Nivel: " + pj.nivel()

    method textColor() = paleta.negro()

}

object vida{
    method position() = new Position(x = configJuego.ancho() - 3, y = configJuego.alto() - 1)

    method text() = "Vida: " + pj.vida()

    method textColor() = paleta.negro()
}

object game_over {
    method position() = game.center()

    method text() = "GAME OVER \n PRESIONA R PARA REINCIAR"

    method textColor() = paleta.negro() 
}

object you_win {
    method position() = game.center()

    method text() = "YOU WIN"

    method textColor() = paleta.negro() 
}

object tiempo {
    var property tiempo = 0
    method position() = new Position(x = configJuego.ancho() - 3, y = configJuego.alto() - 2)

    method text() = "Tiempo: " + tiempo

    method textColor() = paleta.negro() 

    method aumentarTiempo(){
        tiempo += 1
    }

    method reiniciate() {
        tiempo = 0
    }
}

object controles{
    method position() = game.center()

    method text() = "Movimiento: Flechas \nAtaque: WASD "

    method textColor() = paleta.negro() 
}

object texto_menu{
    method position() = game.center()

    method text() = "Empezar juego: ENTER \nControles: C \n Facilidad: F "

    method textColor() = paleta.negro() 
}

object volver_atras{
    method position() = new Position(x = 2, y = 1)

    method text() = "Back: B "

    method textColor() = paleta.negro() 
}

object texto_estadisticas{
    method position() = game.center().down(5)

    method text() = "Enemigos asesinados:  " + pj.enemigos_asesinados() + "\nNivel alcanzado: " + pj.nivel() + "\nTiempo sobrevivido: " + tiempo.tiempo() + "\n\nPuntuacion final: " + (pj.puntuacion() + pj.nivel() * 3)

    method textColor() = paleta.negro() 
}

object texto_facilidad{
    method position() = game.center()

    method text() = "Facil: F \nMedia: M \nDificil: D "

    method textColor() = paleta.negro() 
}

object marcador_facilidad{
    var property facilidad = 6
    const property posicion_inicial = game.center().left(6).down(2)
    var property position = posicion_inicial.up(facilidad/2)

    method text() = "Seleccionada --> "

    method textColor() = paleta.negro() 

    method actualizar(nueva_facilidad){
        self.facilidad(nueva_facilidad / 2)
        position = posicion_inicial
        position = self.position().up(facilidad)
    }
}
class Vida_enemigos{
    const property enemigo
    var property position = enemigo.position().up(1)

    method text() = "Vida: " + enemigo.vida()

    method textColor() = paleta.negro() 

    method mover_con_enemigo(nueva_posicion){
        position = nueva_posicion
        if(enemigo.vida() <= 0){
                game.removeVisual(self)
        }
    }
}