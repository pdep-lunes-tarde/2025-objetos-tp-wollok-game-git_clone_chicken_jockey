import personaje.pj

class Corazon {
    var property position = game.center()
    
    method image() = "Corazon_16.png"

    method aparecer() {
        const x = 0.randomUpTo(game.width()).truncate(0)
        const y = 0.randomUpTo(game.height()).truncate(0)
        position = game.at(x, y)

        game.addVisual(self)
    }

    method chocaste_con_pj() {
        pj.recibir_vida()
        game.removeVisual(self)
    }

    method debo_retroceder() {
        return false
    }
}

class Moneda {
    var property position = game.center()
    
    method image() = "coin_16.png"

    method aparecer() {
        const x = 0.randomUpTo(game.width()).truncate(0)
        const y = 0.randomUpTo(game.height()).truncate(0)
        position = game.at(x,y)

        game.addVisual(self)
    }

    method chocaste_con_pj() {
        pj.sumar_puntuacion(2)
        game.removeVisual(self)
    }

    method debo_retroceder() {
        return false
    }
}