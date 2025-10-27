import src.tp.*
import personaje.pj

class Pocion_vida {
    var property position = game.center()
    
    method image() = "Pocion.png"

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
        pj.sumar_puntuacion(3)
        game.removeVisual(self)
    }

    method debo_retroceder() {
        return false
    }
}

class Cofre {
    var property position = game.center()
    const lista_objetos = ["Escudo", "Espada", "Reloj"]
    
    method image() = "chest.png"

    method aparecer() {
        const x = 0.randomUpTo(game.width()).truncate(0)
        const y = 0.randomUpTo(game.height()).truncate(0)
        position = game.at(x,y)

        game.addVisual(self)
    }

    method chocaste_con_pj() {
        pj.nivel(pj.nivel() + 1)
        game.clear()
        game.removeVisual(self)
        pj.puntuacion_actual(0)
        const objetos_aleatorios = self.generar_objetos_aleatorios()
        configurar_juego.mostrar_menu_subida_nivel(objetos_aleatorios)        
    }

    method generar_objeto_aleatorios(){
        const pos_objeto = 0.randomUpTo(lista_objetos.size() + 1).truncate(0)

        if (pos_objeto == 0) {
            return new Escudo()
        } else if (pos_objeto == 1) {
            return new Espada()
        } else {
            return new Reloj()
        }

    }

    method generar_objetos_aleatorios(){
        const objeto1 = self.generar_objeto_aleatorios()
        const objeto2 = self.generar_objeto_aleatorios()
        const objeto3 = self.generar_objeto_aleatorios()

        objeto1.position(game.center().up(2))
        objeto2.position(game.center())
        objeto3.position(game.center().down(2))

        return [objeto1, objeto2, objeto3]
    }
    method debo_retroceder() {
        return false
    }

}

class Objeto_especial {
    var property position = game.center()
    const image

    method image() {
        return image
    }

    method aparecer() {
        game.addVisual(self)
    }

    method efecto_unico(){     
    }

    method efecto_por_movimiento(){     
    }

    method debo_retroceder() {
        return false
    }
}

class Escudo inherits Objeto_especial ( image = "Shield.png") {

    override method efecto_unico(){     
        pj.dar_escudo()
    }
}

class Reloj inherits Objeto_especial ( image = "Botas.png") {

    override method efecto_unico(){     
        configurar_juego.sumar_lentitud_enemigos()
    }
}

class Espada inherits Objeto_especial ( image = "Sword.png") {

    override method efecto_unico(){     
        pj.aumentar_danio()
    }
}

