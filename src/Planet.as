package
{
    import org.flixel.*;

    public class Planet extends FlxSprite{
        [Embed(source="../assets/planet.png")] private var ImgPlanet:Class;

        public function Planet(x:int,y:int):void{
            super(x,y);
            loadGraphic(ImgPlanet,false,false,80,80);
        }

        override public function update():void{
            super.update();
            this.y++;
            if(this.y > 480){
                this.y = 0;
            }

        }
    }
}