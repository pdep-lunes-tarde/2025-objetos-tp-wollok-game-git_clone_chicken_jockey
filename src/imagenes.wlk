import colores.*

object logo {
    var property position = game.center().left(7).up(1)

    method image() = "logo_chico.png"
}

class Imagen_corazon {
    var property position

    var estado = lleno

    method image() = estado.image()

    method mover_izquierda(cantidad){
        position = position.left(cantidad)
    }

    method estado(nuevo_estado) {
        estado = nuevo_estado
    }
}

object lleno {
    method image() = "Corazon_16.png"
}
object vacio {
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