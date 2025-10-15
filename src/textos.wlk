import personaje.pj
import tp.configJuego

object puntuacion{
    method position() = new Position(x = 1, y = configJuego.alto() - 1)

    method text() = "Puntuacion: " + pj.puntuacion()

    method textColor() = paleta.negro()

}

object paleta{
    const property negro = "000000"
}

object nivel {
    method position() = new Position(x = 1, y = configJuego.alto() - 2)

    method text() = "Nivel: " + pj.nivel()

    method textColor() = paleta.negro()

}

object vida{
    method position() = new Position(x = configJuego.ancho() - 2, y = configJuego.alto() - 1)

    method text() = "Vida: " + pj.vida()

    method textColor() = paleta.negro()
}

object game_over {
    method position() = game.center()

    method text() = "GAME OVER"

    method textColor() = paleta.negro() 
}

object you_win {
    method position() = game.center()

    method text() = "YOU WIN"

    method textColor() = paleta.negro() 
}

object tiempo {
    var property tiempo = 0
    method position() = new Position(x = configJuego.ancho() - 2, y = configJuego.alto() - 2)

    method text() = "Tiempo: " + tiempo

    method textColor() = paleta.negro() 

    method aumentarTiempo(){
        tiempo += 1
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