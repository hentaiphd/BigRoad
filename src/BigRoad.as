package{
    import org.flixel.*;
    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader")]

    public class BigRoad extends FlxGame{
        public static const total_time:Number = 50*110;//50*84;
        public static const total_planets:Number = 4;

        public var screenWidth:Number, screenHeight:Number, aspect_ratio:Number;
        public var applet_dimensions:FlxPoint, letterbox_dimensions:FlxPoint, zero_point:FlxPoint;

        public function BigRoad(){
            applet_dimensions = new FlxPoint(640, 480);
            super(applet_dimensions.x, applet_dimensions.y, MenuState, 2);
        }
    }
}
