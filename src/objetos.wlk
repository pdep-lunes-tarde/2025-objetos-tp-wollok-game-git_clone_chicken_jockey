import src.tp.*
import personaje.*

class Objeto {
    var property position = game.center()

    var property image 

    method fuiste_atacado(enemigo, nueva_posicion) {}

    method debo_retroceder() = false

    method movete_a_posicion_aleatoria() {
        const x = 0.randomUpTo(game.width()).truncate(0)
        const y = 0.randomUpTo(game.height()).truncate(0)

        position = game.at(x, y)
    }

    method chocaste_con_pj() {}
}

class Pocion_vida inherits Objeto (image = "Pocion.png") {
    override method chocaste_con_pj() {
        pj.recibir_vida()
        game.removeVisual(self)
    }
}

class Moneda inherits Objeto (image = "coin_16.png") {
    override method chocaste_con_pj() {
        pj.sumar_puntuacion(3)
        game.removeVisual(self)
    }


}

class Cofre inherits Objeto (image = "chest.png") {
    const lista_objetos = ["Escudo", "Espada", "Reloj"]
    const cantidad_cofres_max = 3

    method cantidad_cofres_max() = cantidad_cofres_max

    method movete_al_radio_del_pj() {
        if (self.puede_aparecer()) {
            const x = self.generar_ratio(2, pj.position().x()).anyOne()
            const y = self.generar_ratio(2, pj.position().y()).anyOne()

            position = game.at(x, y)
        }
    }

    method puede_aparecer() = pj.cofres().size() < cantidad_cofres_max

    method generar_ratio(radio, coordenada) { // Ver si el pj se encuentra en algun borde y/o extremo de la pantalla, puede aparecer justo por fuera de la misma
        const lista = (-radio..radio).asList()

        lista.remove(0)

        return lista.map{ numero => coordenada + numero}
    }

    override method chocaste_con_pj() {
        const objetos_aleatorios = self.generar_objetos_aleatorios()

        pj.nivel(pj.nivel() + 1)
        pj.cofres().clear()
        game.clear()
        game.removeVisual(self)
        pj.puntuacion_actual(0)

        configurar_juego.mostrar_menu_subida_nivel(objetos_aleatorios)
    }

    method generar_objeto_aleatorios() {
        const pos_objeto = 0.randomUpTo(lista_objetos.size() + 1).truncate(0)

        return if (pos_objeto == 0) new Escudo() else if (pos_objeto == 1) new Espada() else new Botas()
    }

    method generar_objetos_aleatorios() {
        const objeto1 = self.generar_objeto_aleatorios()
        const objeto2 = self.generar_objeto_aleatorios()
        const objeto3 = self.generar_objeto_aleatorios()

        objeto1.position(game.center().up(2))
        objeto2.position(game.center())
        objeto3.position(game.center().down(2))

        return [objeto1, objeto2, objeto3]
    }

}

class Objeto_especial inherits Objeto {

    method efecto_unico() {}

    method efecto_por_movimiento() {}

}

class Escudo inherits Objeto_especial (image = "Shield.png") {
    override method efecto_unico() {
        pj.dar_escudo()
    }
}

class Botas inherits Objeto_especial (image = "Botas.png") {
    override method efecto_unico() {
        configurar_juego.sumar_lentitud_enemigos()
    }
}

class Espada inherits Objeto_especial (image = "Sword.png") {
    override method efecto_unico() {
        pj.aumentar_danio()
    }
}