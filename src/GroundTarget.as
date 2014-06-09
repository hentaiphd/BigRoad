package {
    import org.flixel.*;

    public class GroundTarget extends FlxSprite {
        [Embed(source="../assets/lisafrank.png")] private var Planet1Aliens:Class;
        [Embed(source="../assets/cabbagepatch.png")] private var Planet2Aliens:Class;
        [Embed(source="../assets/finalfantasy.png")] private var Planet3Aliens:Class;
        [Embed(source="../assets/zeonon.png")] private var Planet4Aliens:Class;

        public var _active:Boolean = true;
        public var rand_alien:Number;
        public var _origin:FlxPoint;
        public var moveLeft:Boolean = true;
        public var time_frame:Number = 0;
        public var move_interval:Number = 0;
        public var num_types:Number;

        public function GroundTarget(pos:DHPoint,planet:Number) {
            super(pos.x, pos.y);
            _origin = pos;

            move_interval = Math.floor(Math.random()*20);

            if(planet == 1){
                num_types = 4;
                loadGraphic(Planet1Aliens,true,false,48,64,true);
            } else if(planet == 2){
                num_types = 3;
                loadGraphic(Planet2Aliens,true,false,48,64,true);
            } else if(planet == 3){
                num_types = 3;
                loadGraphic(Planet3Aliens,true,false,48,64,true);
            } else if(planet == 4){
                num_types = 2;
                loadGraphic(Planet4Aliens,true,false,48,64,true);
            } else {
                makeGraphic(15, 15, 0xffffff00);
            }
            rand_alien = Math.floor(Math.random()*num_types);

            offset.y = height/2;
            height = height/2;
            y += offset.y;

            offset.x = width/2;
            width = width/2;
            x += offset.x;

            for (var i:int = 0; i < num_types; i++) {
                if(planet == 1 || planet == 2){
                    addAnimation("alien"+i+"_happy",[i*2+1],12,false);
                } else {
                    addAnimation("alien"+i+"_happy",[i],12,false);
                }
            }
        }

        override public function update():void {
            super.update();
            time_frame++;

            play("alien"+rand_alien+"_happy");
            if(_active == false){
                this.y += .5;
                if(this.y > FlxG.height){
                    FlxG.state.remove(this);
                }
            }

            if (x > 10 + _origin.x) {
                moveLeft = true;
            } else if (x < _origin.x - 10) {
                moveLeft = false;
            }
            if (time_frame % move_interval == 0) {
                x += 1 * (moveLeft ? -1 : 1);
            }
        }

        public function makeInactive():void {
            _active = false;
        }
    }
}
