package {
    import org.flixel.*;

    public class GroundTarget extends FlxSprite {
        [Embed(source="../assets/lisafrank.png")] private var Planet2Aliens:Class;
        public var _active:Boolean = true;
        public var rand_alien:Number;

        public function GroundTarget(pos:DHPoint,planet:Number) {
            super(pos.x, pos.y);
            rand_alien = Math.floor(Math.random()*4)+1;
            if(planet == 1){
                loadGraphic(Planet2Aliens,true,false,48,64,true);
                addAnimation("alien1_waiting",[0],12,false);
                addAnimation("alien1_happy",[1],12,false);
                addAnimation("alien2_waiting",[2],12,false);
                addAnimation("alien2_happy",[3],12,false);
                addAnimation("alien3_waiting",[4],12,false);
                addAnimation("alien3_happy",[5],12,false);
                addAnimation("alien4_waiting",[6],12,false);
                addAnimation("alien4_happy",[7],12,false);
            } else {
                makeGraphic(15, 15, 0xffffff00);
            }
        }

        override public function update():void {
            super.update();
            if(rand_alien == 1){
                play("alien1_waiting");
            }
            if(rand_alien == 2){
                play("alien2_waiting");
            }
            if(rand_alien == 3){
                play("alien3_waiting");
            }
            if(rand_alien == 4){
                play("alien4_waiting");
            }

            if(_active == false){
                if(rand_alien == 1){
                    play("alien1_happy");
                }
                if(rand_alien == 2){
                    play("alien2_happy");
                }
                if(rand_alien == 3){
                    play("alien3_happy");
                }
                if(rand_alien == 4){
                    play("alien4_happy");
                }
                this.y += .5;
                if(this.y > FlxG.height){
                    FlxG.state.remove(this);
                }
            }
        }

        public function makeInactive():void {
            _active = false;
        }
    }
}
