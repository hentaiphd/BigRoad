package{
    import org.flixel.*;

    public class DriveState extends FlxState{
        public var now:Date;
        public var startTime:Date;

        public function DriveState():void{
            //pass score?
        }

        override public function create():void{
            FlxG.mouse.hide();
            startTime = new Date();

            var t1:FlxText;
            t1 = new FlxText(20,200,FlxG.width,"Driving to another planet~\nWait 5 secs for it to switch.");
            t1.size = 14;
            add(t1);
        }

        override public function update():void{
            super.update();

            if(new Date().valueOf() - startTime.valueOf() > 5000){
                FlxG.switchState(new PlayState());
            }

        }
    }
}