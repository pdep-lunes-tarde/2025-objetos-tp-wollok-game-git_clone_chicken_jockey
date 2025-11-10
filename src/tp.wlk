import wollok.game.*
import personaje.*
import textos.*
import enemigos.*
import objetos.*

object configurar_juego {
    var property ancho = 30
    var property alto = 30
    var clock_enemigos = 0
    var facilidad = 6
    var lentitud_enemigos = 0
    const cantidad_enemigos_max = 10
    const enemigos = []

    method configurar() {
        game.width(ancho)
        game.height(alto)
        game.cellSize(16)
        game.boardGround("background.jpg")
    }

    method jugar() {
        self.configurar()
        game.start()
        self.mostrar_menu()
    }

    method perdi() {
        game.clear()
        game.addVisual(game_over)
        self.reiniciar_juego() 
    }

    method gane() {
        game.clear()
        game.addVisual(you_win)
        self.reiniciar_juego()
    }

    method reiniciar_juego() {
        game.addVisual(texto_estadisticas)
        keyboard.r().onPressDo {
            game.clear()
            pj.reiniciate()
            barra_de_vida.reiniciate()
            tiempo.reiniciate()
            clock_enemigos = 0
            self.mostrar_menu()
            lentitud_enemigos = 0
            enemigos.clear()
        }
    }

    method agregar_visuales_iniciales() {
        game.addVisual(pj)
        game.addVisual(puntuacion)
        game.addVisual(nivel)
        game.addVisual(tiempo)
        barra_de_vida.corazones_vacios().forEach({ corazon_vacio => game.addVisual(corazon_vacio) })
        barra_de_vida.corazones().forEach({ corazon => game.addVisual(corazon) })
        
        const moneda_inicial = new Moneda()
        self.aparecer_objeto_en_posicion_aleatoria(moneda_inicial)
    }

    method mostrar_menu() {
        const ogro = new Ogro(vida = 3)

        game.addVisual(texto_menu)
        pj.posicion_menu()
        game.addVisual(pj)

        ogro.posicion_menu()
        game.addVisual(ogro)

        keyboard.enter().onPressDo {
            game.clear()
            self.empezar_juego()
        }

        keyboard.c().onPressDo {
            game.clear()
            self.mostrar_controles()
        }

        keyboard.f().onPressDo {
            game.clear()
            self.mostrar_facilidad()
        }
    }

    method mostrar_controles() {
        game.addVisual(controles)
        game.addVisual(volver_atras)

        keyboard.b().onPressDo {
            game.clear()
            self.mostrar_menu()
        }
    }

    method mostrar_facilidad() {
        game.addVisual(texto_facilidad)
        game.addVisual(marcador_facilidad)
        game.addVisual(volver_atras)

        keyboard.f().onPressDo {
            facilidad = 6
            marcador_facilidad.actualizar(facilidad)
        }

        keyboard.m().onPressDo {
            facilidad = 4
            marcador_facilidad.actualizar(facilidad)
        }

        keyboard.d().onPressDo {
            facilidad = 2
            marcador_facilidad.actualizar(facilidad)
        }

        keyboard.b().onPressDo {
            game.clear()
            self.mostrar_menu()
        }
    }

    method empezar_juego() {

        pj.centrate()

        self.agregar_visuales_iniciales()

        keyboard.right().onPressDo {
            pj.movete_a(derecha)
        }

        keyboard.d().onPressDo {
            pj.atacar_a(derecha)
        }

        keyboard.left().onPressDo {
            pj.movete_a(izquierda)
        }

        keyboard.a().onPressDo {
            pj.atacar_a(izquierda)
        }

        keyboard.up().onPressDo {
            pj.movete_a(arriba)
        }

        keyboard.w().onPressDo {
            pj.atacar_a(arriba)
        }

        keyboard.down().onPressDo {
            pj.movete_a(abajo)
        }

        keyboard.s().onPressDo {
            pj.atacar_a(abajo)
        }

        keyboard.any().onPressDo {
            if (clock_enemigos >= facilidad - pj.nivel() && enemigos.size() < cantidad_enemigos_max) {

                const ogro = new Ogro(vida = 3 + pj.nivel(), lentitud = lentitud_enemigos)
                enemigos.add(ogro)

                self.aparecer_objeto_en_posicion_aleatoria(ogro)

                ogro.debo_mostrar_vida(false)

                game.onCollideDo(ogro, { otro => ogro.retrocede(otro) })

                clock_enemigos = 0
            }
            enemigos.forEach({ enemigo => enemigo.mover_hacia(pj) })
            clock_enemigos += 1
        }

        game.onTick(1000, "aumentar_tiempo", { tiempo.aumentarTiempo() })

        game.onCollideDo(pj, { otro => otro.chocaste_con_pj() })
    }

    method agregar_objeto_aleatorio() {
        const probabilidad_corazon = 0.3
        const numero_aleatorio = 0.randomUpTo(1)

        if (numero_aleatorio < probabilidad_corazon) {
            const pocion_vida = new Pocion_vida()
            self.aparecer_objeto_en_posicion_aleatoria(pocion_vida)
        } else {
            const moneda = new Moneda()
            self.aparecer_objeto_en_posicion_aleatoria(moneda)
        }
    }

    method sumar_lentitud_enemigos() {
        lentitud_enemigos += 1
    }

    method eliminar_enemigo(enemimgo) {
        enemigos.remove(enemimgo)
    }

    method mostrar_menu_subida_nivel(objetos_aleatorios) {
        game.clear()
        enemigos.clear()
        objetos_aleatorios.forEach({ objeto => game.addVisual(objeto) })

        game.addVisual(texto_subida_de_nivel)
        game.addVisual(text_seleccion_objetos)

        keyboard.num0().onPressDo {
           game.clear()
           self.empezar_juego()
           pj.agregar_objeto_especial(objetos_aleatorios.get(0))
        }

        keyboard.num1().onPressDo {
           game.clear()
           self.empezar_juego()
           pj.agregar_objeto_especial(objetos_aleatorios.get(1))
        }

        keyboard.num2().onPressDo {
           game.clear()
           self.empezar_juego()
           pj.agregar_objeto_especial(objetos_aleatorios.get(2))
        }
    }

    method mostrar_ogro_y_vida(ogro){
        game.addVisual(ogro)
        game.addVisual(ogro.texto_vida())
    }

    method aparecer_cofre(cofre){
        game.addVisual(cofre)
        cofre.movete_al_radio_del_pj()
    }

    method aparecer_objeto_en_posicion_aleatoria(objeto){
        game.addVisual(objeto)
        objeto.movete_a_posicion_aleatoria()
    }

    method mostrar_objeto(objeto){
        game.addVisual(objeto)
    }
}

object izquierda {
    method siguientePosicion(posicion) {
        return posicion.left(1)
    }
}
object abajo {
    method siguientePosicion(posicion) {
        return posicion.down(1)
    }
}
object arriba {
    method siguientePosicion(posicion) {
        return posicion.up(1)
    }
}
object derecha {
    method siguientePosicion(posicion) {
        return posicion.right(1)
    }
}