import wollok.game.*

object dungeonHunter{

    method ancho() {
        return 20
    }
    method alto() {
        return 20
    }
    method configurar() {
        game.width(self.ancho())
        game.height(self.alto())
        game.cellSize(90)

        keyboard.w().onPressDo{
        explorador.arriba()
        }
        keyboard.d().onPressDo{
        explorador.derecha()
        }
        keyboard.a().onPressDo{
            explorador.izquierda()
        }
        keyboard.s().onPressDo{
            explorador.abajo()
        }

    }
    method jugar() {
        self.configurar()
        game.addVisual(explorador)
        game.addVisual(ogro)
        game.start()
    }
    method spawnOgro(){
        game.addVisual(ogro)
    }

}

object explorador{
    var property position = game.center()
    var i = 0
    method image() = "explorador.png"
    method arriba(){
        position = position.up(1)
        i = i + 1
        if (i % 5 == 0){
            game.say(self, "hola")
        }
        return i
    }
    method abajo(){
        position = position.down(1)
        i = i + 1
        if (i % 5 == 0){
            game.say(self, "hola")
        }
        return i
    }
    method izquierda(){
        position = position.left(1)
        i = i + 1
        if (i % 5 == 0){
            game.say(self, "hola")
        }
        return i
    }
    method derecha(){
        position = position.right(1)
        i = i + 1
        if (i % 5 == 0){
            game.say(self, "hola")
        }
        return i
    }
}

object ogro {
    method image() = "ogro.png"
    var property position = game.center() 
}

