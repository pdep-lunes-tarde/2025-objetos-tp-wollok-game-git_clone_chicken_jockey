
import personaje.pj
class Corazon{
    method image() = "manzana.png"

    var property position = game.center()

    method aparecer(){
        const x = 0.randomUpTo(game.width()).truncate(0)
        const y = 0.randomUpTo(game.height()).truncate(0)
        position = game.at(x,y)

        game.addVisual(self)
    }

    method chocaste_con_pj(){
        pj.recibirVida()
        game.removeVisual(self)
    }
}

class Moneda{
    method image() = "coin_16.png"

    var property position = game.center()

    method aparecer(){
        const x = 0.randomUpTo(game.width()).truncate(0)
        const y = 0.randomUpTo(game.height()).truncate(0)
        position = game.at(x,y)

        game.addVisual(self)
    }

    method chocaste_con_pj(){
        pj.sumarPuntuacion(3)
        game.removeVisual(self)
    }
}