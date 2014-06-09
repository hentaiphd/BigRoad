package{
    import org.flixel.*;
    [SWF(width="640", height="480", backgroundColor="#000000")]
    [Frame(factoryClass="Preloader")]

    public class BigRoad extends FlxGame{
        public static const total_time:Number = 50*84;
        public static const total_planets:Number = 4;

        public function BigRoad(){
            super(640,480,MenuState,2);
        }
    }
}
