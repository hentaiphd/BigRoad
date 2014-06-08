package{
    import org.flixel.*;

    public class OutroGirlsState extends FlxState{
        [Embed(source="../assets/end1.png")] private var ImgBg:Class;

        public var bg:FlxSprite;

        public function OutroGirlsState():void{
            //make variable ending
        }

        override public function create():void{
            FlxG.mouse.hide();

            bg = new FlxSprite(0,0);
            bg.loadGraphic(ImgBg,false,false,320,240);
            add(bg);
        }

        override public function update():void{
            super.update();

            if(FlxG.mouse.pressed()){
                FlxG.switchState(new OutroGirlsState());
            }
        }
    }
}