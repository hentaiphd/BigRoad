package {
    import org.flixel.*;

    public class FloatySprite extends FlxSprite {
        public var originY:Number;
        public var timeFrame:Number = 0;
        public var speed:Number;

        public function FloatySprite(x:Number, y:Number) {
            super(x, y);
            originY = y;
            speed = Math.random()*.07;
        }

        override public function update():void {
            super.update();

            timeFrame++;
            y = originY + Math.sin(timeFrame*speed)*5;
        }
    }
}
