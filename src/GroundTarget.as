package {
    import org.flixel.*;

    public class GroundTarget extends FlxSprite {
        public var _active:Boolean = true;

        public function GroundTarget(pos:DHPoint) {
            super(pos.x, pos.y);
            makeGraphic(15, 15, 0xffffff00);
        }

        override public function update():void {
            super.update();
        }

        public function makeInactive():void {
            _active = false;
            FlxG.state.remove(this);
        }
    }
}
