package{
    import org.flixel.*;

    public class OutroState extends FlxState{
        [Embed(source="../assets/end1.png")] private var ImgBg:Class;

        public var bg:FlxSprite;
        public var startTime:Date;

        public function OutroState():void{
            //make variable ending
        }

        override public function create():void{
            FlxG.mouse.hide();
            startTime = new Date();

            bg = new FlxSprite(0,0);
            bg.loadGraphic(ImgBg,false,false,320,240);
            add(bg);
        }

        override public function update():void{
            super.update();

            if(new Date().valueOf() - startTime.valueOf() > 5000){
                FlxG.switchState(new OutroGirlsState());
            }
        }
    }
}