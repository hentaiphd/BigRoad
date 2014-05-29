package{
    import org.flixel.*;

    public class OutroState extends FlxState{

        public function OutroState(state:Boolean):void{
            //make variable ending
        }

        override public function create():void{
            FlxG.mouse.hide();

            var t1:FlxText;
            t1 = new FlxText(20,200,FlxG.width,"You dreamed that dad ran out of money and came home.\n\nYou're still alone, sitting on the steps of your apartment building.\n\nSPACE to return to start screen.");
            t1.size = 14;
            add(t1);

            var t2:FlxText;
            t2 = new FlxText(20,200,FlxG.width,"You dreamed that dad ran out of money and came home.\n\nYou're still alone, sitting on the steps of your apartment building.\n\nSPACE to return to start screen.");
            t2.size = 14;
            add(t2);
        }

        override public function update():void{
            super.update();

            if(FlxG.keys.SPACE){
                FlxG.switchState(new PlayState());
            }
        }
    }
}